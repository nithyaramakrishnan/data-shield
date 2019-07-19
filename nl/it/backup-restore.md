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


# Backup e ripristino
{: #backup-restore}

Puoi eseguire il backup e ripristino della tua istanza Enclave Manager.
{: shortdesc}


## Backup della tua istanza Enclave Manager
{: #backup}

Puoi configurare {{site.data.keyword.datashield_full}} per eseguire periodicamente il backup del database Enclave Manager su {{site.data.keyword.cos_full_notm}}.
{: shortdesc}

Prendi in considerazione di iscrivere gli host in più di un'ubicazione fisica per ridurre al minimo il rischio di perdita di dati. Puoi ripristinare l'Enclave Manager sull'hardware precedentemente iscritto solo nel cluster Enclave Manager.
{: tip}


1. Crea un [ID servizio](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials) utilizzando le istruzioni indicate nella documentazione di {{site.data.keyword.cos_short}} e selezionando l'opzione per includere le credenziali HMAC. Il lavoro di backup utilizza le credenziali HMAC per l'autenticazione su {{site.data.keyword.cos_short}}.

2. Crea un segreto Kubernetes con le credenziali per l'autenticazione su {{site.data.keyword.cos_short}}.
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. Aggiungi le seguenti opzioni al comando `helm install` quando installi Data Shield o al comando `helm upgrade` quando esegui l'upgrade di un'istanza {{site.data.keyword.datashield_full}} esistente. Modifica i seguenti valori per il tuo ambiente. `enclaveos-chart.Backup.CronSchedule` è la tua pianificazione di backup, che è specificata nella sintassi cron. Ad esempio, `0 0 * * *` effettua un backup ogni giorno a mezzanotte in Coordinated Universal Time. `global.S3.Endpoint` corrisponde all'ubicazione del bucket {{site.data.keyword.cos_short}} da te creato, che puoi ricercare nella [tabella di endpoint](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints).
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    Facoltativamente, puoi anche impostare `enclaveos-chart.Backup.S3Prefix` su un percorso all'interno del bucket {{site.data.keyword.cos_short}} in cui vuoi memorizzare il backup. Per impostazione predefinita, i backup vengono memorizzati nella root del bucket.
    {: tip}



## Ripristino di Enclave Manager
{: #restore}

Se hai configurato il tuo grafico Helm per creare un backup di Enclave Manager prima della sua distribuzione, puoi ripristinarlo in caso di problemi.

1. Assicurati di essere in esecuzione su un nodo che precedentemente era in esecuzione in Enclave Manager. I dati di Enclave Manager vengono crittografati utilizzando le chiavi di sigillo SGX e possono essere decrittografati solo sullo stesso hardware.

2. Distribuisci Enclave Manager con 0 istanze del server di backend impostando il seguente valore Helm.

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. Una volta che Enclave Manager è stato distribuito, copia il backup nel contenitore del database.

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. Crea una shell nel contenitore del database.

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. Prepara il database per il ripristino dal tuo backup.

    1. Crea una shell SQL.

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. Quando richiesto da SQL, immetti i seguenti comandi.

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. Esci e immetti il seguente comando.

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. Amplia la distribuzione di Enclave Manager eseguendo `helm upgrade` senza impostare il valore `enclaveos-chart.Manager.ReplicaCount`.

