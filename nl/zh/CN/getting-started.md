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

# 入门教程
{: #getting-started}

通过由 Fortanix® 提供支持的 {{site.data.keyword.datashield_full}}，您可以在使用 {{site.data.keyword.cloud_notm}} 上运行的容器工作负载中的数据时保护该数据。
{: shortdesc}

有关 {{site.data.keyword.datashield_short}} 的更多信息以及保护使用中数据的含义，您可以了解[关于服务](/docs/services/data-shield?topic=data-shield-about)的信息。

## 开始之前
{: #gs-begin}

在开始使用 {{site.data.keyword.datashield_short}} 之前，必须满足以下先决条件。

有关下载 CLI 或配置 {{site.data.keyword.containershort}} 环境的帮助，请查看教程
[创建 Kubernetes 集群](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)。
{: tip}

* 以下 CLI：

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* 以下 [ CLI 插件](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins)：

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}

* 启用 SGX 的 Kubernetes 集群。当前，节点类型为 mb2c.4x32 的裸机集群上可以启用 SGX。如果没有所需的集群，那么可以使用以下步骤来帮助确保创建该集群。
  1. 准备[创建集群](/docs/containers?topic=containers-clusters#cluster_prepare)。

  2. 确保您具有创建集群[所需的许可权](/docs/containers?topic=containers-users)。

  3. 创建[集群](/docs/containers?topic=containers-clusters)。

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} 服务实例 V0.5.0 或更高版本。缺省安装使用 <code>cert-manager</code> 来设置 [TLS 证书](/docs/services/data-shield?topic=data-shield-tls-certificates)以在 {{site.data.keyword.datashield_short}} 服务之间进行内部通信。要使用 Helm 安装实例，可以运行以下命令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

想要查看 Data Shield 的日志记录信息？设置集群的 {{site.data.keyword.la_full_notm}} 实例。
{: tip}

## 安装服务
{: #gs-install}

您可以使用提供的 Helm chart 在启用 SGX 的裸机集群上安装 {{site.data.keyword.datashield_short}}。
{: shortdesc}

Helm chart 会安装以下组件：

*	SGX 的支持软件，通过特权容器安装在裸机主机上。
*	{{site.data.keyword.datashield_short}} Enclave Manager，用于管理 {{site.data.keyword.datashield_short}} 环境中的 SGX 封套。
*	EnclaveOS® 容器转换服务，允许容器化应用程序在 {{site.data.keyword.datashield_short}} 环境中运行。


要将 {{site.data.keyword.datashield_short}} 安装到集群上，请完成以下步骤。

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

  2. 复制以 `export` 开头的输出，并将其粘贴到控制台中，以设置 `KUBECONFIG` 环境变量。

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

6. 通过创建 Tiller 的角色绑定策略来初始化 Helm。 

  1. 创建 Tiller 的服务帐户。
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. 创建角色绑定以在集群中分配 Tiller 管理访问权。

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. 初始化 Helm。

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  您可能想要将 Helm 配置为使用 `--tls` 方式。有关启用 TLS 的帮助，请查看 [Helm 存储库](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}。如果启用 TLS，请确保将 `--tls` 附加到运行的每个 Helm 命令。
  有关将 Helm 和 IBM Cloud Kubernetes Service 搭配使用的更多信息，请参阅[使用 Helm chart 添加服务](/docs/containers?topic=containers-helm#public_helm_install)。
  {: tip}

7. 安装 chart。

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  如果您已经为您的转换器[配置 {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert)，您必须添加 `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`。
  {: note}

7. 要监视组件的启动，可以运行以下命令。

  ```
  kubectl get pods
  ```
  {: codeblock}

## 后续步骤
{: #gs-next}

既然服务已安装在集群上，您可以开始保护您的数据！接下来，您可以尝试[转换](/docs/services/data-shield?topic=data-shield-convert)和[部署](/docs/services/data-shield?topic=data-shield-deploying)应用程序。 

如果您没有自己的映像可部署，请尝试部署其中一个预打包的 {{site.data.keyword.datashield_short}} 映像：

* [ GitHub 存储库示例](https://github.com/fortanix/data-shield-examples/tree/master/ewallet){: external}
* Container Registry：[Barbican 映像](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)、[MariaDB 映像](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)、[NGINX 映像](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)或 [Vault 映像](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)。


