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

# 更新
{: #update}

{{site.data.keyword.datashield_short}} は、クラスターにインストールした後にいつでも更新することができます。
{: shortdesc}

## クラスター・コンテキストの設定
{: #update-context}

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

  2. 出力をコピーしてコンソールに貼り付けます。

3. `iks-charts` リポジトリーをまだ追加していない場合は追加します。

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. オプション: 管理者または管理アカウント ID に関連付けられた E メールが分からない場合は、次のコマンドを実行します。

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. クラスターの Ingress サブドメインを取得します。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

## Helm を使用した更新
{: #update-helm}

Helm チャートを使用して最新バージョンに更新するには、次のコマンドを実行します。

  ```
  helm upgrade <chart-name> ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

## インストーラーを使用した更新
{: #update-installer}

インストーラーを使用して最新バージョンに更新するには、次のコマンドを実行します。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer upgrade [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ] [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  最新のバージョンの {{site.data.keyword.datashield_short}} をインストールするには、`--version` フラグに `latest` を付けて使用します。


