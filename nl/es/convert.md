---

copyright:
  years: 2018, 2019
lastupdated: "2019-07-08"

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

# Conversión de imágenes
{: #convert}

Puede convertir sus imágenes para que se ejecuten en un entorno de EnclaveOS® utilizando el conversor de contenedores de {{site.data.keyword.datashield_short}}. Una vez que se hayan convertido las imágenes, puede desplegarlas en su clúster de Kubernetes con capacidad para SGX.
{: shortdesc}

Puede convertir las aplicaciones sin cambiar el código. Al realizar la conversión, está preparando la aplicación para que se ejecute en un entorno EnclaveOS. Es importante tener en cuenta que el proceso de conversión no cifra la aplicación. Solo los datos que se generan en tiempo de ejecución, después de que la aplicación se inicie dentro de un enclave SGX, están protegidos por IBM Cloud Data Shield. 

El proceso de conversión no cifra la aplicación.
{: important}


## Antes de empezar
{: #convert-before}

Antes de convertir las aplicaciones, debe asegurarse de que comprende perfectamente las siguientes consideraciones.
{: shortdesc}

* Por motivos de seguridad, los secretos se deben proporcionar en tiempo de ejecución; no se deben colocar en la imagen de contenedor que desea convertir. Cuando la app se convierte y se ejecuta, puede verificar a través de la certificación que la aplicación se está ejecutando en un enclave antes de proporcionar cualquier secreto.

* El invitado del contenedor se debe ejecutar como usuario root del contenedor.

* Las pruebas incluyen contenedores basados en Debian, Ubuntu y Java con resultados variables. Es posible que otros entornos funcionen, pero no se han probado.


## Configuración de credenciales de registro
{: #configure-credentials}

Puede permitir que todos los usuarios del conversor de contenedor {{site.data.keyword.datashield_short}} obtengan imágenes de entrada y envíen imágenes de salida a los registros privados configurados mediante la configuración del conversor con credenciales de registro. Si ha utilizado Container Registry antes del 4 de octubre de 2018, es posible que desee [habilitar la aplicación de políticas de acceso de IAM para el registro](/docs/services/Registry?topic=registry-user#existing_users).
{: shortdesc}

### Configuración de las credenciales de {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión. Si tiene un ID federado, añada la opción `--sso` al final del mandato.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Cree un ID de servicio y una clave de API de ID de servicio para el conversor de contenedores de {{site.data.keyword.datashield_short}}.

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. Otorgue al ID de servicio permiso para acceder a su registro de contenedor.

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. Cree un archivo de configuración JSON utilizando la clave de API que ha creado. Sustituya la variable `<api key>` y, a continuación, ejecute el mandato siguiente. Si no tiene `openssl`, puede utilizar cualquier codificador base64 de línea de mandatos con las opciones adecuadas. Asegúrese de que no haya líneas nuevas en medio o al final de la serie codificada.

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### Configuración de credenciales para otro registro
{: #configure-other-registry}

Si ya tiene un archivo `~/.docker/config.json` que se autentica en el registro que desea utilizar, puede usar dicho archivo. Los archivos de OS X no reciben soporte actualmente.

1. Configure [secretos de extracción](/docs/containers?topic=containers-images#other).

2. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión. Si tiene un ID federado, añada la opción `--sso` al final del mandato.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. Ejecute el mandato siguiente.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## Conversión de las imágenes
{: #converting-images}

Puede utilizar la API de Enclave Manager para conectarse al conversor.
{: shortdesc}

También puede convertir los contenedores al crear las apps mediante la [IU de Enclave Manager](/docs/services/data-shield?topic=enclave-manager#em-apps).
{: tip}

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión. Si tiene un ID federado, añada la opción `--sso` al final del mandato.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Obtenga y exporte una señal de IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. Convierta la imagen. Asegúrese de sustituir las variables por la información de su aplicación.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Conversión de aplicaciones Java
{: #convert-java}

Cuando se convierten aplicaciones basadas en Java, existen unos cuantos requisitos y limitaciones adicionales. Cuando se convierten aplicaciones Java mediante la interfaz de usuario de Enclave Manager, puede seleccionar `Java-Mode`. Para convertir apps Java mediante la API, tenga en cuenta las siguientes limitaciones y opciones.

**Limitaciones**

* El tamaño máximo recomendado para las apps Java es de 4 GB. Los enclaves más grandes pueden funcionar, pero es posible que su rendimiento sea menor.
* El tamaño de almacenamiento dinámico recomendado es menor que el tamaño de enclave. Recomendamos eliminar la opción `-Xmx` como método para reducir el tamaño de almacenamiento dinámico.
* Se han probado las siguientes bibliotecas Java:
  - MySQL Java Connector
  - Crypto (`JCA`)
  - Messaging (`JMS`)
  - Hibernate (`JPA`)

  Si trabaja con otra biblioteca, póngase en contacto con nuestro equipo mediante foros o pulsando el botón de comentarios de esta página. Asegúrese de incluir la información de contacto y la biblioteca con la que desea trabajar.


**Opciones**

Para utilizar la conversión de `Java-Mode`, modifique el archivo Docker para proporcionar las opciones siguientes. Para que la conversión de Java funcione, debe establecer todas las variables tal como están definidas en esta sección. 


* Establezca la variable de entorno MALLOC_ARENA_MAX igual a 1.

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* Si utiliza `JVM de OpenJDK`, establezca las opciones siguientes.

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData
  -XX:ReservedCodeCacheSize=16m
  -XX:-UseCompiler
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* Si utiliza `JVM de OpenJ9`, establezca las opciones siguientes.

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## Solicitud de un certificado de aplicación
{: #request-cert}

Una aplicación convertida puede solicitar un certificado a Enclave Manager cuando se inicia la aplicación. Los certificados los firma la entidad emisora de certificados de Enclave Manager e incluyen un informe de certificación remota de Intel para el enclave SGX de la app.
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
 {: codeblock}


## Colocación de aplicaciones en la lista blanca
{: #convert-whitelist}

Cuando se convierte una imagen de Docker para que se ejecute dentro de Intel® SGX, se puede incluir en una lista blanca. Al incluir la imagen en una lista blanca, se le asignarán privilegios de administración que permitirán que la aplicación se pueda ejecutar en el clúster donde está instalado {{site.data.keyword.datashield_short}}.
{: shortdesc}


1. Obtenga una señal de acceso de Enclave Manager utilizando la señal de autenticación de IAM:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. Realice una solicitud de inclusión en lista blanca a Enclave Manager. Asegúrese de especificar su información al ejecutar el mandato siguiente.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. Utilice la GUI de Enclave Manager para aprobar o denegar solicitudes de lista blanca. Puede realizar el seguimiento y gestionar las compilaciones en lista blanca en la sección **Tareas** de la GUI.

