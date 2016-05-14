resource "aws_instance" "web" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.application.id}"]
  instance_type = "m3.medium"
  subnet_id = "${aws_subnet.application-c.id}"
  associate_public_ip_address = true
  user_data = "I2Nsb3VkLWNvbmZpZw0KcmVwb191cGRhdGU6IHRydWUNCnJlcG9fdXBncmFkZTogYWxsDQoNCnBhY2thZ2VzOg0KIC0gYW5zaWJsZQ0KDQpydW5jbWQ6DQogLSBzdWRvIGFuc2libGUtZ2FsYXh5IGluc3RhbGwga2t3b2tlci5jb25jb3Vyc2UgLS1mb3JjZQ0K"
  tags {
    Name = "application.concourse-next"
  }
}
