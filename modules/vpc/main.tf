# VPC MAIN TF

data "aws_availability_zones" "az_available" {}

resource "aws_vpc" "main" {
  cidr_block           = "${var.aws_vpc_cidr_block}"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "MyMainVPC"
  }
}

# Subnets
resource "aws_subnet" "main-public" {
  count                   = "${var.number_of_azs}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.vpc_net_prefix}${count.index}${var.vpc_net_postfix}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.az_available.names[count.index]}"

  tags {
    Name = "MyMain-public-${count.index}"
  }
}

resource "aws_subnet" "main-private" {
  count                   = "${var.number_of_azs}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.vpc_net_prefix}${count.index+3}${var.vpc_net_postfix}"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  availability_zone = "${data.aws_availability_zones.az_available.names[count.index]}"

  tags {
    Name = "MyMain-private-${count.index}"
  }
}
# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "MyMainGW"
  }
}
# route tables
resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.main.id}"
  depends_on = ["aws_subnet.main-public"]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }

  tags {
    Name = "MyMain-PublicRT"
  }
}

# route tables for private
# resource "aws_route_table" "main-private" {
#   vpc_id = "${aws_vpc.main.id}"
#
#   #depends_on = "${aws_instance.nat-instance}"
#   route {
#     cidr_block = "0.0.0.0/0"
#
#     #instance_id = "${aws_instance.nat-instance.id}"
#     instance_id = "${module.nat.nat_instance_id}"
#   }
#
#   tags {
#     Name = "MyMain-PrivateRT"
#   }
# }

# route associations public
resource "aws_route_table_association" "main-public" {
  count                   = "${var.number_of_azs}"
  #subnet_id      = "${aws_subnet.main-public-1.id}"
  depends_on  = ["aws_route_table.main-public"]
  subnet_id      = "${aws_subnet.main-public.*.id[count.index]}"
  route_table_id = "${aws_route_table.main-public.id}"
}


//===================================================

# # Subnets
# resource "aws_subnet" "main-public-1" {
#   vpc_id                  = "${aws_vpc.main.id}"
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1a"
#
#   tags {
#     Name = "main-public-1"
#   }
# }
#
# resource "aws_subnet" "main-public-2" {
#   vpc_id                  = "${aws_vpc.main.id}"
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1b"
#
#   tags {
#     Name = "main-public-2"
#   }
# }
#
# resource "aws_subnet" "main-public-3" {
#   vpc_id                  = "${aws_vpc.main.id}"
#   cidr_block              = "10.0.3.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1c"
#
#   tags {
#     Name = "main-public-3"
#   }
# }
#
# resource "aws_subnet" "main-private-1" {
#   vpc_id                  = "${aws_vpc.main.id}"
#   cidr_block              = "10.0.4.0/24"
#   map_public_ip_on_launch = "false"
#   availability_zone       = "us-east-1a"
#
#   tags {
#     Name = "main-private-1"
#   }
# }
#
# resource "aws_subnet" "main-private-2" {
#   vpc_id                  = "${aws_vpc.main.id}"
#   cidr_block              = "10.0.5.0/24"
#   map_public_ip_on_launch = "false"
#   availability_zone       = "us-east-1b"
#
#   tags {
#     Name = "main-private-2"
#   }
# }
#
# resource "aws_subnet" "main-private-3" {
#   vpc_id                  = "${aws_vpc.main.id}"
#   cidr_block              = "10.0.6.0/24"
#   map_public_ip_on_launch = "false"
#   availability_zone       = "us-east-1c"
#
#   tags {
#     Name = "main-private-3"
#   }
# }
#
# # Internet GW
# resource "aws_internet_gateway" "main-gw" {
#   vpc_id = "${aws_vpc.main.id}"
#
#   tags {
#     Name = "main"
#   }
# }
#
# # route tables
# resource "aws_route_table" "main-public" {
#   vpc_id = "${aws_vpc.main.id}"
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "${aws_internet_gateway.main-gw.id}"
#   }
#
#   tags {
#     Name = "main-public-1"
#   }
# }
#
# # route tables for private
# resource "aws_route_table" "main-private" {
#   vpc_id = "${aws_vpc.main.id}"
#
#   #depends_on = "${aws_instance.nat-instance}"
#   route {
#     cidr_block = "0.0.0.0/0"
#
#     #instance_id = "${aws_instance.nat-instance.id}"
#     instance_id = "${module.nat.nat_instance_id}"
#   }
#
#   tags {
#     Name = "main-route-private-1"
#   }
# }
#
# # route associations public
# resource "aws_route_table_association" "main-public-1-a" {
#   subnet_id      = "${aws_subnet.main-public-1.id}"
#   route_table_id = "${aws_route_table.main-public.id}"
# }
#
# resource "aws_route_table_association" "main-public-2-a" {
#   subnet_id      = "${aws_subnet.main-public-2.id}"
#   route_table_id = "${aws_route_table.main-public.id}"
# }
#
# resource "aws_route_table_association" "main-public-3-a" {
#   subnet_id      = "${aws_subnet.main-public-3.id}"
#   route_table_id = "${aws_route_table.main-public.id}"
# }
#
# # route associations private
# resource "aws_route_table_association" "main-private-1-a" {
#   subnet_id      = "${aws_subnet.main-private-1.id}"
#   route_table_id = "${aws_route_table.main-private.id}"
# }
#
# resource "aws_route_table_association" "main-private-2-a" {
#   subnet_id      = "${aws_subnet.main-private-2.id}"
#   route_table_id = "${aws_route_table.main-private.id}"
# }
#
# resource "aws_route_table_association" "main-private-3-a" {
#   subnet_id      = "${aws_subnet.main-private-3.id}"
#   route_table_id = "${aws_route_table.main-private.id}"
# }
