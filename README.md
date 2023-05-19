This Terraform file builds a secured AKS cluster inside an existing Azure Landing Zone (assuming VNET, Log Analytics workspace are deployed in an existing resource group)

It comes with :

- Azure AD integration:
    - Only AAD connections are allowed
	- Local admin is disabled
	- A SPN is created and used for further Kubernetes objects provisionning (like namespaces)
- API server lockdown with your detected public IP
- Microsoft Defender enabled
- Container Insights enabled
- KEDA autoscaler

Copy variables.sample.tfvars to variables.tfvars and replace with your values

```
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars 
```