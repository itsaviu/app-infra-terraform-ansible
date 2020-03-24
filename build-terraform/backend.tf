terraform {
  backend "s3" {
    bucket = "tf-avi-state"
    key = "terraform/build-state-file"
    region = "us-east-1"
  }
}
