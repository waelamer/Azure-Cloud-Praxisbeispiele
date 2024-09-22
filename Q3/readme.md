# 3. Aufgabe zur Netzwerkkonfiguration: Implementierung eines virtuellen Netzwerks
Aufgabe: Erstellen Sie ein Azure Virtual Network mit Subnets und einem Network Security Group (NSG).

## Anforderungen:
1. Erstellen Sie ein virtuelles Netzwerk mit mindestens zwei Subnetzen (Frontend und Backend).
2. Richten Sie eine Network Security Group ein, die den HTTP-Traffic nur zum Frontend-Subnetz zulässt.
3. Konfigurieren Sie den Backend-Traffic so, dass er nur aus dem Frontend-Subnetz zugänglich ist.
4. Stellen Sie sicher, dass keine eingehende Verbindung zu Backend-Ressourcen möglich ist.


# Antwort, Die Terraform-Konfiguration entspricht den gestellten Anforderungen:

![Architecture](img/q3_3.png)

1. **Virtuelles Netzwerk und Subnetze**: Zwei Subnetze (Frontend und Backend) sind korrekt im „prod“-Virtuellen Netzwerk angelegt.
2. **Netzwerksicherheitsgruppen**: Die NSG-Regeln sind wirksam implementiert, sodass HTTP-Traffic nur zum Frontend-Subnetz erlaubt ist, während der Zugriff auf das Backend-Subnetz nur aus dem Frontend-Subnetz gestattet wird.
3. **Sicherheit**: Das Backend-Subnetz ist durch eine "deny-all-inbound"-Regel geschützt, die sicherstellt, dass kein externer Zugriff möglich ist, außer vom Frontend.

Zusammenfassend folgt die Konfiguration den Best Practices für eine sichere Netzwerkinfrastruktur und erfüllt alle gestellten Anforderungen.

![NSG](img/q3_1.png)
![NSG](img/q3_2.png)