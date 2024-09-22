
# Resource Group
resource "azurerm_resource_group" "rg_web_app" {
  name     = "rg-${var.web_app_name}-poc"
  location = var.location

  tags = {
    owner       = "Wael Amer"
    environment = "poc"
    project     = "zurich-q1"
    department  = "IT"
    cost_center = "12345"
  }
}

# App Service Plan - Set os_type to Linux
resource "azurerm_service_plan" "app_service_plan" {
  name                = "asp-${var.web_app_name}-poc"
  location            = azurerm_resource_group.rg_web_app.location
  resource_group_name = azurerm_resource_group.rg_web_app.name

  sku_name = var.sku_name
  os_type  = "Linux"

  tags = {
    owner       = "Wael Amer"
    environment = "poc"
    project     = "zurich-q1"
  }
}

# Linux Web App
resource "azurerm_linux_web_app" "web_app" {
  name                = "webapp-${var.web_app_name}-poc"
  location            = azurerm_resource_group.rg_web_app.location
  resource_group_name = azurerm_resource_group.rg_web_app.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    always_on = false
    # linux_fx_version = "PYTHON|3.9" 
  }
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app_insights.connection_string
  }

  https_only = true # For testing purposes, allow both HTTP and HTTPS

  tags = {
    owner       = "Wael Amer"
    environment = "poc"
    project     = "zurich-q1"
  }
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = "appinsights-${var.web_app_name}-poc"
  location            = azurerm_resource_group.rg_web_app.location
  resource_group_name = azurerm_resource_group.rg_web_app.name
  application_type    = "web"

  tags = {
    owner       = "Wael Amer"
    environment = "poc"
    project     = "zurich-q1"
  }
}

