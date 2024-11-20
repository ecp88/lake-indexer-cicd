data "google_secret_manager_secret_version" "near_lake_aws_access_key_id" {
  secret  = "near_lake_aws_access_key_id"
  version = "3"
}

data "google_secret_manager_secret_version" "near_lake_aws_secret_access_key" {
  secret  = "near_lake_aws_secret_access_key"
  version = "3"
}

module "rpc_backup" {
  source = "../modules" # can also be relative to this file directory

  chain_id     = "mainnet"
  region       = "europe-west4"
  machine_name = "mainnet-lake-indexer-reg"

  machine_labels = { "role" : "near-lake-mainnet-indexer-regular" }

  machine_type      = "n2d-standard-16"
  machine_count     = 2
  disk_size_gb_data = 5000

  aws_access_key_id     = data.google_secret_manager_secret_version.near_lake_aws_access_key_id.secret_data
  aws_secret_access_key = data.google_secret_manager_secret_version.near_lake_aws_secret_access_key.secret_data

  module_prefix = ""
  archive       = false
}
