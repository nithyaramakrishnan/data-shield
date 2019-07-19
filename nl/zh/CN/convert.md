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

# 转换映像
{: #convert}

您可以使用 {{site.data.keyword.datashield_short}} 容器转换器转换映像以在 EnclaveOS® 环境中运行。转换映像后，可以将其部署到支持 SGX 的 Kubernetes 集群。
{: shortdesc}

您无需更改代码就可以转换应用程序。通过转换，您为应用程序做好在 EnclaveOS 环境中运行的准备。请务必注意，转换流程不会对应用程序加密。只有在运行时（在 SGX Enclave 中启动应用程序后）生成的数据受 IBM Cloud Data Shield 保护。 

转换流程不会对应用程序加密。
{: important}


## 开始之前
{: #convert-before}

转换应用程序之前，您应确保您完全了解以下注意事项。
{: shortdesc}

* 出于安全考虑，私钥必须在运行时提供，而不是将其放置在要转换的容器映像中。应用程序已转换并开始运行后，您可以在提供任何私钥前，通过认证来验证应用程序是否在封套中运行。

* 容器访客必须以容器 root 用户身份运行。

* 测试包含基于 Debian、Ubuntu 和 Java 的容器，相应的结果各不相同。其他环境可能也适用，但是未经过测试。


## 配置注册表凭证
{: #configure-credentials}

通过使用注册表凭证配置 {{site.data.keyword.datashield_short}} 容器转换器，您可以允许转换器的所有用户从已配置的专用注册表获取输入映像，并将输出映像推送到这些注册表中。
如果在 2018 年 10 月 4 日之前使用了 Container Registry，您可能想要[对注册表启用 IAM 访问策略实施](/docs/services/Registry?topic=registry-user#existing_users)。
{: shortdesc}

### 配置 {{site.data.keyword.cloud_notm}} Container Registry 凭证
{: #configure-ibm-registry}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。如果您具有联合标识，请将 `--sso` 选项附加到命令末尾。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. 创建 {{site.data.keyword.datashield_short}} 容器转换器的服务标识和服务标识 API 密钥。

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. 授予服务标识许可权以访问容器注册表。

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. 使用创建的 API 密钥创建 JSON 配置文件。替换 `<api key>` 变量，然后运行以下命令。如果您没有 `openssl`，那么可以使用任何具有相应选项的命令行 base64 编码器。确保在编码字符串的中间或末尾没有新行。

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### 配置其他注册表的凭证
{: #configure-other-registry}

如果您已经有 `~/.docker/config.json` 文件对您要使用的注册表进行认证，那么可以使用该文件。当前不支持 OS X 上的文件。

1. 配置[拉取私钥](/docs/containers?topic=containers-images#other)。

2. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。如果您具有联合标识，请将 `--sso` 选项附加到命令末尾。

  ```
  ibmcloud login
  ```
  {: codeblock}

3. 运行以下命令。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## 转换映像
{: #converting-images}

您可以使用 Enclave Manager API 连接到转换器。
{: shortdesc}

通过 [Enclave Manager UI](/docs/services/data-shield?topic=enclave-manager#em-apps) 构建应用程序时，您还可以转换容器。
{: tip}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。如果您具有联合标识，请将 `--sso` 选项附加到命令末尾。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. 获取并导出 IAM 令牌。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. 转换映像。请确保将变量替换为您的应用程序的信息。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### 转换 Java 应用程序
{: #convert-java}

转换基于 Java 的应用程序时，存在一些额外的需求和限制。使用 Enclave Manager UI 转换 Java 应用程序时，您可以选择 `Java-Mode`。要使用 API 转换 Java 应用程序，请记住以下限制和选项。

**限制**

* Java 应用程序的建议最大封套大小为 4 GB。更大的封套可能也适用，但是可能会使性能降低。
* 建议的堆大小小于封套大小。我们建议通过除去任何 `-Xmx` 选项来降低堆大小。
* 已测试以下 Java 库：
  - MySQL Java Connector
  - Crypto (`JCA`)
  - Messaging (`JMS`)
  - Hibernate (`JPA`)

  如果您使用其他库，那么使用论坛或者单击此页面上的反馈按钮来联系我们的团队。请务必包含联系人信息以及您想要使用的库。


**选项**

要使用 `Java-Mode` 转换，请修改 Docker 文件以提供以下选项。为了进行 Java 转换，您必须根据本部分中对变量的定义来设置所有变量。 


* 将环境变量 MALLOC_ARENA_MAX 设置为 1。

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* 如果使用 `OpenJDK JVM`，请设置以下选项。

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* 如果使用 `OpenJ9 JVM`，请设置以下选项。

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## 请求应用程序证书
{: #request-cert}

已转换的应用程序可以在应用程序启动时从 Enclave Manager 请求证书。这些证书由 Enclave Manager 认证中心进行签名，并包含针对您应用程序的 SGX 封套的 Intel 远程认证报告。
{: shortdesc}

查看以下示例，了解如何配置请求以生成 RSA 专用密钥并生成密钥证书。密钥保留在应用程序容器的根目录上。如果您不需要临时密钥或证书，那么可以为应用程序定制 `keyPath` 和 `certPath`，并将其存储在持久卷上。

1. 将以下模板另存为 `app.json`，并做出所需的更改以符合您应用程序的证书要求。

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. 输入变量并运行以下命令以再次使用您的证书信息来运行转换器。

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## 将应用程序列入白名单
{: #convert-whitelist}

Docker 映像转换为在 Intel® SGX 内部运行时，可以将其列入白名单。通过将映像列入白名单，您将分配管理特权，以允许应用程序在安装了 {{site.data.keyword.datashield_short}} 的集群上运行。
{: shortdesc}


1. 使用 IAM 认证令牌获取 Enclave Manager 访问令牌：

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. 向 Enclave Manager 发出白名单请求。在运行以下命令时，请务必输入您的信息。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. 使用 Enclave Manager GUI 核准或拒绝白名单请求。您可以在 GUI 的**任务**部分中跟踪和管理列入白名单的构建。

