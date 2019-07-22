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

# アンインストール
{: #uninstall}

{{site.data.keyword.datashield_full}} を使用する必要がなくなったら、サービスと作成された TLS 証明書を削除できます。


## Helm を使用したアンインストール
{: #uninstall-helm}

1. {{site.data.keyword.cloud_notm}} CLI にログインします。 CLI のプロンプトに従っていくとログインが完了します。フェデレーテッド ID がある場合は、コマンドの末尾に `--sso` オプションを付加してください。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>地域</th>
      <th>{{site.data.keyword.cloud_notm}} エンドポイント</th>
      <th>{{site.data.keyword.containershort_notm}} 地域</th>
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
    {: codeblock}

  2. 出力をコピーしてコンソールに貼り付けます。

3. サービスを削除します。

  ```
  helm delete <chart-name> --purge
  ```
  {: codeblock}

4. 以下のコマンドをそれぞれ実行して TLS 証明書を削除します。

  ```
  kubectl delete secret <chart-name>-enclaveos-converter-tls
  kubectl delete secret <chart-name>-enclaveos-frontend-tls
  kubectl delete secret <chart-name>-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. アンインストール処理では、Helm の「フック」を使用してアンインストーラーが実行されます。 実行後はアンインストーラーを削除できます。

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

`cert-manager` インスタンスと Docker 構成シークレットを作成していれば、それらも削除できます。
{: tip}


## インストーラーを使用したアンインストール
{: #uninstall-installer}

インストーラーを使用して {{site.data.keyword.datashield_short}} をインストールした場合は、そのインストーラーでサービスをアンインストールすることもできます。

{{site.data.keyword.datashield_short}} をアンインストールするには、`ibmcloud` CLI にログインし、ご使用のクラスターをターゲットにしてから、次のコマンドを実行します。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

