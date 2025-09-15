resource "azurerm_storage_account" "storage1"{

name= "sandeep177blob"
location = "East US"
resource_group_name = "Terraform"
account_replication_type = "LRS"
account_tier = "Standard"

}
