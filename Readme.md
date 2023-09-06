# AWS Compute Terraform Provisioning Scripts

## Prerequisite locally installed toolset(s):
<ul>
  <li>AWS CLI v2.x</li>
  <li>Terraform v1.x</li>
</ul>
<br>

## Set the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables which will allow Terraform access to store state and deploy resources in AWS:

```

export AWS_ACCESS_KEY_ID="AWS Access Key"
export AWS_SECRET_ACCESS_KEY="AWS Secret Key" 

```
<br>

## Change directory to the desired working environment:
*DEV*
```
cd environments/dev
```
<br>

## Execute the create ssh key script (if EC2 key pair does not exist) and check for errors:
*DEV*
```
. ./create_k8s_dev_ssh_key.sh
```
<br>

## Run the initialization command and check for errors:
```
terraform init 
```
<br>

## Once initialization is confirmed, run the validate command and check for errors:
```
terraform validate
```
<br>

## Once validation is confirmed run the plan command:
*DEV*
```
terraform plan -var-file=dev.env.tfvars -out "planfile"
```
<br>

## Once planning is confirmed run the apply command:
```
terraform apply "planfile"
```
<br>

## If the infrastructure needs to be destroyed run the destroy command:
*DEV*
```
terraform destroy -var-file=dev.env.tfvars
```
<br>
