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



# 精選されたアプリ
{: #curated-apps}

IBM Cloud Data Shield を試してみたいのに、コンテナー化アプリの準備ができていないのではありませんか? 問題ありません。 サービスに用意されているプリパッケージされたアプリケーションの 1 つを使用できます。
{: shortdesc}


## IBM のパブリック・イメージへのアクセス
{: #curated-access}

CLI を使用して、パブリック IBM イメージにアクセスできます。
{: shortdesc}


1. 次のように IBM Cloud にログインします。

    ```
    ibmcloud login
    ```
    {: codeblock}

2. グローバル・レジストリーをターゲットにします。

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. IBM パブリック・イメージのオプションをリストします。

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

コンテナー・イメージの操作方法について詳しくは、[レジストリーの資料](/docs/services/Registry?topic=registry-getting-started)を参照してください。


## IBM Cloud Data Shield イメージのオプション
{: #curated-options}

以下のいずれかのパブリック・イメージを使用して、IBM Cloud Data Shield ですぐに起動することができます。
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


