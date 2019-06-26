---

copyright:
  years: 2018, 2019
lastupdated: "2019-06-12"

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



# Curated apps
{: #curated-apps}

Want to try IBM Cloud Data Shield but don't have a containerized app ready to go? No problem. You can use one of the prepackaged applications that are provided by the service.
{: shortdesc}


## Accessing public IBM images
{: #curated-access}

You can access the public IBM images by using the command line.
{: shortdesc}


1. Log in to IBM Cloud:

    ```
    ibmcloud login
    ```
    {: codeblock}

2. Target the global registry.

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. List the IBM public image options.

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

For more information about working with container images, see the [Registry documentation](/docs/services/Registry?topic=registry-getting-started).


## IBM Cloud Data Shield image options
{: #curated-options}

You can use any of the following public images to quickly get up and running with IBM Cloud Data Shield.
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


