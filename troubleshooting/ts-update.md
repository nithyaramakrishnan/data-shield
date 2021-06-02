---
copyright:
  years: 2018, 2021
lastupdated: "2021-06-02"

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


# Why won't my Data Shield cluster update?
{: #ts-update}

When you try to update your {{site.data.keyword.datashield_full}} cluster, you receive an error message.
{: shortdesc}


{: tsSymptoms}
You try to follow the [update process for Data Shield](/docs/data-shield?topic=data-shield-update#upgrade-ubuntu-18.04), but the `enclaveos-agent` pod or manager pod on the new node is stuck in the `ContainerCreating` state. You encounter the following error when you run `kubectl describe pods <agent | manager-pod>`:

```
Normal   Scheduled  47m                    default-scheduler      Successfully assigned default/datashield-enclaveos-manager-1 to 10.94.114.74
Warning  Failed     47m                    kubelet, 10.94.114.74  Error: failed to generate container "35f6e7f660a80dff105593a5b8ab9fe20146c1771fc9a897b4dbf1d036043fd1" spec: lstat /dev/isgx: no such file or directory
Warning  Failed     47m                    kubelet, 10.94.114.74  Error: failed to generate container "95624416be36ec192abc13429271e86682af1d0f5ef81c4ecda1cd4ec21deb22" spec: lstat /dev/isgx: no such file or directory
```
{: screen}

{: tsCauses}
The SGX driver might not be installed on the node.

{: tsResolve}
To resolve the issue, verify:

- That the `sgx` pod is running on the node. If the `sgx` pod is in the `CrashLoopBackOff` state, the `isgx` driver was not installed successfully on the node. 
- The logs of the `sgx` pod. If the `sgx` pod is in the running state, you can run the following command to check whether the `isgx` driver is installed on the node. 

  ```
  root@kube-dal10-crb672a8b09bf145e2a9edbefecb162495-w5:/# lsmod | grep isgx
  isgx                   45056  0
  ```
  {: codeblock}

  If the `isgx` driver is installed, check whether you can find it in `/dev` path.

  ```
  root@kube-dal10-crb672a8b09bf145e2a9edbefecb162495-w5:/# ls /dev/isgx
  ```
  {: codeblock}

  If you can find the `isgx` driver in the `/dev` path, it is installed successfully. If it is not found, either the node hardware does not support SGX, or SGX is not enabled in your BIOS. If the node that you selected has SGX enabled, reload the node to enable SGX in your BIOS.


If you have access to the worker node, you can check kernel logs by logging into the worker node. If you do not have access to the worker node, use the privileged pod (`dkms` pod in the `data-shield` deployment) and run `kubectl exec -it <dkms-pod> chroot /host bash` to access the shell of the worker node and check kernel logs.
{: note}