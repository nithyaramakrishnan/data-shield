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



# Gestione dei certificati TLS
{: #tls-certificates}

{{site.data.keyword.datashield_full}} utilizza i certificati TLS sia nelle applicazioni front-end che in quelle backend. Per impostazione predefinita, il front-end web Enclave Manager utilizza un certificato "Let's Encrypt" fornito da IBM. Nel backend, TLS viene utilizzato per le comunicazioni interne tra i servizi di backend.
{: shortdesc}


## Utilizzo front-end
{: #tls-frontend}

Puoi scegliere di utilizzare quello predefinito oppure di utilizzare un tuo certificato TLS dal modo in cui definisci il grafico Helm.
{: shortdesc}

Per ulteriori informazioni sui certificati forniti da IBM, vedi la [documentazione di Kubernetes Service](/docs/containers?topic=containers-ingress#ingress_expose_public).
{: note}

Per utilizzare un tuo emittente:

1. Apri il grafico Helm.

2. Imposta il valore `enclaveos-chart.CertManager.Enabled` su `false`.

3. Definisci `global.CertManager.Issuer` e `global.CertManager.IssuerKind` con le informazioni valide per il tuo emittente del certificato.

4. Definisci il valore `enclaveos-chart.manager-frontend.ingress-secret` con il nome del tuo segreto Kubernetes che detiene il tuo certificato TLS e la tua chiave privata.

Questo è tutto. Sei pronto a utilizzare il tuo certificato personale dal tuo emittente. 



## Uso backend
{: #tls-backend}

Il servizio {{site.data.keyword.datashield_short}} utilizza TLS anche per le comunicazioni interne tra i servizi di backend. Questi certificati sono forniti anche da `cert-manager`. In generale, non dovresti aver bisogno di fare nulla con questi certificati.
{: shortdesc}

Consulta la seguente tabella per le informazioni contestuali sul modo in cui {{site.data.keyword.datashield_short}} crea le specifiche risorse `cert-manager`.

<table>
    <tr>
        <th>Risorsa</th>
        <th>Come viene creata</th>
    </tr>
    <tr>
        <td><code>datashield-ca-issuer</code></td>
        <td>Un emittente <code>cert-manager</code> autofirmato che viene utilizzato per generare la CA (Certificate Authority) <code>datashield-enclaveos-ca</code> che emette certificati TLS per i componenti {{site.data.keyword.datashield_short}}.</td>
    </tr>
    <tr>
        <td><code>datashield-issuer</code></td>
        <td>L'emittente di certificati TLS utilizzati nei componenti {{site.data.keyword.datashield_short}}. I certificati vengono creati utilizzando la CA (Certificate Authority) <code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-ca</code></td>
        <td>La risorsa <code>cert-manager</code> che è sia un certificato che una CA (Certificate Authority) privata. In quanto CA (Certificate Authority), emette i certificati TLS per i servizi di backend {{site.data.keyword.datashield_short}}. Il certificato viene montato come un segreto Kubernetes in diversi servizi, che quindi ritiene attendibile i client se hanno un certificato firmato dalla CA <code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-converter</code></td>
        <td>Il certificato utilizzato dall'EnclaveOS Container Converter.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-frontend</code></td>
        <td>Il certificato utilizzato dal contenitore che funge da front-end dell'Enclave Manager. Viene utilizzato per eseguire l'autenticazione presso il proxy Ingress. Nota: non è lo stesso certificato che commuteresti per utilizzare quello tuo.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-manager-main</code></td>
        <td>Il certificato utilizzato dall'applicazione di backend Enclave Manager.</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

