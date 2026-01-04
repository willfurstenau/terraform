terraform {
  required_providers {
    bunnynet = {
      source = "BunnyWay/bunnynet"
    }
  }
}

provider "bunnynet" {
  api_key = var.api_key
}