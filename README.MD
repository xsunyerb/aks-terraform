# AKS WITH TERRAFORM

This repostory contains code to create an AKS cluster with Terraform.

Based on Microsoft Docs' documentation on [Configure Terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell) and [Create an AKS cluster](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks)

### Manage Azure account

To use this commands, you need the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

Azure login
```
az login
```
View current Azure subscription
```
az account show
```
Display a list of subscription name ID values
```
az account list --query "[].{name:name, subscriptionId:id}"
```
To use a specific Azure subscription for the current Cloud Shell session, use az account set.
```
az account set --subscription="<subscription_id>"
```
Create a service principal for terraform
```
az ad sp create-for-rbac --skip-assignment --name myAKSClusterServicePrincipal
```

### Configuration

Set up Azure storage to store Terraform state
```
az storage container create -n tfstate --account-name <YourAzureStorageAccountName> --account-key <YourAzureStorageAccountKey>
```
Create ssh public key
```
ssh-keygen -m PEM -t rsa -b 4096
```

### Cluster creation

1.Initialize terraform
```
terraform init -backend-config="storage_account_name=<YourAzureStorageAccountName>" -backend-config="container_name=tfstate" -backend-config="access_key=<YourStorageAccountAccessKey>" -backend-config="key=codelab.microsoft.tfstate"
```
2.Export your service principal credentials
```
[Environment]::SetEnvironmentVariable("TF_VAR_client_id",<service-principal-appid>)
[Environment]::SetEnvironmentVariable("TF_VAR_client_secret",<service-principal-password>)
```
3.Run the terraform plan command to create the Terraform plan that defines the infrastructure elements.
```
terraform plan -out out.plan
```
4.Run the terraform apply command to apply the plan to create the Kubernetes cluster.
```
terraform apply out.plan
```

### Cluster test

1.Get the Kubernetes configuration from the Terraform state and store it in a file that kubectl can read.
```
echo "$(terraform output kube_config)" > ./azurek8s
```
2.Set an environment variable so that kubectl picks up the correct config.
```
[Environment]::SetEnvironmentVariable("KUBECONFIG", "./azurek8s")
```
3.Verify the health of the cluster.
```
kubectl get nodes
```
