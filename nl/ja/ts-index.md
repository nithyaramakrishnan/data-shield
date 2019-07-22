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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# トラブルシューティング
{: #troubleshooting}

{{site.data.keyword.datashield_full}} の操作中に問題が生じた場合は、ここに示すトラブルシューティング手法やヘルプの利用手法を検討してください。
{: shortdesc}

## ヘルプとサポートの利用
{: #gettinghelp}

支援が必要な場合は、資料中の情報を検索するか、フォーラムで質問することができます。サポート・チケットを開くこともできます。 フォーラムを使用して質問するときは、{{site.data.keyword.cloud_notm}} 開発チームの目に留まるように、質問にタグを付けてください。
  * {{site.data.keyword.datashield_short}} についての技術的な質問がある場合は、質問を<a href="https://stackoverflow.com" target="_blank">スタック・オーバーフロー <img src="../../icons/launch-glyph.svg" alt="外部リンク・アイコン"></a>に投稿し、質問に「ibm-data-shield」のタグを付けてください。
  * サービスや開始手順についての質問は、<a href="https://developer.ibm.com/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="外部リンク・アイコン"></a> フォーラムをご利用ください。 `data-shield` タグを含めてください。

サポートの利用方法について詳しくは、[必要なサポートを利用するには](/docs/get-support?topic=get-support-getting-customer-support)を参照してください。


## ログの取得
{: #ts-logs}

IBM Cloud Data Shield に関するサポート・チケットを開く場合、ログを提供すると、トラブルシューティングのプロセスの時間短縮に役立つことがあります。以下の手順でログを取得してから、問題の作成時にその問題にコピーして貼り付けることができます。

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

3. 以下のコマンドを実行して、ログを取得します。

  ```
  kubectl logs --all-containers=true --selector release=$(helm list | grep 'data-shield' | awk {'print $1'}) > logs
  ```
  {: codeblock}


## Enclave Manager UI にログインできない
{: #ts-log-in}

{: tsSymptoms}
Enclave Manager UI にアクセスしようとしていますが、サインインできません。

{: tsCauses}
以下の理由でサインインに失敗している可能性があります。

* Enclave Manager クラスターに対するアクセス権限がない E メール ID を使用している可能性があります。
* 使用しているトークンが期限切れになっている可能性があります。

{: tsResolve}
この問題を解決するには、正しい E メール ID を使用していることを確認します。 これに問題がなければ、Enclave Manager に対する正しいアクセス権限が E メールに設定されていることを確認してください。 権限が正しければ、アクセス・トークンが期限切れになっている可能性があります。 トークンは 1 回で 60 分間有効です。 新しいトークンを取得するには、`ibmcloud iam oauth-tokens` を実行します。IBM Cloud アカウントが複数ある場合は、Enclave Manager クラスターにとって適切なアカウントを使用して CLI にログインしていることを確認してください。


## コンテナー・コンバーター API が forbidden エラーを返す
{: #ts-converter-forbidden-error}

{: tsSymptoms}
コンテナー・コンバーターを実行しようとしましたが、エラー `Forbidden` を受け取ります。

{: tsCauses}
IAM トークンまたはベアラー・トークンがないか期限切れになっているために、コンバーターにアクセスできない可能性があります。

{: tsResolve}
この問題を解決するには、要求のヘッダーで IBM IAM OAuth トークンまたは Enclave Manager 認証トークンのいずれかを使用していることを確認してください。トークンには次の形式を使用します。

* IAM: `Authentication: Basic <IBM IAM Token>`
* Enclave Manager: `Authentication: Bearer <E.M. Token>`

トークンが存在する場合は、まだ有効であることを確認してから要求を再度実行してください。


## コンテナー・コンバーターが Docker 専用レジストリーに接続できない
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
Docker 専用レジストリーにあるイメージに対してコンテナー・コンバーターを実行しようとしましたが、コンバーターが接続できません。

{: tsCauses}
専用レジストリー資格情報が正しく構成されていない可能性があります。 

{: tsResolve}
この問題を解決するには、以下の手順を実行します。

1. 専用レジストリー資格情報が既に構成されていることを確認します。 構成されていない場合は、ここで構成します。
2. 次のコマンドを実行して、Docker レジストリー資格情報をダンプします。 必要であれば、シークレット名を変更できます。

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: codeblock}

3. Base64 デコーダーを使用して `.dockerconfigjson` のシークレット・コンテンツをデコードし、それが正しいことを確認します。


## AESM ソケットまたは SGX デバイスをマウントできない
{: #ts-problem-mounting-device}

{: tsSymptoms}
ボリューム `/var/run/aesmd/aesm.socket` または `/dev/isgx` に {{site.data.keyword.datashield_short}} コンテナーをマウントしようとすると問題が発生します。

{: tsCauses}
ホストの構成の問題が原因でマウントが失敗することがあります。

{: tsResolve}
この問題を解決するには、以下の両方を確認します。

* `/var/run/aesmd/aesm.socket` がホスト上のディレクトリーではない。 ホスト上のディレクトリーであった場合は、このファイルを削除し、{{site.data.keyword.datashield_short}} ソフトウェアをアンインストールしてから、インストール手順を再度実行します。 
* ホスト・マシンの BIOS で SGX が有効になっている。 有効になっていない場合は、IBM サポートに連絡してください。


## エラー: コンテナーの変換
{: #ts-container-convert-fails}

{: tsSymptoms}
コンテナーを変換しようとすると次のエラーが発生します。

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: codeblock}

{: tsCauses}
macOS では、`config.json` ファイルで OS X キーチェーンが使用されていると、コンテナー・コンバーターが失敗します。 

{: tsResolve}
この問題を解決するには、以下の手順を使用します。

1. ローカル・システムで OS X キーチェーンを無効にします。**「システム環境設定」>「iCloud」**に移動し、**「キーチェーン」**のボックスをクリアします。

2. 作成したシークレットを削除します。 IBM Cloud にログインし、クラスターをターゲットにしてから、次のコマンドを実行します。

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}

3. `$HOME/.docker/config.json` ファイル内の `"credsStore": "osxkeychain"` という行を削除します。

4. レジストリーにログインします。

5. シークレットを作成します。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

6. ポッドをリストし、名前に `enclaveos-converter` が含まれるポッドをメモします。

  ```
  kubectl get pods
  ```
  {: codeblock}

7. そのポッドを削除します。

  ```
  kubectl delete pod <pod name>
  ```
  {: codeblock}

8. イメージを変換します。
