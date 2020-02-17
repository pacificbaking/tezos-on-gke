resource "aws_ecr_repository" "tezos" {
  name = "tezos/tezos"
}
resource "aws_ecr_repository" "tezos-public" {
  name = "tezos/tezos-public"
}
resource "aws_ecr_repository" "tezos-baker-with-remote-signer" {
  name = "tezos-baker-with-remote-signer"
}
resource "aws_ecr_repository" "tezos-endorder-with-remote-signer" {
  name = "tezos-endorser-with-remote-signer"
}
resource "aws_ecr_repository" "tezos-remote-signer-forwarder" {
  name = "tezos-remote-signer-forwarder"
}
resource "aws_ecr_repository" "tezos-remote-signer-loadbalancer" {
  name = "tezos-remote-signer-loadbalancer"
}
resource "aws_ecr_repository" "tezos-snapshot-downloader" {
  name = "tezos-snapshot-downloader"
}
resource "aws_ecr_repository" "tezos-archive-downloader" {
  name = "tezos-archive-downloader"
}
resource "aws_ecr_repository" "tezos-key-importer" {
  name = "tezos-key-importer"
}
resource "aws_ecr_repository" "tezos-private-node-connectivity-checker" {
  name = "tezos-private-node-connectivity-checker"
}
resource "aws_ecr_repository" "website-builder" {
  name = "website-builder"
}

