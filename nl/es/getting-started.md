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

# Guía de aprendizaje de iniciación
{: #getting-started}

Con {{site.data.keyword.datashield_full}}, basado en Fortanix®, puede proteger los datos de sus cargas de trabajo de contenedor que se ejecutan en {{site.data.keyword.cloud_notm}} mientras los datos están en uso.
{: shortdesc}

Para obtener más información sobre {{site.data.keyword.datashield_short}} y lo que implica proteger sus datos en uso, puede aprender más [acerca del servicio](/docs/services/data-shield?topic=data-shield-about#about).

## Antes de empezar
{: #gs-begin}

Para poder empezar a trabajar con {{site.data.keyword.datashield_short}}, primero debe cumplir los requisitos previos siguientes. Como ayuda para descargar las CLI y los plugins o para configurar el entorno del servicio Kubernetes, consulte la guía de aprendizaje para la [creación de clústeres de Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Las CLI siguientes:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  Es posible que quiera configurar Helm para que utilice la modalidad `--tls`. Para obtener ayuda para habilitar TLS, consulte el [repositorio de Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Si habilita TLS, asegúrese de añadir `--tls` a cada mandato de Helm que ejecute.
  {: tip}

* Los [plugins de CLI de {{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) siguientes:

  * Servicio Kubernetes
  * Container Registry

* Un clúster de Kubernetes habilitado para SGX. Actualmente, se puede habilitar SGX en un clúster nativo con el tipo de nodo mb2c.4x32. Si no dispone de uno, puede utilizar los pasos siguientes como ayuda para asegurarse de crear el clúster que necesita.
  1. Realice los preparativos para [crear el clúster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Asegúrese de que tiene los [permisos necesarios](/docs/containers?topic=containers-users#users) para crear un clúster.

  3. Cree el [clúster](/docs/containers?topic=containers-clusters#clusters).

* Una instancia del servicio [cert-manager](https://cert-manager.readthedocs.io/en/latest/) de la versión 0.5.0 o posterior. La instalación predeterminada utiliza <code>cert-manager</code> para configurar los [certificados TLS](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates) para la comunicación interna entre los servicios de {{site.data.keyword.datashield_short}}. Para instalar una instancia utilizando Helm, puede ejecutar el mandato siguiente.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Instalación con un diagrama de Helm
{: #gs-install-chart}

Puede utilizar el diagrama de Helm proporcionado para instalar {{site.data.keyword.datashield_short}} en su clúster nativo habilitado para SGX.
{: shortdesc}

El diagrama de Helm instala los componentes siguientes:

*	El software de soporte para SGX, que se instala en los hosts nativos mediante un contenedor con privilegios.
*	Enclave Manager de {{site.data.keyword.datashield_short}}, que gestiona los enclaves SGX en el entorno de {{site.data.keyword.datashield_short}}.
*	El servicio de conversión de contenedores de EnclaveOS®, que permite que se puedan ejecutar aplicaciones contenerizadas en el entorno de {{site.data.keyword.datashield_short}}.

Al instalar un diagrama de Helm, tiene varias opciones y parámetros para personalizar la instalación. La guía de aprendizaje siguiente le guiará a través de la instalación más básica y predeterminada del diagrama. Para obtener más información sobre las opciones, consulte [Instalación de {{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-deploying).
{: tip}

Para instalar {{site.data.keyword.datashield_short}} en el clúster:

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión.

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

2. Establezca el contexto del clúster.

  1. Obtenga el mandato para establecer la variable de entorno y descargar los archivos de configuración de Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copie la salida a partir de `export` y péguela en el terminal para establecer la variable de entorno `KUBECONFIG`.

3. Si aún no lo ha hecho, añada el repositorio `ibm`.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. Opcional: si no sabe cuál es la dirección de correo electrónico asociada con el administrador o el ID de la cuenta de administrador, ejecute el mandato siguiente.

  ```
  ibmcloud account show
  ```
  {: pre}

5. Obtenga el subdominio Ingress para el clúster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. Instale el diagrama.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  Si ha [configurado {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) para el conversor, puede añadir la opción siguiente: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. Para supervisar el inicio de los componentes, puede ejecutar el mandato siguiente.

  ```
  kubectl get pods
  ```
  {: pre}


## Pasos siguientes
{: #gs-next}

¡Buen trabajo! Ahora que se ha instalado el servicio en el clúster, puede ejecutar las apps en el entorno de {{site.data.keyword.datashield_short}}. 

Para ejecutar sus apps en un entorno de {{site.data.keyword.datashield_short}}, debe [convertir](/docs/services/data-shield?topic=data-shield-convert#convert), [incluir en una lista blanca](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist) y luego [desplegar](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers) su imagen de contenedor.

Si no tiene su propia imagen para el despliegue, intente desplegar una de las imágenes preempaquetadas de {{site.data.keyword.datashield_short}}:

* [Repositorio de GitHub de ejemplos de {{site.data.keyword.datashield_short}}](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* MariaDB o NGINX en {{site.data.keyword.cloud_notm}} Container Registry
