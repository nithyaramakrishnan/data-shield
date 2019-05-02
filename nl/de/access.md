---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

keywords: data protection, data in use, runtime encryption, runtime memory encryption, encrypted memory, intel sgx, software guard extensions, fortanix runtime encryption

subcollection: data-shield

---

{:new_window: target="_blank"}
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

# Zugriff verwalten
{: #access}

Sie können den Zugriff auf {{site.data.keyword.datashield_full}} Enclave Manager steuern. Diese Zugriffssteuerung ist von den typischen IAM-Rollen (Identity and Access Management) getrennt, die Sie bei der Arbeit mit {{site.data.keyword.cloud_notm}} verwenden.
{: shortdesc}


## IAM-API-Schlüssel zum Anmelden an der Konsole verwenden
{: #access-iam}

In der Enclave Manager-Konsole können Sie die Knoten in Ihrem Cluster und den Attestierungsstatus anzeigen. Sie können auch Tasks und Auditprotokolle von Clusterereignissen anzeigen.

1. Melden Sie sich bei der IBM Cloud-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

  <table>
    <tr>
      <th>Region</th>
      <th>IBM Cloud-Endpunkt</th>
      <th>Kubernetes Service-Region</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>Vereinigte Staaten (Süden)</td>
    </tr>
    <tr>
      <td>Frankfurt</td>
      <td><code>eu-de</code></td>
      <td>Mitteleuropa</td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
      <td>Asien-Pazifik (Süden)</td>
    </tr>
    <tr>
      <td>London</td>
      <td><code>eu-gb</code></td>
      <td>Vereinigtes Königreich (Süden)</td>
    </tr>
    <tr>
      <td>Tokio</td>
      <td><code>jp-tok</code></td>
      <td>Asien-Pazifik (Norden)</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>Vereinigte Staaten (Osten)</td>
    </tr>
  </table>

2. Legen Sie den Kontext für Ihren Cluster fest.

  1. Rufen Sie den Befehl ab, um die Umgebungsvariable festzulegen, und laden Sie die Kubernetes-Konfigurationsdateien herunter.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```

  2. Kopieren Sie die Ausgabe, die mit `export` beginnt, und fügen Sie sie in Ihr Terminal ein, um die Umgebungsvariable `KUBECONFIG` festzulegen.

3. Überprüfen Sie, ob der gesamte Service ausgeführt wird, indem Sie bestätigen, dass alle Ihre Pods in einem *aktiven* Status sind.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Führen Sie den folgenden Befehl aus, um die Frontend-URL für Ihre Instanz von Enclave Manager zu suchen.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Fordern Sie Ihre Ingress-Unterdomäne an.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. Geben Sie in einem Browser die Unterdomäne "Ingress" ein, in der Enclave Manager verfügbar ist.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

8. Rufen Sie im Terminal Ihr IAM-Token ab.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. Kopieren Sie das Token, und fügen Sie es in die grafische Benutzerschnittstelle von Enclave Manager ein. Sie müssen den Abschnitt `Bearer` des gedruckten Tokens nicht kopieren.

9. Klicken Sie auf **Melden Sie sich an**.


## Rollen für Enclave Manager-Benutzer festlegen
{: #enclave-roles}

Die {{site.data.keyword.datashield_short}}-Verwaltung findet in Enclave Manager statt. Als Administrator wird Ihnen automatisch die Rolle *Manager* zugewiesen, aber Sie können anderen Benutzern auch Rollen zuweisen.
{: shortdesc}

Beachten Sie, dass diese Rollen sich von den IAM-Rollen der Plattform unterscheiden, die für die Steuerung des Zugriffs auf {{site.data.keyword.cloud_notm}}-Services verwendet werden. Weitere Informationen zum Konfigurieren des Zugriffs für {{site.data.keyword.containerlong_notm}} finden Sie im Abschnitt [Clusterzugriff zuordnen](/docs/containers?topic=containers-users#users).
{: tip}

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
    <td>Kann die Aktionen ausführen, die ein Leseberechtigter ausführen kann. Darüber hinaus kann er Aktionen ausführen, wie z. B. Deaktivieren und Erneuern der Knotenattestierung, Hinzufügen eines Builds, Genehmigen oder Ablehnen von Aktionen und Aufgaben. </td>
    <td>Eine Anwendung zertifizieren.</td>
  </tr>
  <tr>
    <td>Manager</td>
    <td>Kann die Aktionen ausführen, die ein Schreibberechtigter ausführen kann. Darüber hinaus kann er Aktionen ausführen, wie z. B. Aktualisieren von Benutzernamen und Rollen, Hinzufügen von Benutzern zum Cluster, Aktualisieren von Clustereinstellungen und weitere privilegierte Aktionen.</td>
    <td>Benutzerrolle aktualisieren.</td>
  </tr>
</table>

### Benutzerrollen festlegen
{: #set-roles}

Sie können die Benutzerrollen für den Konsolenmanager festlegen oder aktualisieren.
{: shortdesc}

1. Navigieren Sie zur [Enclave Manager-Benutzerschnittstelle](/docs/services/data-shield?topic=data-shield-access#access-iam).
2. Öffnen Sie im Dropdown-Menü die Benutzermanagementanzeige.
3. Wählen Sie **Einstellungen** aus. Sie können die Liste der Benutzer überprüfen oder einen Benutzer aus dieser Anzeige hinzufügen.
4. Wenn Sie die Benutzerberechtigungen bearbeiten möchten, bewegen Sie den Mauszeiger auf einen Benutzer, bis das Stiftsymbol angezeigt wird.
5. Klicken Sie auf das Stiftsymbol, um die Berechtigungen zu ändern. Alle Änderungen an den Berechtigungen eines Benutzers werden sofort wirksam.
