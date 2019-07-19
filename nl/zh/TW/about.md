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

# 關於服務
{: #about}

藉由使用 {{site.data.keyword.datashield_full}}、Fortanix® 和 Intel® SGX，您可以在您的資料處於使用中時保護在 {{site.data.keyword.cloud_notm}} 上執行的容器工作負載中的資料。
{: shortdesc}

當您需要保護資料時，加密是最常用且最有效的控制方法之一。但是，要真正保護資料安全，必須在資料生命週期的每個步驟對資料進行加密。在資料的生命週期中，資料分為三種狀態。即靜態資料、動態資料或者使用中資料。靜態資料和動態資料通常是您思考保護資料時關注的焦點。但是，應用程式開始執行後，CPU 和記憶體使用的資料易受各種攻擊。攻擊可能來自惡意內部人員、root 使用者、認證洩露、作業系統零天、網路入侵者等。若要更進一步保護，您現在可以加密使用中的資料。 

藉由使用 {{site.data.keyword.datashield_short}}，您的應用程式碼和資料會在 CPU 強化的區域中執行。區域是工作者節點上記憶體的可信任區域，用於保護應用程式的關鍵層面。區域可協助保護程式碼和資料的機密性並確保其不會被修改。如果您或貴公司由於內部政策、政府規定或產業合規性需求而需要顧及資料敏感度，本解決方案也許可協助您移至雲端。範例使用的案例包括政府政策要求內部部署雲端解決方案的財務及醫療機構或國家/地區。


## 整合
{: #integrations}

為了向您提供極致無縫體驗，{{site.data.keyword.datashield_short}} 與其他 {{site.data.keyword.cloud_notm}} 服務、Fortanix® 以及 Intel® SGX 整合。

<dl>
  <dt>Fortanix®</dt>
    <dd>藉由使用 [Fortanix Runtime Encryption](https://fortanix.com/){: external}，即使是基礎架構受到攻擊的情況下，您仍然可以保護您最有價值的應用程式和資料。Fortanix 建置在 Intel SGX 上，提供稱為 Runtime Encryption 的全新範疇的資料安全。與靜態資料加密和動態資料加密的方式類似，運行環境加密會持續受保護的金鑰、資料和應用程式不受外部和內部威脅的影響。威脅可能包括惡意的內部人員、雲端提供者、OS 層次駭客或網路侵入者。</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} 是 x86 架構的延伸，容許您在全面隔離的安全封套中執行應用程式。應用程式不只和相同系統上執行的其他應用程式隔離，也和「作業系統」和可能的 Hypervisor 隔離。隔離可防範管理者在啟動之後竄改應用程式。安全區域的記憶體也會加密，以防止實體攻擊。該技術還支援安全地儲存持續資料，以使其只能由安全的封套讀取。</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) 藉由結合 Docker 容器、Kubernetes 技術、直覺式使用者體驗以及內建安全和隔離，提供強大的工具來自動使用容器化的應用程式。</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) 可讓您對服務安全地進行使用者鑑別，以及在 {{site.data.keyword.cloud_notm}} 一致地控制資源存取權。使用者嘗試完成特定動作時，控制系統會使用原則中所定義的屬性，來判定使用者是否有權執行該作業。{{site.data.keyword.cloud_notm}} API 金鑰透過 Tivoli Information Archive Manager 提供，供您使用 CLI 進行鑑別或以您的使用者身分進行自動化登入。</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>您可以透過 {{site.data.keyword.containerlong_notm}} 將日誌轉遞到 [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started) 來建立[記載配置](/docs/containers?topic=containers-health)，進而擴展日誌收集、保留和搜尋功能。使用此服務，您也可以視需要隨時利用集中化的見解、日誌加密以及日誌資料保留。</dd>
</dl>
