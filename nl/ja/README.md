# IBM Cloud Data Shield

IBM Cloud Data Shield、Fortanix®、および Intel® SGX を使用すると、IBM Cloud で実行されるコンテナー・ワークロード内のデータの使用中に、データを保護することができます。

## 概要

データの保護という点に関しては、最も一般的で効果的な方法の一つとして、暗号化が挙げられます。しかし、データを確実に保護するには、そのライフサイクルの各ステップで暗号化する必要があります。データのライフサイクルの 3 つのフェーズとして、Data at Rest (保存されたデータ)、Data in Motion (流れているデータ)、Data in Use (使用中のデータ) が挙げられます。Data at Rest と Data in Motion は、保管時と転送時にデータを保護するために一般的に使用されるフェーズです。

ただし、アプリケーションの実行が開始すると、CPU やメモリーによって使用されるデータは、攻撃に対して脆弱になります。悪意のある内部関係者、root ユーザー、資格情報の漏えい、OS のゼロ・デイ攻撃、ネットワーク侵入者はすべて、データにとって脅威です。暗号化をさらに一歩進めて、Data in Use を保護できるようになりました。 

このサービスについて、および使用中のデータを保護することの意味について詳しくは、[サービスについて](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about)を参照してください。



## チャートの詳細

この Helm チャートは、SGX 対応の IBM Cloud Kubernetes サービス・クラスターに以下のコンポーネントをインストールします。

 * SGX をサポートするソフトウェア。特権コンテナーを使用してベアメタル・ホストにインストールされます。
 * IBM Cloud Data Shield Enclave Manager。IBM Cloud Data Shield 環境で SGX エンクレーブを管理します。
 * EnclaveOS® Container Conversion Service。IBM Cloud Data Shield 環境で実行できるようにコンテナー化アプリケーションを変換します。



## 必要なリソース

