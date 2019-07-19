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



# 큐레이션된 앱
{: #curated-apps}

IBM Cloud Data Shield를 시도하려고 하지만 컨테이너화된 앱이 준비되지 않았습니까? 없어도 문제 없습니다. 서비스에서 제공한 사전 패키지된 애플리케이션 중 하나를 사용할 수 있습니다.
{: shortdesc}


## 공용 IBM 이미지 액세스
{: #curated-access}

CLI를 사용하여 공용 IBM 이미지에 액세스할 수 있습니다.
{: shortdesc}


1. IBM Cloud에 로그인하십시오.

    ```
    ibmcloud login
    ```
    {: codeblock}

2. 글로벌 레지스트리를 대상으로 지정하십시오.

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. IBM 공용 이미지 옵션을 나열하십시오.

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

컨테이너 이미지 작업에 대한 자세한 정보는 [레지스트리 문서](/docs/services/Registry?topic=registry-getting-started)를 참조하십시오.


## IBM Cloud Data Shield 이미지 옵션
{: #curated-options}

다음 공용 이미지를 사용하여 IBM Cloud Data Shield를 신속하게 시작하고 함께 실행할 수 있습니다.
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


