module "folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "organizations/${var.parent_org_id}"

  names = var.folder_names

  set_roles = true

  all_folder_admins = [
    var.admin_group,
  ]
}

resource "random_id" "random_project_id_suffix" {
  byte_length = 1
}

resource "google_billing_account_iam_member" "member" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.user"
  member             = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = "${var.project_name}-${random_id.random_project_id_suffix.hex}"
  billing_account = var.billing_account_id 
  folder_id       = module.folders.id
}

resource "google_project_service" "project" {
  for_each = toset(var.services)
  project  = google_project.project.project_id
  service  = each.value
  disable_on_destroy = true
}

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = true
  project                 = google_project.project.project_id
}

resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.cluster_location
  network                  = google_compute_network.vpc.name
  project                  = google_project.project.project_id
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  
  depends_on = [google_compute_network.vpc, google_project_iam_member.project, google_service_account.default]
}

resource "google_service_account" "gke_nodepool_sa" {
  account_id   = "gke-nodepool-sa"
  display_name = "GKE Node Pool SA"
  project      = google_project.project.project_id
}

resource "google_project_iam_member" "gke_nodepool_storage_reader" {
  member  = "serviceAccount:${google_service_account.gke_nodepool_sa.email}"
  project = google_project.project.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_container_node_pool" "gcc_nodes" {
  name     = "${google_container_cluster.primary.name}-node-pool"
  location = var.cluster_location
  project  = google_project.project.project_id
  cluster  = google_container_cluster.primary.name

  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false

    service_account = google_service_account.gke_nodepool_sa.email

    metadata = {
      disable-legacy-endpoints = true
      master                   = google_container_cluster.primary.name
      name                     = "${google_container_cluster.primary.name}-node-pool"
      network                  = var.vpc_name
      type                     = "gke-node"
    }

    labels = {
      team    = "plaza-devops"
      purpose = "coding-assignment"
    }
    tags = ["plaza-devops", "coding-assignment"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "google_service_account" "default" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  project      = google_project.project.project_id
}

resource "google_project_iam_member" "project" {
  project = google_project.project.project_id
  for_each = toset(var.iam_roles)
  role    = each.key
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_container_registry" "registry" {
  project  = google_project.project.project_id
  location = "EU"
}

resource "google_iam_workload_identity_pool" "pool" {
  provider                  = google-beta
  project                   = google_project.project.project_id
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = var.workload_identity_pool_id
  description               = var.workload_identity_pool_description
}

resource "google_iam_workload_identity_pool_provider" "pool_provider" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_pool_provider_id
  display_name                       = var.workload_identity_pool_provider_id
  oidc {
    issuer_uri = var.workload_identity_pool_provider_oidc_issuer_uri
  }
  attribute_mapping   = var.workload_identity_pool_provider_oidc_attribute_mapping
  attribute_condition = var.workload_identity_pool_provider_oidc_attribute_condition
  project             = google_project.project.project_id
}

resource "google_service_account_iam_member" "workload_identity_federation_binding" {
  service_account_id = google_service_account.default.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/${var.oidc_token_access_attribute}"
}

output "project_id" {
  value = google_project.project.project_id
}

output "project_number" {
  value = google_project.project.number
}

output "pool_provider" {
  value = google_iam_workload_identity_pool_provider.pool_provider.id
}

output "main_sa" {
  value = google_service_account.default.email
}
