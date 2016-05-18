resource "aws_route53_record" "web" {
  zone_id = "Z3PIZYOKTFK9RP"
  name = "concourse"
  type = "CNAME"
  ttl = "60"
  weight = 10
  set_identifier = "concourse"
  records = ["${aws_elb.web.dns_name}"]

}
resource "aws_elb" "web" {
  name = "concourse-elb"
  security_groups = ["${aws_security_group.application.id}"]
  listener {
    instance_port = 8080
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:8080"
    interval = 30
  }
  instances = ["${aws_instance.web.id}"]
  subnets = ["${aws_subnet.application-a.id}", "${aws_subnet.application-b.id}", "${aws_subnet.application-c.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  tags {
    Name = "concourse-elb"
  }
}

resource "aws_instance" "web" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.application.id}"]
  instance_type = "m3.medium"
  subnet_id = "${aws_subnet.application-c.id}"
  associate_public_ip_address = true
  user_data = "${file("resources/user_data.sh")}"
  iam_instance_profile = "autonomous"
  tags {
    Name = "application.concourse-next"
    Project = "concourse"
    Environment = "next"
    Role = "application"
    ForgeBucket = "telusdigital-forge"
    ForgeRegion = "eu-central-1"
  }
}

resource "aws_security_group" "application" {
  name = "application"
  vpc_id = "${aws_vpc.default.id}"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2222
    to_port   = 2222
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

