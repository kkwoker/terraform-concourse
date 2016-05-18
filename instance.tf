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
