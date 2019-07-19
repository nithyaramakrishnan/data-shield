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

# Desinstalación
{: #uninstall}

Si ya no necesita utilizar {{site.data.keyword.datashield_full}}, puede suprimir el servicio y los certificados TLS que se hayan creado.


## Desinstalación con Helm
{: #uninstall-helm}

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión. Si tiene un ID federado, añada la opción `--sso` al final del mandato.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Región</th>
      <th>Punto final de {{site.data.keyword.cloud_notm}}</th>
      <th>Región de {{site.data.keyword.containershort_notm}}</th>
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
    {: codeblock}

  2. Copie la salida y péguela en la consola.

3. Suprima el servicio.

  ```
  helm delete <chart-name> --purge
  ```
  {: codeblock}

4. Suprima los certificados TLS ejecutando cada uno de los mandatos siguientes.

  ```
  kubectl delete secret <chart-name>-enclaveos-converter-tls
  kubectl delete secret <chart-name>-enclaveos-frontend-tls
  kubectl delete secret <chart-name>-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. El proceso de desinstalación utiliza "hooks" de Helm para ejecutar un desinstalador. Puede suprimir el desinstalador después de que se ejecute.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

Es posible que también desee suprimir la instancia de `cert-manager` y el secreto de configuración de Docker si ha creado uno.
{: tip}


## Desinstalación con el instalador
{: #uninstall-installer}

Si ha instalado {{site.data.keyword.datashield_short}} mediante el instalador, también puede desinstalar el servicio con el instalador.

Para desinstalar {{site.data.keyword.datashield_short}}, inicie sesión en la CLI `ibmcloud` y, con su clúster como objetivo, ejecute el mandato siguiente:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

