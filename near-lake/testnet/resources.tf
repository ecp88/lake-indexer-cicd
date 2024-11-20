terraform {
  backend "gcs" {
    bucket = "near-terraform"
    prefix = "state/network/lake-testnet"
  }
}

provider "google" {
  project = "near-core"
}