* SGX 対応の Kubernetes クラスター。現時点では、ノード・タイプが mb2c.4x32 のベアメタル・クラスター上で SGX を使用可能にすることができます。そのようなクラスターがない場合は、以下の手順を実行して必要なクラスターを作成します。
  1. [クラスターを作成する](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare)準備をします。

  2. クラスターを作成するための[必要な許可](https://cloud.ibm.com/docs/containers?topic=containers-users#users)があることを確認します。

  3. [クラスター](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters)を作成します。

* バージョン 0.5.0 以降の [cert-manager](https://cert-manager.readthedocs.io/en/latest/) サービスのインスタンス。Helm を使用してインスタンスをインストールする場合は、次のコマンドを実行できます。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## 前提条件

IBM Cloud Data Shield を使い始めるためには、その前に以下の前提条件を満たす必要があります。CLI とプラグインのダウンロードや、Kubernetes サービスの環境の構成について支援が必要な場合は、チュートリアル [Kubernetes クラスターの作成](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)を参照してください。

* 次の CLI:

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  `--tls` モードを使用するように Helm を構成することもできます。TLS の有効化については、[Helm リポジトリー](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)を参照してください。TLS を有効にした場合、実行する Helm コマンドごとに `--tls` を付加してください。
  {: tip}

* 次の [{{site.data.keyword.cloud_notm}} CLI プラグイン](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes サービス
  * Container Registry



## チャートのインストール

Helm チャートをインストールする際、インストールをカスタマイズするために使用できるいくつかのオプションとパラメーターがあります。以下は、チャートの最も基本的なデフォルトのインストールを行うための手順です。オプションについて詳しくは、[IBM Cloud Data Shield の資料](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started)を参照してください。

ヒント: 専用レジストリーにイメージが保管されていますか? EnclaveOS Container Converter を使用して、IBM Cloud Data Shield と連動するようにイメージを構成できます。必要な構成情報を使用できるように、チャートをデプロイする前にイメージを変換してください。イメージの変換について詳しくは、[この資料](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)を参照してください。


**クラスターに IBM Cloud Data Shield をインストールするには、以下のようにします。**

1. IBM Cloud CLI にログインします。CLI のプロンプトに従ってゆくとログインが完了します。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

  2. `export` で始まる出力をコピーし、端末に貼り付けて `KUBECONFIG` 環境変数を設定します。

3. `ibm` リポジトリーをまだ追加していない場合は追加します。

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. オプション: 管理者または管理アカウント ID に関連付けられた E メールが分からない場合は、次のコマンドを実行します。

  ```
  ibmcloud account show
  ```

5. クラスターの Ingress サブドメインを取得します。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. チャートをインストールします。

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  注: コンバーターに合わせて [IBM Cloud Container Registry を構成](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)した場合、オプション `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config` を追加します

7. コンポーネントの開始をモニターするには、次のコマンドを実行します。

  ```
  kubectl get pods
  ```

## IBM Cloud Data Shield 環境でのアプリの実行

アプリケーションを IBM Cloud Data Shield 環境で実行するには、コンテナー・イメージを変換し、ホワイトリストに登録した後に、デプロイする必要があります。

### イメージの変換
{: #converting-images}

Enclave Manager API を使用してコンバーターに接続できます。
{: shortdesc}

1. IBM Cloud CLI にログインします。CLI のプロンプトに従ってゆくとログインが完了します。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. IAM トークンを取得してエクスポートします。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. イメージを変換します。変数は、ご使用のアプリケーションの情報に置き換えてください。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### アプリケーションのホワイトリスティング
{: #convert-whitelist}

Intel SGX 内で実行するために変換した Docker イメージは、ホワイトリストに登録することができます。イメージをホワイトリスティングすることで、IBM Cloud Data Shield がインストールされているクラスターでアプリケーションを実行できるようにする管理者特権を割り当てることになります。
{: shortdesc}

1. 次の curl 要求を使用して、IAM 認証トークンを使用して Enclave Manager アクセス・トークンを取得します。

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. Enclave Manager に対してホワイトリスト要求を行います。次のコマンドを実行するときは、お客様の情報を入力してください。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. Enclave Manager GUI を使用して、ホワイトリスト要求を承認または拒否します。GUI の**「ビルド (Builds)」**セクションで、ホワイトリストに登録したビルドを追跡および管理できます。



### IBM Cloud Data Shield コンテナーのデプロイ

イメージを変換したら、IBM Cloud Data Shield コンテナーを Kubernetes クラスターに再デプロイする必要があります。
{: shortdesc}

IBM Cloud Data Shield コンテナーを Kubernetes クラスターにデプロイする際、コンテナーの仕様にはボリューム・マウントが含まれている必要があります。ボリュームを使用することによって、コンテナーで SGX デバイスと AESM ソケットを使用できるようになります。

1. 次のポッド仕様をテンプレートとして保存します。

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. `your-app-sgx` および `your-registry-server` の各フィールドをご使用のアプリとサーバーに合わせて更新します。

3. Kubernetes ポッドを作成します。

   ```
   kubectl create -f template.yml
   ```

このサービスを試用するためのアプリケーションをお持ちではないですか? 問題ありません。MariaDB や NGINX など、試用できるサンプル・アプリがいくつも用意されています。IBM Container Registry にある[「datashield」イメージ](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)をサンプルとして自由に使用できます。



## Enclave Manager GUI へのアクセス

Enclave Manager GUI を使用することにより、IBM Cloud Data Shield 環境で実行されるすべてのアプリケーションの概要を確認できます。Enclave Manager コンソールでは、クラスター内のノード、それらの認証状況、タスク、およびクラスター・イベントの監査ログを表示することができます。ホワイトリスト要求の承認と拒否も行えます。

GUI にアクセスするには、以下のようにします。

1. IBM Cloud にサインインし、クラスターのコンテキストを設定します。

2. すべてのポッドが*実行中* の状態であることを確認することによって、このサービスが実行中であるかどうか確認します。

  ```
  kubectl get pods
  ```

3. 次のコマンドを実行して、Enclave Manager のフロントエンド URL を検索します。

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Ingress サブドメインを取得します。

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. ブラウザーで、Enclave Manager が使用可能な Ingress サブドメインを入力します。

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. 端末で、IAM トークンを取得します。

  ```
  ibmcloud iam oauth-tokens
  ```

7. トークンをコピーして、それを Enclave Manager GUI に貼り付けます。出力されたトークンの `Bearer` 部分はコピーする必要はありません。

8. **「サインイン」**をクリックします。

さまざまなアクションを実行するためにユーザーに必要な役割については、[Enclave Manager ユーザーの役割の設定](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles)を参照してください。

## プリパッケージ・シールド・イメージの使用

IBM Cloud Data Shield チームは、IBM Cloud Data Shield 環境で実行できる 4 つの異なる実動対応イメージを組み合わせて提供しています。以下のイメージのどれでも試してみることができます。

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## アンインストールとトラブルシューティング

IBM Cloud Data Shield の使用中に問題が発生した場合は、本資料の[トラブルシューティング](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting)または[よくある質問](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq)のセクションを調べてみてください。該当する質問や問題の解決策が見当たらない場合は、[IBM サポート](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support)に連絡してください。

IBM Cloud Data Shield を使用する必要がなくなったら、[サービスと作成された TLS 証明書を削除する](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall)ことができます。

