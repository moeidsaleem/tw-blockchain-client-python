


# setup aws access key id and secret access key

export AWS_ACCESS_KEY_ID=<your access key id>
export AWS_SECRET_ACCESS_KEY=<your secret access key>
export AWS_DEFAULT_REGION=<your region>



# setup terraform
terraform init -migrate-state


# setup terraform variables
cp .tfvars.example terraform.tfvars

# Apply terraform
terraform apply -var-file="terraform.tfvars"
