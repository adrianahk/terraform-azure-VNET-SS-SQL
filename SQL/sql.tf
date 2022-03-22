terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "team2project"
    container_name       = "tfstate"
    key                  = "path/to/my/sql/prod.terraform.tfstate"
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

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "mysql" {
  name     = "mysql"
  location = "westus"
}

resource "azurerm_mysql_server" "mysqlserver" {
  name                = "mysqlserver"
  location            = azurerm_resource_group.mysqlserver.location
  resource_group_name = azurerm_resource_group.mysqlserver.name

  administrator_login          = "mysqladmin"
  administrator_login_password = "mysqlpassword"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mysqldb" {
  name                = "mysqldb"
  resource_group_name = azurerm_resource_group.mysqldb.name
  server_name         = azurerm_mysql_server.mysqldb.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
