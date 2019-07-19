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


# Sichern und Wiederherstellen
{: #backup-restore}

Sie können Ihre Enclave Manager-Instanz sichern und wiederherstellen.
{: shortdesc}


## Enclave Manager-Instanz sichern
{: #backup}

Sie können {{site.data.keyword.datashield_full}} so konfigurieren, dass die Enclave Manager-Datenbank in regelmäßigen Abständen in {{site.data.keyword.cos_full_notm}} gesichert wird.
{: shortdesc}

Ziehen Sie die Registrierung von Hosts an mehr als einer physischen Position in Betracht, um das Risiko von Datenverlust zu minimieren. Sie können Enclave Manager nur auf der Hardware wiederherstellen, die zuvor im Enclave Manager-Cluster registriert wurde.
{: tip}


1. Erstellen Sie eine [Service-ID](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials), indem Sie die Anweisungen in der {{site.data.keyword.cos_short}}-Dokumentation verwenden und die Option zum Einschließen von HMAC-Berechtigungsnachweisen auswählen. Der Sicherungsjob verwendet die HMAC-Berechtigungsnachweise für die Authentifizierung bei {{site.data.keyword.cos_short}}.

2. Erstellen Sie einen geheimen Kubernetes-Schlüssel mit den Berechtigungsnachweisen für die Authentifizierung bei {{site.data.keyword.cos_short}}.
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. Fügen Sie dem Befehl `helm install` bei der Installation von Data Shield oder dem Befehl `helm upgrade`, wenn Sie ein Upgrade einer vorhandenen {{site.data.keyword.datashield_full}}-Instanz durchführen, die folgenden Optionen hinzu. Ändern Sie die folgenden Werte für Ihre Umgebung. `enclaveos-chart.Backup.CronSchedule` ist Ihr Sicherungszeitplan, der in der Cron-Syntax angegeben ist. Beispiel: Mit `0 0 * * *` wird jeden Tag um Mitternacht (Coordinated Universal Time, koordinierte Weltzeit) eine Sicherung durchgeführt. `global.S3.Endpoint` entspricht der Position des von Ihnen erstellten {{site.data.keyword.cos_short}}-Buckets, das Sie in der [Tabelle der Endpunkte](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints) suchen können.
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    Optional können Sie auch `enclaveos-chart.Backup.S3Prefix` auf einen Pfad innerhalb des {{site.data.keyword.cos_short}}-Buckets festlegen, in dem die Sicherung gespeichert werden soll. Standardmäßig werden Sicherungen im Bucketstammverzeichnis gespeichert.
    {: tip}



## Enclave Manager wiederherstellen
{: #restore}

Wenn Sie Ihr Helm-Diagramm so konfiguriert haben, dass eine Sicherung von Enclave Manager vor der Bereitstellung erstellt wird, können Sie diese im Falle von Problemen wiederherstellen.

1. Stellen Sie sicher, dass die Ausführung auf einem Knoten stattfindet, der zuvor in Enclave Manager ausgeführt wurde. Die Enclave Manager-Daten werden unter Verwendung von SGX-Dichtungsschlüsseln verschlüsselt und können nur auf derselben Hardware entschlüsselt werden.

2. Stellen Sie Enclave Manager mit 0 Instanzen des Back-End-Servers bereit, indem Sie den folgenden Helm-Wert festlegen.

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. Kopieren Sie nach der Enclave Manager-Bereitstellung die Sicherung in den Datenbankcontainer.

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. Erstellen Sie eine Shell im Datenbankcontainer.

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. Bereiten Sie die Datenbank für eine Wiederherstellung aus Ihrer Sicherung vor.

    1. Erstellen Sie eine SQL-Shell.

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. Wenn Sie von SQL dazu aufgefordert werden, führen Sie die folgenden Befehle aus.

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. Beenden Sie den Vorgang und führen Sie den folgenden Befehl aus.

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. Skalieren Sie die Enclave Manager-Bereitstellung vertikal, und zwar durch Ausführen von `helm upgrade` ohne den Wert `enclaveos-chart.Manager.ReplicaCount` festzulegen.

