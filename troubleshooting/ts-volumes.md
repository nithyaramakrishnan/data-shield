---
copyright:
  years: 2018, 2021
lastupdated: "2021-05-24"

keywords: enclave manager, container, convert, private registry, credentials, permissions, error, docker, support, cert manager, tokens, sgx, authentication, intel, fortanix, runtime encryption, memory protection, data in use,

subcollection: data-shield

content-type: troubleshoot
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


# Why can't I mount Data Shield containers to a volume?
{: #ts-container-volume}
{: troubleshoot}

You encounter issues when you try to mount Data Shield containers on volumes.
{:shortdesc}

## Unable to mount AESM-socket or SGX devices
{: #ts-problem-mounting-device}

You encounter issues when you try to mount Data Shield containers on volumes `/var/run/aesmd/aesm.socket` or `/dev/isgx`.
{: tsSymptoms}

Mounting can fail due to issues with the configuration of the host.
{: tsCauses}

To resolve the issue, verify both:
{: tsResolve}

* That `/var/run/aesmd/aesm.socket` is not a directory on the host. If it is, delete the file, uninstall the Data Shield software, and perform the installation steps again. 
* That SGX is enabled in BIOS of the host machines. If it is not enabled, contact IBM support.



## Unable to mount `datashield-admin` volume
{: #ts-problem-mounting-datashield-admin-volume}

You try to follow the [update process for Data Shield](/docs/data-shield?topic=data-shield-update#upgrade-ubuntu-18.04), but Data Shield pods are stuck in the `init` state. You encounter the following error when you run `kubectl describe pods <pod-name>`:
{: tsSymptoms}

```
Warning  FailedMount  60m (x4 over 76m)   kubelet, 10.176.16.235  Unable to attach or mount volumes: unmounted volumes=[datashield-admin-token-7wzv8], unattached volumes=[host-root enclave-volume cluster-ca datashield-admin-token-7wzv8 sgx-psw-version]: timed out waiting for the condition
```
{: screen}


The secret that is associated with the  `datashield-admin` service account is not mounting successfully. You might encounter this problem because a secret does not exist, or a new secret for the service account was created. 
{: tsCauses}

To resolve the issue, delete the pod. A new pod automatically picks up the updated secret.
{: tsResolve}
