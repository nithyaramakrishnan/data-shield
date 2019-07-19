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

# 使用 Enclave Manager
{: #enclave-manager}

您可以使用 Enclave Manager UI 管理使用 {{site.data.keyword.datashield_full}} 保护的应用程序。从 UI，您可以管理应用程序部署，分配访问权，处理白名单请求以及转换应用程序。
{: shortdesc}


## 登录
{: #em-signin}

在 Enclave Manager 控制台中，您可以查看集群中的节点及其认证状态。您还可以查看集群事件的任务和审计日志。首先，请登录。
{: shortdesc}

1. 请确保您具有[正确的访问权](/docs/services/data-shield?topic=data-shield-access)。

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

3. 通过确认所有 pod 都处于*活动*状态来确保您的全体服务都在运行。

  ```
  kubectl get pods
  ```
  {: codeblock}

4. 通过运行以下命令，查找 Enclave Manager 的前端 URL。

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. 获取 Ingress 子域。

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. 在浏览器中，输入您的 Enclave Manager 在其中可用的 Ingress 子域。

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

7. 在终端中，获取 IAM 令牌。

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. 复制令牌，并将其粘贴到 Enclave Manager GUI。您无需复制已打印令牌的 `Bearer` 部分。

9. 单击**登录**。






## 管理节点
{: #em-nodes}

您可以使用 Enclave Manager UI 来监视状态，停用集群中运行 IBM Cloud Data Shield 的节点，或下载这些节点的证书。
{: shortdesc}


1. 登录到 Enclave Manager。

2. 导航至**节点**选项卡。

3. 单击您想要调查的节点的 IP 地址。此时将打开信息屏幕。

4. 在信息屏幕上，您可以选择停用节点或者下载所使用的证书。




## 部署应用程序
{: #em-apps}

您可以使用 Enclave Manager UI 部署应用程序。
{: shortdesc}


### 添加应用程序
{: #em-app-add}

使用 Enclave Manager UI，您可以同时转换、部署应用程序并将应用程序列入白名单。
{: shortdesc}

1. 登录到 Enclave Manager，并导航至**应用程序**选项卡。

2. 单击**添加新应用程序**。

3. 为应用程序指定名称和描述。

4. 输入映像的输入和输出名称。输入是当前的应用程序名称。输出是可在其中查找转换的应用程序的位置。

5. 输入 **ISVPRDID** 和 **ISVSVN**。

6. 输入任何允许的域。

7. 编辑您可能想要更改的任何高级设置。

8. 单击**新建应用程序**。应用程序将部署并添加到白名单。您可以在**任务**选项卡中核准构建请求。




### 编辑应用程序
{: #em-app-edit}

将应用程序添加到列表后，您可以编辑应用程序。
{: shortdesc}


1. 登录到 Enclave Manager，并导航至**应用程序**选项卡。

2. 单击您想要编辑的应用程序的名称。此时将打开新屏幕，您可以在其中查看配置，包括证书和已部署的构建。

3. 单击**编辑应用程序**。

4. 更新您想要进行的配置。在进行任何更改前，请务必了解更改高级设置将如何影响您的应用程序。

5. 单击**编辑应用程序**。


## 构建应用程序
{: #em-builds}

进行更改之后，您可以使用 Enclave Manager UI 重新构建应用程序。
{: shortdesc}

1. 登录到 Enclave Manager，并导航至**构建**选项卡。

2. 单击**新建构建**。

3. 从下拉列表中选择应用程序，或者添加应用程序。

4. 输入 Docker 映像的名称，并进行具体的标记。 

5. 单击**构建**。构建将添加到白名单。您可以在**任务**选项卡中核准构建。



## 核准任务
{: #em-tasks}

应用程序列入白名单时，将添加到 Enclave Manager UI 的**任务**选项卡中的暂挂请求列表中。您可以使用 UI 核准或拒绝请求。
{: shortdesc}

1. 登录到 Enclave Manager，并导航至**任务**选项卡。

2. 单击包含了您想要核准或拒绝的请求的行。此时将打开显示更多信息的屏幕。

3. 查看请求，单击**核准**或**拒绝**。您的姓名将添加到**复审者**列表中。


## 查看日志
{: #em-view}

您可以针对几个不同类型的活动审计 Enclave Manager 实例。
{: shortdesc}

1. 导航至 Enclave Manager UI 的**审计日志**选项卡。
2. 过滤日志记录结果以缩小搜索范围。您可以选择按时间范围或按以下任何类型进行过滤。

  * 应用程序状态：与应用程序相关的活动，例如白名单请求和新构建。
  * 用户核准：与用户访问权相关的活动，例如核准或拒绝使用帐户。
  * 节点认证：与节点认证相关的活动。
  * 认证中心：与认证中心相关的活动。
  * 管理：与管理相关的活动。 

如果您想要保存日志的记录超过 1 个月，可以将信息导出为 `.csv` 文件。

