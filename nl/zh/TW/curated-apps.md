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



# 策劃應用程式
{: #curated-apps}

想要試用 IBM Cloud Data Shield，但沒有準備就緒的容器化應用程式可用？沒問題。您可以使用此服務提供的某個預先包裝的應用程式。
{: shortdesc}


## 存取公用 IBM 映像檔
{: #curated-access}

您可以使用 CLI 存取公用 IBM 映像檔。
{: shortdesc}


1. 登入 IBM Cloud：

    ```
    ibmcloud login
    ```
    {: codeblock}

2. 鎖定廣域登錄。

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. 列出 IBM 公用映像檔選項。

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

如需使用容器映像檔的相關資訊，請參閱[登錄文件](/docs/services/Registry?topic=registry-getting-started)。


## IBM Cloud Data Shield 映像檔選項
{: #curated-options}

您可以使用下列任何公用映像檔，以快速入門和熟悉運用 IBM Cloud Data Shield。
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


