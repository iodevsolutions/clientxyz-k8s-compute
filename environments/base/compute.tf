# Provider Definition 

provider "aws" {
  region = var.aws_region
}

### Terraform Remote State - This creates a data source for remote state to be used to reference downstream outputs (i.e., from vpc, security, etc)

data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_infra_key
    region = var.aws_region
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "description"
    values = ["Amazon Linux 2023 AMI 2023*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_kms_key" "compute_kms_key" {
  key_id = "alias/aws/ebs"
}

### Resources or Moduless

// Create EC2 Instance
resource "aws_instance" "application_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.compute_instance_type
  subnet_id                   = data.terraform_remote_state.infra.outputs.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.compute_sg.id]
  key_name                    = var.compute_key_name
  iam_instance_profile        = data.terraform_remote_state.infra.outputs.ec2_profile_name
  associate_public_ip_address = true
  user_data                   = file("k8s_provision.sh")

  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
    ignore_changes        = [ami, volume_tags, user_data]
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.compute_sda_size
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = data.aws_kms_key.compute_kms_key.arn
  }

  tags = var.compute_instance_tags
}


### Outputs

// Compute instance
output "instance_id" {
  value = aws_instance.application_server.id
}

output "instance_public_ip" {
  value = aws_instance.application_server.public_ip
}

output "instance_public_dns" {
  value = aws_instance.application_server.private_dns
}
