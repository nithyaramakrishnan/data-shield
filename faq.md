---

copyright:
  years: 2018, 2019
lastupdated: "2019-01-21"

---

{:new_window: target="_blank"}
{:shortdesc: .shortdesc}
{:tip: .tip}
{:screen: .screen}
{:codeblock: .codeblock}
{:pre: .pre}

# Frequently asked questions (FAQ)
{: #about}

This FAQ provides answers to common questions about the {{site.data.keyword.datashield_full}} service.
{: shortdesc}


## What is enclave attestation? When and why is it required?
{: #enclave-attestation}
{: faq}

Since enclaves are instantiated on platforms by untrusted code, before enclaves are provisioned with application confidential information, it is essential to be able to confirm that the desired enclave was correctly instantiated on a platform protected by Intel SGX. This is done by a remote attestation process. Remote attestation consists of using Intel SGX instructions and platform software to generate a “quote” that combines the enclave digest with a digest of relevant enclave data and a platform-unique asymmetric key into a data structure that is sent to a remote server over an authenticated channel. If the remote server concludes that the enclave was instantiated as intended and is running on a genuine Intel SGX-capable processor, it will provision the enclave as required.

</br>

##	What languages are currently supported from {{site.data.keyword.datashield_short}}?
{: #language-support}
{: faq}

The service extends SGX language support from C and C++ to Python and Java. It also provides pre-converted SGX applications for MySQL, NGINX, and Vault, with little to no code change.

</br>

##	How do I know if Intel SGX is enabled on my worker node?
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} software checks for SGX availability on the worker node during the install process. If the installation is successful, the node's detailed information as well as SGX attestation report can be viewed on the Enclave Manager UI.

</br>

##	How do I know my application is running in SGX enclave?
{: #running-app}
{: faq}

Log in to your Enclave Manager account and navigate to the **Apps** tab. **Apps** contains information of Intel SGX attestation for your applications in the form of a certificate. The applications enclave can be verified at any time by using Intel remote attestation service (IAS) to make sure that application is running in a verified enclave.

</br>

## What is the performance impact of running the application on {{site.data.keyword.datashield_short}}?
{: #impact}
{: faq}

Performance overhead depends on the nature of the workload. For CPU intensive workload, the performance overhead is minimal. For memory and IO intensive applications, the overhead is caused due to paging and context switching. The amount of overhead generally depends on the size of the memory footprint of an application in relation to the SGX enclave page cache.

</br>
