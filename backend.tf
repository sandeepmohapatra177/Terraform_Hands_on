terraform {
  backend "azurerm" {
    resource_group_name  = "demo-resources"
    storage_account_name = "tfstatestorage177"
    container_name       = "tfstate-container"
    key                  = "terraform.tfstate"
  }
}