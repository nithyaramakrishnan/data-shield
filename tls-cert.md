---
copyright:
  years: 2018, 2021
lastupdated: "2021-04-21"

keywords: tls certificates, data in use, certificate authority, backend services, ingress proxy, issue cert, enclave manager, data shield, private key, data protection, cluster, container, app security, memory,

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:faq: data-hd-content-type='faq'}
{:gif: data-image-type='gif'}
{:important: .important}
{:note: .note}
{:pre: .pre}
{:tip: .tip}
{:preview: .preview}
{:deprecated: .deprecated}
{:beta: .beta}
{:term: .term}
{:shortdesc: .shortdesc}
{:script: data-hd-video='script'}
{:support: data-reuse='support'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:java: .ph data-hd-programlang='java'}
{:javascript: .ph data-hd-programlang='javascript'}
{:swift: .ph data-hd-programlang='swift'}
{:curl: .ph data-hd-programlang='curl'}
{:video: .video}
{:step: data-tutorial-type='step'}
{:tutorial: data-hd-content-type='tutorial'}




# Managing TLS certificates
{: #tls-certificates}

{{site.data.keyword.datashield_full}} uses TLS certificates both in front-end and backend apps. The Enclave Manager web front end uses an IBM-provided "Let's Encrypt" certificate by default. In the backend, TLS is used for internal communication among backend services.
{: shortdesc}




## Front-end use
{: #tls-frontend}

You can choose to use the default or use your own TLS certificate by the way you define the Helm chart.
{: shortdesc}

For more information about IBM-provided certificates, see the [Kubernetes Service documentation](/docs/containers?topic=containers-ingress#ingress_expose_public).
{: note}


1. Open the Helm chart.

2. Set the value `enclaveos-chart.CertManager.Enabled` to `false`.

3. Define `global.CertManager.Issuer` and `global.CertManager.IssuerKind` with the information that applies to your certificate issuer.

4. Define the value `enclaveos-chart.manager-frontend.ingress-secret` with the name of your Kubernetes secret that is holding your TLS certificate and private key.

That's it! You're ready to use your own certificate from your own issuer. 



## Backend use
{: #tls-backend}

The Data Shield service also uses TLS for internal communication between backend services. These certificates are also provided by `cert-manager`. In general, you don't need to do anything with these certificates.
{: shortdesc}

Check out the following table for contextual information about how Data Shield creates the specific `cert-manager` resources.

<table>
    <tr>
        <th>Resource</th>
        <th>Creation</th>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-ca-issuer</code></td>
        <td>A self-signed <code>cert-manager</code> issuer that is used to generate the <code>datashield-enclaveos-ca</code> certificate authority that issues TLS certificates for the Data Shield components.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-issuer</code></td>
        <td>The issuer of TLS certificates that are used in Data Shield components. The certificates are created by using the <code>datashield-enclaveos-ca</code> certificate authority.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-ca</code></td>
        <td>The <code>cert-manager</code> resource that is both a certificate and a private certificate authority. As a certificate authority, it issues TLS certificates to the Data Shield backend services. The certificate is mounted as a Kubernetes secret in various services, which then trusts clients if they have a certificate that is signed by <code>datashield-enclaveos-ca</code> CA.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-converter</code></td>
        <td>The certificate that is used by the EnclaveOS container converter.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-frontend</code></td>
        <td>The certificate that is used by the container that serves the Enclave Manager front end to authenticate to the Ingress proxy. Note: This certificate is different than the one that you would switch to use your own.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-manager-main</code></td>
        <td>The certificate used by the Enclave Manager backend application.</td>
    </tr>
</table>

