# IBM Cloud Data Shield

藉由使用 IBM Cloud Data Shield、Fortanix® 和 Intel® SGX，您可以在您的資料處於使用中時保護在 IBM Cloud 上執行的容器工作負載中的資料。

## 簡介

當您需要保護資料時，加密是最常用且最有效的方法之一。但是，資料必須在其生命週期的每個步驟都加密，才能確實安全。資料在其生命週期期間會經歷三個階段：靜態資料、動態資料，以及使用中的資料。處於靜態和動態的資料通常用來保護儲存中以及傳輸中的資料。

不過，應用程式開始執行之後，CPU 和記憶體中使用的資料容易遭到攻擊。惡意的內部人員、root 使用者、認證遭洩露、OS 零時差漏洞，以及網路侵入者，所有這些都成為資料的威脅。若要更進一步保護，您現在可以使用加密來保護使用中的資料。 

如需服務的相關資訊，以及保護使用中的資料的意義，請參閱[關於服務](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about)。



## 圖表詳細資料

此 Helm 圖表會將下列元件安裝至已啟用 SGX 的 IBM Cloud Kubernetes 服務叢集：

 * SGX 的支援軟體，由特許容器安裝在裸機主機上。
 * IBM Cloud Data Shield Enclave Manager，可管理 IBM Cloud Data Shield 環境中的 SGX 區域。
 * EnclaveOS® Container Conversion Service，可轉換容器化的應用程式，以便能夠在 IBM Cloud Data Shield 環境中執行。



## 所需資源

