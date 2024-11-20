terraform {
  backend "gcs" {
    bucket = "near-terraform"
    prefix = "state/near-lake/mainnet-regular"
  }
}

provider "google" {
  project = "rpc-prod"
}
