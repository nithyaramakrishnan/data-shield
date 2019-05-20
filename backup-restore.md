---

copyright:
  years: 2018, 2019
lastupdated: "2019-05-13"

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


# Backing up and restoring your Enclave Manager
{: #backup-restore}

You can backup and restore your Enclave Manager instance. 


## Backing up your Enclave Manager instance
{: #backup}

You can configure {{site.data.keyword.datashield_full}} to periodically backup the Enclave Manager database to {{site.data.keyword.cos_full_notm}}.
{: shortdesc}

Consider enrolling hosts in more than one physical location to minimize the risk of data loss. You can restore the Enclave Manager on hardware that was previously enrolled in the Enclave Manager cluster only.
{: tip}


1. Create a [service ID](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials#service-credentials) by using the instructions in the {{site.data.keyword.cos_short}} documentation. 

2. Create HMAC credentials. The credentials and ID allow the backup job to authenticate to {{site.data.keyword.cos_short}}. For more information about credentials, see [Using HMAC credentials](/docs/services/cloud-object-storage?topic=cloud-object-storage-hmac#hmac).

3. Create a Kubernetes secret with the credentials to authenticate to {{site.data.keyword.cos_short}}.
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

4. In the Helm chart, set the following values before you deploy.
    
    ```
    enclaveos-chart.Manager.backup.cron-schedule=0 0 * * *
    enclaveos-chart.Manager.backup.cos-endpoint=https://s3.us.cloud-object-storage.appdomain.cloud
    enclaveos-chart.Manager.backup.cos-bucket=<orgname>-enclave-manager-backups
    enclaveos-chart.Manager.backup.cos-hmac-secret=enclave-manager-backup-credentials
    ```
    {: codeblock}

    Optionally, you can also set `enclaveos-chart.Manager.backup.cos-prefix` to a path within the {{site.data.keyword.cos_short}} bucket where you want to store the backup. By default, backups are prefixed with the cluster name.
    {: tip}



## Restoring Enclave Manager
{: #restore}

If you configured your Helm chart to create a backup of the Enclave Manager before deploying, you can restore it if you encounter any issues.

1. Ensure that you're running on a node that was previously running in the Enclave Manager.

2. Deploy the Enclave Manager with 0 instances of the backend server by setting the following Helm value.

    ```
    enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. After the Enclave Manager is deployed, create a shell in the database container.

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

4. Copy the backup to the machine.

5. Prepare the database to restore from your backup.

    1. Create an SQL shell.

        ```
        cockroach sql --insecure
        ```
        {: codeblock}
    
    2. When prompted by SQL run the following commands.

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. Exit and run the following command.

        ```
        cockroach sql --insecure -d malbork <your backup>.sql
        ```
        {: codeblock}

6. Scale the Enclave Manager deployment up by running `helm upgrade` without the `enclaveos-chart.Manager.ReplicaCount` value.

