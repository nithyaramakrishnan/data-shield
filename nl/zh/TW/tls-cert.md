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



# 管理 TLS 憑證
{: #tls-certificates}

{{site.data.keyword.datashield_full}} 在前端及後端應用程式中都使用 TLS 憑證。依預設，「區域管理程式」 Web 前端系統使用 IBM 提供的 "Let's Encrypt" 憑證。在後端中，TLS 用於後端服務之間的內部通訊。
{: shortdesc}


## 前端使用
{: #tls-frontend}

您可以選擇使用預設值，也可以透過定義 Helm 圖表的方式來使用您自己的 TLS 憑證。
{: shortdesc}

如需 IBM 所提供憑證的相關資訊，請參閱 [Kubernetes 服務文件](/docs/containers?topic=containers-ingress#ingress_expose_public)。
{: note}


1. 開啟 Helm 圖表。

2. 將 `enclaveos-chart.CertManager.Enabled` 值設為 `false`。

3. 利用適用於您的憑證發證者的資訊來定義 `global.CertManager.Issuer` 和 `global.CertManager.IssuerKind`。

4. 將 `enclaveos-chart.manager-frontend.ingresse-secret` 值定義為保存 TLS 憑證及私密金鑰的 Kubernetes 密碼的名稱。

就這樣！您已準備好從自己的發證者使用自己的憑證。 



## 後端使用
{: #tls-backend}

{{site.data.keyword.datashield_short}} 服務也會將 TLS 用於後端服務之間的內部通訊。這些憑證也是由 `cert-manager` 提供。通常，您不需要對這些證書執行任何操作。
{: shortdesc}

請參閱下表，以取得有關 {{site.data.keyword.datashield_short}} 如何建立特定 `cert-manager` 資源的環境定義資訊。

<table>
    <tr>
        <th>資源</th>
        <th>建立</th>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-ca-issuer</code></td>
        <td>一個自簽的 <code>cert-manager</code> 發證者，用來產生 <code>dataseld-enclaveos-ca</code> 憑證管理中心，以發出 {{site.data.keyword.datashield_short}} 元件的 TLS 憑證。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-issuer</code></td>
        <td>用於{{site.data.keyword.datashield_short}} 元件的 TLS 憑證發證者。憑證透過使用 <code>dataseld-enclaveos-ca</code> 憑證管理中心來建立。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-ca</code></td>
        <td><code>cert-manager</code> 資源同時是憑證和專用憑證管理中心。作為憑證管理中心，它會將 TLS 憑證發出給 {{site.data.keyword.datashield_short}} 後端服務。憑證會裝載為各種服務中的 Kubernets 密碼，如果它們具有 <code>datahidl-enclaveos-ca</code> CA 簽署的憑證，則會信任用戶端。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-converter</code></td>
        <td>EnclaveOS 容器轉換器所使用的憑證。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-frontend</code></td>
        <td>向 Enclave Manager 前端提供服務的容器所使用的憑證，用於向 Ingress Proxy 進行鑑別。附註：這不是您會切換成使用您自己憑證的同一個憑證。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-manager-main</code></td>
        <td>「區域管理程式」後端應用程式使用的憑證。</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

