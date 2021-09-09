# Defining variable inputs in tfenv to not expose/modify the reusable scripts
    aws_region       = "us-east-1"
    vpc_cidr         = "10.0.0.0/16"
    networkenv       = "prodnqa"        # defining type of environment for network
    zones            = "us-east-1a"
    ec2_amis         = "ami-059eeca93cf09eebd"  # sample example of image
    public_subnets_cidr = "10.0.1.0/24"
    private_subnets_cidr = "10.0.2.0/24"
    max_size         = "6"                    
    min_size         = "3"
    strategy         = "cluster"
    instance_type    = "t2.micro"
    applicationenv   = "prodnqa"        # defining type of environment for application