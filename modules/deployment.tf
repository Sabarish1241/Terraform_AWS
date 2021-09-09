variable "aws_region"    {}
variable "vpc_cidr" {}
variable "networkenv" {}
variable "applicationenv" {}
variable "zones" {}
variable "ec2_amis" {}
variable "public_subnets_cidr" {}
variable "private_subnets_cidr" {}
variable "max_size" {}
variable "min_size" {}
variable "strategy" {}
variable "instance_type" {}

#Defining module inputs
module "deploy" {
    source           = "../terraform_resource/deploy"
    aws_region       = "${var.aws_region}"
    vpc_cidr         = "${var.vpc_cidr}"
    networkenv       = "${var.networkenv}"        #defining type of environment for network
    applicationenv   = "${var.applicationenv}"        #defining type of environment for application
    zones            = "${var.zones}"
    ec2_amis         = "${var.ec2_amis}"  # sample example of image
    max_size         = "${var.max_size}"
    min_size         = "${var.min_size}"
    strategy         = "${var.strategy}"
    instance_type    = "${var.instance_type}"
    public_subnets_cidr = "${var.public_subnets_cidr}"
    private_subnets_cidr = "${var.private_subnets_cidr}"
}

