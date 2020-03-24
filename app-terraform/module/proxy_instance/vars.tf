variable "INSTANCE_AMI" {}

variable "INSTANCE_TYPE" {}

variable "KEY_PAIR_ID" {}

variable "RESOURCE_NAME" {}

variable "SSH_SECRET_KEY" {}

variable "VPC_ID" {}


variable "ROUTE_TABLE_ID" {}

variable "SUBNET_ID" {}


variable "SG_NAME" {}

variable "REQUESTOR_INSTANCE_SG" {
  type = list(string)
}

variable "PROXY_PASS_HOST" {}
