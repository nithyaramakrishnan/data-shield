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

# 疑難排解
{: #troubleshooting}

如果您在使用 {{site.data.keyword.datashield_full}} 時發生問題，請考慮使用這些技術來進行疑難排解及取得協助。
{: shortdesc}

## 取得協助與支援
{: #gettinghelp}

如需協助，您可以在文件中搜尋資訊，或者在討論區提出問題。您也可以開立支援問題單。使用討論區提問時，請標記您的問題，讓 {{site.data.keyword.cloud_notm}} 開發團隊能看到它。
  * 如果您有 {{site.data.keyword.datashield_short}} 的相關技術問題，請將問題張貼在 <a href="https://stackoverflow.com" target="_blank">Stack Overflow<img src="../../icons/launch-glyph.svg" alt="外部鏈結圖示"></a> 上，並使用 “ibm-data-shield” 標記您的問題。
  * 對於服務及開始使用指示的相關問題，請使用 <a href="https://developer.ibm.com/" target="_blank">dW 回答 <img src="../../icons/launch-glyph.svg" alt="外部鏈結圖示"></a> 討論區。請加入 `data-shield` 標籤。

如需取得支援的相關資訊，請參閱[如何取得我需要的支援](/docs/get-support?topic=get-support-getting-customer-support)。


## 取得日誌
{: #ts-logs}

開立 IBM Cloud Data Shield 支援問題單時，提供日誌可以協助加快疑難排解程序。您可以使用下列步驟取得日誌，然後在建立問題時將其複製並貼上到問題中。

1. 登入 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示，完成登入。如果您有聯合 ID，請在指令尾端附加 `--sso` 選項。

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

3. 執行下列指令以取得日誌。

  ```
  kubectl logs --all-containers=true --selector release=$(helm list | grep 'data-shield' | awk {'print $1'}) > logs
  ```
  {: codeblock}


## 我無法登入「區域管理程式使用者介面」
{: #ts-log-in}

{: tsSymptoms}
您嘗試存取「區域管理程式使用者介面」，但您無法登入。

{: tsCauses}
登入可能因下列原因而失敗：

* 您可能使用未獲授權存取「區域管理程式」叢集的電子郵件 ID。
* 您使用的記號可能已過期。

{: tsResolve}
若要解決此問題，請驗證您使用正確的電子郵件 ID。如果是，請驗證電子郵件具有正確的許可權可存取「區域管理程式」。如果您有正確的許可權，則您的存取記號可能已過期。記號有效期為一次 60 分鐘。如果要取得新記號，請執行 `ibmcloud iam oauth-tokens`。如果您具有多個 IBM Cloud 帳戶，請驗證您是否使用了 Enclave Manager 叢集的正確帳戶登入到 CLI。


## 容器轉換器 API 傳回禁止的錯誤
{: #ts-converter-forbidden-error}

{: tsSymptoms}
您嘗試執行容器轉換器，並接收到錯誤：`禁止`。

{: tsCauses}
如果 IAM 或持有人記號遺漏或過期，您可能無法存取轉換器。

{: tsResolve}
若要解決此問題，請確認您使用的是要求標頭中的 IBM IAM OAuth 記號或「區域管理程式」鑑別記號。記號採用下列格式：

* IAM：`Authentication: Basic <IBM IAM Token>`
* 區域管理程式：`Authentication: Bearer <E.M. Token>`

如果您的記號存在，請驗證它仍然有效，然後重新執行要求。


## 容器轉換器無法連接至專用 Docker 登錄
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
您嘗試從專用 Docker 登錄在映像檔上執行容器轉換器，而轉換器無法連接。

{: tsCauses}
您的專用登錄認證可能未正確配置。 

{: tsResolve}
若要解決此問題，您可以遵循下列步驟：

1. 請驗證先前已配置您的專用登錄認證。如果尚未配置，請立即配置。
2. 執行下列指令，以傾出 Docker 登錄認證。必要的話，您可以變更密碼名稱。

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: codeblock}

3. 使用 Base64 解碼器來解碼 `.dockerconfigjson` 的密碼內容，並驗證它是正確的。


## 無法裝載 AESM Socket 或 SGX 裝置
{: #ts-problem-mounting-device}

{: tsSymptoms}
當您嘗試在磁區 `/var/run/aesmd/a/socket` 或 `/dev/isgx` 上裝載 {{site.data.keyword.datashield_short}} 容器時，遇到問題。

{: tsCauses}
由於主機配置發生問題，裝載可能會失敗。

{: tsResolve}
若要解決此問題，請驗證以下兩項：

* `/var/run/aesmd/aesm.socket` 不是主機上的目錄。如果是，請刪除檔案，解除安裝 {{site.data.keyword.datashield_short}} 軟體，然後重新執行安裝步驟。 
* 該主機的 BIOS 中已啟用 SGX。如果未啟用，請聯絡 IBM 支援中心。


## 錯誤：轉換容器
{: #ts-container-convert-fails}

{: tsSymptoms}
嘗試轉換容器時發生下列錯誤。

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: codeblock}

{: tsCauses}
在 macOS 上，如果在 `config.json` 檔案中使用 OS X 金鑰鏈，則容器轉換器會失敗。 

{: tsResolve}
若要解決問題，您可以使用下列步驟：

1. 停用本端系統上的 OS X 金鑰鏈。移至**系統喜好設定 > iCloud**，然後清除**金鑰鏈**的方框。

2. 刪除您建立的密碼。請確保您已登入 IBM Cloud，並且在執行下列指令之前已鎖定您的叢集。

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}

3. 在 `$HOME/.doc_config.json` 檔中，刪除 `"credsStore": "osxkeychain"` 行。

4. 登入您的登錄。

5. 建立密碼。

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

6. 列出您的 Pod，並記下名稱中具有 `enclaveos-converter` 的 Pod。

  ```
kubectl get pods
    ```
  {: codeblock}

7. 刪除該 Pod。

  ```
  kubectl delete pod <pod name>
  ```
  {: codeblock}

8. 轉換映像檔。
