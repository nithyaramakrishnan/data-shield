---

copyright:
  years: 2018, 2019
lastupdated: "2019-01-21"

---

{:new_window: target="_blank"}
{:shortdesc: .shortdesc}
{:screen: .screen}
{:codeblock: .codeblock}
{:pre: .pre}
{:tip: .tip}
{:important: .important}
{:note: .note}

# Converting and deploying your images
{: #convert}

You can convert your images to run in an EnclaveOS® environment by using the Data Shield Container Converter. After your images are converted, you can deploy to your SGX capable {{site.data.keyword.containerlong_notm}}.
{: shortdesc}


## Configuring registry credentials
{: #configure-credentials}

You can allow all users of the converter to obtain input images from and push output images to the configured private registries by configuring the converter with registry credentials.
{: shortdesc}

**Configuring your {{site.data.keyword.cloud_notm}} Container Registry credentials**

1. Log in to the {{site.data.keyword.cloud_notm}} CLI.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>Endpoint</th>
    </tr>
    <tr>
      <td>Germany</td>
      <td><code>eu-de</code></td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
    </tr>
    <tr>
      <td>United Kingdom</td>
      <td><code>eu-gb</code></td>
    </tr>
    <tr>
      <td>US South</td>
      <td><code>us-south</code></td>
    </tr>
  </table>

2. Obtain an authentication token for your {{site.data.keyword.cloud_notm}} Container Registry.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: codeblock}

3. Create a JSON configuration file. Replace <token> in the following command with the token that you created in the previous step. If you don't have `openssl`, you can use any CLI base64 encoder with the appropriate options.

  Be sure there aren't any newlines in the middle or at the end of the encoded string.
  {: tip}

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

**Configuring credentials for another registry**

If you already have a `~/.docker/config.json` file that authenticates to the registry you wish to use, then log in to the `ibmcloud` CLI and then run the following command.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

</br>

## Accessing the converter through the Enclave Manager API
{: #accessing}

You can use the Enclave Manager API to connect to the converter.
{: shortdesc}

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete finish logging in.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>Endpoint</th>
    </tr>
    <tr>
      <td>Germany</td>
      <td><code>eu-de</code></td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
    </tr>
    <tr>
      <td>United Kingdom</td>
      <td><code>eu-gb</code></td>
    </tr>
    <tr>
      <td>US South</td>
      <td><code>us-south</code></td>
    </tr>
  </table>

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output and paste it into your terminal.

3. Obtain an {{site.data.keyword.cloud_notm}} authentication token.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

4. Export the token.

  ```
  ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'
  echo $token
  ```
  {: codeblock}

5. Access the converter.

  ```
  curl -H "Authorization: Basic $token" https://enclave-manager.<cluster ingress subdomain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

6. Convert your image.

  ```
  curl -k -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

  If you are using the default, self-signed, certificate in the conversion service, the `-k` option is required. For production deployments, be sure that you use a trusted certificate and eliminate the `-k` option for security reasons.
  {: important}

7. The converted application Docker image is now capable of running inside Intel SGX. You can whitelist the converted images on the Enclave Manager. The converter return contains the information that was used to create the whitelist request. To make a request, you can use your information as the variables in the following template.

  ```
  curl -k -X POST https://enclave-manager.<Ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

8. Use the Enclave Manager GUI to approve or deny whitelist requests. You can track and manage whitelisted builds in the **Builds** section of the GUI.

## Requesting an application certificate
{: #request-cert}

You can request an application certificate from the Enclave Manager when your application is started. The certificates are signed by Enclave Manager Certificate Authority and include Intel's remote attestation report for your app's SGX enclave.
{: shortdesc}

Check out the following example to see how to configure a request to generate an RSA private key and generate the certificate for the key. The key is kept on the root of the application container. If you don't want an ephemeral key/certificate, you can customize the keyPath/certPath for your apps and store them on a persistent volume.

1. Save the following template as `app.json` and make the required changed to fit your application's certificate requirements.

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "Enclave Manager",
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
 {: codeblock}

2. Input your variables and run the following command.

 ```
 curl -k -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}

 If you are using the default, self-signed, certificate in the conversion service, the `-k` option is required. For production deployments, be sure that you use a trusted certificate and eliminate the `-k` option for security reasons.
 {: important}

</br>

## Deploying {{site.data.keyword.datashield_short}} containers
{: #containers}

After you convert your images, you must redeploy your {{site.data.keyword.datashield_short}} containers to your Kubernetes cluster.
{: shortdesc}

When you deploy {{site.data.keyword.datashield_short}} containers to your Kubernetes cluster, the container specification must include volume mounts. This allows the SGX devices and the AESM socket to be available in the container.

1. Save the following pod specification as a template.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: app-sgx
      labels:
        app: app-sgx
    spec:
      containers:
      - name: app-sgx
        image: registry.ng.bluemix.net/datashield-core/app-sgx    
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
      - name: gsgx
        hostPath:
          path: /dev/gsgx
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
    ```
    {: screen}

2. Update the fields `your-app-sgx` and `your-registry-server` to your app and server.

3. Create the Kubernetes pod.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}


</br>
</br>
