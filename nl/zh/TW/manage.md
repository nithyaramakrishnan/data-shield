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

您可以使用 Enclave Manager 使用者介面管理使用 {{site.data.keyword.datashield_full}} 保護的應用程式。從使用者介面，您可以管理應用程式部署，指派存取權，處理白名單要求以及轉換應用程式。
{: shortdesc}


## 登入
{: #em-signin}

在「區域管理程式」主控台中，您可以檢視叢集中的節點及其認證狀態。您也可以檢視叢集事件的作業和審核日誌。首先，請登錄。
{: shortdesc}

1. 請確保您具有[正確的存取權](/docs/services/data-shield?topic=data-shield-access)。

1. 登入 {{site.data.keyword.cloud_notm}} CLI。
    遵循 CLI 中的提示，完成登入。如果您有聯合 ID，請在指令尾端附加 `--sso` 選項。

  ```
  ibmcloud login
  ```
  {: codeblock}

2. 設定叢集的環境定義。

  1. 取得指令來設定環境變數，並下載 Kubernetes 配置檔。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. 複製以 `export` 開頭的輸出並貼到您的終端機中，以設定 `KUBECONFIG` 環境變數。

3. 確認所有 Pod 都是在*作用中* 狀態，來確定您的所有服務都是正在執行。

  ```
  kubectl get pods
  ```
  {: codeblock}

4. 執行下列指令以查閱「區域管理程式」的前端系統 URL。

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. 取得 Ingress 子網域。

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. 在瀏覽器中，輸入提供使用您的「區域管理程式」的 Ingress 子網域。

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

7. 在終端機中，取得 IAM 記號。

  ```
ibmcloud iam oauth-tokens
```
  {: codeblock}

8. 複製記號並貼到「區域管理程式 GUI」中。您不需要複製印出記號的 `Bearer` 部分。

9. 按一下**登入**。






## 管理節點
{: #em-nodes}

您可以使用 Enclave Manager 使用者介面來監視狀態，停用叢集裡執行 IBM Cloud Data Shield 的節點，或下載這些節點的憑證。
{: shortdesc}


1. 登入 Enclave Manager。

2. 導覽至**節點**標籤。

3. 按一下您想要調查的節點的 IP 位址。此時將開啟資訊畫面。

4. 在資訊畫面上，您可以選擇停用節點或者下載所使用的憑證。




## 部署應用程式
{: #em-apps}

您可以使用 Enclave Manager 使用者介面部署應用程式。
{: shortdesc}


### 新增應用程式
{: #em-app-add}

使用 Enclave Manager UI，您可以同時轉換、部署應用程式並將應用程式列入白名單。
{: shortdesc}

1. 登入 Enclave Manager 並導覽至**應用程式**標籤。

2. 按一下**新增新應用程式**。

3. 為應用程式指定名稱和說明。

4. 輸入映像檔的輸入和輸出名稱。輸入是現行的應用程式名稱。輸出是可在其中尋找轉換的應用程式的位置。

5. 輸入 **ISVPRDID** 和 **ISVSVN**。

6. 輸入任何容許的網域。

7. 編輯您可能想要變更的任何進階設定。

8. 按一下**建立新的應用程式**。應用程式將部署並新增到白名單。您可以在**作業**標籤中核准建置要求。




### 編輯應用程式
{: #em-app-edit}

將應用程式新增到清單後，您可以編輯應用程式。
{: shortdesc}


1. 登入 Enclave Manager 並導覽至**應用程式**標籤。

2. 按一下您想要編輯的應用程式的名稱。此時將開啟新畫面，您可以在其中檢閱配置，包括憑證和已部署的建置。

3. 按一下**編輯應用程式**。

4. 更新您想要進行的配置。在進行任何變更前，請務必瞭解變更進階設定將如何影響您的應用程式。

5. 按一下**編輯應用程式**。


## 建置應用程式
{: #em-builds}

進行更改之後，您可以使用 Enclave Manager 使用者介面重建應用程式。
{: shortdesc}

1. 登入到 Enclave Manager，並導覽至**建置**標籤。

2. 按一下**建立新的建置**。

3. 從下拉清單中選取應用程式，或者新增應用程式。

4. 輸入 Docker 映像檔的名稱，並進行具體的標籤。 

5. 按一下**建置**。建置將新增到白名單。您可以在**作業**標籤中核准建置。



## 核准作業
{: #em-tasks}

應用程式白名單時，將新增到 Enclave Manager 使用者介面的**作業**標籤中的擱置中的要求清單中。您可以使用使用者介面核准或拒絕請求。
{: shortdesc}

1. 登入到 Enclave Manager，並導覽至**作業**標籤。

2. 按一下包含了您想要核准或拒絕的要求的行。此時將開啟顯示相關資訊的畫面。

3. 檢查要求，按一下**核准**或**拒絕**。您的姓名將新增到**檢閱者**清單中。


## 檢視日誌
{: #em-view}

您可以針對幾個不同類型的活動審核 Enclave Manager 實例。
{: shortdesc}

1. 導覽至 Enclave Manager 使用者介面的**審核日誌**標籤。
2. 過濾記載結果以縮短您的搜尋。您可以選擇按時間範圍或按下列任何類型進行過濾。

  * 應用程式狀態：與應用程式相關的活動，例如白名單要求和新建置。
  * 使用者核准：與使用者存取權相關的活動，例如核准或拒絕使用帳戶。
  * 節點認證：與節點認證相關的活動。
  * 憑證管理中心：與憑證管理中心相關的活動。
  * 管理：與管理相關的活動。 

如果您想要保存日誌的記錄超過 1 個月，可以將資訊匯出為 `.csv` 檔案。

