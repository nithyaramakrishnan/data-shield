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

# 更新
{: #update}

在集群上安装 {{site.data.keyword.datashield_short}} 之后，可以随时更新。
{: shortdesc}

## 设置集群上下文
{: #update-context}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。如果您具有联合标识，请将 `--sso` 选项附加到命令末尾。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. 设置集群的上下文。

  1. 获取命令以设置环境变量并下载 Kubernetes 配置文件。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. 复制输出并将其粘贴到控制台中。

3. 如果尚未添加 `iks-charts` 存储库，请进行添加。

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. 可选：如果您不知道与管理员或管理帐户标识关联的电子邮件，请运行以下命令。

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. 获取集群的 Ingress 子域。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

## 对 Helm 进行更新
{: #update-helm}

要更新到 Helm chart 的最新版本，请运行以下命令。

  ```
  helm upgrade <chart-name> ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

## 对安装程序进行更新
{: #update-installer}

要更新到安装程序的最新版本，请运行以下命令。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer upgrade [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ] [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  要安装最新版本的 {{site.data.keyword.datashield_short}}，请对 `--version` 标志使用 `latest` 。


