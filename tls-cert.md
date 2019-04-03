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



# Managing TLS certificates
{: #tls-certificates}

{{site.data.keyword.datashield_full}} uses TLS certificates both in frontend and backend apps. The Enclave Manager web frontend uses an IBM-provided "Let's Encrypt" certificate by default. In the backend, TLS is used for internal communication among backend services.
{: shortdesc}


## Frontend use
{: #tls-frontend}

You can choose to use the default or use your own TLS certificate by the way you define the Helm chart.
{: shortdesc}

For more information about IBM-provided certificates, see the [Kubernetes Service documentation](https://cloud.ibm.com/docs/containers?topic=containers-ingress#ingress_expose_public).
{: note}

To use your own issuer:

1. Open the Helm chart.

2. Set the value `enclaveos-chart.CertManager.Enabled` to `false`.

3. Define `global.CertManager.Issuer` and `global.CertManager.IssuerKind` with the information that applies to your certificate issuer.

4. Define the value `enclaveos-chart.manager-frontend.ingress-secret` with the name of your Kubernetes secret that is holding your TLS certificate and private key.

That's it! You're ready to use your own certificate from your own issuer. 



## Backend use
{: #tls-backend}

The Data Shield service also uses TLS for internal communication between backend services. These certificates are also provided by `cert-manager`. In general, you should not need to do anything with these certificates.
{: shortdesc}

Check out the following table for contextual information about how Data Shield creates the specific `cert-manager` resources.

<table>
    <tr>
        <th>Resource</th>
        <th>How it's created</th>
    </tr>
    <tr>
        <td><code>datashield-ca-issuer</code></td>
        <td>A self-signed <code>cert-manager</code> issuer that is used to generate the <code>datashield-enclaveos-ca</code> certificate authority that issues TLS certificates for the Data Shield components.</td>
    </tr>
    <tr>
        <td><code>datashield-issuer</code></td>
        <td>The issuer of TLS certificates that are used in Data Shield components. The certificates are created by using the <code>datashield-enclaveos-ca</code> certificate authority.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-ca</code></td>
        <td>The <code>cert-manager</code> resource that is both a certificate and a private certificate authority. As a certificate authority, it issues TLS certificates to the Data Shield backend services. The certificate is mounted as a Kubernetes secret in various services, which then trusts clients if they have a certificate that is signed by <code>datashield-enclaveos-ca</code> CA.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-converter</code></td>
        <td>The certificate that is used by the EnclaveOS container converter.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-frontend</code></td>
        <td>The certificate that is used by the container that serves the Enclave Manager frontend. It is used to authenticate to the Ingress proxy. Note: This is not the same certificate that you would switch to use your own.</td>
    </tr>
    <tr>
        <td><code>datashield-enclaveos-manager-main</code></td>
        <td>The certificate used by the Enclave Manager backend application.</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

