#! /bin/bash

# Install basics and prereqs
sudo yum update && \
sudo yum upgrade 

# Set the hostname
sudo hostnamectl set-hostname clientxyz-k8s-dev --static

# Install Docker
sudo yum install -y docker
sudo usermod -aG docker ec2-user && newgrp docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker

# Install Nginx
sudo yum install -y nginx
# create default nginx config
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
echo "user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
                      '\$status \$body_bytes_sent \"\$http_referer\" '
                      '\"\$http_user_agent\" \"\$http_x_forwarded_for\"';
    
    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen 7080;
        server_name _;

        location / {
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header Host \$host;
                proxy_set_header X-NginX-Proxy true;
                proxy_pass http://192.168.100.200:30888/;
        }
    }
}" | sudo tee /etc/nginx/nginx.conf
sudo systemctl enable nginx.service
sudo systemctl restart nginx

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube Cluster
sudo -i -u ec2-user minikube start --driver docker --static-ip 192.168.100.200

# Install Kubectl
sudo -i -u ec2-user minikube kubectl --

# Create Minikube deployment yaml
echo "# First, add the API
apiVersion: apps/v1
# This will be the deployment setup
kind: Deployment
metadata:
  # Name your Deployment here
  name: py-api-dep
  labels:
    # label your deployment
    app: py-api-dev-app
spec:
  # The number of pods/replicas to run
  replicas: 1            
  selector:
    matchLabels:
    # selector to match the pod
      app: py-api-dev-app  
  template:
    metadata:
      labels:
      # label your pod
        app: py-api-dev-app  
    spec:
      containers:
      # Add the container name for Kubernetes
      - name: py-api-app 
      # Add the local image name
        image: clientxyz/py-api:latest 
        # never pull the image policy
        imagePullPolicy: Never
        ports:
        # port for running the container
        - containerPort: 8000   
---
# First, add the Service API
apiVersion: v1
# This will be the Service setup
kind: Service
metadata:
  # Your service name
  name: py-api-src 
spec:
  selector:
    # selector that matches the pod
    app: py-api-dev-app 
  # type of service
  type: NodePort 
  ports:
  - protocol: TCP 
    # port for exposing the service        
    port: 8000
    # port for exposing the pod             
    targetPort: 8000
    nodePort: 30888
" | sudo -i -u ec2-user tee /home/ec2-user/k8s.yaml

# Create Minikube deployment from file
sudo -i -u ec2-user minikube kubectl -- create -f /home/ec2-user/k8s.yaml
