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


# バックアップとリストア
{: #backup-restore}

Enclave Manager インスタンスのバックアップとリストアを行うことができます。
{: shortdesc}


## Enclave Manager インスタンスのバックアップ
{: #backup}

Enclave Manager データベースを {{site.data.keyword.cos_full_notm}} に定期的にバックアップするように、{{site.data.keyword.datashield_full}} を構成できます。
{: shortdesc}

データ損失のリスクを最小限にするために、複数の物理的な場所にホストを登録することを検討してください。Enclave Manager のリストア先は、事前に Enclave Manager クラスターに登録されていたハードウェアに限られます。
{: tip}


1. {{site.data.keyword.cos_short}} 資料の説明に従い、HMAC 資格情報を組み込むオプションを選択して、[サービス ID](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials) を作成します。バックアップ・ジョブでは、HMAC 資格情報を使用して {{site.data.keyword.cos_short}} に対する認証を行います。

2. {{site.data.keyword.cos_short}} に対する認証を行う資格情報を指定して、Kubernetes シークレットを作成します。
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. 以下のオプションを、Data Shield をインストールする場合は `helm install` コマンドに追加し、既存の {{site.data.keyword.datashield_full}} インスタンスを更新する場合は `helm upgrade` コマンドに追加します。環境に合わせて次の値を変更します。`enclaveos-chart.Backup.CronSchedule` はバックアップのスケジュールで、Cron 構文で指定します。例えば、`0 0 * * *` の場合は、バックアップは毎日協定世界時の深夜 0 時に実行されます。`global.S3.Endpoint` は、作成した {{site.data.keyword.cos_short}} バケットの場所に対応します。この場所は、[エンドポイントの表](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints)で確認できます。
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    オプションで、`enclaveos-chart.Backup.S3Prefix` に、バックアップを保管する {{site.data.keyword.cos_short}} バケット内のパスを設定することもできます。デフォルトでは、バックアップはバケットのルートに保管されます。
    {: tip}



## Enclave Manager のリストア
{: #restore}

Enclave Manager のバックアップを作成するように Helm チャートを構成してからデプロイした場合は、問題が発生したときに Enclave Manager をリストアできます。

1. Enclave Manager で以前実行していたノード上で現在実行していることを確認します。Enclave Manager データは、SGX シーリング鍵を使用して暗号化され、同じハードウェアでのみ復号できます。

2. 以下の Helm 値を設定して、バックエンド・サーバーのインスタンスが 0 個の Enclave Manager をデプロイします。

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. Enclave Manager のデプロイ後に、バックアップをデータベース・コンテナーにコピーします。

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. データベース・コンテナー内にシェルを作成します。

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. バックアップからリストアするためにデータベースを準備します。

    1. SQL シェルを作成します。

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. SQL から求められたら、次のコマンドを実行します。

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. 終了して、次のコマンドを実行します。

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. `enclaveos-chart.Manager.ReplicaCount` 値を設定せずに `helm upgrade` を実行して、Enclave Manager デプロイメントをスケールアップします。

