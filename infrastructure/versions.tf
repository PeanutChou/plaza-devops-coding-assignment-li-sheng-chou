terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.27.0"
    }
  }

  required_version = ">= 0.14"

  backend "gcs" {
    bucket = "pricer-admin-terraform-state"
    prefix = "plaza-devops/terraform/state"
  }
}