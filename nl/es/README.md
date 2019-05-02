# IBM Cloud Data Shield

Con IBM Cloud Data Shield, Fortanix® e Intel® SGX, puede proteger los datos de sus cargas de trabajo de contenedor que se ejecutan en IBM Cloud mientras los datos están en uso.

## Introducción

Cuando se trata de proteger sus datos, el cifrado es una de las maneras más populares y efectivos. Sin embargo, los datos se tienen que cifrar en cada paso de su ciclo de vida para que realmente estén protegidos. Las tres fases del ciclo de vida de los datos incluyen datos en reposo, datos en movimiento y datos en uso. Los datos en reposo y en movimiento se utilizan habitualmente para proteger los datos cuando se almacenan y cuando se transportan.

No obstante, después de que una aplicación empiece a ejecutarse, los datos en uso por la CPU o la memoria son vulnerables a posibles ataques. Las personas maliciosas con información privilegiada, usuarios root, credenciales que hayan visto comprometidas, SO en día cero e intrusos de la red constituyen todos amenazas a los datos. Llevando el cifrado un paso más allá, ahora puede proteger los datos en uso. 

Para obtener más información sobre el servicio y lo que implica proteger los datos en uso, puede aprender más
[acerca del servicio](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about).



## Detalles del diagrama

Este diagrama de Helm instala los componentes siguientes en el clúster del servicio IBM Cloud Kubernetes habilitado para SGX:

 * El software de soporte para SGX, que se instala en los hosts nativos mediante un contenedor con privilegios.
 * Enclave Manager de IBM Cloud Data Shield, que gestiona los enclaves SGX en el entorno de IBM Cloud Data Shield.
 * El servicio de conversión de contenedores de EnclaveOS®, que convierte aplicaciones contenerizadas para que se puedan ejecutar en el entorno de
IBM Cloud Data Shield.



## Recursos necesarios

