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

# 分配访问权
{: #access}

您可以控制对 {{site.data.keyword.datashield_full}} Enclave Manager 的访问权。此访问控制类型与您用于 {{site.data.keyword.cloud_notm}} 的典型 Identity and Access Management (IAM) 角色是分开的。
{: shortdesc}


## 分配集群访问权
{: #access-cluster}

登录到 Enclave Manager 之前，您必须访问运行 Enclave Manager 的集群。
{: shortdesc}

1. 登录到托管您想要登录的集群的帐户。

2. 转至**管理 > 访问权 (IAM) > 用户**。

3. 单击**邀请用户**。

4. 提供您想要添加的用户的电子邮件地址。

5. 从**将访问权分配给**下拉列表中，选择**资源**。

6. 从**服务**下拉列表中，选择 **Kubernetes Service**。

7. 选择**区域**、**集群**和**名称空间**。

8. 使用有关[分配集群访问权](/docs/containers?topic=containers-users)的 Kubernetes Service 文档作为指南，分配用户完成任务时需要的访问权。

9. 单击**保存**。

## 设置 Enclave Manager 用户的角色
{: #enclave-roles}

{{site.data.keyword.datashield_short}} 管理在 Enclave Manager 中进行。作为管理员，您会自动分配有 *manager* 角色，但您还可以将角色分配给其他用户。
{: shortdesc}

请查看下表以了解哪些角色受支持，以及每个用户可以执行的一些示例操作：

<table>
  <tr>
    <th>角色</th>
    <th>操作</th>
    <th>示例</th>
  </tr>
  <tr>
    <td>读取者</td>
    <td>可以执行只读操作，例如查看节点、构建、用户信息、应用程序、任务和审计日志。</td>
    <td>下载节点认证证书。</td>
  </tr>
  <tr>
    <td>写入者</td>
    <td>可以执行读取者可以执行的操作以及更多操作，包括取消激活和更新节点认证、添加构建、核准或拒绝任何操作或任务。</td>
    <td>验证应用程序。</td>
  </tr>
  <tr>
    <td>管理者</td>
    <td>可以执行写入者可以执行的操作以及更多操作，包括更新用户名和角色、向集群添加用户、更新集群设置以及任何其他特权操作。</td>
    <td>更新用户角色。</td>
  </tr>
</table>


### 添加用户
{: #set-roles}

通过使用 Enclave Manager GUI，您可以为新用户提供对信息的访问权。
{: shortdesc}

1. 登录到 Enclave Manager。

2. 单击**您的姓名 > 设置**。

3. 单击**添加用户**。

4. 输入用户的电子邮件和姓名。从**角色**下拉菜单中选择角色。

5. 单击**保存**。



### 更新用户
{: #update-roles}

您可以更新分配给用户的角色及其姓名。
{: shortdesc}

1. 登录至 [Enclave Manager UI](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin)。

2. 单击**您的姓名 > 设置**。

3. 将鼠标悬停在您想要编辑其许可权的用户上。此时将显示“画笔”图标。

4. 单击“画笔”图标。此时将打开“编辑用户”屏幕。

5. 从**角色**下拉菜单中，选择您想要分配的角色。

6. 更新用户的姓名。

7. 单击**保存**。对用户许可权的任何更改都将立即生效。


