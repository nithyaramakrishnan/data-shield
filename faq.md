---

copyright:
  years: 2018, 2019
lastupdated: "2019-10-18"

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

# Frequently asked questions (FAQ)
{: #faq}

This FAQ provides answers to common questions about the {{site.data.keyword.datashield_full}} service.
{: shortdesc}

## How is pricing calculated for {{site.data.keyword.datashield_full}}?
{: #pricing}
{: faq}

{{site.data.keyword.datashield_full}} runs on SGX enabled clusters. When you provision an instance of IBM Cloud Kubernetes Service, you are charged as outlined in your purchase for the infrastructure that you use. However, {{site.data.keyword.datashield_full}} itself is currently being offered as a promotion and is free to try.


## What is enclave attestation? When and why is it required?
{: #enclave-attestation}
{: faq}

Enclaves are instantiated on platforms by untrusted code. So, before enclaves are provisioned with application confidential information, it is essential to be able to confirm that the enclave was correctly instantiated on a platform that is protected by Intel® SGX. This is done by a remote attestation process. Remote attestation consists of using Intel® SGX instructions and platform software to generate a “quote”. The quote combines the enclave digest with a digest of relevant enclave data and a platform-unique asymmetric key into a data structure that is sent to a remote server over an authenticated channel. If the remote server concludes that the enclave was instantiated as intended and is running on a genuine Intel® SGX-capable processor, it provisions the enclave as required.


## What languages are currently supported from {{site.data.keyword.datashield_short}}?
{: #language-support}
{: faq}

The service extends SGX language support from C and C++ to Python and Java®. It also provides pre-converted SGX applications for MariaDB, NGINX, and Vault, with little-to-no code change.


##	How do I know whether Intel SGX is enabled on my worker node?
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} software checks for SGX availability on the worker node during the installation process. If the installation is successful, the node's detailed information as well as SGX attestation report can be viewed on the Enclave Manager UI.


##	How do I know that my application is running in an SGX enclave?
{: #running-app}
{: faq}

[Log in](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) to your Enclave Manager account and navigate to the **Apps** tab. On the **Apps** tab, you can see information about the Intel® SGX attestation for your applications in the form of a certificate. The applications enclave can be verified at any time by using Intel Remote Attestation Service (IAS) to verify that the application is running in a verified enclave.


## What is the performance impact of running the application on {{site.data.keyword.datashield_short}}?
{: #impact}
{: faq}


The performance of your application depends on the nature of your workload. If you have a CPU intensive workload, the effect that {{site.data.keyword.datashield_short}} has on your app is minimal. But, if you have memory or I/O intensive applications you might notice an effect due to paging and context switching. The size of the memory footprint of your app in relation to the SGX enclave page cache is generally how you can determine {{site.data.keyword.datashield_short}}'s impact.