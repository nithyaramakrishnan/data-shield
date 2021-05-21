---
copyright:
  years: 2018, 2021
lastupdated: "2021-05-21"

keywords: enclave manager, container, convert, private registry, credentials, permissions, error, docker, support, cert manager, tokens, sgx, authentication, intel, fortanix, runtime encryption, memory protection, data in use,

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
{:beta: .beta}
{:term: .term}
{:shortdesc: .shortdesc}
{:script: data-hd-video='script'}
{:support: data-reuse='support'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:java: .ph data-hd-programlang='java'}
{:javascript: .ph data-hd-programlang='javascript'}
{:swift: .ph data-hd-programlang='swift'}
{:curl: .ph data-hd-programlang='curl'}
{:video: .video}
{:step: data-tutorial-type='step'}
{:tutorial: data-hd-content-type='tutorial'}


# Why did the SGX driver installation fail?

## Error: `datashield-sgx` pod fails
{: #data-shield-sgx-pod}


{: tsSymptoms}
You encounter the following error when you try to install the SGX driver.

```
Starting SGX Installer
UBUNTU
Verifying archive integrity... All good.
Uncompressing SGX base drivers installer
Reading package lists...
Building dependency tree...
Reading state information...
libprotobuf9v5 is already the newest version (2.6.1-1.3).
dkms is already the newest version (2.2.0.3-2ubuntu11.8).
libcurl3 is already the newest version (7.47.0-1ubuntu2.14).
linux-headers-4.4.0-157-generic is already the newest version (4.4.0-157.185).
0 upgraded, 0 newly installed, 0 to remove and 82 not upgraded.
1 not fully installed or removed.
After this operation, 0 B of additional disk space will be used.
Setting up libsgx-enclave-common (2.4.100.48163-xenial1) ...
cp: cannot stat '/opt/intel/libsgx-enclave-common/aesm/data': No such file or directory
dpkg: error processing package libsgx-enclave-common (--configure):
 subprocess installed post-installation script returned error exit status 1
Processing triggers for libc-bin (2.23-0ubuntu11) ...
Errors were encountered while processing:
 libsgx-enclave-common
  100%  E: Sub-process /usr/bin/dpkg returned an error code (1)
```
{: screen}

{: tsCauses}
You might have a library, such as `libsgx-enclave-common`, that is incorrectly installed.

{: tsResolve}
To resolve the issue, try uninstalling the library and then reinstalling the driver.

1. Uninstall the library.

  ```
  dpkg --purge libsgx-enclave-common
  ```
  {: codeblock}

2. Access the worker node on your cluster and restart it.

3. Reinstall the SGX driver, which runs the `datashield-sgx` and installs the necessary packages.
