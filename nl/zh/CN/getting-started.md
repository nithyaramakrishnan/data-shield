---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

keywords: data protection, data in use, runtime encryption, runtime memory encryption, encrypted memory, intel sgx, software guard extensions, fortanix runtime encryption

subcollection: data-shield

---

{:new_window: target="_blank"}
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

有关 {{site.data.keyword.datashield_short}} 的更多信息以及保护使用中数据的含义，您可以了解[关于服务](/docs/services/data-shield?topic=data-shield-about#about)的信息。

## 开始之前
{: #gs-begin}

在开始使用 {{site.data.keyword.datashield_short}} 之前，必须满足以下先决条件。有关下载 CLI 和插件或者配置您的 Kubernetes Service 环境的帮助，请查看教程[创建 Kubernetes 集群](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)。

* 以下 CLI：

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  您可能想要将 Helm 配置为使用 `--tls` 方式。有关启用 TLS 的帮助，请查看 [Helm 存储库](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)。如果启用 TLS，请确保将 `--tls` 附加到运行的每个 Helm 命令。
  {: tip}

* 以下 [{{site.data.keyword.cloud_notm}} CLI 插件](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)：

  * Kubernetes Service
  * Container Registry

* 启用 SGX 的 Kubernetes 集群。当前，节点类型为 mb2c.4x32 的裸机集群上可以启用 SGX。如果没有所需的集群，那么可以使用以下步骤来帮助确保创建该集群。
  1. 准备[创建集群](/docs/containers?topic=containers-clusters#cluster_prepare)。

  2. 确保您具有创建集群[所需的许可权](/docs/containers?topic=containers-users#users)。

  3. 创建[集群](/docs/containers?topic=containers-clusters#clusters)。

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 服务实例 V0.5.0 或更高版本。缺省安装使用 <code>cert-manager</code> 来设置 [TLS 证书](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates)以在 {{site.data.keyword.datashield_short}} 服务之间进行内部通信。要使用 Helm 安装实例，可以运行以下命令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## 使用 Helm chart 进行安装
{: #gs-install-chart}

您可以使用提供的 Helm chart 在启用 SGX 的裸机集群上安装 {{site.data.keyword.datashield_short}}。
{: shortdesc}

Helm chart 会安装以下组件：

*	SGX 的支持软件，通过特权容器安装在裸机主机上。
*	{{site.data.keyword.datashield_short}} Enclave Manager，用于管理 {{site.data.keyword.datashield_short}} 环境中的 SGX 封套。
*	EnclaveOS® 容器转换服务，允许容器化应用程序在 {{site.data.keyword.datashield_short}} 环境中运行。

安装 Helm chart 时，有多个选项和参数可用于定制安装。以下教程将引导您完成 chart 的最基本的缺省安装。有关选项的更多信息，请参阅[安装 {{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-deploying)。
{: tip}

要将 {{site.data.keyword.datashield_short}} 安装到集群，请执行以下操作：

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>区域</th>
      <th>IBM Cloud 端点</th>
      <th>Kubernetes Service 区域</th>
    </tr>
    <tr>
      <td>达拉斯</td>
      <td><code>us-south</code></td>
      <td>美国南部</td>
    </tr>
    <tr>
      <td>法兰克福</td>
      <td><code>eu-de</code></td>
      <td>欧洲中部</td>
    </tr>
    <tr>
      <td>悉尼</td>
      <td><code>au-syd</code></td>
      <td>亚太地区南部</td>
    </tr>
    <tr>
      <td>伦敦</td>
      <td><code>eu-gb</code></td>
      <td>英国南部</td>
    </tr>
    <tr>
      <td>东京</td>
      <td><code>jp-tok</code></td>
      <td>亚太地区北部</td>
    </tr>
    <tr>
      <td>华盛顿</td>
      <td><code>us-east</code></td>
      <td>美国东部</td>
    </tr>
  </table>

2. 设置集群的上下文。

  1. 获取命令以设置环境变量并下载 Kubernetes 配置文件。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. 复制以 `export` 开头的输出，并将其粘贴到终端中，以设置 `KUBECONFIG` 环境变量。

3. 如果尚未添加 `ibm` 存储库，请进行添加。

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. 可选：如果您不知道与管理员或管理帐户标识关联的电子邮件，请运行以下命令。

  ```
  ibmcloud account show
  ```
  {: pre}

5. 获取集群的 Ingress 子域。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. 安装 chart。

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  如果您已经为您的转换器[配置 {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert)，您可以添加以下选项：`--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. 要监视组件的启动，可以运行以下命令。

  ```
  kubectl get pods
  ```
  {: pre}


## 后续步骤
{: #gs-next}

太棒了！现在，服务已安装在集群上，您可以在 {{site.data.keyword.datashield_short}} 环境中运行应用程序。 

要在 {{site.data.keyword.datashield_short}} 环境中运行应用程序，您必须对容器映像进行[转换](/docs/services/data-shield?topic=data-shield-convert#convert)，[列入白名单](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist)，然后进行[部署](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers)。

如果您没有自己的映像可部署，请尝试部署其中一个预打包的 {{site.data.keyword.datashield_short}} 映像：

* [{{site.data.keyword.datashield_short}} GitHub 存储库示例](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* {{site.data.keyword.cloud_notm}} Container Registry 中的 MariaDB 或 NGINX
