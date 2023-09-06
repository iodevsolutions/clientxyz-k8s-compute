# Provider Definition 

### Terraform Remote State - This creates a data source for remote state to be used to reference downstream outputs (i.e., from vpc, security, etc)

### Resources or Modules

// Compute SG
resource "aws_security_group" "compute_sg" {
  name        = var.compute_sg_name
  description = var.compute_sg_description
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  ingress {
    from_port   = 7080
    to_port     = 7080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all access to exposed API port"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


### Outputs

// Compute SG
output "compute_security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.compute_sg.id
}

output "compute_security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.compute_sg.name
}

output "compute_security_group_description" {
  description = "The description of the security group"
  value       = aws_security_group.compute_sg.description
}

output "compute_security_group_ingress_rules" {
  description = "The ingress rules of the security group"
  value       = aws_security_group.compute_sg.ingress
}

output "compute_security_group_egress_rules" {
  description = "The egress rules of the security group"
  value       = aws_security_group.compute_sg.egress
}

output "compute_security_group_vpc_id" {
  description = "The VPC ID"
  value       = aws_security_group.compute_sg.vpc_id
}
