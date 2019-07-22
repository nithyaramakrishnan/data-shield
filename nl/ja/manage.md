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

# Enclave Manager の使用
{: #enclave-manager}

Enclave Manager UI を使用して、{{site.data.keyword.datashield_full}} で保護するアプリケーションを管理できます。UI から、アプリのデプロイメントを管理したり、アクセス権限を割り当てたり、ホワイトリスト登録要求を処理したり、アプリケーションを変換したりできます。
{: shortdesc}


## サインイン
{: #em-signin}

Enclave Manager コンソールでは、クラスター内のノードと、それらの認証状況を表示することができます。 また、クラスター・イベントのタスクと監査ログを表示することもできます。まずはサインインします。
{: shortdesc}

1. [適切なアクセス権限](/docs/services/data-shield?topic=data-shield-access)があることを確認します。

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

3. すべてのポッドが*アクティブ* 状態であることを確認することによって、すべてのサービスが実行中であるかどうか確認します。

  ```
  kubectl get pods
  ```
  {: codeblock}

4. 次のコマンドを実行して、Enclave Manager のフロントエンド URL を検索します。

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Ingress サブドメインを取得します。

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. ブラウザーで、Enclave Manager が使用可能な Ingress サブドメインを入力します。

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

7. 端末で、IAM トークンを取得します。

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. トークンをコピーして、それを Enclave Manager GUI に貼り付けます。 出力されたトークンの `Bearer` 部分はコピーする必要はありません。

9. **「サインイン」**をクリックします。






## ノードの管理
{: #em-nodes}

Enclave Manager UI を使用して、クラスター内で IBM Cloud Data Shield を実行しているノードの状況をモニターしたり、非アクティブ化したり、証明書をダウンロードしたりできます。
{: shortdesc}


1. Enclave Manager にサインインします。

2. **「ノード」**タブにナビゲートします。

3. 調査するノードの IP アドレスをクリックします。情報画面が開きます。

4. 情報画面で、ノードの非アクティブ化、または、使用されている証明書のダウンロードを選択できます。




## アプリケーションのデプロイ
{: #em-apps}

Enclave Manager UI を使用して、アプリケーションをデプロイできます。
{: shortdesc}


### アプリの追加
{: #em-app-add}

Enclave Manager UI を使用して、アプリケーションの変換、デプロイ、ホワイトリストへの登録をすべて同時に行うことができます。
{: shortdesc}

1. Enclave Manager にサインインして、**「アプリ (Apps)」**タブにナビゲートします。

2. **「アプリケーションの新規追加 (Add new application)」**をクリックします。

3. アプリケーションの名前と説明を入力します。

4. イメージの入力名と出力名を入力します。入力は現在のアプリケーション名です。出力は、変換後のアプリケーションが置かれる場所です。

5. **ISVPRDID** と **ISVSVN** を入力します。

6. 許可されているドメインを入力します。

7. 変更する詳細設定を編集します。

8. **「アプリケーションの新規作成 (Create new application)」**をクリックします。アプリケーションがデプロイされ、ホワイトリストに追加されます。**「タスク」**タブで、ビルド要求を承認できます。




### アプリの編集
{: #em-app-edit}

アプリケーションをリストに追加した後に編集することができます。
{: shortdesc}


1. Enclave Manager にサインインして、**「アプリ (Apps)」**タブにナビゲートします。

2. 編集するアプリケーションの名前をクリックします。新しい画面が開き、証明書とデプロイ済みのビルドを含む構成が表示されます。

3. **「アプリケーションの編集 (Edit application)」**をクリックします。

4. 構成を更新します。必ず、詳細設定を変更することでアプリケーションが受ける影響を理解したうえで変更を加えてください。

5. **「アプリケーションの編集 (Edit application)」**をクリックします。


## アプリケーションの構築
{: #em-builds}

変更を加えたら、Enclave Manager UI を使用してアプリケーションを再構築できます。
{: shortdesc}

1. Enclave Manager にサインインして、**「ビルド (Builds)」**タブにナビゲートします。

2. **「ビルドの新規作成 (Create new build)」**をクリックします。

3. ドロップダウン・リストからアプリケーションを選択するか、アプリケーションを追加します。

4. Docker イメージの名前を入力し、タグとしてラベルを付けます。 

5. **「ビルド」**をクリックします。ビルドがホワイトリストに追加されます。**「タスク」**タブで、ビルドを承認できます。



## タスクの承認
{: #em-tasks}

アプリケーションがホワイトリストに登録されると、Enclave Manager UI の**「タスク」**タブの未処理要求のリストに追加されます。この UI を使用して、要求を承認/拒否できます。
{: shortdesc}

1. Enclave Manager にサインインして、**「タスク」**タブにナビゲートします。

2. 承認または拒否する要求が含まれている行をクリックします。詳細情報を示す画面が開きます。

3. 要求を確認し、**「承認」**または**「拒否 (Deny)」**をクリックします。**「レビューアー (Reviewers)」**のリストに自分の名前が追加されます。


## ログの表示
{: #em-view}

数種類のアクティビティーについて、Enclave Manager インスタンスを監査できます。
{: shortdesc}

1. Enclave Manager UI の**「監査ログ」**タブにナビゲートします。
2. ロギングの結果をフィルタリングして検索結果を絞り込みます。フィルター基準として、時間フレームまたは以下のいずれかのタイプを選択できます。

  * アプリの状況: ホワイトリスト登録要求や新しいビルドなど、アプリケーションに関係するアクティビティー。
  * ユーザー承認: アカウントの使用の承認や拒否など、ユーザーのアクセスに関係するアクティビティー。
  * ノード認証: ノード認証に関係するアクティビティー。
  * 認証局: 認証局に関係するアクティビティー。
  * 管理: 管理に関係するアクティビティー。 

1 カ月より長くログのレコードを保持する場合は、情報を `.csv` ファイルとしてエクスポートできます。

