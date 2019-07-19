---

copyright:
  years: 2018, 2019
lastupdated: "2019-07-08"

keywords: Data protection, data in use, runtime encryption, runtime memory encryption, encrypted memory, Intel SGX, software guard extensions, Fortanix runtime encryption

subcollection: data-shield

---

{:external: target="_blank" .external}
{:shortdesc: .shortdesc}
{:screen: .screen}
{:pre: .pre}
{:table: .aria-labeledby="caption"}
{:codeblock: .codeblock}
{:tip: .tip}
{:note: .note}
{:important: .important}
{:deprecated: .deprecated}
{:download: .download}

# Zugriff zuordnen
{: #access}

Sie können den Zugriff auf {{site.data.keyword.datashield_full}} Enclave Manager steuern. Dieser Typ von Zugriffssteuerung ist von den typischen IAM-Rollen (Identity and Access Management) getrennt, die Sie bei der Arbeit mit {{site.data.keyword.cloud_notm}} verwenden.
{: shortdesc}


## Clusterzugriff zuordnen
{: #access-cluster}

Bevor Sie sich bei Enclave Manager anmelden können, müssen Sie über Zugriff auf den Cluster verfügen, auf dem Enclave Manager ausgeführt wird.
{: shortdesc}

1. Melden Sie sich bei dem Konto an, das als Host für den Cluster fungiert, bei dem Sie sich anmelden möchten.

2. Rufen Sie **Verwalten > Zugriff (IAM) > Benutzer** auf.

3. Klicken Sie auf **Benutzer einladen**.

4. Geben Sie die E-Mail-Adressen für die Benutzer an, die Sie hinzufügen möchten.

5. Wählen Sie im Dropdown-Menü **Zugriff zuweisen für** die Option **Ressource** aus.

6. Wählen Sie in der Dropdown-Liste **Services** den Eintrag **Kubernetes Service** aus.

7. Wählen Sie eine **Region**, einen **Cluster** und einen **Namensbereich** aus.

8. Lesen Sie den Abschnitt zum [Zuordnen von Clusterzugriff](/docs/containers?topic=containers-users) in der Dokumentation zum Kubernetes Service, um den Zugriff zuzuweisen, den der Benutzer für die Durchführung der Tasks benötigt.

9. Klicken Sie auf **Speichern**.

## Rollen für Enclave Manager-Benutzer festlegen
{: #enclave-roles}

Die {{site.data.keyword.datashield_short}}-Verwaltung findet in Enclave Manager statt. Als Administrator wird Ihnen automatisch die Rolle *Manager* zugewiesen, aber Sie können anderen Benutzern auch Rollen zuweisen.
{: shortdesc}

In der folgenden Tabelle sehen Sie, welche Rollen unterstützt werden. Und es werden einige Beispielaktionen aufgeführt, die von jedem Benutzer ausgeführt werden können:

<table>
  <tr>
    <th>Rolle</th>
    <th>Aktionen</th>
    <th>Beispiel</th>
  </tr>
  <tr>
    <td>Leseberechtigter</td>
    <td>Kann schreibgeschützte Aktionen ausführen, wie z. B. die Anzeige von Knoten, Builds, Benutzerinformationen, Apps, Tasks und Auditprotokollen.</td>
    <td>Knotenattestierungszertifikat herunterladen.</td>
  </tr>
  <tr>
    <td>Schreibberechtigter</td>
    <td>Kann die Aktionen ausführen, die ein Leseberechtigter ausführen kann. Darüber hinaus kann er Aktionen ausführen, wie z. B. Inaktivieren und Erneuern der Knotenattestierung, Hinzufügen eines Builds, Genehmigen oder Ablehnen von Aktionen und Aufgaben.</td>
    <td>Eine Anwendung zertifizieren.</td>
  </tr>
  <tr>
    <td>Manager</td>
    <td>Kann die Aktionen ausführen, die ein Schreibberechtigter ausführen kann. Darüber hinaus kann er Aktionen ausführen, wie z. B. Aktualisieren von Benutzernamen und Rollen, Hinzufügen von Benutzern zum Cluster, Aktualisieren von Clustereinstellungen und weitere Aktionen, für die eine Berechtigung erforderlich ist.</td>
    <td>Benutzerrolle aktualisieren.</td>
  </tr>
</table>


### Benutzer hinzufügen
{: #set-roles}

Über die grafische Benutzerschnittstelle von Enclave Manager können Sie neuen Benutzern Zugriff auf die Informationen erteilen.
{: shortdesc}

1. Melden Sie sich bei Enclave Manager an.

2. Klicken Sie auf **Eigener Name > Einstellungen**.

3. Klicken Sie auf **Benutzer hinzufügen**.

4. Geben Sie eine E-Mail-Adresse und einen Namen für den Benutzer ein. Wählen Sie in der Dropdown-Liste **Rolle** eine Rolle aus.

5. Klicken Sie auf **Speichern**.



### Benutzer aktualisieren
{: #update-roles}

Sie können die Rollen, die Ihren Benutzern zugeordnet sind, sowie den entsprechenden Namen aktualisieren.
{: shortdesc}

1. Melden Sie sich bei der [Enclave Manager-Benutzerschnittstelle](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) an.

2. Klicken Sie auf **Eigener Name > Einstellungen**.

3. Bewegen Sie den Mauszeiger über den Benutzer, dessen Berechtigungen Sie bearbeiten möchten. Ein Stiftsymbol wird angezeigt.

4. Klicken Sie auf das Stiftsymbol. Daraufhin wird die Anzeige zum Bearbeiten eines Benutzers angezeigt.

5. Wählen Sie in der Dropdown-Liste **Rolle** die Rollen aus, die Sie zuordnen möchten.

6. Aktualisieren Sie den Namen des Benutzers.

7. Klicken Sie auf **Speichern**. Alle Änderungen an den Berechtigungen eines Benutzers werden sofort wirksam.


