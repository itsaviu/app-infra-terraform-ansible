variable "VPC_ID" {}

variable "SUBNET_IDS" {
  type = list(string)
}

variable "ACCESSIBLE_INSTANCE_SG" {
  type = list(string)
}
