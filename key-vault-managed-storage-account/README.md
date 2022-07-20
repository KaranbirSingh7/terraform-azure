### Create a new Azure Key Vault managed Storage Account

> Note: this behaviour as of today cannot be seen through Azure Portal, this can only be achieved using API/SDK methods.

# QuickStart
```bash
# an existing resource_group created in azure
echo "resource_group_name=\"make-changes-to-azure-infrastructure\"" > terraform.tfvars

tf plan

tf apply -auto-approve
```


# Test Rotation of Keys
```bash
# make sure you are logged into azure through az-cli
az login

# list ALL managed keys
az keyvault storage show --vault-name 'mysamplekeyvaultoops' --id 'https://mysamplekeyvaultoops.vault.azure.net/storage/mystorageaccountoops' 

# rotate key1
az keyvault storage regenerate-key  --vault-name 'mysamplekeyvaultoops' --id 'https://mysamplekeyvaultoops.vault.azure.net/storage/mystorageaccountoops' --key-name 'key1'

# rotate key2
az keyvault storage regenerate-key  --vault-name 'mysamplekeyvaultoops' --id 'https://mysamplekeyvaultoops.vault.azure.net/storage/mystorageaccountoops' --key-name 'key2'
```