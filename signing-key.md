---
copyright:
  years: 2018, 2020
lastupdated: "2020-01-09"

keywords: converted containers, sign sgx, app security, production apps, images, containers, cluster, debug key, intel signing key, intel, data protection, runtime, memory encryption, 

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

# Signing converted containers
{: #enclaveos-signer}

When a container is converted by {{site.data.keyword.datashield_full}}, it is signed by an Intel SGX debug key. However, debug keys are not recommended for use with production ready workloads. To ensure the security of your applications, you must obtain a signing key from Intel to run converted containers in production environments.
{: shortdesc}

## Requesting a production signing key
{: #signing-key-request}

When you use your converted applications in production, you must sign them with an Intel enclave signing key.

1. Request a production enclave key by using the [steps that are provided by Intel](https://software.intel.com/en-us/sgx/request-license){: external}. 
2. Assign the `ISVSVN` and `ISVPRODID` parameters for your application.

  <table>
    <caption>Table 1. Intel Parameters</caption>
    <tr>
      <th>Parameter</th>
      <th>Description</th>
    </tr>
    <tr>
      <td><code>ISVSN</code></td>
      <td>The security version number of the enclave as assigned by the enclave author. After an enclave is successfully initialized, the CPU records the `SVN`. The `SVN` is then used during attestation whenever a security property is changed.</td>
    </tr>
    <tr>
      <td><code>ISVPRODID</code></td>
      <td>The product ID of the enclave as assigned by the enclave author. The ID provides the ability to segment enclaves with the same author identity.</td>
    </tr>
  </table>

  For more information about the parameters, see the [Intel SGX documentation](https://software.intel.com/en-us/blogs/2016/12/20/overview-of-an-intel-software-guard-extensions-enclave-life-cycle){: external}.



## Signing your converted applications
{: #signing-convert}

After you have a production signing key, you're ready to start signing your images.


### Before you begin
{: #signing-before}

Before you can sign your converted applications, be sure that you have the following dependencies installed:

* [pip3 package manager](https://pypi.org/project/pip/){: external}
* The python3 environment 3.6 or older

  ```
  sudo apt-get -y install python3-pip
  ```

* The enclaveos-signer requirements

  ```
  pip3  install -r requirements.txt
  ```
  {: codeblock}

### Signing your development images
{: #signing}

Signing your development images is optional. If you choose not to, they are signed in the background by a random debug key that is provided by IBM Cloud Data Shield. If you want to use your own key, use the following steps.

1. Clone the following repository.

  ```
  https://github.com/fortanix/enclaveos-signer.git
  ```
  {: codeblock}

2. Convert the script to an executable.

  ```
  chmod +x enclaveos-signer
  ```
  {: codeblock}

3. Optional: Generate a debug signing key.

  ```
  openssl genrsa -3 -out private_rsa_key.pem 3072
  ```
  {: codeblock}

4. Make the signing request.

  ```
  ./enclaveos-signer --container CONTAINER -output OUTPUT --isvsvn ISVSVN --isvprodid ISVPRODID --key PATH_TO_KEY
  ```
  {: codeblock}

| Parameter | Description |
|:----------|:------------|
| `--container CONTAINER` | The name of the converted container that you want to sign. For example: `<registry>/converter-app-sgx` |
| `-output OUTPUT` | The path to the converted container in your registry. For example: `<registry>/app-sgx-production` |
| `--isvsvn ISVSVN` | The security version number of the enclave as assigned by the enclave author. |
| `--isvprodid ISVPRODID` | The product ID of the enclave as assigned by the enclave author. |
| `--key PATH_TO_KEY` | The path to your debug signing key. |
{: caption="Table 2. Understanding the required parameters" caption-side="top"}


### Signing your production images
{: #signing-images}

You can use the enclaveos-signer to sign IBM Cloud Data Shield converted images with a production-level signing key.


1. Clone the following repository.

  ```
  https://github.com/fortanix/enclaveos-signer.git
  ```
  {: codeblock}

2. Convert the script to an executable.

  ```
  chmod +x enclaveos-signer
  ```
  {: codeblock}

3. Make the signing request.

  ```
  ./enclaveos-signer --container CONTAINER -output OUTPUT --isvsvn ISVSVN --isvprodid ISVPRODID --key PATH_TO_KEY --production  
  ```
  {: codeblock}

| Parameter | Description |
|:----------|:------------|
| `--container CONTAINER` | The name of the converted container that you want to sign. For example: `<registry>/converter-app-sgx` |
| `-output OUTPUT` | The path to the converted container in your registry. For example: `<registry>/app-sgx-production` |
| `--isvsvn ISVSVN` | The security version number of the enclave as assigned by the enclave author. |
| `--isvprodid ISVPRODID` | The product ID of the enclave as assigned by the enclave author. |
| `--key PATH_TO_KEY` | The path to your Intel production signing key. |
| `--production` | Communicates that the signature is for a production enclave and sets `ATTRIBUTES.DEBUG = 0`. |
{: caption="Table 3. Understanding the parameters" caption-side="top"}









