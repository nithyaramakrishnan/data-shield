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

# インストール
{: #install}

提供された Helm チャートまたはインストーラーのいずれかを使用して {{site.data.keyword.datashield_full}} をインストールできます。 使いやすいと思うインストール・コマンドを使用できます。
{: shortdesc}

## 始める前に
{: #begin}

{{site.data.keyword.datashield_short}} での作業を始めるには、その前に以下の前提条件を満たす必要があります。 CLI とプラグインのダウンロードや、Kubernetes サービスの環境の構成について支援が必要な場合は、チュートリアル [Kubernetes クラスターの作成](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)を参照してください。

* 次の CLI:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* 次の [{{site.data.keyword.cloud_notm}} CLI プラグイン](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* SGX 対応の Kubernetes クラスター。 現時点では、ノード・タイプが mb2c.4x32 のベアメタル・クラスター上で SGX を使用可能にすることができます。 そのようなクラスターがない場合は、以下の手順を実行して必要なクラスターを作成します。
  1. [クラスターを作成する](/docs/containers?topic=containers-clusters#cluster_prepare)準備をします。

  2. クラスターを作成するための[必要な許可](/docs/containers?topic=containers-users)があることを確認します。

  3. [クラスター](/docs/containers?topic=containers-clusters)を作成します。

* バージョン 0.5.0 以降の [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} サービスのインスタンス。 Helm を使用してインスタンスをインストールする場合は、次のコマンドを実行できます。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Data Shield のロギング情報を参照するには、クラスター用に {{site.data.keyword.la_full_notm}} インスタンスをセットアップしてください。
{: tip}


## Helm を使用したインストール
{: #install-chart}

提供された Helm チャートを使用して {{site.data.keyword.datashield_short}} を SGX 対応のベアメタル・クラスターにインストールすることができます。
{: shortdesc}

Helm チャートは、以下のコンポーネントをインストールします。

*	SGX をサポートするソフトウェア。特権コンテナーを使用してベアメタル・ホストにインストールされます。
*	{{site.data.keyword.datashield_short}} Enclave Manager。{{site.data.keyword.datashield_short}} 環境で SGX エンクレーブを管理します。
*	EnclaveOS® コンテナー変換サービス。コンテナー化されたアプリケーションを {{site.data.keyword.datashield_short}} 環境で実行できるようになります。


クラスターに {{site.data.keyword.datashield_short}} をインストールするには、以下のようにします。

1. {{site.data.keyword.cloud_notm}} CLI にログインします。 CLI のプロンプトに従っていくとログインが完了します。フェデレーテッド ID がある場合は、コマンドの末尾に `--sso` オプションを付加してください。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. クラスターのコンテキストを設定します。

  1. 環境変数を設定して Kubernetes 構成ファイルをダウンロードするためのコマンドを取得します。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. `export` で始まる出力をコピーし、端末に貼り付けて `KUBECONFIG` 環境変数を設定します。

3. `iks-charts` リポジトリーをまだ追加していない場合は追加します。

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. オプション: 管理者または管理アカウント ID に関連付けられた E メールが分からない場合は、次のコマンドを実行します。

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. クラスターの Ingress サブドメインを取得します。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

6. [バックアップとリストア](/docs/services/data-shield?topic=data-shield-backup-restore)機能のセットアップに必要な情報を取得します。 

7. Tiller 用の役割バインディング・ポリシーを作成して、Helm を初期設定します。 

  1. Tiller 用のサービス・アカウントを作成します。
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. 役割バインディングを作成して、クラスター全体の管理アクセス権限を Tiller に割り当てます。

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Helm を初期設定します。

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  `--tls` モードを使用するように Helm を構成することもできます。 TLS の有効化については、[Helm リポジトリー](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}を参照してください。 TLS を有効にした場合は、実行するすべての Helm コマンドに `--tls` を付加してください。IBM Cloud Kubernetes Service で Helm を使用する方法について詳しくは、[Helm チャートを使用したサービスの追加](/docs/containers?topic=containers-helm#public_helm_install)を参照してください。
  {: tip}

8. チャートをインストールします。

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  コンバーターに [{{site.data.keyword.cloud_notm}} Container Registry を構成](/docs/services/data-shield?topic=data-shield-convert)した場合は、`--set converter-chart.Converter.DockerConfigSecret=converter-docker-config` を追加する必要があります。
  {: note}

9. コンポーネントの開始をモニターするには、次のコマンドを実行します。

  ```
  kubectl get pods
  ```
  {: codeblock}



## インストーラーを使用したインストール
{: #installer}

インストーラーを使用して、{{site.data.keyword.datashield_short}} を SGX 対応のベアメタル・クラスターに簡単にインストールすることができます。
{: shortdesc}

1. {{site.data.keyword.cloud_notm}} CLI にログインします。 CLI のプロンプトに従っていくとログインが完了します。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. クラスターのコンテキストを設定します。

  1. 環境変数を設定して Kubernetes 構成ファイルをダウンロードするためのコマンドを取得します。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. 出力をコピーしてコンソールに貼り付けます。

3. Container Registry CLI にサインインします。

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. ローカル・システムにイメージをプルします。

  ```
  docker pull <region>.icr.io/ibm/datashield-installer
  ```
  {: codeblock}

5. 次のコマンドを実行して {{site.data.keyword.datashield_short}} をインストールします。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  最新のバージョンの {{site.data.keyword.datashield_short}} をインストールするには、`--version` フラグに `latest` を付けて使用します。

