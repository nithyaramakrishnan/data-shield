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

# 管理访问权
{: #access}

您可以控制对 {{site.data.keyword.datashield_full}} Enclave Manager 的访问权。此访问控制与您用于 {{site.data.keyword.cloud_notm}} 的典型 Identity and Access Management (IAM) 角色是分开的。
{: shortdesc}


## 使用 IAM API 密钥登录控制台
{: #access-iam}

在 Enclave Manager 控制台中，您可以查看集群中的节点及其认证状态。您还可以查看集群事件的任务和审计日志。

1. 登录到 IBM Cloud CLI。遵循 CLI 中的提示完成登录。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

  2. 复制以 `export` 开头的输出，并将其粘贴到终端中，以设置 `KUBECONFIG` 环境变量。

3. 通过确认所有 pod 都处于 *running* 状态来检查是否所有服务都在运行。

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

8. 在终端中，获取 IAM 令牌。

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. 复制令牌，并将其粘贴到 Enclave Manager GUI。您无需复制已打印令牌的 `Bearer` 部分。

9. 单击**登录**。


## 设置 Enclave Manager 用户的角色
{: #enclave-roles}

{{site.data.keyword.datashield_short}} 管理在 Enclave Manager 中进行。作为管理员，您会自动分配有 *manager* 角色，但您还可以将角色分配给其他用户。
{: shortdesc}

请记住，这些角色与用于控制对 {{site.data.keyword.cloud_notm}} 服务的访问权的平台 IAM 角色不同。 有关为 {{site.data.keyword.containerlong_notm}} 配置访问权的更多信息，请参阅[分配集群访问权](/docs/containers?topic=containers-users#users)。
{: tip}

请查看下表以了解哪些角色受支持，以及每个用户可以执行的一些示例操作：

<table>
  <tr>
    <th>角色</th>
    <th>操作</th>
    <th>示例</th>
  </tr>
  <tr>
    <td>读者</td>
    <td>可以执行只读操作，例如查看节点、构建、用户信息、应用程序、任务和审计日志。</td>
    <td>下载节点认证证书。</td>
  </tr>
  <tr>
    <td>写入者</td>
    <td>可以执行读者可以执行的操作，以及取消激活和更新节点认证、添加构建、核准或拒绝任何操作或任务等更多操作。</td>
    <td>验证应用程序。</td>
  </tr>
  <tr>
    <td>管理者</td>
    <td>可以执行写入者可以执行的操作，以及更新用户名和角色、向集群添加用户、更新集群设置以及任何其他特权操作等更多操作。</td>
    <td>更新用户角色。</td>
  </tr>
</table>

### 设置用户角色
{: #set-roles}

您可以设置或更新控制台管理器的用户角色。
{: shortdesc}

1. 导航至 [Enclave Manager UI](/docs/services/data-shield?topic=data-shield-access#access-iam)。
2. 从下拉菜单中，打开用户管理屏幕。
3. 选择**设置**。您可以查看用户列表，也可以从此屏幕添加用户。
4. 要编辑用户许可权，请将鼠标悬停在用户上，直到显示“画笔”图标。
5. 单击“画笔”图标以更改其许可权。对用户许可权的任何更改都将立即生效。
