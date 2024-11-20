data "google_secret_manager_secret_version" "near_lake_aws_access_key_id" {
  secret  = "near_lake_aws_access_key_id"
  version = "4" # changed on 2023-12-13
}

data "google_secret_manager_secret_version" "near_lake_aws_secret_access_key" {
  secret  = "near_lake_aws_secret_access_key"
  version = "3" # changed on 2023-12-13
}

module "rpc_backup" {
  source = "../modules" # can also be relative to this file directory

  chain_id     = "testnet"
  region       = "europe-west4"
  machine_name = "testnet-lake-indexer"

  machine_labels = { "role" : "testnet-lake-indexer-regular" }

  machine_type      = "n2d-standard-8"
  machine_image     = "near-lake-indexer-2204"
  machine_count     = 2
  disk_size_gb_data = 1000

  aws_access_key_id     = data.google_secret_manager_secret_version.near_lake_aws_access_key_id.secret_data
  aws_secret_access_key = data.google_secret_manager_secret_version.near_lake_aws_secret_access_key.secret_data

  module_prefix = ""
  archive       = false
}
