---

copyright:
  years: 2018, 2020
lastupdated: "2020-04-20"

keywords: Enclave manager, environment variables, converter, container, convert containers, configuration file, registry credentials, java, image, security, sgx, data, excryption, conversion,

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:new_window: target="_blank"}
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


# Converting images
{: #convert}

You can convert your images to run in an EnclaveOS® environment by using the {{site.data.keyword.datashield_short}} Container Converter. After your images are converted, you can deploy them to your SGX capable Kubernetes cluster.
{: shortdesc}

You can convert your applications without changing your code. By doing the conversion, you're preparing your application to run in an EnclaveOS environment. It's important to note that the conversion process does not encrypt your application. Only data that is generated at run time, after the application is started within an SGX Enclave, is protected by {{site.data.keyword.datashield_short}}. 

The conversion process does not encrypt your application.
{: important}


## Before you begin
{: #convert-before}

Before you convert your applications, ensure that you fully understand the following considerations.
{: shortdesc}

* For security reasons, secrets must be provided at run time - not placed in the container image that you want to convert. When the app is converted and running, you can verify through attestation that the application is running in an enclave before you provide any secrets.

* Tested container environments include the following:

  * Debian 8
  * Debian 9
  * Ubuntu 16.04
  * Ubuntu 18.04
  * Java OpenJDK 8
  * Java OpenJ9 0.14


## Configuring registry credentials
{: #configure-credentials}

You can allow all users of the {{site.data.keyword.datashield_short}} container converter to obtain input images from and push output images to the configured private registries by configuring it with registry credentials. If you used the Container Registry before 4 October 2018, you might want to [enable IAM access policy enforcement for your registry](/docs/Registry?topic=registry-user#existing_users).
{: shortdesc}

### Configuring your {{site.data.keyword.cloud_notm}} Container Registry credentials
{: #configure-ibm-registry}

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Create a service ID and a service ID API key for the {{site.data.keyword.datashield_short}} container converter.

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ```
  {: codeblock}

3. Create an API key for the container converter.

  ```
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. Grant the service ID permission to access your container registry.

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. Create a JSON configuration file by using the API key that you created. Replace the `<api key>` variable, and then run the following command. If you don't have `openssl`, you can use any command-line base64 encoder with appropriate options. Be sure that no new lines in the middle or at the end of the encoded string exist.

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### Configuring credentials for another registry
{: #configure-other-registry}

If you already have a `~/.docker/config.json` file that authenticates to the registry that you want to use, you can use that file. Files on OS X are not supported currently.

1. Configure [pull secrets](/docs/containers?topic=containers-registry#other).

2. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. Run the following command.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## Converting your images
{: #converting-images}

You can use the Enclave Manager API to connect to the converter.
{: shortdesc}

You can also convert your containers when you build your apps through the [Enclave Manager UI](/docs/data-shield?topic=data-shield-enclave-manager#em-app-add).
{: tip}

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Obtain and export an IAM token.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. Convert your image. Be sure to replace the variables with the information for your application.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Converting Java applications
{: #convert-java}

When you convert Java-based applications, there are a few extra requirements and limitations. When you convert Java applications by using the Enclave Manager UI, you can select `Java-Mode`. To convert Java apps by using the API, keep the following limitations and options in mind.

**Limitations**

* The recommended maximum enclave size for Java apps is 4 GB. Larger enclaves might work but can experience degraded performance.
* The recommended heap size is less than the enclave size. We recommend removing any `-Xmx` option as a way to decrease the heap size.
* The following Java libraries have been tested:
  - MySQL Java Connector
  - Crypto (`JCA`)
  - Messaging (`JMS`)
  - Hibernate (`JPA`)

  If you're working with another library, contact our team by using forums or by clicking the feedback button on this page. Be sure to include your contact information and the library that you're interested in working with.


**Options**

To use the `Java-Mode` conversion, modify your Dockerfile to supply the following options. In order for the Java conversion to work, you must set all of the variables as they are defined in the following section.


* Set the environment variable MALLOC_ARENA_MAX equal to 1.

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* If you're using the `OpenJDK JVM`, set the following options.

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData
  -XX:ReservedCodeCacheSize=16m
  -XX:-UseCompiler
  -XX:+UseSerialGC
  ```
  {: codeblock}

* If you're using the `OpenJ9 JVM`, set the following options.

  ```
  -Xnojit
  –Xnoaot
  -Xdump:none
  ```
  {: codeblock}


## Creating an app and requesting a certificate
{: #request-cert}

A converted application can request a certificate from the Enclave Manager when your application is started. The certificates are signed by Enclave Manager certificate authority, which issues certificates only to enclaves that present a valid attestation.
{: shortdesc}

Check out the following example to see how to configure a request to generate an RSA private key and generate the certificate for the key. The key is kept on the root of the application container. If you don't want an ephemeral key or certificate, you can customize the `keyPath` and `certPath` for your apps and store them on a persistent volume.

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

3. Get your Ingress subdomain.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

4. In terminal, get an IAM token.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  ```
  {: codeblock}

5. Obtain an Enclave Manager access token by using an IAM authentication token.

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

6. Save the following template as `app.json` and make the required changes to fit your application's certificate requirements.

  ```json
  {
    "name": "<app_name>",
        "description": "<app_description>",
        "input_image_name": "<your-registry-server/your-app>",
        "output_image_name": "<your-registry-server/your-app-sgx>",
        "isvprodid": <isvprodid>,
        "isvsvn": <isvsvn>,
        "mem_size": <memory_size>,
        "threads": <threads>,
        "allowed_domains": ["<SGX-Application.domain>"],
        "advanced_settings": {
            "java_runtime": "",
              "caCertificate": {
                "caCertPath": "/cacert.pem",
                "system": "true"
              },
            "certificate": {
                    "issuer": "MANAGER_CA",
                    "keyType": "RSA",
                    "keyParam": {
                      "size": 2048
                    },
                    "subject": "SGX-Application.domain",
                    "keyPath": "/appkey.pem",
                    "certPath": "/appcert.pem",
                    "chainPath": "/chainpath.pem"
        }
      }
    }
  ```
  {: screen}

  <table>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
    <tr>
      <td><code>name</code></td>
      <td>The name that you want to give your application. This is how your application is listed in the Enclave Manager.</td>
    </tr>
    <tr>
      <td><code>description</code></td>
      <td>A short description about your application.</td>
    </tr>
    <tr>
      <td><code>input_image_name</code></td>
      <td>The name of the image that you want to convert including your registry. Note that a tag is not included.</td>
    </tr>
    <tr>
      <td><code>output_image_name</code></td>
      <td>The name that you want your converted image to have, including the output registry. Note that a tag is not included.</td>
    </tr>
    <tr>
      <td><code>isvprodid</code></td>
      <td>A numeric product identifier that you assign to your enclave. You can choose a unique value in range 0 - 65,535.</td>
    </tr>
    <tr>
      <td><code>isvsvn</code></td>
      <td>A numeric security version that you assign to your enclave. When you make a change that affects your application security, be sure to incrementally increase the value.</td>
    </tr>
    <tr>
      <td><code>memsize</code></td>
      <td>The size of memory that you want your enclave to have. If your app uses a large amount of memory, you can use a large enclave size. However, the size of your enclave can affect your performance. Be sure that your memory allocation is set to a power of 2. For example: <code>2048 MB</code>.</td>
    </tr>
    <tr>
      <td><code>threads</code></td>
      <td>The number of threads for your enclave. Be sure that your thread size is large enough to accommodate the maximum number of processes that run in your app. For example: <code>128</code>.</td>
    </tr>
    <tr>
      <td><code>allowed_domains</code></td>
      <td>Any domains on which your app is accessible.</td>
    </tr>
    <tr>
      <td><code>advanced_settings</code></td>
      <td>Advanced settings are configured for best practice in the example code block. Be sure that you understand the way that changing a setting affects your application before you make any change. Also, note you can specify only one of <code>certPath</code> or <code>caCertPath</code> at any time. If you specify both at the same time, the command in the following step fails. The <code>caCertpath</code> is the path to store the Manager CA certificate. <code>System</code> sets the option of install the CA Certificate into the system trust store. <code>System<code> options include <code>true</code>, <code>false</code>, and <code>undefined</code>. </br><code>true</code>: Continue to install the service and build the conversion even if the installation of the CA certificate was unsuccessful. </br><code>false</code>: Stop the installation process and do not install the service. </br><code>undefined</code>: Install the service, but fail the build conversion if the CA certificate installation fails. </br></br> The available options for the Java Runtime are <code>ORACLE</code>, <code>OPENJDK</code>, <code>OPENJ9</code>, and <code>LIBERTY</code>.</br>For <code>subject</code>, list one of the domains that you specified in <code>allowed_domains</code>. For <code>system</code>, options include <code>true</code>, </td>
    </tr>
  </table>

7. Enter your variables and run the following command to convert and create a build for your application.

  ```
  curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Bearer $em_token" https://enclave-manager.<ingress-domain>/api/v1/apps
  ```
  {: codeblock}

  Make a note of the app ID in the output of the command.
  {: tip}

## Creating a build
{: #convert-build}

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

3. Get your Ingress subdomain.

  ```
  ibmcloud ks cluster get --cluster <cluster_name>
  ```
  {: codeblock}

4. Enter your variables and run the following command to create the build for your app and add it to your whitelist. You can find the app ID in the output of step number 8 of the previous section.

  ```
  curl -H 'Content-Type: application/json' -d '{"app_id": "<app_id>", "docker_version": "<version_number>" }'  -H "Authorization: Bearer $em_token" https://enclave-manager.<ingress-domain>/api/v1/builds/convert-app
  ```
  {: codeblock}

5. In the Enclave Manager GUI, the build was added to your whitelist. Be sure to approve the build so that it can complete. You can track and manage whitelisted builds in the **Tasks** section of the GUI.

