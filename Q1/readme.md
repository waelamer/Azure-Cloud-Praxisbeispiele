# 1. Terraform-Aufgabe: Bereitstellung einer Azure Web App

## Aufgabe: Verwenden Sie Terraform, um eine Azure Web App zu erstellen. Die Web App sollte in einem neuen Resource Group und in einem definierten Azure App Service Plan bereitgestellt werden.

### Anforderungen:
1.	Eine Resource Group muss erstellt werden.
2.	Erstellen Sie einen App Service Plan im kostenfreien Tarif.
3.	Erstellen Sie eine Web App, die eine einfache Webseite hosten kann.
4.	Die Konfiguration der App sollte von Variablen abhängen (z.B. App Name, Region).**

# Antwort:
Gemäß den vorgegebenen Anforderungen für die Bereitstellung einer Azure Web App mit Terraform habe ich sichergestellt, dass die Konfiguration alle notwendigen Aspekte der Aufgabe abdeckt.

1. **Resource Group**:  
   Ich habe die Ressource `azurerm_resource_group` verwendet, um eine neue Resource Group dynamisch zu erstellen, die basierend auf dem angegebenen App-Namen (`var.web_app_name`) benannt wird. Der Standort ist ebenfalls über die Variable `var.location` konfigurierbar, was Flexibilität bei der Auswahl der Einsatzregionen ermöglicht.

2. **App Service Plan (Free Tier)**:  
   Der App Service Plan ist mit dem kostenlosen Preismodell (`F1`) konfiguriert, wie in der Aufgabe gefordert. Ich habe sichergestellt, dass das `os_type` auf `Linux` gesetzt ist, was den Plattformanforderungen entspricht. Das SKU ist über die Variable `var.sku_name` parametriert, sodass bei Bedarf leicht Änderungen vorgenommen werden können.

3. **Web App Hosting**:  
   Die Web App wird mit der Ressource `azurerm_linux_web_app` bereitgestellt, die sich für das Hosting einer einfachen Webseite eignet. Ich habe sichergestellt, dass die Web-App-Einstellungen flexibel sind, indem wichtige Werte wie der App-Name, der Standort und die Serviceplan-ID aus Variablen bezogen werden. Dies gewährleistet Skalierbarkeit und Anpassungsfähigkeit in verschiedenen Umgebungen oder Regionen.

4. **Variablen für die Konfiguration**:  
   Die Lösung ist hochgradig konfigurierbar, da Variablen für wesentliche Aspekte wie `web_app_name`, `location` und `sku_name` verwendet werden. Dies ermöglicht einfache Änderungen, ohne die Kernlogik des Terraform-Codes ändern zu müssen. Der Output-Block gibt auch den Standard-Hostnamen der Web-App zurück, was den Zugriff nach der Bereitstellung vereinfacht.

## Zusammenfassung:
Ich habe zusätzlich Application Insights für Überwachung und Diagnosen integriert, was zwar nicht Teil der ursprünglichen Anforderungen war, aber wertvolle Überwachungsfunktionen für die Web-App hinzufügt. Außerdem habe ich HTTPS (`https_only = true`) erzwungen, um die Sicherheit der Anwendung zu verbessern, auch wenn HTTP für Testzwecke zugelassen ist.



