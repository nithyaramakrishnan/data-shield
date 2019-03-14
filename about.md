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

# About the service
{: #about}

With {{site.data.keyword.datashield_full}}, Fortanix®, and Intel® SGX you can protect the data in your container workloads that run on {{site.data.keyword.cloud_notm}} while your data is in use.
{: shortdesc}

When it comes to protecting your data, encryption is one of the most popular and effective controls. But the data must be encrypted at each step of its lifecycle for your data to really be secure. Data goes through three phases during its lifecycle: data at rest, data in motion, and data in use. Data at rest and in motion are commonly used to protect data when it is stored and when it is transported. After an application starts to run, data in use by CPU and memory is vulnerable to a variety of attacks including malicious insiders, root users, credential compromise, OS zero-day, network intruders, and others. Taking that protection one step further, you can now encrypt data in use. 

With {{site.data.keyword.datashield_short}} your app code and data run in CPU-hardened enclaves, which are trusted areas of memory on the worker node that protect critical aspects of the app. The enclaves help to keep the code and data confidential and unmodified. If you or your company require data sensitivity due to internal policies, government regulations or industry compliance requirements, this solution might help you to move to the cloud. Example use cases include financial and healthcare institutions or countries with government policies that require on-premises cloud solutions.


## Integrations
{: #integrations}

To provide the most seamless experience for you, {{site.data.keyword.datashield_short}} is integrated with other {{site.data.keyword.cloud_notm}} services, Fortanix® Runtime Encryption, and Intel SGX®.

<dl>
  <dt>Fortanix®</dt>
    <dd>With [Fortanix](http://fortanix.com/) you can keep your most valuable apps and data protected, even when the infrastructure is compromised. Built on Intel SGX, Fortanix provides a new category of data security called Runtime Encryption. Similar to the way encryption works for data at rest and data during motion, runtime encryption keeps keys, data, and applications completely protected from external and internal threats. The threats might include malicious insiders, cloud providers, OS-level hacks, or network intruders.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx) is an extension to the x86 architecture that allows you to run applications in a completely isolated secure enclave. The application is not only isolated from other applications running on the same system, but also from the Operating System and possible Hypervisor. This prevents administrators from tampering with the application after it is started. The memory of secure enclaves is also encrypted to thwart physical attacks. The technology also supports storing persistent data securely such that it can only be read by the secure enclave.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-container_index#container_index) delivers powerful tools by combining Docker containers, the Kubernetes technology, an intuitive user experience, and built-in security and isolation to automate the deployment, operation, scaling, and monitoring of containerized apps in a cluster of compute hosts.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted) enables you to securely authenticate users for services and control access to resources consistently across {{site.data.keyword.cloud_notm}}. When a user tries to complete a specific action, the control system uses the attributes that are defined in the policy to determine whether the user has permission to perform that task. {{site.data.keyword.cloud_notm}} API keys are available through Cloud IAM for you to use to authenticate by using the CLI or as part of automation to log in as your user identity.</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>You can create a [logging configuration](/docs/containers?topic=containers-health#health) through the {{site.data.keyword.containerlong_notm}} that forwards your logs to [{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla). You can expand your log collection, log retention, and log search abilities in {{site.data.keyword.cloud_notm}}. Empower your DevOps team with features such as aggregation of application and environment logs for consolidated application or environment insights, encryption of logs, retention of log data for as long as it is needed, and quick detection and troubleshooting of issues.</dd>
</dl>
