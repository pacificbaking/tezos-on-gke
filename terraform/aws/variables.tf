#
# Variables Configuration
#

variable "cluster-name" {
  default = "terraform-eks-pacificbaking"
  type    = string
}

variable "aws-profile" {
  default = "pacificbaking"
  type    = string
}

variable "aws-region" {
  default = "us-west-2"
  type    = string
}

variable "aws-account-id" {
  type = string
}

#
# Tezos node and baker options
# ------------------------------


variable "tezos_network" {
  type        = string
  description = "The Tezos network (alphanet and mainnet supported)."
}

variable "tezos_sentry_version" {
  type        = string
  description = "The tezos container version for sentry nodes"
}

variable "tezos_private_version" {
  type        = string
  description = "The tezos container version for private node"
}


variable "protocol" {
  type        = string
  description = "The Tezos protocol currently in use."
  default     = "005-PsBabyM1"
}

variable "protocol_short" {
  type        = string
  description = "The shot string describing the protocol."
  default     = "PsBabyM1"
}

variable "public_baking_key" {
  type        = string
  description = "The public baker tz1 public key that delegators delegate to."
}

variable "rolling_snapshot_url" {
  type        = string
  description = "The public URL where to download the Tezos blockchain snapshot for quicker sync of the public nodes."
}

variable "full_snapshot_url" {
  type        = string
  description = "The public URL where to download the full historical Tezos blockchain for quicker sync of the private node."
}

variable "authorized_signer_key_a" {
  type        = string
  description = "Public key of the first remote signer."
}

variable "authorized_signer_key_b" {
  type        = string
  description = "Public key of the first remote signer."
}

variable "signer_target_random_hostname" {
  type        = string
  description = "Random string such as 128fecf31d for the fqdn of the ssh endpoint the remote signer connects to (for example 128fec31d.mybaker.com)."
  default     = "signer"
}

variable "container_version" {
  type        = string
  default     = "latest"
}



