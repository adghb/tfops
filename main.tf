# Create s3 bucket
resource "aws_s3_bucket" "s3test" {
  bucket = "s3-terraform-test-bucket"
  acl = "private"
  versioning {
    enabled = true
  }
  tags {
    Name = "s3-terraform-test-bucket"
  }

}


# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "s3-terraform-test-bucket"
//    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# Use AWS Terraform provider
provider "aws" {
  region = "ap-south-1"
}

# Create EC2 instance
resource "aws_instance" "default" {
  ami                    = "${var.ami}"
//  count                  = "${var.count}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  source_dest_check      = false
  instance_type          = "${var.instance_type}"

  tags {
    Name = "terraform-default"
  }
}

# Create Security Group for EC2
resource "aws_security_group" "default" {
  name = "terraform-default-sg"

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
