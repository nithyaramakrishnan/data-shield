---
copyright:
  years: 2018, 2020
lastupdated: "2020-09-21"

keywords: data protection, remote attestation, intel, nodes, remote server, enclaves, sgx language support, runtime encryption, memory, data in use,

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:faq: data-hd-content-type='faq'}
{:gif: data-image-type='gif'}
{:important: .important}
{:note: .note}
{:pre: .pre}
{:tip: .tip}
{:preview: .preview}
{:deprecated: .deprecated}
{:shortdesc: .shortdesc}
{:support: data-reuse='support'}
{:script: data-hd-video='script'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:video: .video}
{:step: data-tutorial-type='step'}
{:tutorial: data-hd-content-type='tutorial'}


# Frequently asked questions (FAQ)
{: #faq}

This FAQ provides answers to common questions about the {{site.data.keyword.datashield_full}} service.
{: shortdesc}


## What is enclave attestation? When and why is it required?
{: #enclave-attestation}
{: faq}

Enclaves are instantiated on platforms by untrusted code. So, before enclaves are provisioned with application confidential information, it is essential to be able to confirm that the enclave was correctly instantiated on a platform that is protected by Intel® SGX. This is done by a remote attestation process. Remote attestation consists of using Intel® SGX instructions and platform software to generate a “quote”. The quote combines the enclave digest with a digest of relevant enclave data and a platform-unique asymmetric key into a data structure that is sent to a remote server over an authenticated channel. If the remote server concludes that the enclave was instantiated as intended and is running on a genuine Intel® SGX-capable processor, it provisions the enclave as required.


## What languages are currently supported?
{: #language-support}
{: faq}
{: support}

The service extends SGX language support from C and C++ to Python and Java®. It also provides pre-converted SGX applications for MariaDB, NGINX, and Vault, with little-to-no code change.


##	How do I know whether Intel SGX is enabled on my worker node?
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} software checks for SGX availability on the worker node during the installation process. If the installation is successful, the node's detailed information as well as SGX attestation report can be viewed on the Enclave Manager UI.


##	How do I know that my application is running in an SGX enclave?
{: #running-app}
{: faq}
{: support}

[Log in](/docs/data-shield?topic=data-shield-enclave-manager#em-signin) to your Enclave Manager account and navigate to the **Apps** tab. On the **Apps** tab, you can see information about the Intel® SGX attestation for your applications in the form of a certificate. The applications enclave can be verified at any time by using Intel Remote Attestation Service (IAS) to verify that the application is running in a verified enclave.


## What is the performance impact of running the application on {{site.data.keyword.datashield_short}}?
{: #impact}
{: faq}
{: support}


The performance of your application depends on the nature of your workload. If you have a CPU intensive workload, the effect that {{site.data.keyword.datashield_short}} has on your app is minimal. But, if you have memory or I/O intensive applications you might notice an effect due to paging and context switching. The size of the memory footprint of your app in relation to the SGX enclave page cache is generally how you can determine {{site.data.keyword.datashield_short}}'s impact.
