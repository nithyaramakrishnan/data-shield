---

copyright:
  years: 2018, 2019
lastupdated: "2019-08-15"

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

# Converting images
{: #convert}

You can convert your images to run in an EnclaveOS® environment by using the {{site.data.keyword.datashield_short}} Container Converter. After your images are converted, you can deploy them to your SGX capable Kubernetes cluster.
{: shortdesc}

You can convert your applications without changing your code. By doing the conversion, you're preparing your application to run in an EnclaveOS environment. It's important to note that the conversion process does not encrypt your application. Only data that is generated at run time - after the application is started within an SGX Enclave is protected by IBM Cloud Data Shield. 

The conversion process does not encrypt your application.
{: important}


## Before you begin
{: #convert-before}

Before you convert your applications, you should ensure that you fully understand the following considerations.
{: shortdesc}

* For security reasons, secrets must be provided at run time - not placed in the container image that you want to convert. When the app is converted and running, you can verify through attestation that the application is running in an enclave before you provide any secrets.

* The container guest must run as the container's root user.

* Tested container environments include the following:

  * Debian 8
  * Debian 9
  * Ubuntu 16.04
  * Ubuntu 18.04
  * Java OpenJDK 8
  * Java OpenJ9 0.14


## Configuring registry credentials
{: #configure-credentials}

You can allow all users of the {{site.data.keyword.datashield_short}} container converter to obtain input images from and push output images to the configured private registries by configuring it with registry credentials. If you used the Container Registry before 4 October 2018, you might want to [enable IAM access policy enforcement for your registry](/docs/services/Registry?topic=registry-user#existing_users).
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

1. Configure [pull secrets](/docs/containers?topic=containers-images#other).

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

You can also convert your containers when you build your apps through the [Enclave Manager UI](/docs/services/data-shield?topic=data-shield-enclave-manager#em-apps).
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

To use the `Java-Mode` conversion, modify your Docker file to supply the following options. In order for the Java conversion to work, you must set all of the variables as they are defined in this section. 


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
  ```
  {: codeblock}


## Requesting an application certificate
{: #request-cert}

A converted application can request a certificate from the Enclave Manager when your application is started. The certificates are signed by Enclave Manager Certificate Authority and include Intel's remote attestation report for your app's SGX enclave.
{: shortdesc}

Check out the following example to see how to configure a request to generate an RSA private key and generate the certificate for the key. The key is kept on the root of the application container. If you don't want an ephemeral key or certificate, you can customize the `keyPath` and `certPath` for your apps and store them on a persistent volume.

1. Save the following template as `app.json` and make the required changed to fit your application's certificate requirements.

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. Enter your variables and run the following command to run the converter again with your certificate information.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## Whitelisting applications
{: #convert-whitelist}

When a Docker image is converted to run inside of Intel® SGX, it can be whitelisted. By whitelisting your image, you're assigning admin privileges that allow the application to run on the cluster where {{site.data.keyword.datashield_short}} is installed.
{: shortdesc}


1. Obtain an Enclave Manager access token by using the IAM authentication token:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. Make a whitelist request to the Enclave Manager. Be sure to enter your information when you run the following command.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```
  {: codeblock}

3. Use the Enclave Manager GUI to approve or deny whitelist requests. You can track and manage whitelisted builds in the **Tasks** section of the GUI.

