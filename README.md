# Terraform Example EC2 Project

- Export your AWS credentials:

```sh
export AWS_ACCESS_KEY_ID="<your-access-key-id>"
export AWS_SECRET_ACCESS_KEY="<your-secret-access-key>"
```

- Generate an EC2 keypair and place it in the `terraform.tfvars` file in the `ec2.key_name` variable.

- Run Terraform plan

```sh
terraform plan
```

- Run Terraform apply

```sh
terraform apply
```
