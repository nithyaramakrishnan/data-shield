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

# 安装
{: #deploying}

您可以使用提供的 Helm chart 或使用提供的安装程序来安装 {{site.data.keyword.datashield_full}}。您可以使用您最熟悉的安装命令。
{: shortdesc}

## 开始之前
{: #begin}

在开始使用 {{site.data.keyword.datashield_short}} 之前，必须满足以下先决条件。有关下载 CLI 和插件或者配置您的 Kubernetes Service 环境的帮助信息，请查看教程[创建 Kubernetes 集群](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)。

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

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 服务实例 V0.5.0 或更高版本。要使用 Helm 安装实例，可以运行以下命令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## 可选：创建 Kubernetes 名称空间
{: #create-namespace}

缺省情况下，{{site.data.keyword.datashield_short}} 将安装到 `kube-system` 名称空间。（可选）您可以通过创建新的名称空间来使用其他名称空间。
{: shortdesc}


1. 登录到 {{site.data.keyword.cloud_notm}} CLI。按照 CLI 中的提示完成登录。

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
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

  2. 复制输出并将其粘贴到终端中。

3. 创建名称空间。

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. 将任何相关私钥从缺省名称空间复制到新名称空间。

  1. 列出您的可用私钥。

    ```
    kubectl get secrets
    ```
    {: pre}

    必须复制以 `bluemix*` 开头的任何私钥。
    {: tip}

  2. 以一次一个的方式复制这些私钥。

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. 验证私钥是否已复制。

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. 创建服务帐户。要查看所有定制选项，请查看 [Helm GitHub 存储库中的 RBAC 页面](https://github.com/helm/helm/blob/master/docs/rbac.md)。

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. 通过遵循 [Tiller SSL GitHub 存储库](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)中的指示信息，生成证书并使用 TLS 启用 Helm。请确保指定已创建的名称空间。

非常好! 现在，您已准备好将 {{site.data.keyword.datashield_short}} 安装到新的名称空间中。从现在开始，请确保将 `--tiller-namespace<namespace_name>` 添加到您运行的任何 Helm 命令。


## 使用 Helm chart 进行安装
{: #install-chart}

您可以使用提供的 Helm chart 在启用 SGX 的裸机集群上安装 {{site.data.keyword.datashield_short}}。
{: shortdesc}

Helm chart 会安装以下组件：

*	SGX 的支持软件，通过特权容器安装在裸机主机上。
*	{{site.data.keyword.datashield_short}} Enclave Manager，用于管理 {{site.data.keyword.datashield_short}} 环境中的 SGX 封套。
*	EnclaveOS® 容器转换服务，允许容器化应用程序在 {{site.data.keyword.datashield_short}} 环境中运行。


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

  如果您已经为您的转换器[配置 {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert)，您必须添加 `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`。
  {: note}

7. 要监视组件的启动，可以运行以下命令。

  ```
  kubectl get pods
  ```
  {: pre}



## 使用 {{site.data.keyword.datashield_short}} 安装程序进行安装
{: #installer}

您可以使用安装程序在启用 SGX 的裸机集群上快速安装 {{site.data.keyword.datashield_short}}。
{: shortdesc}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 设置集群的上下文。

  1. 获取命令以设置环境变量并下载 Kubernetes 配置文件。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. 复制输出并将其粘贴到终端中。

3. 登录到 Container Registry CLI。

  ```
  ibmcloud cr login
  ```
  {: pre}

4. 将映像拉出到本地计算机。

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: pre}

5. 通过运行以下命令来安装 {{site.data.keyword.datashield_short}}。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  要安装最新版本的 {{site.data.keyword.datashield_short}}，请对 `--version` 标志使用 `latest` 。


## 更新服务
{: #update}

在集群上安装 {{site.data.keyword.datashield_short}} 时，可以随时更新。

要使用 Helm chart 更新到最新版本，请运行以下命令。

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: pre}


要使用安装程序更新到最新版本，请运行以下命令：

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  要安装最新版本的 {{site.data.keyword.datashield_short}}，请对 `--version` 标志使用 `latest` 。

