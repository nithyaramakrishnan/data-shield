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

# Atualizar
{: #update}

Depois que o {{site.data.keyword.datashield_short}} estiver instalado em seu cluster, será possível atualizar a qualquer momento.
{: shortdesc}

## Configurando o contexto do cluster
{: #update-context}

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log. Se você tiver um ID federado, anexe a opção `--sso` no final do comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Configure o contexto para seu cluster.

  1. Obtenha o comando para configurar a variável de ambiente e fazer download dos arquivos de configuração do Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copie a saída e cole-a em seu console.

3. Se você ainda não tiver feito isso, inclua o repositório `iks-charts`.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. Opcional: se você não souber o e-mail que está associado ao administrador nem o ID da conta do administrador, execute o comando a seguir.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. Obtenha o subdomínio do Ingress para seu cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

## Atualizando com o Helm
{: #update-helm}

Para atualizar para a versão mais recente com o gráfico do Helm, execute o comando a seguir.

  ```
  helm upgrade <chart-name> ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

## Atualizando com o instalador
{: #update-installer}

Para atualizar para a versão mais recente com o instalador, execute o comando a seguir.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer upgrade [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ] [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  Para instalar a versão mais recente do {{site.data.keyword.datashield_short}}, use `latest` para a sinalização `--version`.


