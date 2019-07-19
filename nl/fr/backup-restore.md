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


# Sauvegarde et restauration
{: #backup-restore}

Vous pouvez sauvegarder et restaurer votre instance Enclave Manager.
{: shortdesc}


## Sauvegarde de votre instance Enclave Manager
{: #backup}

Vous pouvez configurer {{site.data.keyword.datashield_full}} pour une sauvegarde périodique de la base de données Enclave Manager dans {{site.data.keyword.cos_full_notm}}.
{: shortdesc}

Envisagez d'inscrire des hôtes dans plusieurs emplacements physiques afin de minimiser le risque de perte de données. Vous pouvez restaurer Enclave Manager sur le matériel précédemment inscrit ou sur le cluster Enclave Manager uniquement.
{: tip}


1. Créez un [ID service](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials) en utilisant les instructions de la documentation {{site.data.keyword.cos_short}}, et en sélectionnant l'option qui permet d'inclure les données d'identification HMAC. La tâche de sauvegarde utilise ces données pour s'authentifier auprès de {{site.data.keyword.cos_short}}.

2. Créez un secret Kubernetes avec les données d'identification pour l'authentification auprès de {{site.data.keyword.cos_short}}.
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. Ajoutez les options suivantes à votre commande `helm install` lorsque vous installez Data Shield, ou à votre commande `helm upgrade` lorsque vous mettez à niveau une instance {{site.data.keyword.datashield_full}} existante. Modifiez les valeurs suivantes pour votre environnement. `enclaveos-chart.Backup.CronSchedule` est votre planning de sauvegarde, exprimé dans la syntaxe cron. Par exemple, `0 0 * * *` effectue une sauvegarde quotidienne à minuit, temps universel coordonné. `global.S3.Endpoint` correspond à l'emplacement du compartiment {{site.data.keyword.cos_short}} que vous avez créé, et que vous pouvez rechercher dans la [table des noeuds finaux](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints).
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    Vous avez également la possibilité de définir `enclaveos-chart.Backup.S3Prefix` sur un chemin d'accès au sein du compartiment {{site.data.keyword.cos_short}} dans lequel vous souhaitez stocker la sauvegarde. Par défaut, les sauvegardes sont stockées à la racine du compartiment.{: tip}



## Restauration d'Enclave Manager
{: #restore}

Si vous avez configuré votre charte Helm pour créer une sauvegarde d'Enclave Manager avant déploiement, vous pouvez la restaurer en cas d'incident. 

1. Vérifiez que vous êtes sur un noeud qui s'exécutait précédemment dans Enclave Manager. Les données Enclave Manager sont chiffrées à l'aide de clés de scellement SGX et peuvent être déchiffrées uniquement sur le même matériel. 

2. Déployez Enclave Manager avec 0 instance du serveur back end en définissant s la valeur Helm suivante.

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. Une fois Enclave Manager déployé, copiez la sauvegarde dans le conteneur de base de données. 

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. Créez un interpréteur de commandes (shell) dans le conteneur de base de données. 

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. Préparez la base de données pour restauration depuis votre sauvegarde. 

    1. Créez un shell SQL.

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. Lorsque vous y êtes invité par SQL, exécutez les commandes suivantes.

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. Quittez et exécutez la commande suivante.

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. Agrandissez le déploiement d'Enclave Manager en exécutant la commande `helm upgrade` sans définir la valeur `enclaveos-chart.Manager.ReplicaCount`.

