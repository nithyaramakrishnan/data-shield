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


# Copia de seguridad y restauración
{: #backup-restore}

Puede realizar copias de seguridad y restaurar la instancia de Enclave Manager.
{: shortdesc}


## Copia de seguridad de la instancia de Enclave Manager
{: #backup}

Puede configurar {{site.data.keyword.datashield_full}} de modo que periódicamente realice una copia de seguridad de la base de datos de Enclave Manager en {{site.data.keyword.cos_full_notm}}.
{: shortdesc}

Considere la posibilidad de inscribir los hosts en más de una ubicación física para minimizar el riesgo de pérdida de datos. Solo puede restaurar Enclave Manager en hardware que estaba previamente inscrito en el clúster de Enclave Manager.
{: tip}


1. Cree un [ID de servicio](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials) siguiendo las instrucciones de la documentación de {{site.data.keyword.cos_short}} y seleccionando la opción para incluir credenciales de HMAC. El trabajo de copia de seguridad utiliza las credenciales de HMAC para autenticarse en {{site.data.keyword.cos_short}}.

2. Cree un secreto de Kubernetes con las credenciales para autenticarse en {{site.data.keyword.cos_short}}.
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. Añada las opciones siguientes al mandato `helm install` cuando instale Data Shield, o al mandato `helm upgrade` cuando actualice una instancia de {{site.data.keyword.datashield_full}} existente. Modifique los valores siguientes para adaptarlos a su entorno. `enclaveos-chart.Backup.CronSchedule` es la planificación de la copia de seguridad, que se especifica en sintaxis de cron. Por ejemplo, `0 0 * * *` realiza una copia de seguridad cada día a media noche, hora universal coordinada. `global.S3.Endpoint` corresponde a la ubicación del grupo de {{site.data.keyword.cos_short}} que ha creado, que puede consultar en la [tabla de puntos finales](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints).
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    Si lo desea, también puede establecer `enclaveos-chart.Backup.S3Prefix` en una vía de acceso dentro del grupo de {{site.data.keyword.cos_short}} donde desea guardar la copia de seguridad. De forma predeterminada, las copias de seguridad se guardan en el directorio raíz del grupo.
    {: tip}



## Restauración de Enclave Manager
{: #restore}

Si ha configurado el diagrama de Helm de modo que cree una copia de seguridad de Enclave Manager antes de desplegarlo, puede restaurarlo si encuentra algún problema.

1. Asegúrese de trabajar en un nodo que anteriormente se ejecutaba en Enclave Manager. Los datos de Enclave Manager se cifran mediante claves de sellado SGX y solo se pueden descifrar en el mismo hardware.

2. Despliegue Enclave Manager con 0 instancias del servidor de fondo estableciendo el siguiente valor de Helm.

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. Una vez desplegado Enclave Manager, copie la copia de seguridad en el contenedor de la base de datos.

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. Cree un shell en el contenedor de la base de datos.

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. Prepare la base de datos para la restauración desde la copia de seguridad.

    1. Crear un shell de SQL.

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. Cuando SQL se lo solicite, ejecute los mandatos siguientes.

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. Salga y ejecute el mandato siguiente.

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. Escale el despliegue de Enclave Manager ejecutando `helm upgrade` sin establecer el valor `enclaveos-chart.Manager.ReplicaCount`.

