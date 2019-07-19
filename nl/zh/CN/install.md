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

# 安装
{: #install}

您可以使用提供的 Helm chart 或使用提供的安装程序来安装 {{site.data.keyword.datashield_full}}。您可以使用您最熟悉的安装命令。
{: shortdesc}

## 开始之前
{: #begin}

在开始使用 {{site.data.keyword.datashield_short}} 之前，必须满足以下先决条件。有关下载 CLI 和插件或者配置您的 Kubernetes Service 环境的帮助信息，请查看教程[创建 Kubernetes 集群](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)。

* 以下 CLI：

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* 以下 [{{site.data.keyword.cloud_notm}} CLI 插件](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)：

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* 启用 SGX 的 Kubernetes 集群。当前，节点类型为 mb2c.4x32 的裸机集群上可以启用 SGX。如果没有所需的集群，那么可以使用以下步骤来帮助确保创建该集群。
  1. 准备[创建集群](/docs/containers?topic=containers-clusters#cluster_prepare)。

  2. 确保您具有创建集群[所需的许可权](/docs/containers?topic=containers-users)。

  3. 创建[集群](/docs/containers?topic=containers-clusters)。

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} 服务实例 V0.5.0 或更高版本。要使用 Helm 安装实例，可以运行以下命令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

想要查看 Data Shield 的日志记录信息？设置集群的 {{site.data.keyword.la_full_notm}} 实例。
{: tip}


## 使用 Helm 安装
{: #install-chart}

您可以使用提供的 Helm chart 在启用 SGX 的裸机集群上安装 {{site.data.keyword.datashield_short}}。
{: shortdesc}

Helm chart 会安装以下组件：

*	SGX 的支持软件，通过特权容器安装在裸机主机上。
*	{{site.data.keyword.datashield_short}} Enclave Manager，用于管理 {{site.data.keyword.datashield_short}} 环境中的 SGX 封套。
*	EnclaveOS® 容器转换服务，允许容器化应用程序在 {{site.data.keyword.datashield_short}} 环境中运行。


要将 {{site.data.keyword.datashield_short}} 安装到集群，请执行以下操作：

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

  2. 复制以 `export` 开头的输出，并将其粘贴到终端中，以设置 `KUBECONFIG` 环境变量。

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

6. 获取您在设置[备份和复原](/docs/services/data-shield?topic=data-shield-backup-restore)功能时所需的信息。 

7. 通过创建 Tiller 的角色绑定策略来初始化 Helm。 

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

8. 安装 chart。

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  如果您已经为您的转换器[配置 {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert)，您必须添加 `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`。
  {: note}

9. 要监视组件的启动，可以运行以下命令。

  ```
  kubectl get pods
  ```
  {: codeblock}



## 使用安装程序进行安装
{: #installer}

您可以使用安装程序在启用 SGX 的裸机集群上快速安装 {{site.data.keyword.datashield_short}}。
{: shortdesc}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. 设置集群的上下文。

  1. 获取命令以设置环境变量并下载 Kubernetes 配置文件。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. 复制输出并将其粘贴到控制台中。

3. 登录到 Container Registry CLI。

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. 将映像拉出到本地系统。

  ```
  docker pull <region>.icr.io/ibm/datashield-installer
  ```
  {: codeblock}

5. 通过运行以下命令来安装 {{site.data.keyword.datashield_short}}。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  要安装最新版本的 {{site.data.keyword.datashield_short}}，请对 `--version` 标志使用 `latest` 。

