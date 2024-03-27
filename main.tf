terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "random_integer" "rand" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-votre_nom-${random_integer.rand.result}"
  location = "West Europe"  # Remplacez par votre région Azure préférée
}

resource "azurerm_app_service_plan" "asp" {
  name                = "asp-votre_nom-${random_integer.rand.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-votre_nom-${random_integer.rand.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    java_version = "1.7"
    java_container = "TOMCAT"
  }
}
