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
{:faq: data-hd-content-type='faq'}

# よくある質問 (FAQ)
{: #faq}

この FAQ では、{{site.data.keyword.datashield_full}} サービスに関する、よくある質問の答えを記載しています。
{: shortdesc}


## エンクレーブ認証とは何ですか? どのような場合に必要で、なぜ必要なのですか?
{: #enclave-attestation}
{: faq}

エンクレーブは、信頼されていないコードによって、プラットフォーム上にインスタンス化されます。 そのため、エンクレーブにアプリケーションの機密情報を入れてプロビジョンする前に、Intel® SGX によって保護されているプラットフォーム上にエンクレーブが適切にインスタンス化されていることを確認できることが必要です。 これは、リモート認証プロセスによって行われます。 リモート認証は、Intel® SGX 命令とプラットフォーム・ソフトウェアを使用して「クオート」を生成することによって行われます。見積もりは、エンクレーブのダイジェストと、関連するエンクレーブ・データとプラットフォーム固有の非対称鍵のダイジェストを、1 つのデータ構造に結合したもので、認証済みチャネルを介してリモート・サーバーに送信されます。 エンクレーブが意図したとおりにインスタンス化されていて Intel® 純正の SGX 対応プロセッサーで稼働しているとリモート・サーバーが判断すると、そこで必要に応じてエンクレーブがプロビジョンされます。


## {{site.data.keyword.datashield_short}} では、現在どの言語がサポートされていますか?
{: #language-support}
{: faq}

このサービスは、SGX の言語サポートを、C と C++ だけでなく Python と Java® も使えるように拡張します。また、MariaDB、NGINX、Vault に関しても、コード変更をほとんどしなくても (あるいはまったくしなくても) 使用できる、事前に変換された SGX アプリケーションが用意されています。


##	自分のワーカー・ノード上で Intel SGX が使用可能かどうか確認する方法を教えてください。
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} ソフトウェアが、インストール・プロセスの際にワーカー・ノード上で SGX を使用できるかどうかを検査します。インストールが成功すると、ノードの詳細情報と SGX 認証レポートを Enclave Manager UI で表示できるようになります。


##	アプリケーションが SGX エンクレーブ内で実行されているかどうか確認する方法を教えてください。
{: #running-app}
{: faq}

Enclave Manager アカウントに[ログイン](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin)して、**「アプリ (Apps)」**タブに移動します。 **「アプリ (Apps)」**タブには、アプリケーションの Intel® SGX 認証に関する情報が、証明書の形式で表示されています。Intel Remote Attestation Service (IAS) を使用してアプリケーションが検証済みのエンクレーブで実行されていることを検証することによって、いつでもアプリケーションのエンクレーブを確認できます。



## アプリケーションを {{site.data.keyword.datashield_short}} 上で実行することで、どのようなパフォーマンス上の影響がありますか?
{: #impact}
{: faq}


アプリケーションのパフォーマンスは、ワークロードの性質に依存します。 CPU の負荷が高いワークロードでは、{{site.data.keyword.datashield_short}} がアプリに与える影響は最小限にとどまります。 ただし、メモリーまたは入出力の負荷が高いアプリケーションを使用する場合は、ページングやコンテキスト切り替えに伴う影響が見られる場合があります。一般に、SGX エンクレーブ・ページ・キャッシュに関連する、アプリのメモリー占有スペースのサイズによって、{{site.data.keyword.datashield_short}} の影響を判別できます。
