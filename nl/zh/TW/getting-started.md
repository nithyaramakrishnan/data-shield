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

# 入門指導教學
{: #getting-started}

利用 {{site.data.keyword.datashield_full}}、採用 Fortanix® 技術，您可以在您的資料處於使用中時保護在 {{site.data.keyword.cloud_notm}} 上執行的容器工作負載中的資料。
{: shortdesc}

如需 {{site.data.keyword.datashield_short}} 的相關資訊，以及保護使用中的資料的意義，請參閱[關於服務](/docs/services/data-shield?topic=data-shield-about)。

## 在開始之前
{: #gs-begin}

您必須具有下列必要條件，才能開始使用 {{site.data.keyword.datashield_short}}。

如需下載 CLI 或配置 {{site.data.keyword.containershort}} 環境的說明，請查看指導教學[建立 Kubernetes 叢集](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)。
{: tip}

* 下列 CLI：

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* 下列 [ CLI 外掛程式](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins)：

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}

* 已啟用 SGX 的 Kubernetes 叢集。目前，SGX 可以在具有下列節點類型的裸機叢集上啟用：mb2c.4x32。如果您還沒有所需要的叢集，可以使用下列步驟來協助確保建立它。
  1. 準備[建立您的叢集](/docs/containers?topic=containers-clusters#cluster_prepare)。

  2. 確定您有[必要許可權](/docs/containers?topic=containers-users)來建立叢集。

  3. 建立[叢集](/docs/containers?topic=containers-clusters)。

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} 服務 0.5.0 版或更新版本的實例。預設安裝會使用 <code>cert-manager</code> 來設定 [TLS 憑證](/docs/services/data-shield?topic=data-shield-tls-certificates)，以進行 {{site.data.keyword.datashield_short}} 服務之間的內部通訊。若要使用 Helm 來安裝實例，您可以執行下列指令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

想要查看 Data Shield 的記載資訊？請設定叢集的 {{site.data.keyword.la_full_notm}} 實例。
{: tip}

## 安裝服務
{: #gs-install}

您可以使用所提供的 Helm 圖表，在您的已啟用 SGX 的裸機叢集上安裝 {{site.data.keyword.datashield_short}}。
{: shortdesc}

Helm 圖表會安裝下列元件：

*	SGX 的支援軟體，由特許容器安裝在裸機主機上。
*	{{site.data.keyword.datashield_short}} 區域管理程式，可管理 {{site.data.keyword.datashield_short}} 環境中的 SGX 區域。
*	EnclaveOS® 容器轉換服務，可讓容器化應用程式在 {{site.data.keyword.datashield_short}} 環境中執行。


若要將 {{site.data.keyword.datashield_short}} 安裝到叢集，請執行下列動作。

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

  2. 複製以 `export` 開頭的輸出並貼到您的主控台中，以設定 `KUBECONFIG` 環境變數。

3. 如果您還沒有 `iks-charts` 儲存庫，請新增它。

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. 選用項目：如果您不知道管理者或管理者帳戶 ID 相關聯的電子郵件，請執行下列指令。

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. 取得叢集的 Ingress 子網域。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

6. 藉由為 Tiller 建立角色連結原則來起始設定 Helm。 

  1. 建立 Tiller 的服務帳戶。
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. 建立角色連結，以在叢集裡指派 Tiller 管理者存取權。

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. 起始設定 Helm。

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  您可能要配置 Helm 以使用 `--tls` 模式。如需啟用 TLS 的協助，請參閱 [Helm 儲存庫](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}。如果您啟用 TLS，請務必對您所執行的每個 Helm 指令附加 `--tls`。
  如需使用 Helm 搭配 IBM Cloud Kubernetes Service 的相關資訊，請參閱[使用 Helm 圖表新增服務](/docs/containers?topic=containers-helm#public_helm_install)。
  {: tip}

7. 安裝圖表。

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  如果您已對轉換器[配置 {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert)，您必須新增 `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`。
  {: note}

7. 若要監視元件啟動，您可以執行下列指令。

  ```
  kubectl get pods
  ```
  {: codeblock}

## 下一步
{: #gs-next}

既然服務已安裝在叢集上，您可以開始保護您的資料！接下來，您可以嘗試[轉換](/docs/services/data-shield?topic=data-shield-convert)和[部署](/docs/services/data-shield?topic=data-shield-deploying)應用程式。 

如果您沒有要部署的專屬映像檔，請嘗試部署其中一個預先包裝的 {{site.data.keyword.datashield_short}} 映像檔：

* [ 範例 GitHub 儲存庫](https://github.com/fortanix/data-shield-examples/tree/master/ewallet){: external}
* Container Registry：[Barbican 映像檔](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)、[MariaDB 映像檔](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)、[NGINX 映像檔](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)或 [Vault 映像檔](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)。


