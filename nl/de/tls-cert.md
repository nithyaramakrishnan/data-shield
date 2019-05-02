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



# TLS-Zertifikate verwalten
{: #tls-certificates}

{{site.data.keyword.datashield_full}} verwendet TLS-Zertifikate sowohl in Front-End-als auch in Back-End-Apps. Das Web-Front-End von Enclave Manager verwendet standardmäßig ein von IBM bereitgestelltes "Let's Encrypt"-Zertifikat. Im Back-End wird TLS für die interne Kommunikation zwischen Back-End-Services verwendet.
{: shortdesc}


## Front-End-Verwendung
{: #tls-frontend}

Sie können entweder das Standardzertifikat oder Ihr eigenes TLS-Zertifikat verwenden, indem Sie das Helm-Diagramm definieren.
{: shortdesc}

Weitere Informationen zu von IBM bereitgestellten Zertifikaten finden Sie in der [Dokumentation zu Kubernetes Service](/docs/containers?topic=containers-ingress#ingress_expose_public).
{: note}

Gehen Sie wie folgt vor, um Ihren eigenen Aussteller zu verwenden:

1. Installieren Sie das Helm-Diagramm.

2. Legen Sie den Wert `enclaveos-chart.CertManager.Enabled` auf `false` fest.

3. Definieren Sie `global.CertManager.Issuer` und `global.CertManager.IssuerKind` mit den Informationen, die für den Zertifikatsaussteller gelten.

4. Definieren Sie den Wert `enclaveos-chart.manager-frontend.ingress-secret` mit dem Namen Ihres geheimen Kubernetes-Schlüssels, der das TLS-Zertifikat und den privaten Schlüssel enthält.

Das ist alles! Sie können jetzt Ihr eigenes Zertifikat von Ihrem eigenen Aussteller verwenden. 



## Back-End-Verwendung
{: #tls-backend}

Der {{site.data.keyword.datashield_short}}-Service verwendet TLS auch für die interne Kommunikation zwischen Back-End-Services. Diese Zertifikate werden von `cert-manager` bereitgestellt. In der Regel sollten Sie mit diesen Zertifikaten nichts tun.
{: shortdesc}

Prüfen Sie die folgende Tabelle auf Kontextinformationen, wie {{site.data.keyword.datashield_short}} die spezifischen `cert-manager`-Ressourcen erstellt.

<table>
    <tr>
        <th>Ressource</th>
        <th>Vorgehensweise bei der Erstellung</th>
    </tr>
    <tr>
        <td><code>datashield-ca-issuer</code></td>
        <td>Ein selbst signierter <code>cert-manager</code>-Aussteller, der zum Generieren der Zertifizierungsstelle <code>datashield-enclaveos-ca</code> verwendet wird, die TLS-Zertifikate für die {{site.data.keyword.datashield_short}}-Komponenten ausgibt.</td>
    </tr>
    <tr>
        <td><code>datashield-issuer</code></td>
        <td>Der Aussteller von TLS-Zertifikaten, die in den {{site.data.keyword.datashield_short}}-Komponenten verwendet werden. Die Zertifikate werden unter Verwendung der Zertifizierungsstelle <code>datashield-enclaveos-ca</code> erstellt.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-ca</code></td>
        <td>Die Ressource <code>cert-manager</code>, die sowohl ein Zertifikat als auch eine private Zertifizierungsstelle ist. Als Zertifizierungsstelle gibt sie TLS-Zertifikate an die {{site.data.keyword.datashield_short}}-Back-End-Services aus. Das Zertifikat wird als geheimer Kubernetes-Schlüssel an verschiedene Services angehängt, die Clients dann vertrauen, wenn sie über ein Zertifikat verfügen, das von der Zertifizierungsstelle <code>datashield-enclaveos-ca</code> signiert ist.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-converter</code></td>
        <td>Das Zertifikat, das von EnclaveOS Container Converter verwendet wird.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-frontend</code></td>
        <td>Das Zertifikat, das von dem Container verwendet wird, der das Front-End von Enclave Manager bedient. Es wird für die Authentifizierung beim Ingress-Proxy verwendet. Hinweis: Hierbei handelt es sich nicht um das gleiche Zertifikat, zu dem Sie wechseln würden, wenn Sie Ihr eigenen Zertifikat verwenden wollten.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-manager-main</code></td>
        <td>Das Zertifikat, das von der Back-End-Anwendung von Enclave Manager verwendet wird.</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

