# Outputs
output "web_app_default_hostname" {
  description = "The default hostname of the Web App"
  value       = "https://${azurerm_linux_web_app.web_app.default_hostname}"
}