#!/bin/bash

set -e  # Exit on any error

echo "Starting deployment process..."

# Validate Terraform
echo "Validating Terraform configuration..."
cd infrastructure/terraform
terraform validate

# Plan changes
echo "Creating Terraform plan..."
terraform plan -out=plan.tfplan

# Apply changes (uncomment for actual deployment)
# terraform apply -auto-approve plan.tfplan

# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --cluster-name portfolio-cluster

# Deploy to Kubernetes
echo "Deploying to Kubernetes..."
kubectl apply -f ../../kubernetes/

# Wait for rollout
echo "Waiting for deployment to complete..."
kubectl rollout status deployment/webapp-deployment

echo "Deployment completed successfully!"