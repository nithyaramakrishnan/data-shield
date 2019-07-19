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


# 備份和還原
{: #backup-restore}

您可以備份和還原 Enclave Manager 實例。
{: shortdesc}


## 備份 Enclave Manager 實例
{: #backup}

您可以將 {{site.data.keyword.datashield_full}} 配置為將 Enclave Manager 資料庫定期備份到 {{site.data.keyword.cos_full_notm}}。
{: shortdesc}

考慮在多個實體位置中註冊主機，以降低資料流失的風險。您只能在先前在 Enclave Manager 叢集裡註冊的硬體上還原 Enclave Manager。
{: tip}


1. 使用 {{site.data.keyword.cos_short}} 文件中的指示，選取包含 HMAC 認證的選項來建立[服務 ID](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials)。備份工作使用 HMAC 認證向 {{site.data.keyword.cos_short}} 進行鑑別。

2. 使用認證建立 Kubernetes 密碼以向 {{site.data.keyword.cos_short}} 進行鑑別。
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. 安裝 Data Shield 時將下列選項新增到 `helm install` 指令，或者升級現有 {{site.data.keyword.datashield_full}} 實例時將下列選項新增到 `helm upgrade` 指令。修改您環境的下列值。`enclaveos-chart.Backup.CronSchedule` 是在 cron 語法中指定的備份排程。例如，`0 0 * * *` 每天在世界標準時間午夜執行備份。`global.S3.Endpoint` 對應於您建立的 {{site.data.keyword.cos_short}} 儲存區的位置，您可以在[端點表格](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints)中查閱該位置。
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    您還可以選擇將 `enclaveos-chart.Backup.S3Prefix` 設定為 {{site.data.keyword.cos_short}} 儲存區中要用於儲存備份的路徑。依預設，備份儲存在儲存區根目錄中。
    {: tip}



## 還原 Enclave Manager
{: #restore}

如果將 Helm chart 配置為在部署之前建立 Enclave Manager 的備份，遇到任何問題時可以將其還原。

1. 確保在 Enclave Manager 中先前執行的節點上執行。Enclave Manager 資料使用 SGX 密封金鑰進行加密，並且只能在相同硬體上解密。

2. 藉由設定下列 Helm 值，在 Enclave Manager 上部署後端伺服器的 0 個實例。

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. 部署 Enclave Manager 之後，將備份複製到資料庫容器。

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. 在資料庫容器中建立 Shell。

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. 準備資料庫以從備份中還原。

    1. 建立 SQL Shell。

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. 在 SQL 提示後，執行下列指令。

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. 結束並執行下列指令。

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. 執行 `helm upgrade` 而不設定 `enclaveos-chart.Manager.ReplicaCount` 值，來擴增 Enclave Manager 部署。

