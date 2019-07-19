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

# 正在更新
{: #update}

在叢集上安裝 {{site.data.keyword.datashield_short}} 之後，可以隨時更新。
{: shortdesc}

## 設定叢集環境定義
{: #update-context}

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

  2. 複製輸出，並貼到您的主控台中。

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

## 對 Helm 進行更新
{: #update-helm}

若要使用 Helm 圖表來更新至最新版本，請執行下列指令。

  ```
  helm upgrade <chart-name> ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

## 對安裝程式進行更新
{: #update-installer}

若要使用安裝程式更新至最新版本，請執行下列指令。

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer upgrade [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ] [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  若要安裝最新的 {{site.data.keyword.datashield_short}} 版本，請對 `--version` 旗標使用 `latest`。


