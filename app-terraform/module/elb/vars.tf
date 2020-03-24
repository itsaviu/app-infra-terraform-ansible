variable "INSTANCES" {
  type = list(string)
}

variable "RESOURCE_NAME" {}

variable "VPC_ID" {}

variable "INSTANCE_SUBNETS" {
  type = list(string)
}
