variable "parent_org_id" {
  description = "The ID of the parent organization"
  default     = "783041407275"
}

variable "folder_names" {
  description = "The names of the folders to create"
  default     = ["plaza-devops"]
}

variable "admin_group" {
  description = "The group to grant folder admin permissions"
  default     = "group:cloud-infra@pricer.com"
}

variable "billing_account_id" {
  description = "The ID of the billing account"
  default     = "0164F2-C4DDF5-9CC70F"
}

variable "project_name" {
  description = "The name of the Google Cloud project"
  default     = "code-assignment"
}

variable "org_id" {
  description = "The ID of the organization"
  default     = "783041407275"
}

variable "services" {
  description = "The list of services to enable for the project"
  default     = ["container.googleapis.com", "compute.googleapis.com", "iam.googleapis.com", "containerregistry.googleapis.com", "storage-api.googleapis.com", "storage-component.googleapis.com"]
}

variable "network_name" {
  description = "The name of the network"
  default     = "plaza-devops-network"
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  default     = "plaza-devops-gke"
}

variable "cluster_location" {
  description = "The location of the Kubernetes cluster"
  default     = "europe-north1-a"
}

variable "service_account_id" {
  description = "The ID of the service account"
  default     = "coding-assignment-sa"
}

variable "service_account_display_name" {
  description = "The display name of the service account"
  default     = "coding assignment sa"
}

variable "iam_roles" {
  description = "The IAM roles to assign to the service account"
  default     = ["roles/editor", "roles/storage.admin", "roles/container.admin", "roles/iam.serviceAccountUser", "roles/iam.workloadIdentityUser"]
}

variable "vpc_name" {
  description = "The name of the VPC"
  default     = "code-assignment-vpc"
}

variable "region" {
  description = "The region for the subnet"
  default     = "europe-north1"
}

variable "workload_identity_pool_id" {
  description = "Workload identity pool ID"
  type        = string
  default     = "pricer-github-pool"
}

variable "workload_identity_pool_description" {
  description = "Workload identity pool description"
  type        = string
  default     = "Workload Identity pool for GitHub"
}

variable "workload_identity_pool_provider_id" {
  description = "Workload identity pool provider ID"
  type        = string
  default     = "github-actions"
}

variable "workload_identity_pool_provider_oidc_issuer_uri" {
  description = "Workload identity pool provider OIDC issuer uri"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "workload_identity_pool_provider_oidc_attribute_mapping" {
  description = "Workload identity pool provider OIDC attribute mapping"
  type        = map(string)
  default     = {
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "google.subject"             = "assertion.repository"
  }
}

variable "workload_identity_pool_provider_oidc_attribute_condition" {
  description = "OIDC attribute condition required to use the provider"
  type        = string
  default     = "assertion.repository_owner=='PricerAB'"
}

variable "oidc_token_access_attribute" {
  description = "Restrict access to service account by OIDC token attribute (* means no restriction)"
  default     = "attribute.repository/PricerAB/plaza-devops-coding-assignment"
}
