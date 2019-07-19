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



# Apps adjuntas
{: #curated-apps}

¿Desea probar IBM Cloud Data Shield pero no tiene una app de contenedor preparada? No pasa nada. Puede utilizar una de las aplicaciones empaquetadas que proporciona el servicio.
{: shortdesc}


## Acceso a imágenes públicas de IBM
{: #curated-access}

Puede acceder a las imágenes públicas de IBM mediante la CLI.
{: shortdesc}


1. Inicie una sesión en IBM Cloud:

    ```
    ibmcloud login
    ```
    {: codeblock}

2. Elija como destino el registro global.

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. Obtenga una lista de las opciones de imágenes públicas de IBM.

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

Para obtener más información sobre cómo trabajar con imágenes de contenedor, consulte la [documentación de registro](/docs/services/Registry?topic=registry-getting-started).


## Opciones de imágenes de IBM Cloud Data Shield
{: #curated-options}

Puede utilizar cualquiera de las siguientes imágenes públicas para ponerse en marcha rápidamente con IBM Cloud Data Shield.
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


