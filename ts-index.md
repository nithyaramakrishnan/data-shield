---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

keywords: data protection, data in use, runtime encryption, runtime memory encryption, encrypted memory, intel sgx, software guard extensions, fortanix runtime encryption

subcollection: data-shield

---

{:new_window: target="_blank"}
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

For help, you can search for information in the documentation or by askquestions through a forum. You can also open a support ticket. When you are using the forums to ask a question, tag your question so that it is seen by the {{site.data.keyword.Bluemix_notm}} development team.
  * If you have technical questions about {{site.data.keyword.datashield_short}}, post your question on <a href="https://stackoverflow.com/search?q=ibm-data-shield" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="External link icon"></a> and tag your question with "ibm-data-shield".
  * For questions about the service and getting started instructions, use the <a href="https://developer.ibm.com/answers/topics/data-shield/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="External link icon"></a> forum. Include the `data-shield` tag.

For more information about getting support, see [how do I get the support that I need](/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).


## I don't know the options that I can use with the installer
{: #options}

To see all of the commands and more help information, you can run the following command and review the output.

```
docker run registry.bluemix.net/ibm/datashield-installer help
```
{: pre}

## I can't log in to the Enclave Manager UI
{: #ts-log-in}

{: tsSymptoms}
You attempt to access the Enclave Manager UI and you're unable to sign in.

{: tsCauses}
Sign-in might fail for the following reasons:

* You might be using an email ID that is not authorized to access the Enclave Manager cluster.
* The token that you're using might be expired.

{: tsResolve}
To resolve the issue, verify that you are using the correct email ID. If yes, verify that the email has the correct permissions to access the Enclave Manager. If you have the right permissions, your access token might be expired. Tokens are valid for 60 minutes at a time. To obtain a new token, run `ibmcloud iam oauth-tokens`.


## The container converter API returns a forbidden error
{: #ts-converter-forbidden-error}

{: tsSymptoms}
You attempt to run the container converter and receive an error: `Forbidden`.

{: tsCauses}
You might not be able to access the converter if your IAM or Bearer token is missing or expired.

{: tsResolve}
To resolve the issue, you should verify that you are using either an IBM IAM OAauth token or an Enclave Manager authentication token in the header of your request. The tokens would take the following form:

* IAM: `Authentication: Basic <IBM IAM Token>`
* Enclave Manager: `Authentication: Bearer <E.M. Token>`

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
  {: pre}

3. Use a Base64 decoder to decode the secret content of `.dockerconfigjson` and verify that it is correct.


## Unable to mount AESM-socket or SGX devices
{: #ts-problem-mounting-device}

{: tsSymptoms}
You encounter issues while trying to mount Data Shield containers on volumes `/var/run/aesmd/aesm.socket` or `/dev/isgx`.

{: tsCauses}
Mounting can fail due to issues with the configuration of the host.

{: tsResolve}
To resolve the issue, verify both:

* That `/var/run/aesmd/aesm.socket` is not a directory on the host. If it is, delete the file, uninstall the Data Shield software, and perform the installation steps again. 
* That SGX is enabled in BIOS of the host machines. If it is not enabled, contact IBM support.
