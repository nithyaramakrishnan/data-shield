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

# 轉換映像檔
{: #convert}

您可以使用 {{site.data.keyword.datashield_short}} Container Converter，將映像檔轉換為可在 EnclaveOS® 環境中執行。轉換映像檔之後，您可以部署至具有 SGX 功能的 KPbernetes 叢集。
{: shortdesc}


## 配置登錄認證
{: #configure-credentials}

您可以使用登錄認證來配置轉換器，讓轉換器的所有使用者都可以從配置的專用登錄取得輸入映像檔，以及向其推送輸出映像檔。
{: shortdesc}

### 配置您的 {{site.data.keyword.cloud_notm}} Container Registry 認證
{: #configure-ibm-registry}

1. 登入 {{site.data.keyword.cloud_notm}} CLI。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>地區 (Region)</th>
      <th>IBM Cloud 端點</th>
      <th>Kubernetes 服務區域</th>
    </tr>
    <tr>
      <td>達拉斯</td>
      <td><code>us-south</code></td>
      <td>美國南部</td>
    </tr>
    <tr>
      <td>法蘭克福</td>
      <td><code>eu-de</code></td>
      <td>歐盟中部</td>
    </tr>
    <tr>
      <td>雪梨</td>
      <td><code>au-syd</code></td>
      <td>亞太地區南部</td>
    </tr>
    <tr>
      <td>倫敦</td>
      <td><code>eu-gb</code></td>
      <td>英國南部</td>
    </tr>
    <tr>
      <td>東京</td>
      <td><code>jp-tok</code></td>
      <td>亞太地區北部</td>
    </tr>
    <tr>
      <td>華盛頓特區</td>
      <td><code>us-east</code></td>
      <td>美國東部</td>
    </tr>
  </table>

2. 取得 {{site.data.keyword.cloud_notm}} Container Registry 的鑑別記號。

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. 使用您建立的記號來建立 JSON 配置檔。請取代 `<token>` 變數，然後執行下列指令。如果沒有 `openssl`，您可以使用任何指令行 Base64 編碼器並搭配適當的選項。請確定已編碼字串的中間或結尾沒有換行。

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### 配置另一個登錄的認證
{: #configure-other-registry}

如果您已經有 `~/.docker/config.json` 檔並可對您要使用的登錄進行鑑別，則可以使用該檔案。

1. 登入 {{site.data.keyword.cloud_notm}} CLI。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 執行下列指令。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## 轉換映像檔
{: #converting-images}

您可以使用「區域管理程式 API」來連接至轉換器。
{: shortdesc}

1. 登入 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示，完成登入。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 取得並匯出 IAM 記號。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. 轉換映像檔。請務必將變數取代為您的應用程式資訊。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## 要求應用程式憑證
{: #request-cert}

當您的應用程式啟動時，已轉換的應用程式可以向「區域管理程式」要求憑證。憑證是由「區域管理程式憑證管理中心」簽署，並包含您的應用程式的 SGX 區域的 Intel 的遠端認證報告。
{: shortdesc}

參閱下列範例，以查看如何配置要求來產生 RSA 私密金鑰並產生金鑰的憑證。金鑰保存在應用程式容器的根目錄上。如果您不想要暫時金鑰/憑證，您可以自訂應用程式的 `keyPath` 和 `certPath`，並將它們儲存在持續性磁區上。

1. 將下列範本儲存為 `app.json`，並進行必要變更以符合應用程式憑證需求。

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

2. 輸入變數，並執行下列指令，以您的憑證資訊重新執行轉換器。

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: pre}


## 將應用程式列入白名單
{: #convert-whitelist}

當 Docker 映像檔轉換成在 Intel® SGX 內執行時，即可以列入白名單。藉由將映像檔列入白名單，即表示您在指派管理專用權，以容許在安裝 {{site.data.keyword.datashield_short}} 的叢集上執行應用程式。
{: shortdesc}

1. 使用下列 curl 要求，取得使用 IAM 鑑別記號的「區域管理程式」存取記號：

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. 對「區域管理程式」進行白名單要求。執行下列指令時，請務必輸入您的資訊。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. 使用「區域管理程式 GUI」來核准或拒絕白名單要求。您可以在 GUI 的**建置**區段中追蹤和管理白名單建置。
