data "terraform_remote_state" "main" {
  backend = "azurerm" 
  config = {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "team2project"
    container_name       = "tfstate"
    key                  = "path/to/my/asg/prod.terraform.tfstate"
    access_key           = "pbdzjjYmnpXTUmYIi/bLxl5qhq+iDbkHXCTFe+UhTwi1UoF1ZvzOszr/KcZFXtkvLPgm+YiyX6NI+AStIDDJsA=="
  }
}

output "full_info" {
 value = data.terraform_remote_state.main.outputs.*
}



# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_linux_virtual_machine_scale_set" "terraform-ss" {
  name                = "terraform-ss"
  resource_group_name = "terraform-resources"
  location            = "westus"
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
      name      = "internal"
      primary   = true
      subnet_id =["/subscriptions/9fa90ac8-c1ee-4759-ba48-216e13b0c938/resourceGroups/terraform-resources/providers/Microsoft.Network/virtualNetworks/terraform_vnet/subnets/subnet3", subscriptions/9fa90ac8-c1ee-4759-ba48-216e13b0c938/resourceGroups/terraform-resources/providers/Microsoft.Network/virtualNetworks/terraform_vnet/subnets/subnet2", "/subscriptions/9fa90ac8-c1ee-4759-ba48-216e13b0c938/resourceGroups/terraform-resources/providers/Microsoft.Network/virtualNetworks/terraform_vnet/subnets/subnet1"]
    }
  }
}
  


resource "azurerm_traffic_manager_profile" "tm-profile" {
  name                = "tm-profile"
  resource_group_name = "terraform-resources"
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "tm-profile"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
  }

resource "azurerm_traffic_manager_azure_endpoint" "terraform" {
  target_resource_id  = "/subscriptions/9fa90ac8-c1ee-4759-ba48-216e13b0c938/resourceGroups/terraform-resources/providers/Microsoft.DBforMySQL/servers/project-mysqlserver/databases/projectdb"
  name                = "terraform-endpoint"
  profile_id          = azurerm_traffic_manager_profile.tm-profile.id
  weight              = 100
}

