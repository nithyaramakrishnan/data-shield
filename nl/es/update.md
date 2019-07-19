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

# Actualizando
{: #update}

Cuando {{site.data.keyword.datashield_short}} esté instalado en el clúster, puede actualizarlo en cualquier momento.
{: shortdesc}

## Configuración del contexto del clúster
{: #update-context}

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

  2. Copie la salida y péguela en la consola.

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

## Actualización con Helm
{: #update-helm}

Para actualizar a la versión más reciente con el diagrama de Helm, ejecute el mandato siguiente.

  ```
  helm upgrade <chart-name> ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

## Actualización con el instalador
{: #update-installer}

Para actualizar a la versión más reciente con el instalador, ejecute el mandato siguiente.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer upgrade [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ] [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  Para instalar la versión más reciente de {{site.data.keyword.datashield_short}}, utilice `latest` para el distintivo `--version`.


