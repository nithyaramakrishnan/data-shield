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



# Kuratierte Apps
{: #curated-apps}

Möchten Sie versuchen, IBM Cloud Data Shield zu testen, haben aber keine bereite containerisierte App? Kein Problem. Sie können eine der vordefinierten Anwendungen verwenden, die vom Service bereitgestellt werden.
{: shortdesc}


## Zugriff auf öffentliche IBM Images
{: #curated-access}

Über die Befehlszeilenschnittstelle haben Sie Zugriff auf die öffentlichen IBM Images.
{: shortdesc}


1. Melden Sie sich bei IBM Cloud an:

    ```
    ibmcloud login
    ```
    {: codeblock}

2. Visieren Sie die globale Registry an.

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. Listen Sie die Optionen für die öffentlichen IBM Images auf.

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

Weitere Informationen zum Arbeiten mit Container-Images finden Sie in der [Registry-Dokumentation](/docs/services/Registry?topic=registry-getting-started).


## Optionen für IBM Cloud Data Shield-Images
{: #curated-options}

Mithilfe der folgenden öffentlichen Images können Sie IBM Cloud Data Shield ohne zeitliche Verzögerung betriebsbereit machen.
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


