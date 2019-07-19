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

# Enclave Manager verwenden
{: #enclave-manager}

Sie können die Enclave Manager-Benutzerschnittstelle verwenden, um die Anwendungen zu verwalten, die Sie mit {{site.data.keyword.datashield_full}} schützen. Von der Benutzerschnittstelle aus können Sie Ihre App-Bereitstellung verwalten, den Zugriff zuordnen, Whitelist-Anforderungen bearbeiten und Ihre Anwendungen konvertieren.
{: shortdesc}


## Anmeldung
{: #em-signin}

In der Enclave Manager-Konsole können Sie die Knoten in Ihrem Cluster und den Attestierungsstatus anzeigen. Sie können auch Tasks und Auditprotokolle von Clusterereignissen anzeigen. Melden Sie sich zuerst an.
{: shortdesc}

1. Stellen Sie sicher, dass Sie über den [korrekten Zugriff](/docs/services/data-shield?topic=data-shield-access) verfügen.

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen. Wenn Sie über eine eingebundene ID verfügen, hängen Sie die Option `-- sso` an das Ende des Befehls an.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Legen Sie den Kontext für Ihren Cluster fest.

  1. Rufen Sie den Befehl ab, um die Umgebungsvariable festzulegen, und laden Sie die Kubernetes-Konfigurationsdateien herunter.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Kopieren Sie die Ausgabe, die mit `export` beginnt, und fügen Sie sie in Ihr Terminal ein, um die Umgebungsvariable `KUBECONFIG` festzulegen.

3. Überprüfen Sie, ob der gesamte Service ausgeführt wird, indem Sie bestätigen, dass sich alle Ihre Pods in einem *aktiven* Status befinden.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Führen Sie den folgenden Befehl aus, um die Front-End-URL für Ihre Instanz von Enclave Manager zu suchen.

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

7. Rufen Sie im Terminal Ihr IAM-Token ab.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. Kopieren Sie das Token und fügen Sie es in die grafische Benutzerschnittstelle von Enclave Manager ein. Sie müssen den Abschnitt `Bearer` des gedruckten Tokens nicht kopieren.

9. Klicken Sie auf **Anmelden**.






## Knoten verwalten
{: #em-nodes}

Mithilfe der Benutzerschnittstelle von Enclave Manager können Sie den Status überwachen und die Zertifikate für Knoten inaktivieren oder herunterladen, die IBM Cloud Data Shield in Ihrem Cluster ausführen.
{: shortdesc}


1. Melden Sie sich bei Enclave Manager an.

2. Navigieren Sie zur Registerkarte **Knoten**.

3. Klicken Sie auf die IP-Adresse des Knotens, den Sie überprüfen möchten. Daraufhin wird eine Informationsanzeige geöffnet.

4. In der Informationsanzeige können Sie auswählen, ob der Knoten inaktiviert oder das verwendete Zertifikat heruntergeladen werden soll.




## Anwendungen bereitstellen
{: #em-apps}

Mithilfe der Benutzerschnittstelle von Enclave Manager können Sie Ihre Anwendungen bereitstellen.
{: shortdesc}


### App hinzufügen
{: #em-app-add}

Mithilfe der Benutzerschnittstelle von Enclave Manager können Sie Ihre Anwendungen gleichzeitig konvertieren, bereitstellen und auf eine Whitelist setzen.
{: shortdesc}

1. Melden Sie sich bei Enclave Manager an und navigieren Sie zur Registerkarte **Apps**.

2. Klicken Sie auf **Neue Anwendung hinzufügen**.

3. Geben Sie Ihrer Anwendung einen Namen und geben Sie eine Beschreibung ein.

4. Geben Sie den Eingabe- und Ausgabenamen für Ihre Images ein. Bei der Eingabe handelt es sich um den Namen Ihrer aktuellen Anwendung. Bei der Ausgabe handelt es sich um die Position der konvertierten Anwendung.

5. Geben Sie **ISVPRDID** und **ISVSVN** ein.

6. Geben Sie alle zulässigen Domänen ein.

7. Bearbeiten Sie alle erweiterten Einstellungen, die Sie möglicherweise ändern möchten.

8. Klicken Sie auf **Neue Anwendung erstellen**. Die Anwendung wird bereitgestellt und zu Ihrer Whitelist hinzugefügt. Sie können die Buildanforderung auf der Registerkarte **Tasks** genehmigen.




### App bearbeiten
{: #em-app-edit}

Sie können eine Anwendung bearbeiten, nachdem Sie sie zu Ihrer Liste hinzugefügt haben.
{: shortdesc}


1. Melden Sie sich bei Enclave Manager an und navigieren Sie zur Registerkarte **Apps**.

2. Klicken Sie auf den Namen der Anwendung, die Sie bearbeiten möchten. Es wird eine neue Anzeige geöffnet, in der Sie die Konfiguration, einschließlich der Zertifikate und bereitgestellten Builds, überprüfen können.

3. Klicken Sie auf **Anwendung bearbeiten**.

4. Aktualisieren Sie die Konfiguration, die Sie wünschen. Bevor Sie irgendeine Änderungen vornehmen, müssen Sie verstanden haben, wie sich die erweiterten Einstellungen auf Ihre Anwendung auswirken.

5. Klicken Sie auf **Anwendung bearbeiten**.


## Anwendungen erstellen
{: #em-builds}

Mithilfe der Benutzerschnittstelle von Enclave Manager können Sie Ihre Anwendungen neu erstellen, nachdem Sie die Änderungen vorgenommen haben.
{: shortdesc}

1. Melden Sie sich bei Enclave Manager an und navigieren Sie zur Registerkarte **Builds**.

2. Klicken Sie auf **Neuen Build erstellen**. 

3. Wählen Sie eine Anwendung in der Dropdown-Liste aus oder fügen Sie eine Anwendung hinzu.

4. Geben Sie den Namen Ihres Docker-Image ein und versehen Sie ihn mit einem bestimmten Tag. 

5. Klicken Sie auf **Build**. Der Build wird zur Whitelist hinzugefügt. Sie können den Build auf der Registerkarte **Tasks** genehmigen.



## Tasks genehmigen
{: #em-tasks}

Ist eine Anwendung in der Whitelist aufgeführt, wird sie zur Liste der anstehenden Anforderungen auf der Registerkarte **Tasks** der Benutzerschnittstelle von Enclave Manager hinzugefügt. Sie können die Anforderung über die Benutzerschnittstelle genehmigen oder zurückweisen.
{: shortdesc}

1. Melden Sie sich bei Enclave Manager an und navigieren Sie zur Registerkarte **Tasks**.

2. Klicken Sie auf die Zeile mit der Anforderung, die Sie genehmigen oder verweigern möchten. Daraufhin wird eine Anzeige mit weiteren Informationen geöffnet.

3. Überprüfen Sie die Anforderung und klicken Sie auf die Option zum **Genehmigen** oder zum **Zurückweisen**. Ihr Name wird zur Liste der **Überprüfer** hinzugefügt.


## Protokolle anzeigen
{: #em-view}

Sie können Ihre Enclave Manager-Instanz auf mehrere verschiedene Arten von Aktivitäten hin überprüfen.
{: shortdesc}

1. Navigieren Sie zur Registerkarte **Auditprotokoll** der Enclave Manager-Benutzerschnittstelle.
2. Filtern Sie die Protokollierungsergebnisse, um Ihre Suche einzugrenzen. Sie können auswählen, ob nach Zeitrahmen oder nach einem der folgenden Typen gefiltert werden soll.

  * App-Status: Die Aktivität, die Ihre Anwendung betrifft, z. B. Anforderungen und neue Builds auf eine Whitelist setzen.
  * Benutzergenehmigung: Die Aktivität, die den Zugriff eines Benutzers betrifft, z. B. die Genehmigung oder Verweigerung, das Konto zu verwenden.
  * Knotenattestierung: Die Aktivität, die die Knotenattestierung betrifft.
  * Zertifizierungsstelle: Die Aktivität, die eine Zertifizierungsstelle betrifft.
  * Administration: Die Aktivität, die Verwaltungsaufgaben betrifft. 

Wenn Sie einen Protokolldatensatz mehr als einen Monat aufbewahren möchten, können Sie die entsprechenden Informationen in eine CSV-Datei (`.csv`) exportieren.

