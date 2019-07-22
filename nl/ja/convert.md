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

# イメージの変換
{: #convert}

{{site.data.keyword.datashield_short}} Container Converter を使用して、EnclaveOS® 環境で実行するイメージを変換することができます。 変換したイメージは、SGX 対応の Kubernetes クラスターにデプロイできます。
{: shortdesc}

アプリケーションはコードを変更することなく変換できます。この変換によって、EnclaveOS 環境で実行するための準備をアプリケーションに施すことになります。変換プロセスでアプリケーションが暗号化されるわけではないことに注意してください。IBM Cloud Data Shield で保護されるのは、実行時に生成されるデータ、つまり SGX エンクレーブ内でアプリケーションが開始された後に生成されるデータだけです。 

変換プロセスでは、アプリケーションは暗号化されません。
{: important}


## 始める前に
{: #convert-before}

アプリケーションを変換する前に、以下の考慮事項を完全に理解していることを確認する必要があります。
{: shortdesc}

* セキュリティー上の理由で、シークレットは、変換するコンテナー・イメージの中に置くのではなく、実行時に提供しなければなりません。アプリを変換して実行したら、アプリケーションがエンクレーブ内で実行されていることを認証によって確認した後に、シークレットを提供してください。

* コンテナー・ゲストは、コンテナーの root ユーザーとして実行しなければなりません。

* Debian、Ubuntu、Java ベースのコンテナーがテストされ、さまざまな結果が出ています。その他の環境も機能する可能性はありますが、テストされていません。


## レジストリー資格情報の構成
{: #configure-credentials}

{{site.data.keyword.datashield_short}} コンテナー・コンバーターにプライベート・レジストリーの資格情報を構成すれば、コンバーターのすべてのユーザーがそのレジストリーを使用して入力イメージの取得や出力イメージのプッシュを行えるようになります。2018 年 10 月 4 日より前に Container Registry を使用した場合は、[レジストリーの IAM アクセス・ポリシー適用を有効にする](/docs/services/Registry?topic=registry-user#existing_users)ことをお勧めします。
{: shortdesc}

### {{site.data.keyword.cloud_notm}} Container Registry 資格情報の構成
{: #configure-ibm-registry}

1. {{site.data.keyword.cloud_notm}} CLI にログインします。 CLI のプロンプトに従っていくとログインが完了します。フェデレーテッド ID がある場合は、コマンドの末尾に `--sso` オプションを付加してください。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. {{site.data.keyword.datashield_short}} コンテナー・コンバーターのサービス ID とサービス ID API キーを作成します。

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. そのサービス ID に、コンテナー・レジストリーにアクセスするための許可を付与します。

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. 作成した API キーを使用して、JSON 構成ファイルを作成します。`<api key>` 変数を置換して次のコマンドを実行します。 `openssl` がない場合は、任意のコマンド・ライン base64 エンコーダーに適切なオプションを設定して使用できます。 エンコードされた文字列の途中または末尾に改行が入らないように注意してください。

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### 別のレジストリーの資格情報の構成
{: #configure-other-registry}

使用するレジストリーで認証を受けるための `~/.docker/config.json` ファイルが既にある場合は、そのファイルを使用できます。OS X のファイルは、現在サポートされていません。

1. [プル・シークレット](/docs/containers?topic=containers-images#other)を構成します。

2. {{site.data.keyword.cloud_notm}} CLI にログインします。 CLI のプロンプトに従っていくとログインが完了します。フェデレーテッド ID がある場合は、コマンドの末尾に `--sso` オプションを付加してください。

  ```
  ibmcloud login
  ```
  {: codeblock}

3. 次のコマンドを実行します。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## イメージの変換
{: #converting-images}

Enclave Manager API を使用してコンバーターに接続できます。
{: shortdesc}

[Enclave Manager UI](/docs/services/data-shield?topic=enclave-manager#em-apps) を使用してアプリを構築する際に、コンテナーを変換することもできます。
{: tip}

1. {{site.data.keyword.cloud_notm}} CLI にログインします。 CLI のプロンプトに従っていくとログインが完了します。フェデレーテッド ID がある場合は、コマンドの末尾に `--sso` オプションを付加してください。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. IAM トークンを取得してエクスポートします。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. イメージを変換します。 変数は、ご使用のアプリケーションの情報に置き換えてください。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Java アプリケーションの変換
{: #convert-java}

Java ベースのアプリケーションを変換する場合には、追加の要件と制限がいくつかあります。Enclave Manager UI を使用して Java アプリケーションを変換する際には、`Java-Mode` を選択できます。API を使用して Java アプリを変換するには、以下の制限とオプションを念頭に置いてください。

**制限**

* Java アプリの場合、エンクレーブの最大サイズの推奨値は 4 GB です。これより大きいエンクレーブも使用できますが、パフォーマンスが低下する可能性があります。
* ヒープ・サイズの推奨値は、エンクレーブのサイズ未満です。ヒープ・サイズを小さくする 1 つの方法として、`-Xmx` オプションを省くことをお勧めします。
* 以下の Java ライブラリーがテスト済みです。
  - MySQL Java コネクター
  - 暗号 (`JCA`)
  - メッセージング (`JMS`)
  - ハイバネート (`JPA`)

  別のライブラリーを使用する場合は、フォーラムを使用するかこのページ上のフィードバック・ボタンをクリックして、弊社チームにお問い合わせください。連絡先情報と、使用したいライブラリーをお知らせください。


**オプション**

`Java-Mode` 変換を使用するには、Docker ファイルを変更して、以下のオプションを指定します。Java 変換が機能するには、すべての変数を、このセクションで定義しているとおりに設定しなければなりません。 


* 環境変数 MALLOC_ARENA_MAX を 1 に設定します。

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* `OpenJDK JVM` を使用する場合は、以下のオプションを設定します。

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* `OpenJ9 JVM` を使用する場合は、以下のオプションを設定します。

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## アプリケーション証明書の要求
{: #request-cert}

変換したアプリケーションは、ご使用のアプリケーションを開始すると Enclave Manager に証明書を要求できます。 証明書は Enclave Manager 認証局によって署名され、そこにはアプリの SGX エンクレーブに対する Intel のリモート認証レポートが含まれています。
{: shortdesc}

以下の例では、RSA プライベート・キーの生成とそのキーの証明書の生成の要求を構成する方法を示しています。 キーは、アプリケーション・コンテナーのルートに保管されます。 一時的なキーや証明書が不要な場合は、アプリに合わせて `keyPath` と `certPath` をカスタマイズし、永続ボリュームに保管します。

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

2. 変数を入力し、次のコマンドを実行して、証明書情報を使用してコンバーターを再度実行します。

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## アプリケーションのホワイトリストへの登録
{: #convert-whitelist}

Intel® SGX 内で実行するために変換した Docker イメージは、ホワイトリストに登録することができます。 イメージをホワイトリストに登録することで、{{site.data.keyword.datashield_short}} がインストールされているクラスターでアプリケーションを実行できるようにする管理者特権を割り当てることになります。
{: shortdesc}


1. 次のように、IAM 認証トークンを使用して Enclave Manager アクセス・トークンを取得します。

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. Enclave Manager に対してホワイトリスト要求を行います。 次のコマンドを実行するときは、お客様の情報を入力してください。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. Enclave Manager GUI を使用して、ホワイトリスト要求を承認または拒否します。 GUI の**「タスク」**セクションで、ホワイトリストに登録したビルドを追跡したり管理したりできます。

