provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "concourse-next"
  }
}
output "vpc" {
  value = "${aws_vpc.default.id}"
}
resource "aws_db_subnet_group" "default" {
  name = "concourse_subnets"
  description = "group of concourse subnets"
  subnet_ids = ["${aws_subnet.database-a.id}",
                "${aws_subnet.database-b.id}",
                "${aws_subnet.database-c.id}"]
}

resource "aws_db_instance" "default" {
  allocated_storage = 10
  engine            = "postgres"
  engine_version    = "9.4.7"
  instance_class    = "db.m3.medium"
  identifier        = "database-concourse"
  name              = "concourse"
  username          = "concourse"
  password          = "password"
  multi_az          = false
  db_subnet_group_name = "concourse_subnets"
  vpc_security_group_ids = ["${aws_security_group.database.id}"]
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
resource "aws_security_group" "database" {
  name = "database"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
