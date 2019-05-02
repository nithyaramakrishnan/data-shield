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

# Instalación
{: #deploying}

Puede instalar {{site.data.keyword.datashield_full}} utilizando el diagrama de Helm proporcionado o utilizando el instalador proporcionado. Puede trabajar con los mandatos de instalación con los que se sienta más cómodo.
{: shortdesc}

## Antes de empezar
{: #begin}

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

* Una instancia del servicio [cert-manager](https://cert-manager.readthedocs.io/en/latest/) de la versión 0.5.0 o posterior. Para instalar la instancia utilizando Helm, puede ejecutar el mandato siguiente.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Opcional: Creación de un espacio de nombres de Kubernetes
{: #create-namespace}

De forma predeterminada, {{site.data.keyword.datashield_short}} se instala en el espacio de nombres `kube-system`. De manera opcional, puede utilizar un espacio de nombres alternativo creando uno nuevo.
{: shortdesc}


1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para finalizar el inicio de sesión.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
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

  2. Copie la salida y péguela en el terminal.

3. Cree un espacio de nombres.

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. Copie los secretos pertinentes del espacio de nombres predeterminado al nuevo espacio de nombres.

  1. Obtenga una lista de los secretos disponibles.

    ```
    kubectl get secrets
    ```
    {: pre}

    Se deben copiar los secretos que empiecen por `bluemix*`.
    {: tip}

  2. De uno en uno, copie los secretos.

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. Compruebe que se hayan copiado los secretos.

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. Cree una cuenta de servicio. Para ver todas las opciones de personalización, consulte la [página de RBAC en el repositorio de GitHub de Helm](https://github.com/helm/helm/blob/master/docs/rbac.md).

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. Genere certificados y habilite Helm con TLS siguiendo las instrucciones que aparecen en el [repositorio de GitHub de Tiller SSL](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Asegúrese de especificar el espacio de nombres que ha creado.

¡Excelente! Ahora está preparado para instalar {{site.data.keyword.datashield_short}} en el nuevo espacio de nombres. A partir de este punto, asegúrese de añadir `--tiller-namespace <namespace_name>` a cualquier mandato de Helm que ejecute.


## Instalación con un diagrama de Helm
{: #install-chart}

Puede utilizar el diagrama de Helm proporcionado para instalar {{site.data.keyword.datashield_short}} en su clúster nativo habilitado para SGX.
{: shortdesc}

El diagrama de Helm instala los componentes siguientes:

*	El software de soporte para SGX, que se instala en los hosts nativos mediante un contenedor con privilegios.
*	Enclave Manager de {{site.data.keyword.datashield_short}}, que gestiona los enclaves SGX en el entorno de {{site.data.keyword.datashield_short}}.
*	El servicio de conversión de contenedores de EnclaveOS®, que permite que se puedan ejecutar aplicaciones contenerizadas en el entorno de {{site.data.keyword.datashield_short}}.


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

  2. Copie la salida a partir de `export` y péguela en el terminal para establecer la variable de entorno
`KUBECONFIG`.

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

  Si ha [configurado {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) para el conversor, debe añadir `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Para supervisar el inicio de los componentes, puede ejecutar el mandato siguiente.

  ```
  kubectl get pods
  ```
  {: pre}



## Instalación con el instalador de {{site.data.keyword.datashield_short}}
{: #installer}

Puede utilizar el instalador para instalar rápidamente {{site.data.keyword.datashield_short}} en el clúster nativo habilitado para SGX.
{: shortdesc}

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Establezca el contexto del clúster.

  1. Obtenga el mandato para establecer la variable de entorno y descargar los archivos de configuración de Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copie la salida y péguela en el terminal.

3. Inicie sesión en la CLI de Container Registry.

  ```
  ibmcloud cr login
  ```
  {: pre}

4. Extraiga la imagen en la máquina local.

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: pre}

5. Instale {{site.data.keyword.datashield_short}} ejecutando el mandato siguiente.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Para instalar la versión más reciente de {{site.data.keyword.datashield_short}}, utilice
`latest` para el distintivo `--version`.


## Actualización del servicio
{: #update}

Cuando {{site.data.keyword.datashield_short}} se instale en el clúster, puede actualizarlo en cualquier momento.

Para actualizar a la versión más reciente con el diagrama de Helm, ejecute el mandato siguiente.

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: pre}


Para actualizar a la versión más reciente con el instalador, ejecute el mandato siguiente:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Para instalar la versión más reciente de {{site.data.keyword.datashield_short}}, utilice `latest` para el distintivo `--version`.

