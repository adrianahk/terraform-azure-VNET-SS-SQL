terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "team2project"
    container_name       = "tfstate"
    key                  = "path/to/my/key/prod.terraform.tfstate"
    access_key = "pbdzjjYmnpXTUmYIi/bLxl5qhq+iDbkHXCTFe+UhTwi1UoF1ZvzOszr/KcZFXtkvLPgm+YiyX6NI+AStIDDJsA=="
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "terraform" {
  name     = "terraform-resources"
  location = "westus"
}

resource "azurerm_linux_virtual_machine_scale_set" "terraform" {
  name                = "terraform-vmss"
  resource_group_name = azurerm_resource_group.terraform.name
  location            = azurerm_resource_group.terraform.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
    os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "terraform"
    primary = true

    ip_configuration {
      name      = ["subnet1", "subnet2", "subnet3"]
      primary   = true
      subnet_id = element(azurerm_subnet.subnets[*].id)
    }
  }
}


resource "azurerm_traffic_manager_profile" "terraform" {
  name                = "terraformteam2"
  resource_group_name = azurerm_resource_group.terraform.name

  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "terraformteam2"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_endpoint" "terraform" {
  name                = "terraformteam2"
  resource_group_name = azurerm_resource_group.terraform.name
  profile_name        = azurerm_traffic_manager_profile.terraform.name
  target              = "terraform.io"
  type                = "externalEndpoints"
  weight              = 100
}