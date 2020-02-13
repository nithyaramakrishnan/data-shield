---

copyright:
  years: 2018, 2020
lastupdated: "2020-02-11"

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


![Types of encryption shown in an image. Includes data at rest, in motion, and in use.](images/encryption-types.png){: caption="Figure 1. Types of encryption" caption-side="bottom"}

When it comes to protecting your data, encryption is one of the most popular and effective controls. But, the data must be encrypted at each step of its lifecycle for your data to really be secure. During its lifecycle, data has three phases. It can be at rest, in motion, or in use. Data at rest and in motion are generally the area of focus when you think of securing your data. But, after an application starts to run, data that is in use by CPU and memory is vulnerable to various attacks. The attacks might include malicious insiders, root users, credential compromise, OS zero-day, network intruders, and others. Enter - {{site.data.keyword.datashield_short}}.



## How it works
{: #architecture}

With {{site.data.keyword.datashield_short}}, you can secure your data while it is in use.

![An example Data Shield enabled cluster.](images/ds-arch.png){: caption="Figure 1. Cluster set up" caption-side="bottom"}


On your worker node, you might have several different applications running at the same time. To fully secure your app data, you can run any of the apps that handle sensitive information within an enclave. Enclaves are trusted areas of memory that keep code and data confidential and secure. The information in the enclave cannot be read or modified in anyway by anything outside the enclave - including processes that run at higher privilege levels.

IBM Cloud Data Shield achieves this level of security by establishing trust through Elliptic Curve Digital Signature Algorithm (ECDSA)-based remote attestation. An attestation report provides information like the identity of the software, details of an execution, and an assessment of any possible software tampering. After the enclave establishes trust, an encrypted communication channel is established.

If you or your company require data sensitivity because of internal policies, government regulations, or industry compliance requirements, this solution might help you to move to the cloud.


## Integrated technologies
{: #integrations}

{{site.data.keyword.datashield_short}} is built by combining several technologies.

<dl>
  <dt>Intel SGX</dt>
    <dd>With <a href="https://software.intel.com/en-us/sgx" target="_blank" class="external">Intel SGX</a>, which is an extension to the x86 architecture, you can run applications in a fully isolated, secure enclave. Because it is only offered on a bare metal server, the application isn't only isolated from other applications that run on the same system, but also from the Operating System and possible Hypervisor. The isolation also prevents administrators from tampering with the application after it's started. The memory of secure enclaves is also encrypted to thwart physical attacks. The technology also supports storing persistent data securely such that it can be read only by the secure enclave.</dd>
  <dt>Fortanix Runtime Encryption</dt>
    <dd>With <a href="https://fortanix.com/" target="_blank" class="external">Fortanix Runtime Encryption</a> you can keep your most valuable apps and data protected, even when the infrastructure is compromised. Built on Intel SGX, Fortanix provides a new category of data security. Similar to the way encryption works for data at rest and data during motion, runtime encryption keeps keys, data, and applications protected from external and internal threats.</dd>
  <dt>Container orchestration tools</dt>
    <dd><a href="/docs/containers?topic=containers-getting-started">{{site.data.keyword.containerlong_notm}}</a> delivers powerful tools by combining Docker containers, the Kubernetes technology, an intuitive user experience, and built-in security and isolation to automate working with containerized apps.</dd></br>
    <dd><a href="/docs/openshift?topic=openshift-getting-started">{{site.data.keyword.openshiftlong_notm}}</a> combines the power of {{site.data.keyword.containerlong_notm}} with the best of IBM Cloud container orchestration software. You get all of the benefits of managed {{site.data.keyword.containerlong_notm}} and you gain the flexibility to use <a href="https://docs.openshift.com/container-platform/3.11/welcome/index.html">OpenShift tools</a> such as Red Hat Enterprise Linux® for your app deployments.</dd>
  <dt>Access control</dt>
    <dd>With <a href="/docs/iam?topic=iam-getstarted">{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</a>, you can securely authenticate users for services and control access to resources consistently across {{site.data.keyword.cloud_notm}}. When a user tries to complete a specific action, the control system uses the attributes that are defined in the policy to determine whether the user has permission to perform that task. You can get {{site.data.keyword.cloud_notm}} API keys through IAM and then use them to authenticate your user identity through the CLI or as part of automation.</dd>
  <dt>Logging</dt>
    <dd>Activity logs for Helm install, update, and delete are captured by your respective Kubernetes Service audit logs.</dd></br>
    <dd>With {{site.data.keyword.la_full_notm}}, you can expand your log collection, retention, and search abilities by creating a <a href="/docs/containers?topic=containers-health">logging configuration</a> through the {{site.data.keyword.containerlong_notm}} that forwards your logs to <a href="/docs/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started">{{site.data.keyword.la_full_notm}}</a>. With the service, you can also take advantage of centralized insights, log encryption, and log data retention while you need.</dd>
  <dt>Certificate management</dt>
    <dd>Cert manager is a native Kubernetes add on that helps to manage the certificates by issuing self-signed certificates from the Enclave Manager.</dd>
</dl>


## Business partner
{: #partner}

{{site.data.keyword.datashield_short}} is offered in conjunction with <a href="https://fortanix.com/" target="_blank" class="external">Fortanix®</a>. 



## Disaster recovery
{: #disaster-recovery}

When you work with {{site.data.keyword.datashield_short}}, you are responsible for the backup and recovery of your data. For more information about backing up your instance of the Enclave Manager, see [Backing up and restoring](/docs/data-shield?topic=data-shield-backup-restore).

