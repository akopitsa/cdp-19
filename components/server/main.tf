# server component

terraform {
  backend "s3" {
    bucket  = "cdp-terraform-task"
    key     = "server/terraform.tfstate" 
    region  = "us-east-1"
    encrypt = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "cdp-terraform-task"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "nat" {
  backend = "s3"
  config {
    bucket = "cdp-terraform-task"
    key    = "nat/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "elb" {
  backend = "s3"
  config {
    bucket = "cdp-terraform-task"
    key    = "elb/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
    region = "${var.region}"
#    access_key = "${var.aws_access_key}"
#    secret_key = "${var.aws_secret_key}"
}

# resource "aws_key_pair" "auth" {
#   key_name   = "${var.key_name}"
#   public_key = "${file(var.public_key_path)}"
# }

module "server" {
  source = "../../modules/server"
  subnet-id = "${data.terraform_remote_state.nat.subnet-id}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  dns_name = "${data.terraform_remote_state.elb.ELB}"
  elb-name =  "${data.terraform_remote_state.elb.elb-name}"
  elb_sg_id = "${data.terraform_remote_state.elb.elb_sg_id}"
}
