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

# 安裝
{: #deploying}

您可以使用提供的 helm 圖表，或使用提供的安裝程式來安裝 {{site.data.keyword.datashield_full}}。您可以使用您感到最舒適的安裝指令來進行作業。
{: shortdesc}

## 在開始之前
{: #begin}

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

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 服務 0.5.0 版或更新版本的實例。若要使用 Helm 來安裝實例，您可以執行下列指令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## 選用項目：建立 Kubernetes 名稱空間
{: #create-namespace}

依預設，{{site.data.keyword.datashield_short}} 會安裝在 `kube-system` 名稱空間中。您可以選擇性地建立新的名稱空間來使用替代名稱空間。
{: shortdesc}


1. 登入 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示，完成登入。

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

3. 建立名稱空間。

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. 將任何相關的密碼從預設名稱空間複製到新名稱空間。

  1. 列出您的可用密碼。

    ```
    kubectl get secrets
    ```
    {: pre}

    必須複製以 `bluemix*` 開頭的所有密碼。
    {: tip}

  2. 複製密碼，一次一個。

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. 驗證已完全複製您的密碼。

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. 建立服務帳戶。若要查看您的所有自訂選項，請參閱 Helm GitHub 儲存庫中的 [RBAC 頁面](https://github.com/helm/helm/blob/master/docs/rbac.md)。

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. 遵循 [Tiller SSL GitHub 儲存庫](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)中的指示，產生憑證並將 Helm 與 TLS 併用。請務必指定您建立的名稱空間。

太棒了！現在，您已準備好將 {{site.data.keyword.datashield_short}} 安裝到新名稱空間中。從現在起，請務必要對您執行的所有 Helm 指令附加 `--tiller-namespace <namespace_name>`。


## 使用 Helm 圖表進行安裝
{: #install-chart}

您可以使用所提供的 Helm 圖表，在您的已啟用 SGX 的裸機叢集上安裝 {{site.data.keyword.datashield_short}}。
{: shortdesc}

Helm 圖表會安裝下列元件：

*	SGX 的支援軟體，由特許容器安裝在裸機主機上。
*	{{site.data.keyword.datashield_short}} 區域管理程式，可管理 {{site.data.keyword.datashield_short}} 環境中的 SGX 區域。
*	EnclaveOS® 容器轉換服務，可讓容器化應用程式在 {{site.data.keyword.datashield_short}} 環境中執行。


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

  如果您已對轉換器[配置 {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert)，您必須新增 `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`。
  {: note}

7. 若要監視元件啟動，您可以執行下列指令。

  ```
kubectl get pods
    ```
  {: pre}



## 使用 {{site.data.keyword.datashield_short}} 安裝程式進行安裝
{: #installer}

您可以使用安裝程式，在已啟用 SGX 的裸機叢集上快速安裝 {{site.data.keyword.datashield_short}}。
{: shortdesc}

1. 登入 {{site.data.keyword.cloud_notm}} CLI。
    遵循 CLI 中的提示，完成登入。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 設定叢集的環境定義。

  1. 取得指令來設定環境變數，並下載 Kubernetes 配置檔。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. 複製輸出，並貼到您的終端機中。

3. 登入 Container Registry CLI。

  ```
        ibmcloud cr login
        ```
  {: pre}

4. 將映像檔取回至您的本端機器。

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: pre}

5. 執行下列指令，安裝 {{site.data.keyword.datashield_short}}。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  若要安裝最新的 {{site.data.keyword.datashield_short}} 版本，請對 `--version` 旗標使用 `latest`。


## 更新服務
{: #update}

{{site.data.keyword.datashield_short}} 安裝在叢集上後，您隨時可以更新。

若要使用 Helm 圖表來更新至最新版本，請執行下列指令。

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: pre}


若要使用安裝程式更新至最新版本，請執行下列指令：

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  若要安裝最新的 {{site.data.keyword.datashield_short}} 版本，請對 `--version` 旗標使用 `latest`。

