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



# Applications organisées
{: #curated-apps}

Vous souhaitez essayer IBM Cloud Data Shield mais ne disposez pas d'une application conteneurisée prête à l'emploi ? Pas de problème. Vous pouvez utiliser l'une des applications prépackagées fournies par le service.
{: shortdesc}


## Accès aux images IBM publiques
{: #curated-access}

Vous pouvez accéder aux images IBM publiques via l'interface de ligne de commande.
{: shortdesc}


1. Connectez-vous à IBM Cloud :

    ```
    ibmcloud login
    ```
    {: codeblock}

2. Ciblez la base de registre globale.

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. Répertoriez les options d'image publique IBM.

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

Pour plus d'informations sur l'utilisation d'images de conteneur, voir la [documentation sur les registres](/docs/services/Registry?topic=registry-getting-started).


## Options d'image IBM Cloud Data Shield
{: #curated-options}

Vous pouvez utiliser les images publiques suivantes pour être rapidement opérationnel avec IBM Cloud Data Shield.
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


