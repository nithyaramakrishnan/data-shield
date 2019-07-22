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

# サービスについて
{: #about}

{{site.data.keyword.datashield_full}}、Fortanix®、および Intel® SGX を使用すると、{{site.data.keyword.cloud_notm}} で実行されるコンテナー・ワークロード内のデータの使用中に、データを保護することができます。
{: shortdesc}

データの保護という点に関しては、最も一般的で効果的な手段の一つとして、暗号化が挙げられます。 しかし、データを確実に保護するには、データのライフサイクルの各ステップで暗号化する必要があります。データのライフサイクルには、3 つのフェーズがあります。保存中のデータ (Data at Rest)、転送中のデータ (Data in Motion)、使用中のデータ (Data in Use) の 3 つです。一般的に、データの保護について考えるときには、保存中のデータと転送中のデータが焦点領域になります。しかし、アプリケーションの実行が開始されると、CPU やメモリーで使用されているデータがさまざまな攻撃の対象になります。悪意のある内部関係者や root ユーザー、資格情報の漏えい、OS のゼロデイ攻撃、ネットワーク侵入者などの攻撃があります。保護手段をさらに一歩進めて、使用中のデータを暗号化できるようになりました。 

{{site.data.keyword.datashield_short}} では、アプリのコードとデータは、CPU で強化されたエンクレーブ内で実行されます。このエンクレーブはワーカー・ノード上の信頼されたメモリーの領域であり、アプリの重要な部分を保護します。エンクレーブは、コードとデータの機密を維持し、変更を防止します。お客様またはお客様の会社が、内部ポリシー、政府規制、または業界のコンプライアンス要件のためにデータの機密性を確保する必要がある場合、このソリューションがクラウドへの移行をサポートします。ユース・ケースの例には、金融機関や医療機関、政府の方針としてオンプレミスのクラウド・ソリューションの設置を定める国などが含まれます。


## 統合
{: #integrations}

シームレスな環境を実現するために、{{site.data.keyword.datashield_short}} は他の {{site.data.keyword.cloud_notm}} サービス、Fortanix®、Intel® SGX と統合されています。

<dl>
  <dt>Fortanix®</dt>
    <dd>[Fortanix Runtime Encryption](https://fortanix.com/){: external} では、インフラストラクチャーに侵入されても、最も重要なアプリとデータを保護し続けることができます。Intel SGX 上に構築された Fortanix は、Runtime Encryption と呼ばれるデータ・セキュリティーの新しいカテゴリーを提供します。 保存中のデータと転送中のデータの暗号化の仕組みと同様に、Runtime Encryption は、内外の脅威から保護されている鍵、データ、アプリケーションを保持します。この脅威には、悪意のある内部関係者、クラウド・プロバイダー、OS レベルのハッキング、またはネットワークの侵入者などが含まれる場合があります。</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} は、x86 アーキテクチャーの拡張であり、アプリケーションを完全に隔離されたセキュアなエンクレーブで実行する機能を提供します。アプリケーションは、同じシステムで実行される他のアプリケーションから隔離されるだけでなく、オペレーティング・システムやハイパーバイザー (使用する場合) からも隔離されます。この隔離によって、開始されたアプリケーションが管理者によって改ざんされることを防ぐこともできます。セキュアなエンクレーブのメモリーも暗号化され、物理的な攻撃を阻止できます。 このテクノロジーによって、永続データを安全に保管して、セキュアなエンクレーブからのみ読み取れるようにすることもできます。</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) では、Docker コンテナー、Kubernetes テクノロジー、直観的なユーザー・エクスペリエンス、標準装備のセキュリティーと分離機能を組み合わせることにより、コンテナー化アプリの処理を自動化する強力なツールが提供されます。</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) を使用すると、サービスにおいてユーザーをセキュアに認証できるようになり、{{site.data.keyword.cloud_notm}} 全体で一貫した方法でリソースへのアクセスを制御できます。 ユーザーが特定アクションを実行しようとすると、制御システムは、ポリシーで定義された属性を使用して、ユーザーにそのタスクの実行許可があるかどうかを判別します。 Tivoli Information Archive Manager から取得できる {{site.data.keyword.cloud_notm}} API キーをユーザー ID として使用して、CLI や自動ログインで認証を受けることができます。</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>{{site.data.keyword.containerlong_notm}} で[ロギング構成](/docs/containers?topic=containers-health)を作成してログを [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started) に転送し、ログ収集、ログ保存、ログ検索の機能を拡張できます。このサービスを使用すると、洞察を集約する機能、ログを暗号化する機能、必要な期間だけログ・データを保存する機能を利用することもできます。</dd>
</dl>
