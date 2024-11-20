# Get each available zone for the given region.
data "google_compute_zones" "available" {
  region = var.region
}

data "google_project" "default" {}

# RPC node part of the network, but doesn't serve traffic.
# Used to sync its attached disk and act as a source for snapshots.
resource "google_compute_region_instance_group_manager" "near_lake_group_2" {
  name = "${var.module_prefix}${var.chain_id}-lake-group-1"

  base_instance_name = "${var.module_prefix}${var.chain_id}-lake-node-1"

  region = var.region

  distribution_policy_zones = [
    data.google_compute_zones.available.names[0],
    data.google_compute_zones.available.names[1],
  ]
  target_size = var.machine_count

  wait_for_instances = true

  version {
    name              = "lake"
    instance_template = google_compute_instance_template.lake_template_2.id
  }

  lifecycle {
    create_before_destroy = true
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_surge_fixed       = 2
    max_unavailable_fixed = 2
  }

  timeouts {
    create = "1h"
    update = "1h"
    delete = "30m"
  }
}

resource "google_compute_instance_template" "lake_template_2" {
  name_prefix  = "${var.module_prefix}${var.chain_id}-lake"
  region       = var.region
  machine_type = var.machine_type

  # Boot disk for the VM image and basic OS data.
  disk {
    source_image = var.machine_image
    disk_type    = "pd-standard"
    boot         = true
    auto_delete  = true
    disk_size_gb = var.disk_size_gb_system
  }

  disk {
    disk_type    = "pd-ssd"
    disk_size_gb = var.disk_size_gb_data
    source_image = "projects/${data.google_project.default.project_id}/global/images/family/backup-${var.archive ? "archive" : "rpc"}-${var.chain_id}"
  }

  network_interface {
    network = "default"
    access_config {
      // create external IP
    }
  }

  metadata_startup_script = templatefile("${path.module}/init.sh.tmpl", { chain_id = var.chain_id, archive = var.archive, near_lake_tar_gz_url = var.near_lake_url, aws_access_key_id = var.aws_access_key_id, aws_secret_access_key = var.aws_secret_access_key })

  metadata = {
    enable-oslogin = "false"
  }

  labels = merge({
    owner         = "near-sre"
    created_by    = "terraform"
    repo          = "near-ops"
    role          = "explorer"
    chain_id      = var.chain_id
    prometheus    = "true",
    node_exporter = "true"
    binary        = "neard-lake"
    node_type     = "indexer"
    gcp_region    = var.region
  }, var.machine_labels)

  tags = ["${var.chain_id}-lake-node", "near"]

  lifecycle {
    create_before_destroy = true
  }
}
