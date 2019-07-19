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

# 常见问题 (FAQ)
{: #faq}

此常见问题提供了对 {{site.data.keyword.datashield_full}} 服务相关常见问题的解答。
{: shortdesc}


## 什么是封套认证？何时以及为何需要封套认证？
{: #enclave-attestation}
{: faq}

在平台上，封套通过不可信代码进行实例化。因此，对封套供应应用程序机密信息之前，必须能够确认在受 Intel® SGX 保护的平台上已正确实例化封套。这是由远程认证过程完成的。远程认证包括使用 Intel® SGX 指令和平台软件来生成“quote”。此 quote 将封套摘要和相关封套数据与平台特有的非对称密钥的摘要合并到一个数据结构中，并通过认证的通道发送到远程服务器。如果远程服务器得出的结论是，封套已按预期实例化，并且正在真正的支持 Intel® SGX 的处理器上运行，那么它根据需要供应封套。


## {{site.data.keyword.datashield_short}} 当前支持哪些语言？
{: #language-support}
{: faq}

该服务将 SGX 语言支持从 C 和 C++ 扩展至 Python 和 Java®。它还为 MariaDB、NGINX 和 Vault 提供了预先转换的 SGX 应用程序，几乎无需代码更改。


##	我如何得知我的工作程序节点上是否启用了 Intel SGX？
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} 软件会在安装过程中检查工作程序节点上的 SGX 可用性。如果安装成功，那么可以在 Enclave Manager UI 上查看节点的详细信息以及 SGX 认证报告。


##	我如何得知我的应用程序是否在 SGX 封套中运行？
{: #running-app}
{: faq}

[登录](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin)到您的 Enclave Manager 帐户，并导航至**应用程序**选项卡。在**应用程序**选项卡上，您可以通过证书的形式查看有关应用程序的 Intel® SGX 认证的信息。可随时通过使用 Intel Remote Attestation Service (IAS) 来验证应用程序是否在已验证的封套中运行，从而验证应用程序封套。



## 在 {{site.data.keyword.datashield_short}} 上运行应用程序会带来怎样的性能影响？
{: #impact}
{: faq}


应用程序的性能取决于工作负载的性质。如果您有 CPU 密集型工作负载，那么 {{site.data.keyword.datashield_short}} 对应用程序的影响极小。但是，如果您有内存或 I/O 密集型应用程序，那么您可能会注意到由于页面调度和上下文切换而产生的影响。通常，您可以通过应用程序相对于 SGX 封套页面高速缓存的内存占用量的大小确定 {{site.data.keyword.datashield_short}} 的影响。
