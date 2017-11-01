# ROOT - MAIN TF
provider "aws" {
    region = "${var.region}"
#    access_key = "${var.aws_access_key}"
#    secret_key = "${var.aws_secret_key}"
}

module "vpc" {
  source = "./modules/vpc"
}
# module "nat" {
#   source = "./modules/nat"
# }
# module "server" {
#   source = "./modules/server"
# }
# module "elb" {
#   source = "./modules/elb"
# }
