terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {}

resource "github_repository" "terraform_infrastructure_lab" {
  name        = "terraform-infrastructure-lab"
  description = "Repository for Terraform labs and certification preparation"
  visibility  = "public"
}