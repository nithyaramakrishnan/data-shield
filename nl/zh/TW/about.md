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

# 關於服務
{: #about}

藉由使用 {{site.data.keyword.datashield_full}}、Fortanix® 和 Intel® SGX，您可以在您的資料處於使用中時保護在 {{site.data.keyword.cloud_notm}} 上執行的容器工作負載中的資料。
{: shortdesc}

當您需要保護資料時，加密是最常用且最有效的控制方法之一。但是，資料必須在其生命週期的每個步驟都加密，才能確實安全。資料在其生命週期期間會經歷三個階段：靜態資料、動態資料，以及使用中的資料。處於靜態和動態的資料通常用來保護儲存中以及傳輸中的資料。應用程式開始執行之後，在 CPU 和記憶體中使用的資料容易遭到各種攻擊，包括惡意的內部人員、root 使用者、認證遭洩露、OS 零時差漏洞、網路侵入者，以及其他攻擊。若要更進一步保護，您現在可以加密使用中的資料。 

藉由使用 {{site.data.keyword.datashield_short}}，您的應用程式碼和資料會在 CPU 強化的區域（即工作者節點上用來保護應用程式重要層面的受信任的記憶體區域）中執行。區域可協助保護程式碼和資料的機密性並確保其不會被修改。如果您或貴公司因為內部政策、政府規定或產業合規性需求而需要顧及資料敏感度，本解決方案也許可協助您移至雲端。範例使用的案例包括政府政策要求內部部署雲端解決方案的財務及醫療機構或國家。


## 整合
{: #integrations}

{{site.data.keyword.datashield_short}} 已經和其他 {{site.data.keyword.cloud_notm}} 服務、Fortanix® Runtime Encryption 以及 Intel SGX® 整合，來為您提供最無縫的體驗。

<dl>
  <dt>Fortanix®</dt>
    <dd>藉由使用 [Fortanix](http://fortanix.com/)，即使是基礎架構受到攻擊的情況下，您仍然可以保護您最有價值的應用程式和資料。Fortanix 建置在 Intel SGX 上，提供稱為 Runtime Encryption 的全新範疇的資料安全。和靜態資料及動態資料所使用的加密方式類似，Runtime Encryption 可以完全保護金鑰、資料及應用程式，不會受到外部和內部的威脅。威脅可能包括惡意的內部人員、雲端提供者、OS 層次駭客或網路侵入者。</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx) 是 x86 架構的延伸，可讓您在完全隔離的安全區域中執行應用程式。應用程式不只和相同系統上執行的其他應用程式隔離，也和「作業系統」和可能的 Hypervisor 隔離。這可防範管理者在啟動之後竄改應用程式。安全區域的記憶體也會加密，以防止實體攻擊。此技術還支援安全儲存持續資料，以便只能由安全區域讀取。</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started) 藉由結合 Docker 容器、Kubernetes 技術、直覺式使用者體驗，以及內建安全和隔離來提供功能強大的工具，以便在運算主機的叢集中自動部署、操作、調整及監視容器化應用程式。</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted) 可讓您對服務安全地進行使用者鑑別，以及在 {{site.data.keyword.cloud_notm}} 一致地控制資源存取權。使用者嘗試完成特定動作時，控制系統會使用原則中所定義的屬性，來判定使用者是否有權執行該作業。{{site.data.keyword.cloud_notm}} API 金鑰透過 Cloud IAM 提供給您使用 CLI 來進行鑑別，或者作為以您的使用者身分進行自動化登入的一部分。</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>您可以透過 {{site.data.keyword.containerlong_notm}} 來建立[記載配置](/docs/containers?topic=containers-health#health)，以將您的日誌轉遞至 [{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla)。您可以在 {{site.data.keyword.cloud_notm}} 中展開日誌收集、日誌保留及日誌搜尋功能。請利用下列特性來強化您的 DevOps 團隊，諸如聚集應用程式及環境日誌以便合併應用程式或環境洞察、日誌加密、日誌資料保留（需要時），以及對問題進行快速偵測及疑難排解。</dd>
</dl>
