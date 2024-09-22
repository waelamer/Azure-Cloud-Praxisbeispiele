# 1. Terraform-Aufgabe: Bereitstellung einer Azure Web App

## Aufgabe: Verwenden Sie Terraform, um eine Azure Web App zu erstellen. Die Web App sollte in einem neuen Resource Group und in einem definierten Azure App Service Plan bereitgestellt werden.

### Anforderungen:
1.	Eine Resource Group muss erstellt werden.
2.	Erstellen Sie einen App Service Plan im kostenfreien Tarif.
3.	Erstellen Sie eine Web App, die eine einfache Webseite hosten kann.
4.	Die Konfiguration der App sollte von Variablen abhängen (z.B. App Name, Region).**

# Antwort :
As per the given requirements for deploying an Azure Web App with Terraform, I've ensured that the configuration covers all necessary aspects for the task.

1. **Resource Group**:  
   I've used the `azurerm_resource_group` resource to create a new resource group dynamically, named based on the provided app name (`var.web_app_name`). The location is also configurable via the `var.location` variable, allowing flexibility in deployment regions.

2. **App Service Plan (Free Tier)**:  
   The App Service Plan is configured with the free-tier pricing model (`F1`), as specified in the task. I’ve ensured that the `os_type` is set to `Linux`, which aligns with the platform requirements. The SKU is parameterized via the `var.sku_name` variable to allow easy changes if needed.

3. **Web App Hosting**:  
   The Web App is deployed using the `azurerm_linux_web_app` resource, which is suitable for hosting a simple webpage. I've made sure that the web app settings are flexible, pulling critical values from variables like the app name, location, and service plan ID. This ensures scalability and adaptability across different environments or regions.

4. **Variables for Configuration**:  
   The solution is highly configurable, utilizing variables for essential aspects such as `web_app_name`, `location`, and `sku_name`. This allows for easy modifications without changing the core logic of the Terraform code. The output block also returns the default hostname for the web app, which simplifies post-deployment access.

## Zusammenfassung
I've incorporated Application Insights for monitoring and diagnostics, which wasn't part of the original requirements but adds valuable observability features to the web app. I've also enforced HTTPS (`https_only = true`) to enhance the security of the application, even though HTTP is allowed for testing purposes.


