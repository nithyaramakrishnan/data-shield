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

# About the service
{: #about}

With {{site.data.keyword.datashield_full}}, Fortanix®, and Intel® SGX you can protect the data in your container workloads that run on {{site.data.keyword.cloud_notm}} while your data is in use.
{: shortdesc}

When it comes to protecting your data, encryption is one of the most popular and effective controls. But, the data must be encrypted at each step of its lifecycle for your data to really be secure. During its lifecycle, data has three phases. It can be at rest, in motion, or in use. Data at rest and in motion are generally the area of focus when you think of securing your data. But, after an application starts to run, data that is in use by CPU and memory is vulnerable to various attacks. The attacks might include malicious insiders, root users, credential compromise, OS zero-day, network intruders, and others. Taking that protection one step further, you can now encrypt data in use. 

With {{site.data.keyword.datashield_short}}, your app code and data run in CPU-hardened enclaves. The enclaves are trusted areas of memory, on the worker node, that protect the critical aspects of your apps. The enclaves help to keep the code and data confidential and prevent modification. If you or your company require data sensitivity because of internal policies, government regulations, or industry compliance requirements, this solution might help you to move to the cloud. Example use cases include financial and healthcare institutions or countries with government policies that require on-premises cloud solutions.


## Integrations
{: #integrations}

To provide the most seamless experience for you, {{site.data.keyword.datashield_short}} is integrated with other {{site.data.keyword.cloud_notm}} services, Fortanix®, and Intel® SGX.

<dl>
  <dt>Fortanix®</dt>
    <dd>With [Fortanix Runtime Encryption](https://fortanix.com/){: external} you can keep your most valuable apps and data protected, even when the infrastructure is compromised. Built on Intel SGX, Fortanix provides a new category of data security called Runtime Encryption. Similar to the way encryption works for data at rest and data during motion, runtime encryption keeps keys, data, and applications that are protected from external and internal threats. The threats might include malicious insiders, cloud providers, OS-level hacks, or network intruders.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} is an extension to the x86 architecture that allows you to run applications in a fully isolated, secure enclave. The application isn't only isolated from other applications that run on the same system, but also from the Operating System and possible Hypervisor. The isolation also prevents administrators from tampering with the application after it's started. The memory of secure enclaves is also encrypted to thwart physical attacks. The technology also supports storing persistent data securely such that it can be read only by the secure enclave.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) delivers powerful tools by combining Docker containers, the Kubernetes technology, an intuitive user experience, and built-in security and isolation to automate working with containerized apps.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) enables you to securely authenticate users for services and control access to resources consistently across {{site.data.keyword.cloud_notm}}. When a user tries to complete a specific action, the control system uses the attributes that are defined in the policy to determine whether the user has permission to perform that task. {{site.data.keyword.cloud_notm}} API keys are available through Tivoli Information Archive Manager that you can use to authenticate through the CLI or as part of automation to log in as your user identity.</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>You can expand your log collection, retention, and search abilities by creating a [logging configuration](/docs/containers?topic=containers-health) through the {{site.data.keyword.containerlong_notm}} that forwards your logs to [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started).
    With the service, you can also take advantage of centralized insights, log encryption, and log data retention for as long as you need.</dd>
</dl>
