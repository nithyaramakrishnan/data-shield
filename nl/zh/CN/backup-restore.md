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


# 备份和复原
{: #backup-restore}

您可以备份和复原 Enclave Manager 实例。
{: shortdesc}


## 备份 Enclave Manager 实例
{: #backup}

您可以将 {{site.data.keyword.datashield_full}} 配置为将 Enclave Manager 数据库定期备份到 {{site.data.keyword.cos_full_notm}}。
{: shortdesc}

考虑在多个物理位置中注册主机，以降低数据丢失的风险。您可以复原硬盘上先前仅在 Enclave Manager 集群中注册的 Enclave Manager。
{: tip}


1. 通过使用 {{site.data.keyword.cos_short}} 文档中的指示信息，选择包含 HMAC 凭证的选项来创建[服务标识](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials)。备份作业使用 HMAC 凭证向 {{site.data.keyword.cos_short}} 进行认证。

2. 使用凭证创建 Kubernetes 私钥以向 {{site.data.keyword.cos_short}} 进行认证。
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. 安装 Data Shield 时将以下选项添加到 `helm install` 命令，或者升级现有 {{site.data.keyword.datashield_full}} 实例时将以下选项添加到 `helm upgrade` 命令。修改您环境的以下值。`enclaveos-chart.Backup.CronSchedule` 是在 cron 语法中指定的备份调度。例如，`0 0 * * *` 每天在全球标准时间午夜执行备份。`global.S3.Endpoint` 对应于您创建的 {{site.data.keyword.cos_short}} 存储区的位置，您可以在[端点表](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints)中查找该位置。
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    您还可以选择将 `enclaveos-chart.Backup.S3Prefix` 设置为 {{site.data.keyword.cos_short}} 存储区中要用于存储备份的路径。缺省情况下，备份存储在存储区根目录中。
    {: tip}



## 复原 Enclave Manager
{: #restore}

如果将 Helm chart 配置为在部署之前创建 Enclave Manager 的备份，那么遇到任何问题时可以将其复原。

1. 确保在 Enclave Manager 中先前运行的节点上运行。Enclave Manager 数据使用 SGX 密封密钥进行加密，并且只能在同一硬件上解密。

2. 通过设置以下 Helm 值，在 Enclave Manager 上部署后端服务器的 0 个实例。

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. 部署 Enclave Manager 之后，将备份复制到数据库容器。

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. 在数据库容器中创建 shell。

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. 准备数据库以从备份中复原。

    1. 创建 SQL shell。

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. 在 SQL 提示后，运行以下命令。

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. 退出并运行以下命令。

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. 通过运行 `helm upgrade` 来扩展 Enclave Manager 部署，而不设置 `enclaveos-chart.Manager.ReplicaCount` 值。

