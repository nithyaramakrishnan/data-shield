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

# Converting images
{: #convert}

You can convert your images to run in an EnclaveOS® environment by using the Data Shield Container Converter. After your images are converted, you can deploy to your SGX capable Kubernetes cluster.
{: shortdesc}


## Configuring registry credentials
{: #configure-credentials}

You can allow all users of the converter to obtain input images from and push output images to the configured private registries by configuring the converter with registry credentials.
{: shortdesc}

### Configuring your {{site.data.keyword.cloud_notm}} Container Registry credentials
{: #configure-ibm-registry}

1. Log in to the {{site.data.keyword.cloud_notm}} CLI.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>Region</th>
      <th>IBM Cloud Endpoint</th>
      <th>Kubernetes Service region</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>US South</td>
    </tr>
    <tr>
      <td>Frankfurt</td>
      <td><code>eu-de</code></td>
      <td>EU Central</td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
      <td>AP South</td>
    </tr>
    <tr>
      <td>London</td>
      <td><code>eu-gb</code></td>
      <td>UK South</td>
    </tr>
    <tr>
      <td>Tokyo</td>
      <td><code>jp-tok</code></td>
      <td>AP North</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>US East</td>
    </tr>
  </table>

2. Obtain an authentication token for your {{site.data.keyword.cloud_notm}} Container Registry.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. Create a JSON configuration file by using the token that you just created. Replace the `<token>` variable, and then run the following command. If you don't have `openssl`, you can use any command line base64 encoder with appropriate options. Be sure that there aren't any new lines in the middle or at the end of the encoded string.

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### Configuring credentials for another registry
{: #configure-other-registry}

If you already have a `~/.docker/config.json` file that authenticates to the registry that you want to use, you can use that file.

1. Log in to the {{site.data.keyword.cloud_notm}} CLI.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Run the following command.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## Converting your images
{: #converting-images}

You can use the Enclave Manager API to connect to the converter.
{: shortdesc}

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Obtain and export an IAM token.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. Convert your image. Be sure to replace the variables with the information for your application.

  ```
  curl -k -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}

  If you are using the default, self-signed, certificate in the conversion service, the `-k` option is required. For production deployments, be sure that you use a trusted certificate and eliminate the `-k` option for security reasons.
  {: important}

## Requesting an application certificate
{: #request-cert}

A converted application can request a certificate from the Enclave Manager when your application is started. The certificates are signed by Enclave Manager Certificate Authority and include Intel's remote attestation report for your app's SGX enclave.
{: shortdesc}

Check out the following example to see how to configure a request to generate an RSA private key and generate the certificate for the key. The key is kept on the root of the application container. If you don't want an ephemeral key/certificate, you can customize the `keyPath` and `certPath` for your apps and store them on a persistent volume.

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

2. Input your variables and run the following command to run the converter again with your certificate information.

 ```
 curl -k -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: pre}

 If you are using the default, self-signed, certificate in the conversion service, the `-k` option is required. For production deployments, be sure that you use a trusted certificate and eliminate the `-k` option for security reasons.
 {: important}

## Whitelisting applications
{: #convert-whitelist}

When a Docker image is converted to run inside of Intel SGX, it can be whitelisted. By whitelisting your image, you're assigning admin privileges that allows the application to run on the cluster where Data Shield is installed.
{: shortdesc}

1. Make a whitelist request to the Enclave Manager. Be sure to fill in your information when running the following command.

  ```
  curl -k -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

2. Use the Enclave Manager GUI to approve or deny whitelist requests. You can track and manage whitelisted builds in the **Builds** section of the GUI.