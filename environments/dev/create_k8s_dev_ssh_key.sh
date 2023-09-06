aws ec2 create-key-pair --region us-east-2 --key-name clientxyz-k8s-dev-ec2 --query 'KeyMaterial' --output text > clientxyz-k8s-dev-ec2.pem
chmod 600 clientxyz-k8s-dev-ec2.pem