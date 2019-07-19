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



# Gestion des certificats TLS
{: #tls-certificates}

{{site.data.keyword.datashield_full}} utilise les certificats TLS dans les applications frontales et de backend. Le site Web frontal d'Enclave Manager utilise par défaut un certificat "Let's Encrypt" fourni par IBM. Dans le backend, TLS est utilisé pour la communication interne entre les services du backend.
{: shortdesc}


## Utilisation en avant-plan
{: #tls-frontend}

Vous pouvez choisir d'utiliser le certificat TLS par défaut ou d'utiliser votre propre certificat TLS par la manière dont vous définissez la charte Helm.
{: shortdesc}

Pour en savoir plus sur les certificats fournis par IBM, consultez la [documentation de Kubernetes Service](/docs/containers?topic=containers-ingress#ingress_expose_public).
{: note}


1. Ouvrez la charte Helm.

2. Définissez la valeur `enclaveos-chart.CertManager.Enabled` sur `false`.

3. Définissez `global.CertManager.Issuer` et `global.CertManager.IssuerKind` avec les informations qui s'appliquent à votre émetteur de certificat.

4. Définissez la valeur `enclaveos-chart.manager-frontend.ingress-secret` avec le nom de votre secret Kubernetes qui contient votre certificat TLS et votre clé privée.

Ca y est ! Vous êtes prêt à utiliser votre propre certificat de votre propre émetteur. 



## Utilisation en arrière-plan
{: #tls-backend}

Le service {{site.data.data.keyword.datashield_short}} utilise également TLS pour la communication interne entre les services de back end. Ces certificats sont également fournis par `cert-manager`. En général, vous n'avez rien à faire avec ces certificats.
{: shortdesc}

Consultez le tableau suivant pour obtenir des informations contextuelles sur la façon dont {{site.data.data.keyword.datashield_short}} crée les ressources `cert-manager` spécifiques.

<table>
    <tr>
        <th>Ressource</th>
        <th>Création</th>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-ca-issuer</code></td>
        <td>Emetteur <code>cert-manager</code> auto-signé utilisé pour générer l'autorité de certification <code>datashield-enclaveos-ca</code> qui délivre les certificats TLS pour les composants {{site.data.keyword.datashield_short}}.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-issuer</code></td>
        <td>Emetteur des certificats TLS utilisés dans les composants {{site.data.keyword.datashield_short}}. Les certificats sont créés à l'aide de l'autorité de certification <code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-ca</code></td>
        <td>Ressource <code>cert-manager</code> qui est à la fois un certificat et une autorité de certification privée. En tant qu'autorité de certification, elle délivre des certificats TLS aux services de back end d'{{site.data.keyword.datashield_short}}. Le certificat est monté comme un secret Kubernetes dans divers services, et fait alors confiance aux clients s'ils ont un certificat signé par l'autorité de certification <code>datashield-enclaveos-ca</code>.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-converter</code></td>
        <td>Certificat utilisé par le convertisseur de conteneur EnclaveOS.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-frontend</code></td>
        <td>Certificat utilisé par le conteneur qui sert la partie frontale d'Enclave Manager pour s'authentifier auprès du proxy Ingress. Remarque : Ce certificat est différent de celui que vous changeriez pour utiliser votre propre certificat.</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-manager-main</code></td>
        <td>Certificat utilisé par l'application de back end d'Enclave Manager.</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

