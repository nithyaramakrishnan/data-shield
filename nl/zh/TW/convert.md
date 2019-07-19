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

# 轉換映像檔
{: #convert}

您可以使用 {{site.data.keyword.datashield_short}} Container Converter，將映像檔轉換為可在 EnclaveOS® 環境中執行。轉換映像檔之後，您可以將它們部署至具有 SGX 功能的 KPbernetes 叢集。
{: shortdesc}

您無需變更代碼就可以轉換應用程式。藉由執行轉換，您為應用程式做好在 EnclaveOS 環境中執行的準備。請務必注意，轉換流程不會對應用程式加密。只有在執行時期（在 SGX Enclave 中啟動應用程式後）產生的資料受 IBM Cloud Data Shield 受保護的。 

轉換程序不會將應用程式加密。
{: important}


## 在開始之前
{: #convert-before}

轉換應用程式之前，您應確保您完全瞭解下列注意事項。
{: shortdesc}

* 由於安全的因素，密碼必須在執行時期提供，而不是將其放在要轉換的容器映像檔中。應用程式已轉換並開始執行後，您可以在提供任何密碼前，透過認證來驗證應用程式是否在封套中執行。

* 容器訪客必須以容器 root 使用者身分執行。

* 測試包含以 Debian、Ubuntu 和 Java 為基礎的容器，相應的結果各不相同。其他環境可能也適用，但是未經過測試。


## 配置登錄認證
{: #configure-credentials}

您可以使用登錄認證來配置 {{site.data.keyword.datashield_short}} 容器轉換器，讓轉換器的所有使用者都可以從配置的專用登錄取得輸入映像檔，以及將輸出映像檔推送到這些登錄中。如果在 2018 年 10 月 4 日之前使用了 Container Registry，您可能想要[對登錄啟用 IAM 存取原則實施](/docs/services/Registry?topic=registry-user#existing_users)。
{: shortdesc}

### 配置您的 {{site.data.keyword.cloud_notm}} Container Registry 認證
{: #configure-ibm-registry}

1. 登入 {{site.data.keyword.cloud_notm}} CLI。
    遵循 CLI 中的提示，完成登入。如果您有聯合 ID，請在指令尾端附加 `--sso` 選項。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. 建立 {{site.data.keyword.datashield_short}} 容器轉換器的服務 ID 和服務 ID API 金鑰。

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. 授權服務 ID 許可權以存取容器登錄。

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. 使用建立的 API 金鑰建立 JSON 配置檔。請取代 `<api key>` 變數，然後執行下列指令。如果沒有 `openssl`，您可以使用任何指令行 Base64 編碼器並搭配適當的選項。確保在編碼字串的中間或末尾沒有新行。

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### 配置另一個登錄的認證
{: #configure-other-registry}

如果您已經有 `~/.docker/config.json` 檔並可對您要使用的登錄進行鑑別，則可以使用該檔案。現行不支援 OS X 上的檔案。

1. 配置[取回密碼](/docs/containers?topic=containers-images#other)。

2. 登入 {{site.data.keyword.cloud_notm}} CLI。
    遵循 CLI 中的提示，完成登入。如果您有聯合 ID，請在指令尾端附加 `--sso` 選項。

  ```
  ibmcloud login
  ```
  {: codeblock}

3. 執行下列指令。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## 轉換映像檔
{: #converting-images}

您可以使用「區域管理程式 API」來連接至轉換器。
{: shortdesc}

您也可以在透過 [Enclave Manager 使用者介面](/docs/services/data-shield?topic=enclave-manager#em-apps)建置應用程式時轉換容器。
{: tip}

1. 登入 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示，完成登入。如果您有聯合 ID，請在指令尾端附加 `--sso` 選項。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. 取得並匯出 IAM 記號。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. 轉換映像檔。請務必將變數取代為您的應用程式資訊。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### 轉換 Java 應用程式
{: #convert-java}

轉換 Java 型應用程式時，存在一些額外的需求和限制。使用 Enclave Manager 使用者介面轉換 Java 應用程式時，您可以選取 `Java-Mode`。若要使用 API 轉換 Java 應用程式，請記住下列限制和選項。

**限制**

* Java 應用程式的建議上限區域大小為 4 GB。更大的區域可能也適用，但是可能會使效能降低。
* 建議的資料堆大小小於區域大小。我們建議移除任何 `-Xmx` 選項來降低資料堆大小。
* 已測試下列 Java 庫：
  - MySQL Java Connector
  - Crypto (`JCA`)
  - Messaging (`JMS`)
  - Hibernate (`JPA`)

  如果您使用其他程式庫，請使用討論區或者按一下此頁面上的意見按鈕來聯絡我們的團隊。請務必包含聯絡資訊以及您想要使用的程式庫。


**選項**

若要使用 `Java-Mode` 轉換，請修改 Docker 檔案以提供下列選項。為了進行 Java 轉換，您必須根據本區段中對變數的定義來設定所有變數。 


* 將環境變數 MALLOC_ARENA_MAX 設定為 1。

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* 如果使用 `OpenJDK JVM`，請設定下列選項。

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* 如果使用 `OpenJ9 JVM`，請設定下列選項。

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## 要求應用程式憑證
{: #request-cert}

當您的應用程式啟動時，已轉換的應用程式可以向「區域管理程式」要求憑證。憑證是由「區域管理程式憑證管理中心」簽署，並包含您的應用程式的 SGX 區域的 Intel 的遠端認證報告。
{: shortdesc}

參閱下列範例，以查看如何配置要求來產生 RSA 私密金鑰並產生金鑰的憑證。金鑰保存在應用程式容器的根目錄上。如果您不想要暫時金鑰或憑證，您可以自訂應用程式的 `keyPath` 和 `certPath`，並將它們儲存在持續性磁區上。

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

2. 輸入變數並執行下列指令以再次使用您的憑證資訊來執行轉換器。

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## 將應用程式列入白名單
{: #convert-whitelist}

當 Docker 映像檔轉換成在 Intel® SGX 內執行時，即可以列入白名單。藉由將映像檔列入白名單，即表示您在指派管理專用權，以容許在安裝 {{site.data.keyword.datashield_short}} 的叢集上執行應用程式。
{: shortdesc}


1. 使用 IAM 鑑別記號取得 Enclave Manager 存取記號：

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. 對「區域管理程式」進行白名單要求。執行下列指令時，請務必輸入您的資訊。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. 使用「區域管理程式 GUI」來核准或拒絕白名單要求。您可以在 GUI 的**作業**區段中追蹤和管理白名單的建置。

