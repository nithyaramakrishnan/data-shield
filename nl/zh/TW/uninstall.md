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

# 解除安裝
{: #uninstall}

如果您不再需要使用 {{site.data.keyword.datashield_full}}，可以刪除已建立的服務和 TLS 憑證。


## 使用 Helm 解除安裝
{: #uninstall-helm}

1. 登入 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示，完成登入。如果您有聯合 ID，請在指令尾端附加 `--sso` 選項。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>地區 (Region)</th>
      <th>{{site.data.keyword.cloud_notm}} 端點</th>
      <th>{{site.data.keyword.containershort_notm}} 地區</th>
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
    {: codeblock}

  2. 複製輸出，並貼到您的主控台中。

3. 刪除服務。

  ```
  helm delete <chart-name> --purge
  ```
  {: codeblock}

4. 執行下列每個指令，以刪除 TLS 憑證。

  ```
  kubectl delete secret <chart-name>-enclaveos-converter-tls
  kubectl delete secret <chart-name>-enclaveos-frontend-tls
  kubectl delete secret <chart-name>-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. 解除安裝處理程序使用 Helm「連結鉤」來執行解除安裝程式。在執行解除安裝程式之後，您可以將它刪除。

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

如果已經建立 `cert-manager` 實例，您還可能想要刪除該實例以及 Docker 配置密碼。
{: tip}


## 使用安裝程式進行卸載
{: #uninstall-installer}

如果您使用安裝程式來安裝{{site.data.keyword.datashield_short}}，還可以使用該安裝程式來解除安裝服務。

若要解除安裝 {{site.data.keyword.datashield_short}}，請登入 `ibmcloud` CLI，並將您的叢集設為目標，然後執行下列指令：

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

