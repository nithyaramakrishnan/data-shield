---
copyright:
  years: 2018, 2020
lastupdated: "2020-11-03"

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


# Troubleshooting
{: #troubleshooting}

If you have problems while you're working with {{site.data.keyword.datashield_full}}, consider these techniques for troubleshooting and getting help.
{: shortdesc}

## Getting help and support
{: #gettinghelp}

For help, you can search for information in the documentation or by asking questions through a forum. You can also open a support ticket. When you are using the forums to ask a question, tag your question so that it is seen by the {{site.data.keyword.cloud_notm}} development team.

If you have technical questions about {{site.data.keyword.datashield_short}}, post your question on <a href="https://stackoverflow.com" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="External link icon"></a> and tag your question with "ibm-data-shield".

For more information about getting support, see [how do I get the support that I need](/docs/get-support?topic=get-support-using-avatar).


## Obtaining logs
{: #ts-logs}

When you open a support ticket for {{site.data.keyword.datashield_short}}, providing your logs can help to speed up the troubleshooting process. You can use the following steps to obtain your logs and then copy and paste them into the issue when you create it.

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Set the context for your cluster.

  ```
  ibmcloud ks cluster config --cluster <cluster_name_or_ID>
  ```
  {: codeblock}

3. Run the following command to obtain your logs.

  ```
  kubectl logs --all-containers=true --selector release=$(helm list | grep 'data-shield' | awk {'print $1'}) > logs
  ```
  {: codeblock}


## I can't log in to the Enclave Manager UI
{: #ts-log-in}

{: tsSymptoms}
You attempt to access the Enclave Manager UI and you're unable to sign in.

{: tsCauses}
Sign-in might fail for the following reasons:

* You might be using an email ID that is not authorized to access the Enclave Manager cluster.
* The token that you're using might be expired.

{: tsResolve}
To resolve the issue, verify that you are using the correct email ID. If yes, verify that the email has the correct permissions to access the Enclave Manager. If you have the correct permissions, your access token might be expired. Tokens are valid for 60 minutes at a time. To obtain a new token, run `ibmcloud iam oauth-tokens`. If you have multiple IBM Cloud accounts, verify that the account you are logged in to the CLI with the correct account for the Enclave Manager cluster.


## Error: Container converter forbidden
{: #ts-converter-forbidden-error}

{: tsSymptoms}
You attempt to run the container converter and receive an error: `Forbidden`.

{: tsCauses}
You might not be able to access the converter if your IAM or Bearer token is missing or expired.

{: tsResolve}
To resolve the issue, verify that you are using either an IBM IAM OAuth token or an Enclave Manager authentication token in the header of your request. The tokens would take the following form:

* IAM: `Authentication: Basic <IBM_IAM_Token>`
* Enclave Manager: `Authentication: Bearer <EM_Token>`

If your token is present, verify that it is still valid and run the request again.


## The container converter is unable to connect to a private Docker registry
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
You attempt to run the container converter on an image from a private Docker registry and the converter is unable to connect.

{: tsCauses}
Your private registry credentials might not be configured correctly. 

{: tsResolve}
To resolve the issue, you can follow these steps:

1. Verify that your private registry credentials were previously configured. If not, configure them now.
2. Run the following command to dump your Docker registry credentials. If necessary, you can change the secret name.

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: codeblock}

3. Use a Base64 decoder to decode the secret content of `.dockerconfigjson` and verify that it is correct.


## Unable to mount AESM-socket or SGX devices
{: #ts-problem-mounting-device}

{: tsSymptoms}
You encounter issues when you try to mount {{site.data.keyword.datashield_short}} containers on volumes `/var/run/aesmd/aesm.socket` or `/dev/isgx`.

{: tsCauses}
Mounting can fail due to issues with the configuration of the host.

{: tsResolve}
To resolve the issue, verify both:

* That `/var/run/aesmd/aesm.socket` is not a directory on the host. If it is, delete the file, uninstall the {{site.data.keyword.datashield_short}} software, and perform the installation steps again. 
* That SGX is enabled in BIOS of the host machines. If it is not enabled, contact IBM support.


## Error: Converting containers
{: #ts-container-convert-fails}

{: tsSymptoms}
You encounter the following error when you try to convert your container.

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: codeblock}

{: tsCauses}
On macOS, if the OS X Keychain is used in your `config.json` file the container converter fails. 

{: tsResolve}
To resolve the issue you can use the following steps:

1. Disable OS X keychain on your local system. Go to **System preferences > iCloud** and clear the box for **Keychain**.

2. Delete the secret that you created. Be sure that you're logged in to IBM Cloud and are targeted to your cluster before you run the following command.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}

3. In your `$HOME/.docker/config.json` file, delete the line `"credsStore": "osxkeychain"`.

4. Log in to your registry.

5. Create a secret.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

6. List your pods and make a note of the pod with `enclaveos-converter` in the name.

  ```
  kubectl get pods
  ```
  {: codeblock}

7. Delete the pod.

  ```
  kubectl delete pod <pod name>
  ```
  {: codeblock}

8. Convert your image.


## Error: `cert-manager` CRD
{: #ts-cert-manager-crd}

{: tsSymptoms}
You encounter the following error when you try to install version `0.5.0` of the Cert Manager service.

```
Error: customresourcedefinitions.apiextensions.k8s.io "certificates.certmanager.k8s.io" already exists
```
{: codeblock}

{: tsCauses}
If you have you previously installed cert-manager and then uninstalled it, you might have CRDs left from the initial instance.

{: tsResolve}
To resolve the issue, delete the following CRDs.

```
kubectl delete crd certificates.certmanager.k8s.io
kubectl delete crd clusterissuers.certmanager.k8s.io 
kubectl delete crd issuers.certmanager.k8s.io
```
{: codeblock}


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

## Unable to update {{site.data.keyword.datashield_short}}
{: #ts-problem-updating-data-shield}

{: tsSymptoms}
You try to follow the [update process for {{site.data.keyword.datashield_short}}](/docs/data-shield?topic=data-shield-update#upgrade-ubuntu-18.04), but the `enclaveos-agent` pod or manager pod on the new node is stuck in the `ContainerCreating` state. You encounter the following error when you run `kubectl describe pods <agent | manager-pod>`:

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

## Unable to mount `datashield-admin` volume
{: #ts-problem-mounting-datashield-admin-volume}

{: tsSymptoms}
You try to follow the [update process for {{site.data.keyword.datashield_short}}](/docs/data-shield?topic=data-shield-update#upgrade-ubuntu-18.04), but {{site.data.keyword.datashield_short}} pods are stuck in the `init` state. You encounter the following error when you run `kubectl describe pods <pod-name>`:

```
Warning  FailedMount  60m (x4 over 76m)   kubelet, 10.176.16.235  Unable to attach or mount volumes: unmounted volumes=[datashield-admin-token-7wzv8], unattached volumes=[host-root enclave-volume cluster-ca datashield-admin-token-7wzv8 sgx-psw-version]: timed out waiting for the condition
```
{: screen}

{: tsCauses}
The secret that is associated with the  `datashield-admin` service account is not mounting successfully. You might encounter this problem because a secret does not exist, or a new secret for the service account was created. 
  
{: tsResolve}
To resolve the issue, delete the pod. A new pod automatically picks up the updated secret.
