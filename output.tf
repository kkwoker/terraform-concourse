output "application-concourse-next" {
  value = "${aws_instance.web.public_ip}"
}

