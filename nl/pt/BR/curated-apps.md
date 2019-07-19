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



# Aplicativos selecionados
{: #curated-apps}

Deseja experimentar o IBM Cloud Data Shield, mas não tem um aplicativo conteinerizado pronto para começar? Sem problema. É possível usar um dos aplicativos pré-empacotados que são fornecidos pelo serviço.
{: shortdesc}


## Acessando imagens públicas da IBM
{: #curated-access}

É possível acessar as imagens públicas da IBM usando a CLI.
{: shortdesc}


1. Efetue login no IBM Cloud:

    ```
    ibmcloud login
    ```
    {: codeblock}

2. Direcione o registro global.

    ```
    ibmcloud cr region-set global
    ```
    {: codeblock}

3. Liste as opções de imagem pública da IBM.

    ```
    ibmcloud cr images --include-ibm
    ```
    {: codeblock}

Para obter mais informações sobre como trabalhar com imagens de contêiner, consulte a [Documentação do registro](/docs/services/Registry?topic=registry-getting-started).


## Opções de imagem do IBM Cloud Data Shield
{: #curated-options}

É possível usar qualquer uma das imagens públicas a seguir para rapidamente estar funcional com o IBM Cloud Data Shield.
{: shortdesc}

* [Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)
* [NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Cofre](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


