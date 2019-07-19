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



# Applicazioni curate
{: #curated-apps}

Vuoi provare IBM Cloud Data Shield ma non hai un'applicazione inserita in un contenitore pronta per l'uso? Nessun problema. Puoi utilizzare una delle applicazioni preconfezionate fornite dal servizio.
{: shortdesc}


## Accesso alle immagini IBM pubbliche
{: #curated-access}

Puoi accedere alle immagini IBM pubbliche utilizzando la CLI.
{: shortdesc}


1. Accedi a IBM Cloud:

    ```
    ibmcloud login
    ```
    {: codeblock}

2. Specifica il registro globale.

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. Elenca le opzioni di immagine pubblica IBM.

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

Per ulteriori informazioni su come lavorare con le immagini del contenitore, consulta la [documentazione del registro](/docs/services/Registry?topic=registry-getting-started).


## Opzioni di immagine IBM Cloud Data Shield
{: #curated-options}

Puoi utilizzare una qualsiasi delle seguenti immagini pubbliche per iniziare subito a lavorare con IBM Cloud Data Shield.
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


