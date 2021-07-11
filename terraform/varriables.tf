variable "aws_region" {
  description = "AWS region"
  default = "eu-west-2"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  default = "ami-03ac5a9b225e99b02"
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  default = "t2.micro"
}

variable "name" {
  description = "name to pass to Name tag"
  default = "terraform server"
}

variable "security_group_name"{
  description = "sg-name"
  default = "homework-sg-terraform"
}

variable "security_group_name_description"{
  description = "description for "
  default = "terraform security_group"
}

variable "ingress_descritpion"{
  description = "description for "
  default = "ingres settings"
}
