# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
terraform {
  cloud {
    organization = "albertnis"

    workspaces {
      tags = ["tf-demo"]
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_account_id" {
  type = string
}

provider "cloudflare" {
  api_token  = var.cloudflare_api_token
  account_id = var.cloudflare_account_id
}

variable "domain" {
  type = string
}

variable "environment_name" {
  type    = string
  default = "staging"
}

variable "app_subdomain" {
  type    = string
  default = "staging.tf"
}

data "cloudflare_zone" "zone" {
  name = var.domain
}

resource "cloudflare_worker_script" "script" {
  name    = "tf-script-${var.environment_name}-${terraform.workspace}"
  content = file("./index.js")
  plain_text_binding {
    name = "ENV_NAME"
    text = var.environment_name
  }
}

resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.app_subdomain
  value   = "192.0.2.1"
  type    = "A"
  proxied = true
}

resource "cloudflare_worker_route" "route" {
  zone_id     = data.cloudflare_zone.zone.id
  pattern     = "${var.app_subdomain}.${var.domain}/*"
  script_name = cloudflare_worker_script.script.name
}
