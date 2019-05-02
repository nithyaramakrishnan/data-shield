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

# Conversión de imágenes
{: #convert}

Puede convertir sus imágenes para que se ejecuten en un entorno de EnclaveOS® utilizando el conversor de contenedores de {{site.data.keyword.datashield_short}}. Una vez que se hayan convertido las imágenes, puede desplegarlas en su clúster de Kubernetes con capacidad para SGX.
{: shortdesc}


## Configuración de credenciales de registro
{: #configure-credentials}

Puede permitir que todos los usuarios del conversor puedan obtener imágenes de entrada y enviar imágenes de salida a los registros privados configurados mediante la configuración del conversor con credenciales de registro.
{: shortdesc}

### Configuración de las credenciales de {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>Región</th>
      <th>Punto final de IBM Cloud</th>
      <th>Región del servicio Kubernetes</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>EE.UU. sur</td>
    </tr>
    <tr>
      <td>Frankfurt</td>
      <td><code>eu-de</code></td>
      <td>UE central</td>
    </tr>
    <tr>
      <td>Sídney</td>
      <td><code>au-syd</code></td>
      <td>AP sur</td>
    </tr>
    <tr>
      <td>Londres</td>
      <td><code>eu-gb</code></td>
      <td>RU sur</td>
    </tr>
    <tr>
      <td>Tokio</td>
      <td><code>jp-tok</code></td>
      <td>AP norte</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>EE.UU. este</td>
    </tr>
  </table>

2. Obtenga una señal de autenticación para {{site.data.keyword.cloud_notm}} Container Registry.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. Cree un archivo de configuración JSON utilizando la señal que ha creado. Sustituya la variable `<token>` y, a continuación, ejecute el mandato siguiente. Si no tiene `openssl`, puede utilizar cualquier codificador base64 de línea de mandatos con las opciones adecuadas. Asegúrese de que no haya líneas nuevas en el medio o al final de la serie codificada.

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### Configuración de credenciales para otro registro
{: #configure-other-registry}

Si ya tiene un archivo `~/.docker/config.json` que se autentica en el registro que desea utilizar, puede usar dicho archivo.

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Ejecute el mandato siguiente.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## Conversión de las imágenes
{: #converting-images}

Puede utilizar la API de Enclave Manager para conectarse al conversor.
{: shortdesc}

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Obtenga y exporte una señal de IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. Convierta la imagen. Asegúrese de sustituir las variables por la información de su aplicación.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## Solicitud de un certificado de aplicación
{: #request-cert}

Una aplicación convertida puede solicitar un certificado a Enclave Manager cuando se inicia la aplicación. Los certificados los firma la entidad emisora de certificados de Enclave Manager e incluyen un informe de testificación remota de Intel para el enclave SGX de la app.
{: shortdesc}

Consulte el ejemplo siguiente para ver cómo configurar una solicitud para generar una clave privada RSA y generar el certificado para la clave. La clave se guarda en la raíz del contenedor de aplicaciones. Si no desea una clave o un certificado efímero, puede personalizar los parámetros `keyPath` y `certPath` para sus apps y almacenarlos en un volumen persistente.

1. Guarde la plantilla siguiente como `app.json` y realice los cambios necesarios para que se ajuste a los requisitos de certificados de su aplicación.

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

2. Especifique las variables y ejecute el mandato siguiente para ejecutar de nuevo el conversor con la información del certificado.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: pre}


## Inclusión de aplicaciones en una lista blanca
{: #convert-whitelist}

Cuando se convierte una imagen de Docker para que se ejecute dentro de Intel® SGX, se puede incluir en una lista blanca. Al incluir la imagen en una lista blanca, se le asignarán privilegios de administración que permitirán que la aplicación se pueda ejecutar en el clúster donde está instalado {{site.data.keyword.datashield_short}}.
{: shortdesc}

1. Obtenga una señal de acceso de Enclave Manager utilizando la señal de autenticación de IAM, utilizando la solicitud curl siguiente:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. Realice una solicitud de inclusión en lista blanca a Enclave Manager. Asegúrese de especificar su información al ejecutar el mandato siguiente.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. Utilice la GUI de Enclave Manager para aprobar o denegar solicitudes de lista blanca. Puede realizar el seguimiento y gestionar las compilaciones en lista blanca en la sección **Compilaciones** de la GUI.
