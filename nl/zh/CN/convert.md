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

# 转换映像
{: #convert}

您可以使用 {{site.data.keyword.datashield_short}} 容器转换器转换映像以在 EnclaveOS® 环境中运行。转换映像后，可以部署到支持 SGX 的 Kubernetes 集群。
{: shortdesc}


## 配置注册表凭证
{: #configure-credentials}

通过使用注册表凭证配置转换器，您可以允许转换器的所有用户从已配置的专用注册表获取输入映像，以及将输出映像推送到这些注册表中。
{: shortdesc}

### 配置 {{site.data.keyword.cloud_notm}} Container Registry 凭证
{: #configure-ibm-registry}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。

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

2. 获取 {{site.data.keyword.cloud_notm}} Container Registry 的认证令牌。

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. 使用创建的令牌创建 JSON 配置文件。替换 `<token>` 变量，然后运行以下命令。如果您没有 `openssl`，那么可以使用任何具有相应选项的命令行 base64 编码器。确保在编码字符串的中间或末尾没有新行。

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### 配置其他注册表的凭证
{: #configure-other-registry}

如果您已经有 `~/.docker/config.json` 文件对您要使用的注册表进行认证，那么可以使用该文件。

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 运行以下命令。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## 转换映像
{: #converting-images}

您可以使用 Enclave Manager API 连接到转换器。
{: shortdesc}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 获取并导出 IAM 令牌。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. 转换映像。请确保将变量替换为您的应用程序的信息。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## 请求应用程序证书
{: #request-cert}

已转换的应用程序可以在应用程序启动时从 Enclave Manager 请求证书。这些证书由 Enclave Manager 认证中心进行签名，并包含针对您应用程序的 SGX 封套的 Intel 远程认证报告。
{: shortdesc}

查看以下示例，了解如何配置请求以生成 RSA 专用密钥并生成密钥证书。密钥保留在应用程序容器的根目录上。如果您不需要临时密钥/证书，那么可以为应用程序定制 `keyPath` 和 `certPath`，并将其存储在持久卷上。

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
 {: pre}


## 将应用程序列入白名单
{: #convert-whitelist}

Docker 映像转换为在 Intel® SGX 内部运行时，可以将其列入白名单。通过将映像列入白名单，您将分配管理特权，以允许应用程序在安装了 {{site.data.keyword.datashield_short}} 的集群上运行。
{: shortdesc}

1. 通过以下 curl 请求，使用 IAM 认证令牌获取 Enclave Manager 访问令牌：

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. 向 Enclave Manager 发出白名单请求。在运行以下命令时，请务必输入您的信息。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. 使用 Enclave Manager GUI 核准或拒绝白名单请求。您可以在 GUI 的**构建**部分中跟踪和管理列入白名单的构建。
