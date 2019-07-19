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

# Instalación
{: #install}

Puede instalar {{site.data.keyword.datashield_full}} utilizando el diagrama de Helm proporcionado o utilizando el instalador proporcionado. Puede trabajar con los mandatos de instalación con los que se sienta más cómodo.
{: shortdesc}

## Antes de empezar
{: #begin}

Para poder empezar a trabajar con {{site.data.keyword.datashield_short}}, primero debe cumplir los requisitos previos siguientes. Como ayuda para descargar las CLI y los plugins o para configurar el entorno del servicio Kubernetes, consulte la guía de aprendizaje para la [creación de clústeres de Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Las CLI siguientes:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* Los [plugins de CLI de {{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) siguientes:

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* Un clúster de Kubernetes habilitado para SGX. Actualmente, se puede habilitar SGX en un clúster nativo con el tipo de nodo mb2c.4x32. Si no dispone de uno, puede utilizar los pasos siguientes como ayuda para asegurarse de crear el clúster que necesita.
  1. Realice los preparativos para [crear el clúster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Asegúrese de que tiene los [permisos necesarios](/docs/containers?topic=containers-users) para crear un clúster.

  3. Cree el [clúster](/docs/containers?topic=containers-clusters).

* Una instancia del servicio [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} de la versión 0.5.0 o posterior. Para instalar la instancia utilizando Helm, puede ejecutar el mandato siguiente.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

¿Desea ver información de registro para Data Shield? Configure una instancia de {{site.data.keyword.la_full_notm}} para el clúster.
{: tip}


## Instalación con Helm
{: #install-chart}

Puede utilizar el diagrama de Helm proporcionado para instalar {{site.data.keyword.datashield_short}} en su clúster nativo habilitado para SGX.
{: shortdesc}

El diagrama de Helm instala los componentes siguientes:

*	El software de soporte para SGX, que se instala en los hosts nativos mediante un contenedor con privilegios.
*	Enclave Manager de {{site.data.keyword.datashield_short}}, que gestiona los enclaves SGX en el entorno de {{site.data.keyword.datashield_short}}.
*	El servicio de conversión de contenedores de EnclaveOS®, que permite que se puedan ejecutar aplicaciones contenerizadas en el entorno de {{site.data.keyword.datashield_short}}.


Para instalar {{site.data.keyword.datashield_short}} en el clúster:

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión. Si tiene un ID federado, añada la opción `--sso` al final del mandato.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Establezca el contexto del clúster.

  1. Obtenga el mandato para establecer la variable de entorno y descargar los archivos de configuración de Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copie la salida a partir de `export` y péguela en el terminal para establecer la variable de entorno
`KUBECONFIG`.

3. Si aún no lo ha hecho, añada el repositorio `iks-charts`.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. Opcional: si no sabe cuál es la dirección de correo electrónico asociada con el administrador o el ID de la cuenta de administrador, ejecute el mandato siguiente.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. Obtenga el subdominio Ingress para el clúster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

6. Obtenga la información que necesita para configurar las prestaciones de [copia de seguridad y restauración](/docs/services/data-shield?topic=data-shield-backup-restore). 

7. Inicialice Helm creando una política de enlace de rol para Tiller. 

  1. Cree una cuenta de servicio para Tiller.
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. Cree el enlace de rol para asignar el acceso de administrador de Tiller en el clúster.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Inicialice Helm.

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  Es posible que quiera configurar Helm para que utilice la modalidad `--tls`. Para obtener ayuda para habilitar TLS, consulte el [repositorio de Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}. Si habilita TLS, asegúrese de añadir `--tls` a cada mandato de Helm que ejecute. Para obtener más información sobre el uso de Helm con el servicio Kubernetes de IBM Cloud, consulte [Adición de servicios mediante diagramas de Helm](/docs/containers?topic=containers-helm#public_helm_install).
  {: tip}

8. Instale el diagrama.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Si ha [configurado {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) para el conversor, debe añadir `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

9. Para supervisar el inicio de los componentes, puede ejecutar el mandato siguiente.

  ```
  kubectl get pods
  ```
  {: codeblock}



## Instalación con el instalador
{: #installer}

Puede utilizar el instalador para instalar rápidamente {{site.data.keyword.datashield_short}} en el clúster nativo habilitado para SGX.
{: shortdesc}

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. Establezca el contexto del clúster.

  1. Obtenga el mandato para establecer la variable de entorno y descargar los archivos de configuración de Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copie la salida y péguela en la consola.

3. Inicie sesión en la CLI de Container Registry.

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. Extraiga la imagen en su sistema local.

  ```
  docker pull <region>.icr.io/ibm/datashield-installer
  ```
  {: codeblock}

5. Instale {{site.data.keyword.datashield_short}} ejecutando el mandato siguiente.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  Para instalar la versión más reciente de {{site.data.keyword.datashield_short}}, utilice `latest` para el distintivo `--version`.

