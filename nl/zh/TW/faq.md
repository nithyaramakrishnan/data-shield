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

# 常見問題 (FAQ)
{: #faq}

此常見問題提供 {{site.data.keyword.datashield_full}} 服務常見問題的回答。
{: shortdesc}


## 何謂區域認證？何時及為何需要它？
{: #enclave-attestation}
{: faq}

區域由未受信任程式碼在平台上實例化。因此，在使用應用程式機密資訊來佈建之前，能夠確認已在 Intel ® SGX 保護的平台上正確地實例化區域非常重要。這是由遠端認證處理程序來完成。遠端認證包括使用 Intel® SGX 指令 / 指示和平台軟體來產生 "quote" 。引用會結合區域摘要與相關區域資料的摘要以及平台唯一的非對稱金鑰摘要，成為透過已鑑別通道傳送至遠端伺服器的資料結構。如果遠端伺服器推斷區域依預期實例化並且在真正的 Intel® SGX 功能的處理器上執行，則它會視需要佈建區域。


## {{site.data.keyword.datashield_short}} 目前支援哪些語言？
{: #language-support}
{: faq}

該服務將 SGX 語言支援從 C 和 C++ 延伸至 Python 和 Java®。它還透過少許（或者不需要）程式碼變更來針對 MariaDB、NGINX 和 Vault 提供預先轉換的 SGX 應用程式。


##	如何得知工作者節點上是否啟用 Intel SGX？
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} 軟體會在安裝程序中檢查工作者節點上的 SGX 可用性。如果安裝成功，則可以在「區域管理程式使用者介面」上檢視節點的詳細資訊及 SGX 認證報告。


##	我如何得知我的應用程式是否在 SGX 封套中執行？
{: #running-app}
{: faq}

[登入](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin)您的「區域管理程式」帳戶，然後導覽至**應用程式**標籤。在**應用程式**標籤上，您可以透過憑證的形式，查看應用程式的 Intel® SGX 認證相關資訊。您可以隨時利用 Intel 遠端認證服務 (IAS) 來驗證應用程式區域，以驗證應用程式是否在已驗證的區域中執行。



## 在{{site.data.keyword.datashield_short}}上執行應用程式的效能影響為何？
{: #impact}
{: faq}


應用程式的效能由工作負載的本質決定。如果您有 CPU 密集的工作負載，則 {{site.data.keyword.datashield_short}} 對您應用程式的影響最小。但是，如果您有記憶體或 I/O 密集的應用程式，則可能會看到分頁和環境定義切換造成的影響。您的應用程式的記憶體覆蓋區的大小和 SGX 區域頁面快取的關係，通常可讓您判定對 {{site.data.keyword.datashield_short}} 的影響程度。
