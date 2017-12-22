# NAT component

# output "vpc_id" {
#   value = "${aws_vpc.main.id}"
# }
# output "subnet-id" {
#   value = ["${aws_subnet.main-public.*.id}"]
# }
# output "count_number" {
#   value = "${var.number_of_azs}"
# }

terraform {
  backend "s3" {
    bucket  = "cdp-terraform-task"
    key     = "nat/terraform.tfstate" 
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


module "nat" {
  source = "../../modules/nat"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet-id = "${data.terraform_remote_state.vpc.subnet-id}"
  count_number = "${data.terraform_remote_state.vpc.count_number}"
}

output "subnet-id" {
  value = "${module.nat.subnet-id}"
}
