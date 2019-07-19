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

# 关于服务
{: #about}

通过 {{site.data.keyword.datashield_full}}、Fortanix® 和 Intel® SGX，您可以在使用 {{site.data.keyword.cloud_notm}} 上运行的容器工作负载中的数据时保护该数据。
{: shortdesc}

在保护您的数据时，加密是最常用、最有效的控件之一。 但是，要真正保护数据安全，必须在数据生命周期的每个步骤对数据进行加密。在生命周期中，数据分为三种状态。即静态数据、动态数据或者使用中数据。静态数据和动态数据通常是保护数据时关注的焦点。但是，应用程序开始运行后，CPU 和内存使用的数据易受各种攻击。攻击可能来自恶意内部人员、root 用户、凭证泄露、操作系统零天、网络入侵者等。为了使保护更进一步，您现在可以加密使用中的数据。 

使用 {{site.data.keyword.datashield_short}}，您的应用程序代码和数据在 CPU 固化的封套中运行。封套是工作程序节点上内存的可信区域，用于保护应用程序的关键方面。封套可帮助使代码和数据保持机密性，并防止修改。如果您或贵公司由于内部政策、政府法规或行业合规性需求而需要数据敏感度，那么此解决方案可帮助您迁移到云。示例用例包括财务和医疗保健机构或者其中的政府政策需要内部部署云解决方案的国家或地区。


## 集成
{: #integrations}

为了向您提供极致无缝体验，{{site.data.keyword.datashield_short}} 与其他 {{site.data.keyword.cloud_notm}} 服务、Fortanix® 以及 Intel® SGX 集成。

<dl>
  <dt>Fortanix®</dt>
    <dd>通过 [Fortanix Runtime Encryption](https://fortanix.com/){: external}，您可以持续保护最有价值的应用程序和数据，即使基础架构遭到破坏也是如此。Fortanix 基于 Intel SGX 进行构建，提供了名为“运行时加密”的新类别的数据安全性。与静态数据加密和动态数据加密的方式类似，运行时加密会持续保护密钥、数据和应用程序不受外部和内部威胁的影响。威胁可能来自恶意内部人员、云提供者、操作系统级别黑客或网络入侵者。</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} 是 x86 体系结构的扩展，允许您在全面隔离的安全封套中运行应用程序。应用程序不仅与在同一系统上运行的其他应用程序隔离，还与操作系统和可能的系统管理程序隔离。此隔离还将阻止管理员在应用程序启动后对其进行篡改。此外，还会对安全的封套的内存进行加密，以阻止物理攻击。该技术还支持安全地存储持久数据，以使其只能由安全的封套读取。</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) 通过组合 Docker 容器、Kubernetes 技术、直观的用户体验以及内置安全性和隔离，提供强大的工具来自动使用容器化的应用程序。</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) 使您能够安全地认证服务用户，并在 {{site.data.keyword.cloud_notm}} 中一致地控制对资源的访问。用户尝试完成特定操作时，控制系统会使用策略中定义的属性来确定用户是否有权执行该任务。{{site.data.keyword.cloud_notm}} API 密钥通过 Tivoli Information Archive Manager 提供，供您使用 CLI 进行认证或以您的用户身份进行自动化登录。</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>您可以通过 {{site.data.keyword.containerlong_notm}} 将日志转发到 [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started) 来创建[日志记录配置](/docs/containers?topic=containers-health)，进而扩展日志收集、保留和搜索功能。通过此服务，您还可以根据需要随时利用集中化的洞察、日志加密以及日志数据保留。</dd>
</dl>
