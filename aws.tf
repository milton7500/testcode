provider "aws" {
  region = var.region
}


#AWS ec2 intance

resource "aws_instance" "myec2" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = var.instance_type
}