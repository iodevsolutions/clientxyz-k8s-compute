### Global Variables

aws_region = "us-east-2"
stack      = "dev"

### Security Specific

compute_sg_name        = "clientxyz-k8s-api-dev-sg"
compute_sg_description = "ClientXYZ K8s Server Security Group"

### Compute Specific

remote_state_bucket    = "clientxyz-terraform-states"
remote_state_infra_key = "k8s-infra/aws-k8s-infra-us-east-2-dev"

compute_instance_type = "t3a.medium"
compute_key_name      = "clientxyz-k8s-dev-ec2"
compute_sda_size      = 40

compute_instance_tags = {
  Name        = "clientxyz-k8s-dev",
  Description = "ClientXYZ K8s DEV EC2 Server",
  DeployedBy  = "Terraform",
  stack       = "dev"
}
