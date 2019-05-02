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



# TLS 인증서 관리
{: #tls-certificates}

{{site.data.keyword.datashield_full}}는 프론트 엔드와 백엔드 앱에서 TLS 인증서를 사용합니다. 엔클레이브 관리자 웹 프론트 엔드는 기본적으로 IBM 제공 "Let's Encrypt" 인증서를 사용합니다. 백엔드에서 TLS는 백엔드 서비스 간의 내부 통신에 사용됩니다.
{: shortdesc}


## 프론트 엔드 사용
{: #tls-frontend}

Helm 차트를 정의하는 방식으로 고유 TLS 인증서를 사용하거나 기본값을 사용하도록 선택할 수 있습니다.
{: shortdesc}

IBM 제공 인증서에 대한 자세한 정보는 [Kubernetes Service 문서](/docs/containers?topic=containers-ingress#ingress_expose_public)를 참조하십시오.
{: note}

고유 발행자를 사용하려면 다음을 수행하십시오.

1. Helm 차트를 여십시오.

2. 값 `enclaveos-chart.CertManager.Enabled`를 `false`로 설정하십시오.

3. 인증서 발행자에 적용되는 정보로 `global.CertManager.Issuer` 및 `global.CertManager.IssuerKind`를 정의하십시오.

4. TLS 인증서 및 개인 키를 보유하는 Kubernetes 시크릿의 이름으로 값 `enclaveos-chart.manager-frontend.ingress-secret`을 정의하십시오.

모두 완료되었습니다. 고유 발행자의 고유 인증서를 사용할 준비가 되었습니다. 



## 백엔드 사용
{: #tls-backend}

{{site.data.keyword.datashield_short}} 서비스도 백엔드 서비스 간 내부 통신에 TLS를 사용합니다. 이러한 인증서는 `cert-manager`를 통해서도 제공됩니다. 일반적으로 이러한 인증서에 대해 어떤 작업도 수행할 필요가 없습니다.
{: shortdesc}

{{site.data.keyword.datashield_short}}가 특정 `cert-manager` 리소스를 작성하는 방법에 대한 컨텍스트 정보는 다음 표를 참조하십시오.

<table>
    <tr>
        <th>리소스</th>
        <th>작성 방법</th>
    </tr>
    <tr>
        <td><code>datashield-ca-issuer</code></td>
        <td>{{site.data.keyword.datashield_short}} 컴포넌트의 TLS 인증서를 발행하는 <code>datashield-enclaveos-ca</code> 인증 기관을 생성하는 데 사용되는 자체 서명된 <code>cert-manager</code> 발행자입니다.</td>
    </tr>
    <tr>
        <td><code>datashield-issuer</code></td>
        <td>{{site.data.keyword.datashield_short}} 컴포넌트에 사용되는 TLS 인증서의 발행자입니다. 인증서는 <code>datashield-enclaveos-ca</code> 인증 기관을 사용하여 작성됩니다.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-ca</code></td>
        <td>인증서이면서 사설 인증 기관인 <code>cert-manager</code> 리소스입니다. 인증 기관으로서 {{site.data.keyword.datashield_short}} 백엔드 서비스에 TLS 인증서를 발행합니다. 인증서는 다양한 서비스에 Kubernetes 시크릿으로 마운트되며, <code>datashield-enclaveos-ca</code> CA에서 서명한 인증서를 가진 클라이언트를 신뢰합니다.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-converter</code></td>
        <td>EnclaveOS 컨테이너 변환기에서 사용되는 인증서입니다.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-frontend</code></td>
        <td>엔클레이브 관리자 프론트 엔드를 제공하는 컨테이너에서 사용하는 인증서입니다. 이 인증서는 Ingress 프록시 인증에 사용됩니다. 참고: 이는 고유 인증서로 사용하기 위해 전환하려는 인증서와 다릅니다.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-manager-main</code></td>
        <td>엔클레이브 관리자 백엔드 애플리케이션에서 사용하는 인증서입니다.</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

