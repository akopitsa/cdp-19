# vpc component

terraform {
  backend "s3" {
    bucket  = "cdp-terraform-task"
    key     = "vpc/terraform.tfstate" 
    region  = "us-east-1"
    encrypt = true
  }
}
provider "aws" {
    region = "${var.region}"
#    access_key = "${var.aws_access_key}"
#    secret_key = "${var.aws_secret_key}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
module "vpc" {
  source = "../../modules/vpc"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
output "subnet-id" {
  value = "${module.vpc.subnet-id}"
}

output "count_number" {
  value = "${module.vpc.count_number}"
}
