resource "aws_subnet" "application-a" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "eu-west-1a"
  cidr_block              = "10.0.1.0/27"
  map_public_ip_on_launch = true
  tags {
    Name = "concourse-application"
  }
}

resource "aws_subnet" "application-b" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "eu-west-1b"
  cidr_block              = "10.0.1.32/27"
  map_public_ip_on_launch = true
  tags {
    Name = "concourse-application"
  }
}

resource "aws_subnet" "application-c" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "eu-west-1c"
  cidr_block              = "10.0.1.64/27"
  map_public_ip_on_launch = true
  tags {
    Name = "concourse-application"
  }
}
resource "aws_subnet" "database-a" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "eu-west-1a"
  cidr_block              = "10.0.2.0/27"
  map_public_ip_on_launch = true
  tags {
    Name = "concourse-database"
  }
}
resource "aws_subnet" "database-b" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "eu-west-1b"
  cidr_block              = "10.0.2.32/27"
  map_public_ip_on_launch = true
  tags {
    Name = "concourse-database"
  }
}
resource "aws_subnet" "database-c" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "eu-west-1c"
  cidr_block              = "10.0.2.64/27"
  map_public_ip_on_launch = true
  tags {
    Name = "concourse-database"
  }
}
output "subnet-application-a" {
  value = "${aws_subnet.application-a.id}"
}
output "subnet-application-b" {
  value = "${aws_subnet.application-b.id}"
}
output "subnet-application-c" {
  value = "${aws_subnet.application-c.id}"
}
output "subnet-database-a" {
  value = "${aws_subnet.database-a.id}"
}
output "subnet-database-b" {
  value = "${aws_subnet.database-b.id}"
}
output "subnet-database-c" {
  value = "${aws_subnet.database-c.id}"
}
