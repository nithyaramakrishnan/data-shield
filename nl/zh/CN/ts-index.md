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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# 故障诊断

{: #troubleshooting}

在使用 {{site.data.keyword.datashield_full}} 时，如果遇到问题，可以考虑使用下列方法进行故障诊断和获取帮助。
{: shortdesc}

## 获取帮助与支持
{: #gettinghelp}

有关帮助，您可以在文档中搜索信息，或者通过论坛提问。您还可以开具支持凭单。使用论坛提问时，请标记您的问题，以使其可由 {{site.data.keyword.Bluemix_notm}} 开发团队看到。
  * 如果您对 {{site.data.keyword.datashield_short}} 存在技术问题，请在 <a href="https://stackoverflow.com/search?q=ibm-data-shield" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="外部链接图标"></a> 上发布您的问题，并使用“ibm-data-shield”标记您的问题。
  * 有关服务和入门指示信息的问题，请使用 <a href="https://developer.ibm.com/answers/topics/data-shield/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="外部链接图标"></a> 论坛。包含 `data-shield` 标记。

有关获取支持的更多信息，请参阅[如何获得所需的支持](/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support)。


## 我不了解可以与安装程序一起使用的选项
{: #options}

要查看所有命令和更多帮助信息，可以运行以下命令并查看输出。

```
docker run registry.bluemix.net/ibm/datashield-installer help
```
{: pre}

## 我无法登录到 Enclave Manager UI
{: #ts-log-in}

{: tsSymptoms}
您尝试访问 Enclave Manager UI，但您无法登录。

{: tsCauses}
登录可能由于以下原因而失败：

* 您可能使用的是无权访问 Enclave Manager UI 集群的电子邮件标识。
* 您使用的令牌可能已到期。

{: tsResolve}
要解决此问题，请验证您是否使用了正确的电子邮件标识。如果是，请验证电子邮件是否具有访问 Enclave Manager 的正确许可权。如果您具有正确的许可权，那么您的访问令牌可能已到期。令牌的有效期每次为 60 分钟。要获取新令牌，请运行 `ibmcloud iam oauth-tokens`。


## 容器转换器 API 返回已禁止错误
{: #ts-converter-forbidden-error}

{: tsSymptoms}
您尝试运行容器转换器，并收到错误：`已禁止`。

{: tsCauses}
如果 IAM 令牌或不记名令牌丢失或到期，那么您可能无法访问该转换器。

{: tsResolve}
要解决此问题，您应该验证您是否在请求头中使用 IBM IAM OAuth 令牌或 Enclave Manager 认证令牌。令牌采用以下格式：

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
  {: pre}

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


## 转换容器时出错
{: #ts-container-convert-fails}

{: tsSymptoms}
尝试转换容器时，遇到以下错误。

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: pre}

{: tsCauses}
在 MacOS 上，如果在 config.json 文件中使用 OSX 密钥链，那么容器转换器会失败。 

{: tsResolve}
要解决此问题，您可以使用以下步骤：

1. 禁用本地系统上的 OSX 密钥链。转至**系统首选项 > iCloud**，然后取消选中**密钥链**的框。

2. 删除已创建的私钥。请确保您已登录到 IBM Cloud，并且在运行以下命令之前已将您的集群设置为目标。

  ```
  kubectl delete secret converter-docker-config
  ```
  {: pre}

3. 在 `$HOME/.docker/config.json` 文件中，删除行 `"credsStore": "osxkeychain"`。

4. 登录到注册表。

5. 创建新的私钥。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}

6. 列出您的 pod，并记录名称中带有 `cludveos-converter` 的 pod。

  ```
  kubectl get pods
  ```
  {: pre}

7. 删除 pod。

  ```
  kubectl delete pod <pod name>
  ```
  {: pre}

8. 转换映像。
