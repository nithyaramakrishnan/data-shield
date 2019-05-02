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

# 入門指導教學
{: #getting-started}

利用 {{site.data.keyword.datashield_full}}、採用 Fortanix® 技術，您可以在您的資料處於使用中時保護在 {{site.data.keyword.cloud_notm}} 上執行的容器工作負載中的資料。
{: shortdesc}

如需 {{site.data.keyword.datashield_short}} 的相關資訊，以及保護使用中的資料的意義，請參閱[關於服務](/docs/services/data-shield?topic=data-shield-about#about)。

## 在開始之前
{: #gs-begin}

您必須具有下列必要條件，才能開始使用 {{site.data.keyword.datashield_short}}。如需下載 CLI 及外掛程式或配置 Kubernetes Service 環境的說明，請參閱[建立 Kubernetes 叢集](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)指導教學。

* 下列 CLI：

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  您可能要配置 Helm 以使用 `--tls` 模式。如需啟用 TLS 的協助，請參閱 [Helm 儲存庫](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)。如果您啟用 TLS，請務必對您所執行的每個 Helm 指令附加 `--tls`。
  {: tip}

* 下列 [{{site.data.keyword.cloud_notm}} CLI 外掛程式](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)：

  * Kubernetes 服務
  * Container Registry

* 已啟用 SGX 的 Kubernetes 叢集。目前，SGX 可以在具有下列節點類型的裸機叢集上啟用：mb2c.4x32。如果您還沒有所需要的叢集，可以使用下列步驟來協助確保建立它。
  1. 準備[建立您的叢集](/docs/containers?topic=containers-clusters#cluster_prepare)。

  2. 確定您有[必要許可權](/docs/containers?topic=containers-users#users)來建立叢集。

  3. 建立[叢集](/docs/containers?topic=containers-clusters#clusters)。

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 服務 0.5.0 版或更新版本的實例。預設安裝會使用 <code>cert-manager</code> 來設定 [TLS 憑證](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates)，以進行 {{site.data.keyword.datashield_short}} 服務之間的內部通訊。若要使用 Helm 來安裝實例，您可以執行下列指令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## 使用 Helm 圖表進行安裝
{: #gs-install-chart}

您可以使用所提供的 Helm 圖表，在您的已啟用 SGX 的裸機叢集上安裝 {{site.data.keyword.datashield_short}}。
{: shortdesc}

Helm 圖表會安裝下列元件：

*	SGX 的支援軟體，由特許容器安裝在裸機主機上。
*	{{site.data.keyword.datashield_short}} 區域管理程式，可管理 {{site.data.keyword.datashield_short}} 環境中的 SGX 區域。
*	EnclaveOS® 容器轉換服務，可讓容器化應用程式在 {{site.data.keyword.datashield_short}} 環境中執行。

安裝 Helm 圖表時，您有數個選項及參數可自訂您的安裝。下列指導教學會逐步引導您完成最基本的預設圖表安裝。如需您選項的相關資訊，請參閱[安裝 {{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-deploying)。
{: tip}

若要將 {{site.data.keyword.datashield_short}} 安裝到叢集，請執行下列動作：

1. 登入 {{site.data.keyword.cloud_notm}} CLI。
    遵循 CLI 中的提示，完成登入。

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

2. 設定叢集的環境定義。

  1. 取得指令來設定環境變數，並下載 Kubernetes 配置檔。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. 複製以 `export` 開頭的輸出並貼到您的終端機中，以設定 `KUBECONFIG` 環境變數。

3. 如果您還沒有 `ibm` 儲存庫，請新增它。

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. 選用項目：如果您不知道管理者或管理者帳戶 ID 相關聯的電子郵件，請執行下列指令。

  ```
ibmcloud account show
```
  {: pre}

5. 取得叢集的 Ingress 子網域。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. 安裝圖表。

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  如果您已對轉換器[配置 {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert)，您可以新增下列選項：`--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. 若要監視元件啟動，您可以執行下列指令。

  ```
  kubectl get pods
  ```
  {: pre}


## 下一步
{: #gs-next}

做得好！現在，服務已經安裝在叢集上，您可以在 {{site.data.keyword.datashield_short}} 環境中執行您的應用程式。 

如果要在 {{site.data.keyword.datashield_short}} 環境中執行您的應用程式，您必須[轉換](/docs/services/data-shield?topic=data-shield-convert#convert)、[列入白名單](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist)，然後[部署](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers)容器映像檔。

如果您沒有要部署的專屬映像檔，請嘗試部署其中一個預先包裝的 {{site.data.keyword.datashield_short}} 映像檔：

* [{{site.data.keyword.datashield_short}} 範例 GitHub 儲存庫](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* {{site.data.keyword.cloud_notm}} Container Registry 中的 MariaDB 或 NGINX
