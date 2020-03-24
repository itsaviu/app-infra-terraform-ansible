resource "aws_key_pair" "keypair" {
  key_name   =   var.RESOURCE_NAME
  public_key =   file(var.KEY_DIR)
  tags = {
    Name     =   var.RESOURCE_NAME
    Owner    =   "Avi"
  }
}
