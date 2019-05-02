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

# アンインストール
{: #uninstall}

{{site.data.keyword.datashield_full}} を使用する必要がなくなったら、サービスと作成された TLS 証明書を削除できます。


## Helm を使用したアンインストール

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

3. サービスを削除します。

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. 以下のコマンドをそれぞれ実行して TLS 証明書を削除します。

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. アンインストール処理では、Helm の「フック」を使用してアンインストーラーが実行されます。実行後はアンインストーラーを削除できます。

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

`cert-manager` インスタンスと Docker 構成シークレットを作成していれば、それらも削除できます。
{: tip}



## ベータ版インストーラーを使用したアンインストール
{: #uninstall-installer}

ベータ版インストーラーを使用して {{site.data.keyword.datashield_short}} をインストールした場合は、そのインストーラーでサービスをアンインストールすることもできます。

{{site.data.keyword.datashield_short}} をアンインストールするには、`ibmcloud` CLI にログインし、ご使用のクラスターをターゲットにしてから、次のコマンドを実行します。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
