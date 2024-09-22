# Variables
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "xxx-xxx-xxx-xxx"
}

variable "location" {
  description = "Azure resources location"
  type        = string
  default     = "West Europe"
}

variable "web_app_name" {
  description = "The name of the Web App"
  type        = string
  default     = "demo"
}

variable "sku_name" {
  description = "The SKU name for the App Service Plan (Free tier)"
  type        = string
  default     = "F1"
}
