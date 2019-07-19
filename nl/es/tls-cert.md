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



# Gestión de certificados TLS
{: #tls-certificates}

{{site.data.keyword.datashield_full}} utiliza certificados TLS en las apps tanto de programa de usuario como de programa de fondo. El cliente web Enclave Manager utiliza un certificado "Let's Encrypt" proporcionado por IBM de forma predeterminada. En el programa de fondo, se utiliza TLS para la comunicación interna entre servicios de fondo.
{: shortdesc}


## Uso por parte del cliente
{: #tls-frontend}

Puede optar por utilizar el certificado predeterminado o utilizar su propio certificado TLS según la manera en que defina el diagrama de Helm.
{: shortdesc}

Para obtener más información sobre los certificados proporcionados por IBM, consulte la
[documentación del servicio de Kubernetes](/docs/containers?topic=containers-ingress#ingress_expose_public).
{: note}


1. Abra el diagrama de Helm.

2. Establezca el valor de `enclaveos-chart.CertManager.Enabled` en `false`.

3. Defina `global.CertManager.Issuer` y `global.CertManager.IssuerKind` con la información que se aplique a su emisor de certificados.

4. Defina el valor `enclaveos-chart.manager-frontend.ingress-secret` con el nombre del secreto de Kubernetes que contiene el certificado TLS y la clave privada.

Eso es todo. Está preparado para utilizar su propio certificado de su propio emisor. 



## Utilización del programa de fondo
{: #tls-backend}

El servicio {{site.data.keyword.datashield_short}} también utiliza TLS para la comunicación interna entre servicios de fondo. Estos certificados también los proporciona `cert-manager`. En general, no tiene que hacer nada con estos certificados.
{: shortdesc}

Consulte la tabla siguiente para ver información contextual sobre el modo en que
{{site.data.keyword.datashield_short}} crea los recursos específicos de `cert-manager`.

<table>
    <tr>
        <th>Recurso</th>
        <th>Creación</th>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-ca-issuer</code></td>
        <td>Un emisor de <code>cert-manager</code> autofirmado que se utiliza para generar la entidad emisora de certificados
<code>datashield-enclaveos-ca</code> que emite certificados TLS para los componentes de {{site.data.keyword.datashield_short}}.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-issuer</code></td>
        <td>El emisor de certificados TLS que se utilizan en los componentes de {{site.data.keyword.datashield_short}}. Los certificados se crean utilizando la entidad emisora de certificados <code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-ca</code></td>
        <td>El recurso <code>cert-manager</code> que es tanto un certificado como una entidad emisora de certificados privados. Como entidad emisora de certificados, emite certificados TLS para los servicios de fondo de {{site.data.keyword.datashield_short}}. El certificado se monta como un secreto de Kubernetes en diversos servicios, que luego confía en los clientes que tengan un certificado firmado por la entidad emisora de certificados
<code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-converter</code></td>
        <td>El certificado utilizado por el conversor de contenedores de EnclaveOS.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-frontend</code></td>
        <td>El certificado utilizado por el contenedor que proporciona el programa de usuario de Enclave Manager para autenticarse ante el proxy Ingress. Nota: este certificado es distinto del certificado al que podría cambiar para utilizar el suyo propio.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-manager-main</code></td>
        <td>El certificado utilizado por la aplicación de fondo de Enclave Manager.</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

