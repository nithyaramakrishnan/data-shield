---

copyright:
  years: 2018, 2020
lastupdated: "2020-09-21"

keywords: images, public, global registry, applications, containerized app, sample app, data security, encryption, kube security,

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:faq: data-hd-content-type='faq'}
{:gif: data-image-type='gif'}
{:important: .important}
{:note: .note}
{:pre: .pre}
{:tip: .tip}
{:preview: .preview}
{:deprecated: .deprecated}
{:beta: .beta}
{:term: .term}
{:shortdesc: .shortdesc}
{:script: data-hd-video='script'}
{:support: data-reuse='support'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:java: .ph data-hd-programlang='java'}
{:javascript: .ph data-hd-programlang='javascript'}
{:swift: .ph data-hd-programlang='swift'}
{:curl: .ph data-hd-programlang='curl'}
{:video: .video}
{:step: data-tutorial-type='step'}
{:tutorial: data-hd-content-type='tutorial'}





# Curated apps
{: #curated-apps}

Want to try IBM Cloud Data Shield but don't have a containerized app ready to go? No problem. You can use one of the prepackaged applications that are provided by the service.
{: shortdesc}


## Accessing public IBM images
{: #curated-access}

You can access the public IBM images by using the CLI.
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

For more information about working with container images, see the [Registry documentation](/docs/Registry?topic=Registry-getting-started).


## IBM Cloud Data Shield image options
{: #curated-options}

You can use any of the following public images to quickly get up and running with IBM Cloud Data Shield.
{: shortdesc}

* [Barbican](/docs/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](/docs/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


