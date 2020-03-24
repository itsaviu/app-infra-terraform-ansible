terraform {
  backend "s3" {
    bucket = "tf-avi-state"
    key = "terraform/movie-webapp-state-file"
    region = "us-east-1"
  }
}
