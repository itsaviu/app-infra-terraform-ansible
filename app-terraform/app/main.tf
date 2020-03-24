locals {
  
  BUILD_VPC="vpc-04d76ebde474cb98e"
  BUILD_ROUTE_TABLE="rtb-039b1cff3400f3109"
  BUILD_SG="sg-0fdcce8d9ab6ee5a0"
  BUILD_SUBNET="subnet-0ed3f2ead1e0674a3"

  SECRET_KEY="/home/ubuntu/.ssh/id_rsa"
  SSH_KEY_DIR="/home/ubuntu/.ssh/id_rsa.pub"
}


module "key-gen" {
  source = "../module/key_pair"
  KEY_DIR = local.SSH_KEY_DIR
  RESOURCE_NAME = "instace_key"
}

module "aws_proxy_instance" {
  source = "../module/proxy_instance"
  INSTANCE_AMI = "ami-04b9e92b5572fa0d1"
  INSTANCE_TYPE = "t2.micro"
  KEY_PAIR_ID = module.key-gen.KEY_PAIR_ID
  RESOURCE_NAME = "Proxy Instance"
  SSH_SECRET_KEY = local.SECRET_KEY
  VPC_ID = local.BUILD_VPC
  ROUTE_TABLE_ID = local.BUILD_ROUTE_TABLE
  SUBNET_ID = module.aws_network.PROXY_SUBNET_ID
  SG_NAME = "proxy_instance_sg"
  REQUESTOR_INSTANCE_SG = list(local.BUILD_SG)
  PROXY_PASS_HOST = module.aws_webapp_instance.PRIVATE_IP
}


module "aws_proxy_instance_2" {
  source = "../module/proxy_instance"
  INSTANCE_AMI = "ami-04b9e92b5572fa0d1"
  INSTANCE_TYPE = "t2.micro"
  KEY_PAIR_ID = module.key-gen.KEY_PAIR_ID
  RESOURCE_NAME = "Proxy Instance 2"
  SSH_SECRET_KEY = local.SECRET_KEY
  VPC_ID = local.BUILD_VPC
  ROUTE_TABLE_ID = local.BUILD_ROUTE_TABLE
  SUBNET_ID = module.aws_network.PROXY_2_SUBNET_ID
  SG_NAME = "proxy_instance_sg_2"
  REQUESTOR_INSTANCE_SG = list(local.BUILD_SG)
  PROXY_PASS_HOST = module.aws_webapp_instance.PRIVATE_IP
}

module "aws_webapp_instance" {
  source = "../module/instance"
  INSTANCE_AMI = "ami-04b9e92b5572fa0d1"
  INSTANCE_TYPE = "t2.micro"
  KEY_PAIR_ID = module.key-gen.KEY_PAIR_ID
  RESOURCE_NAME = "Web Instance"
  SSH_SECRET_KEY = local.SECRET_KEY
  ACCESSIBLE_INSTANCE_SG = list(local.BUILD_SG, module.aws_proxy_instance.INSTANCE_SG, module.aws_proxy_instance_2.INSTANCE_SG)
  VPC_ID = local.BUILD_VPC
  ROUTE_TABLE_ID = module.aws_network.ROUTE_NAT_ID
  SUBNET_ID = module.aws_network.WEBAPP_SUBNET_ID
  SG_NAME = "webapp_instance_sg"
  REQUESTOR_INSTANCE_SG = list(local.BUILD_SG)
  DB_PASSWORD = "postgresql"
  DB_URL = module.aws_rds.RDS_HOST_ENDPOINT
  PROXY_PASS_HOST = "localhost:8080"
}


module "aws_rds" {
  source = "../module/rds"
  ACCESSIBLE_INSTANCE_SG = list(module.aws_webapp_instance.INSTANCE_SG)
  SUBNET_IDS = list(module.aws_network.WEBAPP_SUBNET_ID, module.aws_network.PROXY_SUBNET_ID, module.aws_network.PROXY_2_SUBNET_ID)
  VPC_ID = local.BUILD_VPC
}

module "aws_network" {
  source = "../module/network"
  VPC_ID = local.BUILD_VPC
  PUBLIC_SUBNET_ID = local.BUILD_SUBNET
}


module "aws_elb" {
  source = "../module/elb"
  INSTANCES = list(module.aws_proxy_instance.INSTANCE_ID, module.aws_proxy_instance_2.INSTANCE_ID)
  RESOURCE_NAME = "ELB_INSTANCE"
  INSTANCE_SUBNETS = list(module.aws_network.PROXY_SUBNET_ID, module.aws_network.PROXY_2_SUBNET_ID)
  VPC_ID = local.BUILD_VPC
}
