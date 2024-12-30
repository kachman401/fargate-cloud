
cidr_block = "10.0.0.0/16"
region = "eu-north-1"
profile = "staging"
environment = "staging"
all_cidr  = "0.0.0.0/0"
tag     = "fargate-deployment"
name    = "fargate"
public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets     = ["10.0.100.0/24", "10.0.200.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
container_port = "8081"