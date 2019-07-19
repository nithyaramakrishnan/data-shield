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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# 故障诊断

{: #troubleshooting}

在使用 {{site.data.keyword.datashield_full}} 时，如果遇到问题，可以考虑使用下列方法进行故障诊断和获取帮助。
{: shortdesc}

## 获取帮助与支持
{: #gettinghelp}

要获取帮助，您可以在文档中搜索信息，或者通过论坛提问。您还可以开具支持凭单。使用论坛提问时，请标记您的问题，以使其可由 {{site.data.keyword.cloud_notm}} 开发团队看到。
  * 如果您对 {{site.data.keyword.datashield_short}} 存在技术问题，请在 <a href="https://stackoverflow.com" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="外部链接图标"></a> 上发布您的问题，并使用“ibm-data-shield”标记您的问题。
  * 有关服务和入门指示信息的问题，请使用 <a href="https://developer.ibm.com/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="外部链接图标"></a> 论坛。包含 `data-shield` 标记。

有关获取支持的更多信息，请参阅[如何获得所需的支持](/docs/get-support?topic=get-support-getting-customer-support)。


## 获取日志
{: #ts-logs}

开具 IBM Cloud Data Shield 支持凭单时，提供日志可以帮助加快故障诊断过程。您可以使用以下步骤获取日志，然后在创建问题时将其复制并粘贴到问题中。

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

3. 运行以下命令以获取日志。

  ```
  kubectl logs --all-containers=true --selector release=$(helm list | grep 'data-shield' | awk {'print $1'}) > logs
  ```
  {: codeblock}


## 我无法登录到 Enclave Manager UI
{: #ts-log-in}

{: tsSymptoms}
您尝试访问 Enclave Manager UI，但您无法登录。

{: tsCauses}
登录可能由于以下原因而失败：

* 您可能使用的是无权访问 Enclave Manager UI 集群的电子邮件标识。
* 您使用的令牌可能已到期。

{: tsResolve}
要解决此问题，请验证您是否使用了正确的电子邮件标识。如果是，请验证电子邮件是否具有访问 Enclave Manager 的正确许可权。如果您具有正确的许可权，那么您的访问令牌可能已到期。令牌的有效期每次为 60 分钟。要获取新令牌，请运行 `ibmcloud iam oauth-tokens`。如果您具有多个 IBM Cloud 帐户，请验证您是否使用了 Enclave Manager 集群的正确帐户登录到 CLI。


## 容器转换器 API 返回已禁止错误
{: #ts-converter-forbidden-error}

{: tsSymptoms}
您尝试运行容器转换器，并收到错误：`已禁止`。

{: tsCauses}
如果 IAM 令牌或不记名令牌丢失或到期，那么您可能无法访问该转换器。

{: tsResolve}
要解决此问题，请验证您在请求头中使用的是 IBM IAM OAuth 令牌还是 Enclave Manager 认证令牌。令牌采用以下格式：

* IAM：`Authentication: Basic <IBM IAM Token>`
* Enclave Manager：`Authentication: Bearer <E.M. Token>`

如果令牌存在，请验证它是否仍然有效，然后再次运行请求。


## 容器转换器无法连接到专用 Docker 注册表
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
您尝试在映像上从专用 Docker 注册表运行容器转换器，并且转换器无法连接。

{: tsCauses}
您的专用注册表凭证可能未正确配置。 

{: tsResolve}
要解决此问题，您可以执行以下步骤:

1. 验证您的专用注册表凭证先前是否已配置。如果未配置，请立即配置。
2. 运行以下命令以转储 Docker 注册表凭证。如果需要，可以更改私钥名称。

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: codeblock}

3. 使用 Base64 解码器来解码 `.dockerconfigjson` 的私钥内容，并验证它是否正确。


## 无法安装 AESM-socket 或 SGX 设备
{: #ts-problem-mounting-device}

{: tsSymptoms}
尝试在卷 `/var/run/aesmd/aesm.socket` 或 `/dev/isgx` 上安装 {{site.data.keyword.datashield_short}} 容器时遇到问题。

{: tsCauses}
由于主机配置问题，安装可能失败。

{: tsResolve}
要解决此问题，请验证以下两项：

* `/var/run/aesmd/aesm.socket` 是否不是主机上的目录。如果是，请删除该文件，卸载 {{site.data.keyword.datashield_short}} 软件，然后再次执行安装步骤。 
* 在主机的 BIOS 中是否启用了 SGX。如果未启用，请联系 IBM 支持人员。


## 错误：转换容器
{: #ts-container-convert-fails}

{: tsSymptoms}
尝试转换容器时，遇到以下错误。

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: codeblock}

{: tsCauses}
在 macOS 上，如果在 `config.json` 文件中使用 OS X 钥匙串，那么容器转换器会失败。 

{: tsResolve}
要解决此问题，您可以使用以下步骤：

1. 禁用本地系统上的 OS X 钥匙串。转至**系统偏好设置 > iCloud**，然后清除**钥匙串**的框。

2. 删除已创建的私钥。请确保您已登录到 IBM Cloud，并且在运行以下命令之前已锁定您的集群。

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}

3. 在 `$HOME/.docker/config.json` 文件中，删除行 `"credsStore": "osxkeychain"`。

4. 登录到注册表。

5. 创建私钥。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

6. 列出您的 pod，并记录名称中带有 `cludveos-converter` 的 pod。

  ```
  kubectl get pods
  ```
  {: codeblock}

7. 删除 pod。

  ```
  kubectl delete pod <pod name>
  ```
  {: codeblock}

8. 转换映像。
