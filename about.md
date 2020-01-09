---

copyright:
  years: 2018, 2020
lastupdated: "2020-01-09"

keywords: confidential computing, secure data, encryption, Fortanix, runtime encryption, memory, encrypt, app security, private data, Intel, SGX, convert, protect, data in use, data protection, containerized apps, 

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

With {{site.data.keyword.datashield_full}}, Fortanix®, and Intel® SGX you can protect the data in your containerized workloads that run on {{site.data.keyword.containershort_notm}} while your data is in use.
{: shortdesc}

When it comes to protecting your data, encryption is one of the most popular and effective controls. But, the data must be encrypted at each step of its lifecycle for your data to really be secure. During its lifecycle, data has three phases. It can be at rest, in motion, or in use. Data at rest and in motion are generally the area of focus when you think of securing your data. But, after an application starts to run, data that is in use by CPU and memory is vulnerable to various attacks. The attacks might include malicious insiders, root users, credential compromise, OS zero-day, network intruders, and others. Taking that protection one step further, you can now encrypt data in use. 

With {{site.data.keyword.datashield_short}}, your app code and data run in CPU-hardened enclaves. The enclaves are trusted areas of memory, on the worker node, that protect the critical aspects of your apps. The enclaves help to keep the code and data confidential and prevent modification. If you or your company require data sensitivity because of internal policies, government regulations, or industry compliance requirements, this solution might help you to move to the cloud. Example use cases include financial and healthcare institutions or countries with government policies that require on-premises cloud solutions.


## Integrations
{: #integrations}

To provide the best experience possible for you, {{site.data.keyword.datashield_short}} is integrated with other {{site.data.keyword.cloud_notm}} services, Fortanix®, and Intel® SGX.


<dl>
  <dt>Fortanix®</dt>
    <dd>With <a href="https://fortanix.com/" target="_blank" class="external">Fortanix Runtime Encryption</a> you can keep your most valuable apps and data protected, even when the infrastructure is compromised. Built on Intel SGX, Fortanix provides a new category of data security called Runtime Encryption. Similar to the way encryption works for data at rest and data during motion, runtime encryption keeps keys, data, and applications that are protected from external and internal threats. The threats might include malicious insiders, cloud providers, OS-level hacks, or network intruders.</dd>
  <dt>Intel® SGX</dt>
    <dd>With <a href="https://software.intel.com/en-us/sgx" target="_blank" class="external">Intel SGX</a>, which is an extension to the x86 architecture, you can run applications in a fully isolated, secure enclave. The application isn't only isolated from other applications that run on the same system, but also from the Operating System and possible Hypervisor. The isolation also prevents administrators from tampering with the application after it's started. The memory of secure enclaves is also encrypted to thwart physical attacks. The technology also supports storing persistent data securely such that it can be read only by the secure enclave.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd><a href="/docs/containers?topic=containers-getting-started">{{site.data.keyword.containerlong_notm}}</a> delivers powerful tools by combining Docker containers, the Kubernetes technology, an intuitive user experience, and built-in security and isolation to automate working with containerized apps.</dd>
  <dt>{{site.data.keyword.openshiftlong_notm}} (Technology preview)</dt>
    <dd><a href="/docs/openshift?topic=openshift-getting-started">{{site.data.keyword.openshiftlong_notm}}</a> combines the power of {{site.data.keyword.containerlong_notm}} with the best of IBM Cloud container orchestration software. You get all of the benefits of managed {{site.data.keyword.containerlong_notm}} and you gain the flexibility to use <a href="https://docs.openshift.com/container-platform/3.11/welcome/index.html">OpenShift tools</a> such as Red Hat Enterprise Linux® for your app deployments.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>With <a href="/docs/iam?topic=iam-getstarted">IAM</a>, you can securely authenticate users for services and control access to resources consistently across {{site.data.keyword.cloud_notm}}. When a user tries to complete a specific action, the control system uses the attributes that are defined in the policy to determine whether the user has permission to perform that task. You can get {{site.data.keyword.cloud_notm}} API keys through IAM and then use them to authenticate your user identity through the CLI or as part of automation.</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>You can expand your log collection, retention, and search abilities by creating a <a href="/docs/containers?topic=containers-health">logging configuration</a> through the {{site.data.keyword.containerlong_notm}} that forwards your logs to <a href="/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started">{{site.data.keyword.la_full_notm}}</a>. With the service, you can also take advantage of centralized insights, log encryption, and log data retention while you need.</dd>
</dl>

## Disaster recovery
{: #disaster-recovery}

When you work with {{site.data.keyword.datashield_short}}, you are responsible for the backup and recovery of your data. For more information about backing up your instance of the Enclave Manager, see [Backing up and restoring](/docs/services/data-shield?topic=data-shield-backup-restore).

