terraform {
  backend "azurerm" {
    resource_group_name  = "demo-resources"
    storage_account_name = "terraform177s"
    container_name       = "tf-state"
    key                  = "terraform.tfstate"
  }
}