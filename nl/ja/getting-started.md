---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

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

# 入門チュートリアル
{: #getting-started}

Fortanix® を採用した {{site.data.keyword.datashield_full}} を使用すると、{{site.data.keyword.cloud_notm}} で実行されるコンテナー・ワークロード内のデータの使用中に、データを保護することができます。
{: shortdesc}

{{site.data.keyword.datashield_short}} について、および使用中のデータを保護することの意味について詳しくは、[サービスについて](/docs/services/data-shield?topic=data-shield-about#about)をご覧ください。

## 始める前に
{: #gs-begin}

{{site.data.keyword.datashield_short}} での作業を始めるには、その前に以下の前提条件を満たす必要があります。CLI とプラグインのダウンロードや、Kubernetes サービスの環境の構成について支援が必要な場合は、チュートリアル [Kubernetes クラスターの作成](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)を参照してください。

* 次の CLI:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  `--tls` モードを使用するように Helm を構成することもできます。TLS の有効化については、[Helm リポジトリー](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)を参照してください。TLS を有効にした場合、実行する Helm コマンドごとに `--tls` を付加してください。
   {: tip}

* 次の [{{site.data.keyword.cloud_notm}} CLI プラグイン](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes サービス
  * Container Registry

* SGX 対応の Kubernetes クラスター。現時点では、ノード・タイプが mb2c.4x32 のベアメタル・クラスター上で SGX を使用可能にすることができます。そのようなクラスターがない場合は、以下の手順を実行して必要なクラスターを作成します。
  1. [クラスターを作成する](/docs/containers?topic=containers-clusters#cluster_prepare)準備をします。

  2. クラスターを作成するための[必要な許可](/docs/containers?topic=containers-users#users)があることを確認します。

  3. [クラスター](/docs/containers?topic=containers-clusters#clusters)を作成します。

* バージョン 0.5.0 以降の [cert-manager](https://cert-manager.readthedocs.io/en/latest/) サービスのインスタンス。デフォルトのインストールでは、<code>cert-manager</code> を使用して {{site.data.keyword.datashield_short}} サービス間の内部通信用の [TLS 証明書](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates)をセットアップします。Helm を使用してインスタンスをインストールする場合は、次のコマンドを実行できます。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Helm チャートを使用したインストール
{: #gs-install-chart}

提供された Helm チャートを使用して {{site.data.keyword.datashield_short}} を SGX 対応のベアメタル・クラスターにインストールすることができます。
{: shortdesc}

Helm チャートは、以下のコンポーネントをインストールします。

*	SGX をサポートするソフトウェア。特権コンテナーを使用してベアメタル・ホストにインストールされます。
*	{{site.data.keyword.datashield_short}} Enclave Manager。{{site.data.keyword.datashield_short}} 環境で SGX エンクレーブを管理します。
*	EnclaveOS® コンテナー変換サービス。コンテナー化されたアプリケーションを {{site.data.keyword.datashield_short}} 環境で実行できるようになります。

Helm チャートをインストールする際、インストールをカスタマイズするためのいくつかのオプションとパラメーターを利用できます。以下のチュートリアルは、チャートの最も基本的なデフォルトのインストールを行うための手順です。オプションについて詳しくは、[{{site.data.keyword.datashield_short}} のインストール](/docs/services/data-shield?topic=data-shield-deploying)を参照してください。
{: tip}

クラスターに {{site.data.keyword.datashield_short}} をインストールするには、以下のようにします。

1. {{site.data.keyword.cloud_notm}} CLI にログインします。CLI のプロンプトに従ってゆくとログインが完了します。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>地域</th>
      <th>IBM Cloud エンドポイント</th>
      <th>Kubernetes サービス地域</th>
    </tr>
    <tr>
      <td>ダラス</td>
      <td><code>us-south</code></td>
      <td>米国南部</td>
    </tr>
    <tr>
      <td>フランクフルト</td>
      <td><code>eu-de</code></td>
      <td>中欧</td>
    </tr>
    <tr>
      <td>シドニー</td>
      <td><code>au-syd</code></td>
      <td>アジア太平洋南部</td>
    </tr>
    <tr>
      <td>ロンドン</td>
      <td><code>eu-gb</code></td>
      <td>英国南部</td>
    </tr>
    <tr>
      <td>東京</td>
      <td><code>jp-tok</code></td>
      <td>アジア太平洋北部</td>
    </tr>
    <tr>
      <td>ワシントン DC</td>
      <td><code>us-east</code></td>
      <td>米国東部</td>
    </tr>
  </table>

2. クラスターのコンテキストを設定します。

  1. 環境変数を設定して Kubernetes 構成ファイルをダウンロードするためのコマンドを取得します。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. `export` で始まる出力をコピーし、端末に貼り付けて `KUBECONFIG` 環境変数を設定します。

3. `ibm` リポジトリーをまだ追加していない場合は追加します。

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. オプション: 管理者または管理アカウント ID に関連付けられた E メールが分からない場合は、次のコマンドを実行します。

  ```
  ibmcloud account show
  ```
  {: pre}

5. クラスターの Ingress サブドメインを取得します。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. チャートをインストールします。

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  コンバーターに合わせて [{{site.data.keyword.cloud_notm}} Container Registry を構成](/docs/services/data-shield?topic=data-shield-convert#convert)した場合、次のオプションを追加することができます: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. コンポーネントの開始をモニターするには、次のコマンドを実行します。

  ```
  kubectl get pods
  ```
  {: pre}


## 次のステップ
{: #gs-next}

お疲れさまでした。サービスがクラスターにインストールされたので、アプリを {{site.data.keyword.datashield_short}} 環境で実行できるようになりました。 

アプリを {{site.data.keyword.datashield_short}} 環境で実行するには、コンテナー・イメージを[変換](/docs/services/data-shield?topic=data-shield-convert#convert)し、[ホワイトリスト](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist)に登録した後に、[デプロイ](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers)する必要があります。

デプロイする独自のイメージがない場合は、プリパッケージされた {{site.data.keyword.datashield_short}} イメージをデプロイしてください。

* [{{site.data.keyword.datashield_short}} サンプル GitHub リポジトリー](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* {{site.data.keyword.cloud_notm}} Container Registry の MariaDB または NGINX
