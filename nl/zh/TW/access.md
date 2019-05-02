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

# 管理存取權
{: #access}

您可以控制 {{site.data.keyword.datashield_full}} Enclave Manager 的存取權。此存取控制權和您使用 {{site.data.keyword.cloud_notm}} 時所使用的典型 Identity and Access Management (IAM) 角色並不相同。
{: shortdesc}


## 使用 IAM API 金鑰登入主控台
{: #access-iam}

在「區域管理程式」主控台中，您可以檢視叢集中的節點及其認證狀態。您也可以檢視叢集事件的作業和審核日誌。

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

3. 確認所有 Pod 都是在*執行中* 狀態，來確定您的所有服務都是正在執行。

  ```
kubectl get pods
    ```
  {: codeblock}

4. 執行下列指令，以查閱「區域管理程式」的前端 URL。

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

8. 在終端機中，取得 IAM 記號。

  ```
ibmcloud iam oauth-tokens
```
  {: codeblock}

7. 複製記號並貼到「區域管理程式 GUI」中。您不需要複製印出記號的 `Bearer` 部分。

9. 按一下**登入**。


## 設定「區域管理程式」使用者的角色
{: #enclave-roles}

{{site.data.keyword.datashield_short}} 管理在「區域管理程式」中進行。您作為管理者，*管理員* 角色會自動指派給您，但您也可以將角色指派給其他使用者。
{: shortdesc}

請記住，這些角色與用來控制 {{site.data.keyword.cloud_notm}} 服務存取權的平台 IAM 角色不同。如需配置 {{site.data.keyword.containerlong_notm}} 的相關資訊，請參閱[指派叢集存取權](/docs/containers?topic=containers-users#users)。
{: tip}

參閱下列表格，以查看哪些是支援的角色，以及每個使用者可以採取的部分範例動作：

<table>
  <tr>
    <th>角色</th>
    <th>動作</th>
    <th>範例</th>
  </tr>
  <tr>
    <td>讀者</td>
    <td>可以執行唯讀動作，例如檢視節點、建置、使用者資訊、應用程式、作業及審核日誌。</td>
    <td>下載節點認證憑證。</td>
  </tr>
  <tr>
    <td>撰寫者</td>
    <td>可以執行「讀者」可以執行的動作以及其他動作，包括停用及更新節點認證、新增建置、核准或拒絕任何動作或作業。</td>
    <td>認證應用程式</td>
  </tr>
  <tr>
    <td>管理員</td>
    <td>可以執行「撰寫者」可以執行的動作以及其他動作，包括更新使用者名稱和角色、將使用者新增至叢集、更新叢集設定，以及任何其他特許動作。</td>
    <td>更新使用者角色</td>
  </tr>
</table>

### 設定使用者角色
{: #set-roles}

您可以設定或更新主控台管理程式的使用者角色。
{: shortdesc}

1. 導覽至[區域管理程式使用者介面](/docs/services/data-shield?topic=data-shield-access#access-iam)。
2. 從下拉功能表中，開啟使用者管理畫面。
3. 選取**設定**。您可以檢閱使用者清單，或從此畫面新增使用者。
4. 若要編輯使用者許可權，請將游標移至使用者上方，直到顯示鉛筆圖示為止。
5. 按一下鉛筆圖示，以變更其許可權。對使用者許可權所做的任何變更都會立即生效。
