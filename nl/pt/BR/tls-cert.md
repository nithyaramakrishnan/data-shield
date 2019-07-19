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



# Gerenciando certificados TLS
{: #tls-certificates}

O {{site.data.keyword.datashield_full}} usa certificados TLS em apps de front-end e back-end. O front-end da web do Enclave Manager usa um certificado "Let's Encrypt" fornecido pela IBM, por padrão. No back-end, o TLS é usado para comunicação interna entre os serviços de back-end.
{: shortdesc}


## Uso de front-end
{: #tls-frontend}

É possível escolher usar o padrão ou usar seu próprio certificado TLS pela maneira como define o gráfico do Helm.
{: shortdesc}

Para obter mais informações sobre os certificados fornecidos pela IBM, veja a [Documentação do Kubernetes Service](/docs/containers?topic=containers-ingress#ingress_expose_public).
{: note}


1. Abra o gráfico do Helm.

2. Configure o valor `enclaveos-chart.CertManager.Enabled` como `false`.

3. Defina `global.CertManager.Issuer` e `global.CertManager.IssuerKind` com as informações aplicáveis ao seu emissor de certificados.

4. Defina o valor `enclaveos-chart.manager-frontend.ingress-secret` com o nome
do segredo do Kubernetes que está mantendo o certificado TLS e chave privada.

É isso! Você está pronto para usar seu próprio certificado de seu próprio emissor. 



## Uso de back-end
{: #tls-backend}

O serviço {{site.data.keyword.datashield_short}} também usa o TLS para comunicação interna
entre os serviços de back-end. Esses certificados também são fornecidos pelo `cert-manager`. Em geral, não é necessário fazer nada com esses certificados.
{: shortdesc}

Confira a tabela a seguir para obter informações contextuais sobre como o {{site.data.keyword.datashield_short}} cria os recursos específicos do `cert-manager`.

<table>
    <tr>
        <th>Recursos</th>
        <th>Data</th>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-ca-issuer</code></td>
        <td>Um emissor <code>cert-manager</code> autoassinado que é usado para gerar a autoridade
de certificação <code>datashield-enclaveos-ca-ca</code> que emite certificados TLS para os componentes
do {{site.data.keyword.datashield_short}}.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-issuer</code></td>
        <td>O emissor de certificados TLS que são usados em componentes do {{site.data.keyword.datashield_short}}. Os certificados são criados usando a autoridade de certificação <code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-ca</code></td>
        <td>O recurso <code>cert-manager</code> que é um certificado e uma autoridade de certificação privada. Como uma autoridade de certificação, ele emite certificados TLS para os serviços de back-end do {{site.data.keyword.datashield_short}}. O certificado é montado como um segredo do Kubernetes em vários serviços, que confiam nos clientes caso eles tenham um certificado assinado pela CA <code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-converter</code></td>
        <td>O certificado que é usado pelo conversor de contêiner EnclaveOS.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-frontend</code></td>
        <td>O certificado que é usado pelo contêiner que atende o front-end do Enclave Manager para autenticação no proxy de ingresso. Nota: esse certificado é diferente daquele do qual você alternaria para usar o seu próprio.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-manager-main</code></td>
        <td>O certificado usado pelo aplicativo back-end do Enclave Manager.</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

