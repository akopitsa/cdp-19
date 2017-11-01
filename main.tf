# ROOT - MAIN TF
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
  source = "./modules/vpc"
}
module "nat" {
  source = "./modules/nat"
  vpc_id = "${module.vpc.vpc_id}"
  subnet-id = "${module.vpc.subnet-id}"
  count_number = "${module.vpc.count_number}"
}
# module "server" {
#   source = "./modules/server"
# }
# module "elb" {
#   source = "./modules/elb"
# }
