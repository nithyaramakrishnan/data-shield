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

# イメージの変換
{: #convert}

{{site.data.keyword.datashield_short}} Container Converter を使用して、EnclaveOS® 環境で実行するイメージを変換することができます。変換したイメージは、SGX 対応の Kubernetes クラスターにデプロイできます。
{: shortdesc}


## レジストリー資格情報の構成
{: #configure-credentials}

コンバーターにレジストリー資格情報を構成することで、コンバーターのすべてのユーザーが、その構成済み専用レジストリーから入力イメージを取得したりそこに出力イメージをプッシュしたりできるようになります。
{: shortdesc}

### {{site.data.keyword.cloud_notm}} Container Registry 資格情報の構成
{: #configure-ibm-registry}

1. {{site.data.keyword.cloud_notm}} CLI にログインします。

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

2. {{site.data.keyword.cloud_notm}} Container Registry の認証トークンを取得します。

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. 作成したトークンを使用して、JSON 構成ファイルを作成します。`<token>` 変数を置換して次のコマンドを実行します。`openssl` がない場合は、任意のコマンド・ライン base64 エンコーダーに適切なオプションを設定して使用できます。エンコード・ストリングの途中または末尾に改行を入れないようにご注意ください。

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### 別のレジストリーの資格情報の構成
{: #configure-other-registry}

使用する予定のレジストリーに対して認証を行う `~/.docker/config.json` ファイルが既にある場合、そのファイルを使用できます。

1. {{site.data.keyword.cloud_notm}} CLI にログインします。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 次のコマンドを実行します。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## イメージの変換
{: #converting-images}

Enclave Manager API を使用してコンバーターに接続できます。
{: shortdesc}

1. {{site.data.keyword.cloud_notm}} CLI にログインします。CLI のプロンプトに従ってゆくとログインが完了します。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. IAM トークンを取得してエクスポートします。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. イメージを変換します。変数は、ご使用のアプリケーションの情報に置き換えてください。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## アプリケーション証明書の要求
{: #request-cert}

変換したアプリケーションは、アプリケーションの開始時に Enclave Manager からの証明書を要求できます。証明書は Enclave Manager 認証局によって署名され、そこにはアプリの SGX エンクレーブに対する Intel のリモート認証レポートが含まれています。
{: shortdesc}

以下の例では、RSA プライベート・キーの生成とそのキーの証明書の生成の要求を構成する方法を示しています。キーは、アプリケーション・コンテナーのルートに保管されます。一時キー/証明書を希望しない場合は、ご使用のアプリに合わせて `keyPath` と `certPath` をカスタマイズし、それらを永続ボリュームに格納します。

1. 以下のテンプレートを `app.json` として保存し、ご使用のアプリケーションの証明書要件に応じて必要な変更を行います。

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. 変数を入力し、次のコマンドを実行して証明書情報を使用してコンバーターを再度実行します。

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: pre}


## アプリケーションのホワイトリスティング
{: #convert-whitelist}

Intel® SGX 内で実行するために変換した Docker イメージは、ホワイトリストに登録することができます。イメージをホワイトリスティングすることで、{{site.data.keyword.datashield_short}} がインストールされているクラスターでアプリケーションを実行できるようにする管理者特権を割り当てることになります。
{: shortdesc}

1. 次の curl 要求を使用して、IAM 認証トークンを使用して Enclave Manager アクセス・トークンを取得します。

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. Enclave Manager に対してホワイトリスト要求を行います。次のコマンドを実行するときは、お客様の情報を入力してください。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. Enclave Manager GUI を使用して、ホワイトリスト要求を承認または拒否します。GUI の**「ビルド (Builds)」**セクションで、ホワイトリストに登録したビルドを追跡および管理できます。
