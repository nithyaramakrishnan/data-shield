---
copyright:
  years: 2018, 2019
lastupdated: "2019-11-15"

keywords: enclave manager, container, convert, private registry, credentials, permissions, error, docker, support, cert manager, tokens, sgx, authentication, intel, fortanix, runtime encryption, memory protection, data in use,

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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# Troubleshooting
{: #troubleshooting}

If you have problems while you're working with {{site.data.keyword.datashield_full}}, consider these techniques for troubleshooting and getting help.
{: shortdesc}

## Getting help and support
{: #gettinghelp}

For help, you can search for information in the documentation or by asking questions through a forum. You can also open a support ticket. When you are using the forums to ask a question, tag your question so that it is seen by the {{site.data.keyword.cloud_notm}} development team.
  * If you have technical questions about {{site.data.keyword.datashield_short}}, post your question on <a href="https://stackoverflow.com" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="External link icon"></a> and tag your question with "ibm-data-shield".
  * For questions about the service and getting started instructions, use the <a href="https://developer.ibm.com/" target="_blank">IBM Developer Answers <img src="../../icons/launch-glyph.svg" alt="External link icon"></a> forum. Include the `data-shield` tag.

For more information about getting support, see [how do I get the support that I need](/docs/get-support?topic=get-support-getting-customer-support).


## Obtaining logs
{: #ts-logs}

When you open a support ticket for {{site.data.keyword.datashield_short}}, providing your logs can help to speed up the troubleshooting process. You can use the following steps to obtain your logs and then copy and paste them into the issue when you create it.

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

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
The error occurs when the SGX driver is unable to install the package. You might have a library such as `libsgx-enclave-common` which prevents the driver from accessing the package in the cluster.

{: tsResolve}
To resolve the issue, try uninstalling the library.

1. Access each node on the cluster.
2. Run either of the following commands on each node:

  * 

