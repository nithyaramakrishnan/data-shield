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

# アクセス権限の管理
{: #access}

{{site.data.keyword.datashield_full}} Enclave Manager へのアクセスを制御することができます。このアクセス制御は、{{site.data.keyword.cloud_notm}} で作業する際に使用する典型的な Identity and Access Management (IAM) の役割とは別のものです。
{: shortdesc}


## IAM API キーを使用してコンソールにログインする
{: #access-iam}

Enclave Manager コンソールでは、クラスター内のノードと、それらの認証状況を表示することができます。また、クラスター・イベントのタスクと監査ログを確認することもできます。

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

3. すべてのポッドが*実行中* の状態であることを確認することによって、すべてのサービスが実行中であるかどうか確認します。

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

8. 端末で、IAM トークンを取得します。

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. トークンをコピーして、それを Enclave Manager GUI に貼り付けます。出力されたトークンの `Bearer` 部分はコピーする必要はありません。

9. **「サインイン」**をクリックします。


## Enclave Manager ユーザーの役割の設定
{: #enclave-roles}

{{site.data.keyword.datashield_short}} は Enclave Manager で管理されます。管理者には自動的に*管理者* 役割が割り当てられますが、他のユーザーにも役割を割り当てることができます。
{: shortdesc}

これらの役割は、{{site.data.keyword.cloud_notm}} サービスへのアクセスを制御する際に使用するプラットフォーム IAM 役割とは異なる点にご注意ください。{{site.data.keyword.containerlong_notm}} のアクセスの構成について詳しくは、[クラスター・アクセス権限の割り当て](/docs/containers?topic=containers-users#users)を参照してください。
{: tip}

以下の表は、サポート対象の役割と、各ユーザーが実行できるアクションの例を示しています。

<table>
  <tr>
    <th>役割</th>
    <th>アクション</th>
    <th>例</th>
  </tr>
  <tr>
    <td>リーダー</td>
    <td>ノード、ビルド、ユーザー情報、アプリ、タスク、および監査ログの表示など、読み取り専用のアクションを実行できます。</td>
    <td>ノード認証の証明書のダウンロード。</td>
  </tr>
  <tr>
    <td>ライター</td>
    <td>リーダーが実行できるアクションに加え、ノード認証の非アクティブ化と更新、ビルドの追加、アクションとタスクの承認と拒否などのアクションを実行できます。</td>
    <td>アプリケーションの認証。</td>
  </tr>
  <tr>
    <td>管理者</td>
    <td>ライターが実行できるアクションに加え、ユーザー名と役割の更新、クラスターへのユーザーの追加、クラスター設定の更新などの特権アクションを実行できます。</td>
    <td>ユーザー役割の更新。</td>
  </tr>
</table>

### ユーザー役割の設定
{: #set-roles}

コンソール・マネージャーのユーザー役割を設定と更新を行うことができます。
{: shortdesc}

1. [Enclave Manager UI](/docs/services/data-shield?topic=data-shield-access#access-iam) に移動します。
2. ドロップダウン・メニューから、ユーザー管理画面を開きます。
3. **「設定」**を選択します。この画面では、ユーザーのリストを確認したり、ユーザーを追加したりできます。
4. ユーザー許可を編集するには、ユーザーにカーソルを合わせて、鉛筆アイコンを表示させます。
5. 鉛筆アイコンをクリックして、ユーザー許可を変更します。ユーザー許可に加えた変更は、すぐに反映されます。