* 已啟用 SGX 的 Kubernetes 叢集。目前，SGX 可以在具有下列節點類型的裸機叢集上啟用：mb2c.4x32。如果您還沒有所需要的叢集，可以使用下列步驟來協助確保建立它。
  1. 準備[建立您的叢集](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare)。

  2. 確定您有[必要許可權](https://cloud.ibm.com/docs/containers?topic=containers-users#users)來建立叢集。

  3. 建立[叢集](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters)。

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 服務 0.5.0 版或更新版本的實例。若要使用 Helm 來安裝實例，您可以執行下列指令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## 必要條件

您必須備妥下列必要條件，才能開始使用 IBM Cloud Data Shield。如需下載 CLI 與外掛程式以及配置「Kubernetes 服務」環境的說明，請參閱[建立 Kubernetes 叢集](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)指導教學。

* 下列 CLI：

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  您可能要配置 Helm 以使用 `--tls` 模式。如需啟用 TLS 的協助，請參閱 [Helm 儲存庫](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)。如果您啟用 TLS，請務必對您所執行的每個 Helm 指令附加 `--tls`。
  {: tip}

* 下列 [{{site.data.keyword.cloud_notm}} CLI 外掛程式](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)：

  * Kubernetes 服務
  * Container Registry



## 安裝圖表

安裝 Helm 圖表時，您有數個選項及參數可用來自訂您的安裝。下列指導教學會逐步引導您完成最基本的預設圖表安裝。如需您選項的相關資訊，請參閱 [IBM Cloud Data Shield 文件](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started)。

提示：您的映像檔是否儲存在專用登錄中？您可以使用「EnclaveOS 容器轉換器」將映像檔配置為和 IBM Cloud Data Shield 搭配使用。請務必在部署圖表之前轉換映像檔，以便擁有必要的配置資訊。
如需轉換映像檔的相關資訊，請參閱[文件](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)。


**若要將 IBM Cloud Data Shield 安裝到叢集，請執行下列動作：**

1. 登入 IBM Cloud CLI。遵循 CLI 中的提示，完成登入。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

2. 設定叢集的環境定義。

  1. 取得指令來設定環境變數，並下載 Kubernetes 配置檔。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```

  2. 複製以 `export` 開頭的輸出並貼到您的終端機中，以設定 `KUBECONFIG` 環境變數。

3. 如果您還沒有 `ibm` 儲存庫，請新增它。

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. 選用項目：如果您不知道管理者或管理者帳戶 ID 相關聯的電子郵件，請執行下列指令。

  ```
ibmcloud account show
```

5. 取得叢集的 Ingress 子網域。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. 安裝圖表。

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  附註：如果您的轉換器[已配置 IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)，請新增下列選項：`--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. 若要監視元件啟動，您可以執行下列指令。

  ```
kubectl get pods
    ```

## 在 IBM Cloud Data Shield 環境中執行您的應用程式

若要在 IBM Cloud Data Shield 環境中執行您的應用程式，您必須進行轉換、列入白名單，然後部署容器映像檔。

### 轉換映像檔
{: #converting-images}

您可以使用「區域管理程式 API」來連接至轉換器。
{: shortdesc}

1. 登入 IBM Cloud CLI。遵循 CLI 中的提示，完成登入。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. 取得並匯出 IAM 記號。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. 轉換映像檔。請務必將變數取代為您的應用程式資訊。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### 將應用程式列入白名單
{: #convert-whitelist}

當 Docker 映像檔已轉換並在 Intel SGX 內執行時，可以列入白名單。藉由將映像檔列入白名單，即表示您在指派管理專用權，以容許應用程式在已安裝 IBM Cloud Data Shield 的叢集上執行。
{: shortdesc}

1. 使用下列 curl 要求，取得使用 IAM 鑑別記號的「區域管理程式」存取記號：

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. 對「區域管理程式」進行白名單要求。執行下列指令時，請務必輸入您的資訊。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. 使用「區域管理程式 GUI」來核准或拒絕白名單要求。您可以在 GUI 的**建置**區段中追蹤和管理白名單建置。



### 部署 IBM Cloud Data Shield 容器

轉換映像檔之後，您必須將 IBM Cloud Data Shield 容器重新部署至 Kubernetes 叢集。
{: shortdesc}

將 IBM Cloud Data Shield 容器部署至 Kubernetes 叢集時，容器規格必須包括磁區裝載。磁區可容許在容器中使用 SGX 裝置和 AESM Socket。

1. 將下列 Pod 規格儲存為範本。

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. 將 `your-app-sgx` 和 `your-registry-server` 欄位更新為您的應用程式和伺服器。

3. 建立 Kubernetes Pod。

   ```
   kubectl create -f template.yml
   ```

沒有應用程式可嘗試服務嗎？沒問題。我們提供數個您可以嘗試的範例應用程式，包括 MariaDB 及 NGINX。IBM Container Registry 中的任何 ["datashield" 映像檔](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)都可以作為範例。



## 存取區域管理程式 GUI

您可以使用「區域管理程式 GUI」來查看在 IBM Cloud Data Shield 環境中執行的所有應用程式的概觀。在「區域管理程式」主控台中，您可以檢視叢集中的節點、節點的認證狀態、作業以及叢集事件的審核日誌。您也可以核准和拒絕白名單要求。

若要移至 GUI，請執行下列動作：

1. 登入 IBM Cloud，然後設定叢集的環境定義。

2. 確定所有 Pod 都是在*執行中* 狀態，以確認服務正在執行。

  ```
kubectl get pods
    ```

3. 執行下列指令以查閱「區域管理程式」的前端系統 URL。

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. 取得 Ingress 子網域。

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. 在瀏覽器中，輸入提供使用您的「區域管理程式」的 Ingress 子網域。

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. 在終端機中，取得 IAM 記號。

  ```
ibmcloud iam oauth-tokens
```

7. 複製記號並貼到「區域管理程式 GUI」中。您不需要複製印出記號的 `Bearer` 部分。

8. 按一下**登入**。

如需使用者執行不同動作所需角色的相關資訊，請參閱[設定區域管理程式使用者的角色](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles)。

## 使用預先包裝的防護映像檔

IBM Cloud Data Shield 團隊已經將能夠在 IBM Cloud Data Shield 環境中執行的四個不同的可正式作業的映像檔整合在一起。您可以嘗試下列任何映像檔：

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## 解除安裝和疑難排解

如果您在使用 IBM Cloud Data Shield 時遇到問題，請嘗試瀏覽文件的[疑難排解](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting)或[常見問題](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq)區段。如果您沒有看到您的問題或問題的解決方案，請聯絡 [IBM 支援中心](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support)。

如果您不再需要使用 IBM Cloud Data Shield，您可以[刪除服務以及建立的 TLS 憑證](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall)。

