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



# TLS 証明書の管理
{: #tls-certificates}

{{site.data.keyword.datashield_full}} は、フロントエンド・アプリとバックエンド・アプリの両方で TLS 証明書を使用します。 Enclave Manager Web フロントエンドは、IBM 提供の「Let's Encrypt」証明書をデフォルトで使用します。 バックエンドでは、バックエンド・サービス間の内部通信に TLS が使用されます。
{: shortdesc}


## フロントエンドでの使用
{: #tls-frontend}

デフォルトを使用するか、独自の TLS 証明書を Helm チャートで定義して使用するかを選択できます。
{: shortdesc}

IBM 提供の証明書について詳しくは、[Kubernetes Service の資料](/docs/containers?topic=containers-ingress#ingress_expose_public)を参照してください。
{: note}


1. Helm チャートを開きます。

2. 値 `enclaveos-chart.CertManager.Enabled` を `false` に設定します。

3. 該当する証明書発行者に関する情報を使用して `global.CertManager.Issuer` と `global.CertManager.IssuerKind` を定義します。

4. ご使用の TLS 証明書と秘密鍵を保持している Kubernetes シークレットの名前を使用して、値 `enclaveos-chart.manager-frontend.ingress-secret` を定義します。

操作は以上です。 お客様独自の発行者からの独自の証明書を使用する準備ができました。 



## バックエンドでの使用
{: #tls-backend}

{{site.data.keyword.datashield_short}} サービスは、バックエンド・サービス間の内部通信にも TLS を使用します。 これらの証明書も `cert-manager` によって提供されます。 一般に、ユーザーがこれらの証明書を使用して何かを行う必要はありません。
{: shortdesc}

{{site.data.keyword.datashield_short}} がそれぞれの `cert-manager` リソースを作成する方法に影響する前後関係については、以下の表を確認してください。

<table>
    <tr>
        <th>リソース</th>
        <th>作成方法</th>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-ca-issuer</code></td>
        <td>{{site.data.keyword.datashield_short}} コンポーネント用の TLS 証明書を発行する <code>datashield-enclaveos-ca</code> 認証局を生成するために使用される自己署名 <code>cert-manager</code> 発行者。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-issuer</code></td>
        <td>{{site.data.keyword.datashield_short}} コンポーネントで使用される TLS 証明書の発行者。 証明書は <code>datashield-enclaveos-ca</code> 認証局を使用して作成されます。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-ca</code></td>
        <td>証明書でもありプライベート認証局でもある <code>cert-manager</code> リソース。 認証局として、{{site.data.keyword.datashield_short}} バックエンド・サービスに TLS 証明書を発行します。 証明書はさまざまなサービスに Kubernetes シークレットとしてマウントされ、<code>datashield-enclaveos-ca</code> CA によって署名された証明書がクライアントにあれば、そのクライアントは Kubernetes シークレットに基づいて信頼されるようになります。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-converter</code></td>
        <td>EnclaveOS コンテナー・コンバーターによって使用される証明書。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-frontend</code></td>
        <td>Enclave Manager フロントエンドとして機能するコンテナーが、Ingress プロキシーの認証を受けるために使用する証明書。注: この証明書は、独自の証明書を使用するように切り替えられる証明書とは違います。</td>
    </tr>
    <tr>
        <td><code>&lt;chartname&gt;-enclaveos-manager-main</code></td>
        <td>Enclave Manager バックエンド・アプリケーションによって使用される証明書。</td>
    </tr>
</table>


<!---## Disabling cert-manager
{: #tls-disable-cert-manager}

You can choose to disable `cert-manager` entirely and configure your certificates manually for the Enclave Manager backend services. To do so, set the Helm value `global.CertManager.Enabled` to `false`.--->

