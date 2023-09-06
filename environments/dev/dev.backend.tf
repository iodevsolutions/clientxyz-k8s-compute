terraform {
  backend "s3" {
    bucket = "clientxyz-terraform-states"
    key    = "k8s-compute/aws-k8s-compute-us-east-2-dev"
    region = "us-east-2"
  }
}