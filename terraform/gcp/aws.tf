# This file contains all the interactions with AWS
provider "aws" {
    region = "us-west-2"
    alias = "usw2"
    allowed_account_ids = ["${var.allowed_account_ids}"]
    assume_role {
        role_arn = "${var.role_arn}"
    }
}
