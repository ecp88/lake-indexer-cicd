variable "chain_id" {
  type        = string
  description = "NEAR chain_id (betanet, testnet, mainnet, etc)"
}

variable "region" {
  type        = string
  description = "Name of the deployed region, e.g. 'us-central1'"
}

variable "machine_image" {
  type        = string
  description = "Machine image for new nodes"
  default     = "projects/near-core/global/images/near-lake-indexer-2204"
}

variable "machine_type" {
  type        = string
  description = "Machine type for new nodes (defines allocated CPU, RAM, etc)"
}

variable "disk_size_gb_system" {
  type        = number
  description = "Attached disk size in GB"
  default     = 256
}

variable "disk_size_gb_data" {
  type        = number
  description = "Attached disk size in GB"
}

variable "image_size_gb" {
  type        = number
  description = "Image default size in GB"
  default     = 128
}

variable "machine_labels" {
  type        = map(any)
  description = "Labels for machine"
  default     = {}
}

variable "tags" {
  type        = list(any)
  description = "Network tags for machine"
  default     = []
}

variable "machine_name" {
  type        = string
  description = "Network tags for machine"
}

variable "archive" {
  type        = bool
  description = "Does this node run in archival node/tracks all data"
}

variable "near_lake_url" {
  type        = string
  description = "NEAR Lake bin url to download on machine start, if not provided latest release be used"
  default     = ""
}

variable "machine_count" {
  type = number
}

variable "module_prefix" {
  type    = string
  default = ""
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS credentials to Read/Write AWS S3"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS credentials to Read/Write AWS S3"
  sensitive   = true
}
