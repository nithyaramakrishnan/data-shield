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

# インストール
{: #deploying}

提供された Helm チャートまたはインストーラーのいずれかを使用して {{site.data.keyword.datashield_full}} をインストールできます。各自が使いやすいと思うインストール・コマンドを使用できます。
{: shortdesc}

## 始める前に
{: #begin}

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

* バージョン 0.5.0 以降の [cert-manager](https://cert-manager.readthedocs.io/en/latest/) サービスのインスタンス。Helm を使用してインスタンスをインストールする場合は、次のコマンドを実行できます。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## オプション: Kubernetes 名前空間の作成
{: #create-namespace}

デフォルトでは、{{site.data.keyword.datashield_short}} は `kube-system` 名前空間にインストールされます。オプションで、代わりの名前空間を新しく作成して使用することもできます。
{: shortdesc}


1. {{site.data.keyword.cloud_notm}} CLI にログインします。CLI のプロンプトに従ってゆくとログインが完了します。

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
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

  2. 出力をコピーして、それを端末に貼り付けます。

3. 名前空間を作成します。

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. 関連するシークレットがあれば、デフォルトの名前空間から新しい名前空間にコピーします。

  1. 使用可能なシークレットをリストします。

    ```
    kubectl get secrets
    ```
    {: pre}

    `bluemix*` で始まるシークレットをすべてコピーする必要があります。
    {: tip}

  2. シークレットは 1 つずつコピーします。

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. シークレットがコピーされたことを確認します。

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. サービス・アカウントを作成します。すべてのカスタマイズ・オプションを参照するには、[Helm GitHub リポジトリーの RBAC ページ](https://github.com/helm/helm/blob/master/docs/rbac.md)をご覧ください。

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. [Tiller SSL GitHub リポジトリー](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)の指示に従って、証明書を生成して Helm の TLS を有効にします。作成した名前空間を指定してください。

これで完了です。{{site.data.keyword.datashield_short}} を新しい名前空間にインストールする準備ができました。これ以降は、実行するすべての Helm コマンドに `--tiller-namespace <namespace_name>` を付加してください。


## Helm チャートを使用したインストール
{: #install-chart}

提供された Helm チャートを使用して {{site.data.keyword.datashield_short}} を SGX 対応のベアメタル・クラスターにインストールすることができます。
{: shortdesc}

Helm チャートは、以下のコンポーネントをインストールします。

*	SGX をサポートするソフトウェア。特権コンテナーを使用してベアメタル・ホストにインストールされます。
*	{{site.data.keyword.datashield_short}} Enclave Manager。{{site.data.keyword.datashield_short}} 環境で SGX エンクレーブを管理します。
*	EnclaveOS® コンテナー変換サービス。コンテナー化されたアプリケーションを {{site.data.keyword.datashield_short}} 環境で実行できるようになります。


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

  コンバーターに合わせて [{{site.data.keyword.cloud_notm}} Container Registry を構成](/docs/services/data-shield?topic=data-shield-convert#convert)した場合、`--set converter-chart.Converter.DockerConfigSecret=converter-docker-config` を追加する必要があります。
  {: note}

7. コンポーネントの開始をモニターするには、次のコマンドを実行します。

  ```
  kubectl get pods
  ```
  {: pre}



## {{site.data.keyword.datashield_short}} インストーラーを使用したインストール
{: #installer}

インストーラーを使用して、{{site.data.keyword.datashield_short}} を SGX 対応のベアメタル・クラスターに簡単にインストールすることができます。
{: shortdesc}

1. {{site.data.keyword.cloud_notm}} CLI にログインします。CLI のプロンプトに従ってゆくとログインが完了します。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. クラスターのコンテキストを設定します。

  1. 環境変数を設定して Kubernetes 構成ファイルをダウンロードするためのコマンドを取得します。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. 出力をコピーして、それを端末に貼り付けます。

3. Container Registry CLI にサインインします。

  ```
  ibmcloud cr login
  ```
  {: pre}

4. ローカル・マシンにイメージをプルします。

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: pre}

5. 次のコマンドを実行して {{site.data.keyword.datashield_short}} をインストールします。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  最新のバージョンの {{site.data.keyword.datashield_short}} をインストールするには、`--version` フラグに `latest` を付けて使用します。


## サービスの更新
{: #update}

{{site.data.keyword.datashield_short}} は、クラスターにインストールした後、いつでも更新できます。

Helm チャートを使用して最新バージョンに更新するには、次のコマンドを実行します。

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: pre}


インストーラーを使用して最新バージョンに更新するには、次のコマンドを実行します。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  最新のバージョンの {{site.data.keyword.datashield_short}} をインストールするには、`--version` フラグに `latest` を付けて使用します。