* Un clúster de Kubernetes habilitado para SGX. Actualmente, se puede habilitar SGX en un clúster nativo con el tipo de nodo mb2c.4x32. Si no dispone de uno, puede utilizar los pasos siguientes como ayuda para asegurarse de crear el clúster que necesita.
  1. Realice los preparativos para [crear el clúster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Asegúrese de que tiene los [permisos necesarios](https://cloud.ibm.com/docs/containers?topic=containers-users#users) para crear un clúster.

  3. Cree el [clúster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters).

* Una instancia del servicio [cert-manager](https://cert-manager.readthedocs.io/en/latest/) de la versión 0.5.0 o posterior. Para instalar la instancia utilizando Helm, puede ejecutar el mandato siguiente.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## Requisitos previos

Para poder empezar a utilizar IBM Cloud Data Shield, primero debe cumplir los requisitos previos siguientes. Como ayuda para obtener las CLI y los plugins descargados y configurar el entorno del servicio Kubernetes, consulte la guía de aprendizaje para la
[creación de clústeres de Kubernetes](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Las CLI siguientes:

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  Es posible que quiera configurar Helm para que utilice la modalidad `--tls`. Para obtener ayuda para habilitar TLS, consulte el
[repositorio de Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Si habilita TLS, asegúrese de añadir
`--tls` a cada mandato de Helm que ejecute.
  {: tip}

* Los [plugins de CLI de {{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) siguientes:

  * Servicio Kubernetes
  * Container Registry



## Instalación del diagrama

Al instalar un diagrama de Helm, tiene varias opciones y parámetros que puede utilizar para personalizar la instalación. Las instrucciones siguientes le guiarán a través de la instalación más básica y predeterminada del diagrama. Para obtener más información sobre las opciones, consulte
[la documentación de IBM Cloud Data Shield](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started).

Sugerencia: ¿Se almacenan sus imágenes en un registro privado? Puede utilizar el conversor de contenedores de EnclaveOS para configurar las imágenes para que funcionen con IBM Cloud Data Shield. Asegúrese de convertir las imágenes antes de desplegar el diagrama, de manera que tenga la información de configuración necesaria. Para obtener más información sobre cómo convertir imágenes, consulte
[la documentación](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert).


**Para instalar IBM Cloud Data Shield en el clúster:**

1. Inicie sesión en la CLI de IBM Cloud. Siga las indicaciones de la CLI para completar el inicio de sesión.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

2. Establezca el contexto del clúster.

  1. Obtenga el mandato para establecer la variable de entorno y descargar los archivos de configuración de Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```

  2. Copie la salida a partir de `export` y péguela en el terminal para establecer la variable de entorno
`KUBECONFIG`.

3. Si aún no lo ha hecho, añada el repositorio `ibm`.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. Opcional: si no sabe cuál es la dirección de correo electrónico asociada con el administrador o el ID de la cuenta de administrador, ejecute el mandato siguiente.

  ```
  ibmcloud account show
  ```

5. Obtenga el subdominio Ingress para el clúster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. Instale el diagrama.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  Nota: si ha [configurado IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert) para el conversor, añada la opción siguiente: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. Para supervisar el inicio de los componentes, puede ejecutar el mandato siguiente.

  ```
  kubectl get pods
  ```

## Ejecución de las apps en el entorno de IBM Cloud Data Shield

Para ejecutar sus aplicaciones en el entorno de IBM Cloud Data Shield, debe convertir la aplicación de contenedor, incluirl en una lista blanca y, a continuación, desplegarla.

### Conversión de las imágenes
{: #converting-images}

Puede utilizar la API de Enclave Manager para conectarse al conversor.
{: shortdesc}

1. Inicie sesión en la CLI de IBM Cloud. Siga las indicaciones de la CLI para completar el inicio de sesión.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. Obtenga y exporte una señal de IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. Convierta la imagen. Asegúrese de sustituir las variables por la información de su aplicación.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### Inclusión de la aplicación en una lista blanca
{: #convert-whitelist}

Cuando se convierte una imagen de Docker para que se ejecute dentro de Intel SGX, se puede incluir en una lista blanca. Al incluir la imagen en una lista blanca, se le asignarán privilegios de administración que permitirán que la aplicación se pueda ejecutar en el clúster donde está instalado
IBM Cloud Data Shield.
{: shortdesc}

1. Obtenga una señal de acceso de Enclave Manager utilizando la señal de autenticación de IAM, utilizando la solicitud curl siguiente:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. Realice una solicitud de inclusión en lista blanca a Enclave Manager. Asegúrese de especificar su información al ejecutar el mandato siguiente.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. Utilice la GUI de Enclave Manager para aprobar o denegar solicitudes de lista blanca. Puede realizar el seguimiento y gestionar las compilaciones en lista blanca en la sección **Compilaciones** de la GUI.



### Despliegue de contenedores de IBM Cloud Data Shield

Tras convertir las imágenes, debe volver a desplegar los contenedores de IBM Cloud Data Shield en su clúster de Kubernetes.
{: shortdesc}

Al desplegar contenedores de IBM Cloud Data Shield en el clúster de Kubernetes, la especificación del contenedor debe incluir montajes de volúmenes. Los volúmenes permiten que los dispositivos SGX y el socket AESM estén disponibles en el contenedor.

1. Guarde la especificación de pod siguiente como plantilla.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. Actualice los campos `your-app-sgx` y `your-registry-server` para su app y servidor.

3. Cree el pod de Kubernetes.

   ```
   kubectl create -f template.yml
   ```

¿No tiene ninguna aplicación con la que probar el servicio? No pasa nada. Ofrecemos varias apps de ejemplo que puede probar, incluyendo MariaDB y NGINX. Puede utilizarse como ejemplo cualquiera de las
[imágenes "datashield"](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter) de IBM Container Registry.



## Acceso a la GUI de Enclave Manager

Puede obtener una visión general de todas las aplicaciones que se ejecutan en un entorno de IBM Cloud Data Shield utilizando la GUI de Enclave Manager. En la consola de Enclave Manager, puede ver los nodos del clúster, su estado de testificación, tareas y un registro de auditoría de sucesos del clúster. También puede aprobar y denegar solicitudes de lista blanca.

Para acceder a la GUI:

1. Inicie sesión en IBM Cloud y establezca el contexto para el clúster.

2. Compruebe si el servicio está en ejecución confirmando que todos los pods están en el estado *en ejecución*.

  ```
  kubectl get pods
  ```

3. Busque el URL de programa de usuario de Enclave Manager ejecutando el mandato siguiente.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Obtenga el subdominio Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. En un navegador, especifique el subdominio Ingress donde esté disponible Enclave Manager.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. En el terminal, obtenga la señal de IAM.

  ```
  ibmcloud iam oauth-tokens
  ```

7. Copie la señal y péguela en la GUI de Enclave Manager. No es necesario que copie la parte de `Bearer` de la señal impresa.

8. Pulse **Iniciar sesión**.

Para obtener información sobre los roles que necesita un usuario para realizar distintas acciones, consulte
[Establecimiento de roles para usuarios de Enclave Manager](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles).

## Utilización de imágenes blindadas preempaquetadas

El equipo de IBM Cloud Data Shield ha reunido cuatro imágenes distintas preparadas para producción que se pueden ejecutar en entornos de
IBM Cloud Data Shield. Puede probar cualquiera de las imágenes siguientes:

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## Desinstalación y resolución de problemas

Si encuentra un problema mientras trabaja con IBM Cloud Data Shield, intente buscar en las secciones de
[resolución de problemas](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting) o [preguntas más frecuentes](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq) de la documentación. Si no encuentra su pregunta o una solución a su problema, póngase en contacto con el
[soporte de IBM](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).

Si ya no necesita utilizar IBM Cloud Data Shield, puede
[suprimir el servicio y los certificados TLS que se hayan creado](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall).

