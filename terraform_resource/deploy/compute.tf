
# Variables will be coming from module
variable "aws_region"    {}
variable "vpc_cidr" {}
variable "applicationenv" {}
variable "zones" {}
variable "ec2_amis" {}
variable "public_subnets_cidr" {}
variable "private_subnets_cidr" {}
variable "instance_type" {}

# Creation of EC2 and S3 as part of compute script
resource "aws_security_group" "docker_ec2" {
  #name        = "docker-nginx-demo-ec2"
  name        = "${format("docker-nginx-%s", lower(var.applicationenv)}"
  description = "allow incoming HTTP traffic only"
  vpc_id      = "${aws_vpc.demo.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Calling existing 
data "aws_ecr_image" "service_image" {
  repository_name = "my/service"
  image_tag       = "latest"
}

# EC2 instances creation
resource "aws_instance" "docker" {
  name                        = "${format("product_name-%s", lower(var.networkenv)}"
  #ami                         = "${lookup(var.ec2_amis, var.aws_region)}"
  ami                         = ${data.aws_ecr_image.image.service_image}
  associate_public_ip_address = true
  count                       = "${length(var.zones)}"
  depends_on                  = ["aws_subnet.private"]
  instance_type               = "${var.instance_type}"
  #subnet_id                   = "${element(aws_subnet_ids.private.ids, count.index)}"
  subnet_id                   = "${element(aws_subnet.private.*.id,count.index)}"
  user_data                   = "${file("user_data.sh")}"

  # references security group created above
  vpc_security_group_ids = ["${aws_security_group.docker_ec2.id}"]

  tags {
    Name = "docker-nginx-demo-instance-${count.index}"
  }
}

#Creating S3 bucket with index.html
resource "aws_s3_bucket" "b" {
  bucket = ""${format("S3-product_name-%s", lower(var.networkenv)}""
  acl    = "public-read"
  policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}
