variable "public_key_path" {
  default = "~/.ssh/test-terraform.pub"
}

variable "key_name" {
  default = "concourse"
}

variable "aws_region" {
  default = "eu-west-1"
}
variable "aws_amis" {
  # Ubuntu Xenial 16.04 LTS (x64) hvm:dbs-ssd
  default = {
    eu-west-1 = "ami-3079f543"
    us-west-2 = "ami-fa82739a"
    us-east-1 = "ami-840910ee"
  }
  # Trusty
  trusty = {
   eu-west-1 =  "ami-f9a62c8a"
  }
}

