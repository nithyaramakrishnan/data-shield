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

# 解除安裝
{: #uninstall}

如果您不再需要使用 {{site.data.keyword.datashield_full}}，則可以刪除服務及已建立的 TLS 憑證。


## 使用 Helm 解除安裝

1. 登入 {{site.data.keyword.cloud_notm}} CLI。
    遵循 CLI 中的提示，完成登入。

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
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

2. 設定叢集的環境定義。

  1. 取得指令來設定環境變數，並下載 Kubernetes 配置檔。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. 複製輸出，並貼到您的終端機中。

3. 刪除服務。

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. 執行下列每個指令，以刪除 TLS 憑證。

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. 解除安裝處理程序使用 Helm「連結鉤」來執行解除安裝程式。在執行解除安裝程式之後，您可以將它刪除。

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

如果已經建立 `cert-manager` 實例，您還可能想要刪除該實例以及 Docker 配置密碼。
{: tip}



## 使用測試版安裝程式解除安裝
{: #uninstall-installer}

如果您使用測試版安裝程式來安裝{{site.data.keyword.datashield_short}}，還可以使用該安裝程式來解除安裝服務。

若要解除安裝 {{site.data.keyword.datashield_short}}，請登入 `ibmcloud` CLI，並將您的叢集設為目標，然後執行下列指令：

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
