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



# 组织的应用程序
{: #curated-apps}

想要试用 IBM Cloud Data Shield，但没有准备就绪的容器化应用程序可用？不用担心。您可以使用此服务提供的某个预先打包的应用程序。
{: shortdesc}


## 访问公共 IBM 映像
{: #curated-access}

您可以使用 CLI 访问公共 IBM 映像。
{: shortdesc}


1. 登录到 IBM Cloud：

    ```
    ibmcloud login
    ```
    {: codeblock}

2. 锁定全局注册表。

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. 列出 IBM 公共映像选项。

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

有关使用容器映像的更多信息，请参阅[注册表文档](/docs/services/Registry?topic=registry-getting-started)。


## IBM Cloud Data Shield 映像选项
{: #curated-options}

您可以使用以下任何公共映像，以快速入门和熟悉运用 IBM Cloud Data Shield。
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


