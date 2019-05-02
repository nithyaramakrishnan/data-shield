---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

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

# サービスについて
{: #about}

{{site.data.keyword.datashield_full}}、Fortanix®、および Intel® SGX を使用すると、{{site.data.keyword.cloud_notm}} で実行されるコンテナー・ワークロード内のデータの使用中に、データを保護することができます。
{: shortdesc}

データの保護という点に関しては、最も一般的で効果的な手段の一つとして、暗号化が挙げられます。しかし、データを確実に保護するには、データのライフサイクルの各ステップで暗号化する必要があります。データのライフサイクルは、Data at Rest (保存されたデータ)、Data in Motion (流れているデータ)、および Data in Use (使用中のデータ) の 3 つのフェーズに分けられます。Data at Rest と Data in Motion は、保管時と転送時にデータを保護するために一般的に使用されるフェーズです。アプリケーションの実行が開始すると、CPU やメモリーによって使用されるデータは、悪意のある内部関係者や root ユーザー、資格情報の漏えい、OS のゼロ・デイ攻撃、ネットワーク侵入者など、さまざまな攻撃に対して脆弱になります。保護手段をさらに一歩進めて、Data in Use を暗号化できるようになりました。 

{{site.data.keyword.datashield_short}} では、アプリのコードとデータは、CPU で強化されたエンクレーブ内で実行されます。これはワーカー・ノード上の信頼されたメモリーの領域で、アプリの重要な部分を保護します。エンクレーブは、コードとデータの機密を保護し、変更されないようにします。お客様またはお客様の会社が、内部ポリシー、政府規制、または業界のコンプライアンス要件によりデータの機密性を確保する必要がある場合、このソリューションがクラウドへの移行をサポートします。ユース・ケースの例には、金融機関や医療機関、政府の方針としてオンプレミスのクラウド・ソリューションの設置を定める国などが含まれます。


## 統合
{: #integrations}

シームレスな環境を実現するために、{{site.data.keyword.datashield_short}} は他の {{site.data.keyword.cloud_notm}} サービス、Fortanix® Runtime Encryption、および Intel SGX® と統合されています。

<dl>
  <dt>Fortanix®</dt>
    <dd>[Fortanix](http://fortanix.com/) では、インフラストラクチャーが漏えいの被害にあったとしても、最も重要なアプリとデータを保護することができます。Intel SGX 上に構築された Fortanix は、Runtime Encryption と呼ばれるデータ・セキュリティーの新しいカテゴリーを提供します。Data at Rest と Data in Motion での暗号化の仕組みと同様に、Runtime Encryption は、鍵、データ、およびアプリケーションを内外の脅威から完全に保護します。この脅威には、悪意のある内部関係者、クラウド・プロバイダー、OS レベルのハッキング、またはネットワークの侵入者などが含まれる場合があります。</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx) は、x86 アーキテクチャーの拡張機能で、アプリケーションを完全に隔離されたセキュアなエンクレーブで実行する機能を提供します。アプリケーションは、同じシステムで実行される他のアプリケーションから隔離されるだけでなく、オペレーティング・システムやハイパーバイザー (使用する場合) からも隔離されます。これにより、開始されたアプリケーションが管理者によって改ざんされることを防ぐことができます。セキュアなエンクレーブのメモリーも暗号化され、物理的な攻撃を阻止できます。このテクノロジーによって、永続データを安全に保管して、セキュアなエンクレーブからのみ読み取れるようにすることもできます。</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started) では、Docker コンテナー、Kubernetes テクノロジー、直観的なユーザー・エクスペリエンス、標準装備のセキュリティーと分離機能を結合させることにより、コンピュート・ホストのクラスター内でコンテナー化アプリのデプロイメント、操作、スケーリング、モニタリングを自動化する強力なツールが提供されます。</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted) を使用すると、サービスにおいてユーザーをセキュアに認証できるようになり、{{site.data.keyword.cloud_notm}} 全体で一貫した方法でリソースへのアクセスを制御できます。ユーザーが特定アクションを実行しようとすると、制御システムは、ポリシーで定義された属性を使用して、ユーザーにそのタスクの実行許可があるかどうかを判別します。Cloud IAM から入手できる {{site.data.keyword.cloud_notm}} API キーをユーザー ID として使用して、CLI またはログイン自動化を利用して認証を行うことができます。</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>{{site.data.keyword.containerlong_notm}} で[ロギング構成](/docs/containers?topic=containers-health#health)を作成して、ログを[{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla)に転送できます。{{site.data.keyword.cloud_notm}} では、ログ収集、ログ保存、およびログ検索の機能を拡張できます。アプリケーションまたは環境に関する総合的な洞察を得るためにアプリケーションおよび環境のログを集約する機能や、ログを暗号化する機能、必要な期間だけログ・データを保存する機能、問題を素早く検出してトラブルシューティングする機能などを DevOps チームで使用できるようになります。</dd>
</dl>
