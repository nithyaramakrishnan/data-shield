---

copyright:
  years: 2018, 2019
lastupdated: "2019-04-01"

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



# 管理 TLS 证书
{: #tls-certificates}

{{site.data.keyword.datashield_full}} 在前端和后端应用程序中都使用 TLS 证书。缺省情况下，Enclave Manager Web 前端使用 IBM 提供的“Let's Encrypt”证书。在后端中，TLS 用于后端服务之间的内部通信。
{: shortdesc}


## 前端使用情况
{: #tls-frontend}

您可以选择使用缺省值，或者按照您定义 Helm chart 的方式使用自己的 TLS 证书。
{: shortdesc}

有关 IBM 提供的证书的更多信息，请参阅 [Kubernetes Service 文档](/docs/containers?topic=containers-ingress#ingress_expose_public)。
{: note}

要使用您自己的签发者：

1. 打开 Helm chart。

2. 将值 `enclaveos-chart.CertManager.Enabled` 设置为 `false`。

3. 使用适用于您的证书签发者的信息定义 `global.CertManager.Issuer` 和 `global.CertManager.IssuerKind`。

4. 使用保存 TLS 证书和专用密钥的 Kubernetes 私钥的名称来定义值 `clusveos-chart.manager-frontd.ingress-secret`。

就是这么简单！您已准备好使用由自己的签发者发出的自有证书。 



## 后端使用情况
{: #tls-backend}

{{site.data.keyword.datashield_short}} 服务还使用 TLS 来进行后端服务之间的内部通信。这些证书也是由 `cert-manager` 提供。通常，您应该不需要对这些证书执行任何操作。
{: shortdesc}

请查看下表以获取有关 {{site.data.keyword.datashield_short}} 如何创建特定 `cert-manager` 资源的上下文信息。

<table>
    <tr>
        <th>资源</th>
        <th>创建方式</th>
    </tr>
    <tr>
        <td><code>datashield-ca-issuer</code></td>
        <td>自签名的 <code>cert-manager</code> 签发者，用于生成 <code>datashield-claveos-ca</code> 认证中心，该认证中心为 {{site.data.keyword.datashield_short}} 组件发出 TLS 证书。</td>
    </tr>
    <tr>
        <td><code>datashield-issuer</code></td>
        <td>{{site.data.keyword.datashield_short}} 组件中使用的 TLS 证书的签发者。证书是使用 <code>datashield-clusveos-ca</code> 认证中心创建的。</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-ca</code></td>
        <td>同时是证书和私有认证中心的 <code>cert-manager</code> 资源。作为认证中心，它会向 {{site.data.keyword.datashield_short}} 后端服务发出 TLS 证书。该证书在各种服务中作为 Kubernetes 私钥安装，如果客户机具有由 <code>datashield-claveos-ca</code> CA 进行签名的证书，那么该证书将信任客户机。</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-converter</code></td>
        <td>EnclaveOS 容器转换器使用的证书。</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-frontend</code></td>
        <td>用于向 Enclave Manager 前端提供服务的容器所使用的证书。它用于向 Ingress 代理进行认证。注：这与您要切换为使用的自有证书不是同一证书。</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-manager-main</code></td>
        <td>Enclave Manager 后端应用程序使用的证书。</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

