terraform {
  backend "s3" {
    bucket  = "cdp-terraform-task"
    key     = "elb/terraform.tfstate" 
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
provider "aws" {
    region = "${var.region}"
#    access_key = "${var.aws_access_key}"
#    secret_key = "${var.aws_secret_key}"
}

# resource "aws_key_pair" "auth" {
#   key_name   = "${var.key_name}"
#   public_key = "${file(var.public_key_path)}"
# }

module "elb" {
  source = "../../modules/elb"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet-id = "${data.terraform_remote_state.vpc.subnet-id}"
}

output "ELB" {
  value = "${module.elb.ELB}"
}

output "elb-name" {
  value = "${module.elb.elb-name}"
}

output "elb_sg_id" {
  value = "${module.elb.elb_sg_id}"
}
