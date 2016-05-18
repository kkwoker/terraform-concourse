resource "aws_elb" "web" {
  name = "concourse-elb"
  security_groups = ["${aws_security_group.application.id}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8000/"
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
