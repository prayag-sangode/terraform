# Terraform EKS with EBS CSI Driver

This repository contains Terraform code to deploy an EKS (Elastic Kubernetes Service) cluster and configure the AWS EBS CSI Driver for persistent storage on AWS.

## Prerequisites

Before running the Terraform code, ensure that you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [IAM permissions](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) to create and manage the required AWS resources.

## Files

1. **`provider.tf`**: Contains the AWS provider configuration for Terraform.
2. **`eks.tf`**: Defines the EKS cluster and associated IAM roles.
3. **`ebs-csi-driver.tf`**: Manages the creation of the EBS CSI driver, IAM roles, and service accounts.

## Usage

1. **Initialize Terraform**: Run the following command to initialize Terraform and download the necessary providers:
   ```bash
   terraform init
   ```

2. **Plan**: Create an execution plan to see what Terraform will do:
   ```bash
   terraform plan
   ```

3. **Apply**: Apply the Terraform plan to create the resources in AWS:
   ```bash
   terraform apply
   ```

4. **Verify the Deployment**:
   After applying, you can verify that the EKS cluster is up and running using `kubectl`:
   ```bash
   kubectl get nodes
   ```

5. **Access the EBS CSI Driver**:
   The EBS CSI driver should now be installed and ready to use with your EKS cluster.

## Outputs

- `cluster_endpoint`: The endpoint URL of the EKS cluster.
- `cluster_name`: The name of the EKS cluster.
- `node_group_name`: The name of the EKS node group.

## Cleanup

To destroy all the resources created by Terraform, run:
```bash
terraform destroy
```

## Notes

- This configuration uses the default VPC and subnets for the EKS cluster.
- Ensure your AWS credentials and region are properly configured (either via the AWS CLI or environment variables).
