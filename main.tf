terraform {
  required_version = ">= 0.11.0"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "sghomework" {
  name        = "${var.security_group_name}"
  description = "${var.security_group_name_description}"

  ingress {
    description      = "${var.ingress_descritpion}"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.aws_region}"
  vpc_security_group_ids = [aws_security_group.sghomework.id]
}

resource "aws_elb" "elb" {
  name               = "test-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  security_groups    = [aws_security_group.sghomework.id]
  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3000/"
    interval            = 30
  }

  instances                   = [aws_instance.ubuntu.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}

resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "ami-0af861938197b2ba3"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["eu-west-2"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}

module "asg_scaling" {
  source           = "HENNGE/ecs/aws//modules/autoscaling/asg-target-tracking/ecs-reservation"
  version          = "1.0.0"

  name                         = "test"
  autoscaling_group_name       = "bar"
  ecs_cluster_name             = "ecs-cluster-name"
  enable_cpu_based_autoscaling = true
  cpu_threshold                = 50
  cpu_statistics               = "Average"
}