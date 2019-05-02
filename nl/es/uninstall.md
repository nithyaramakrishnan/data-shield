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

# Desinstalación
{: #uninstall}

Si ya no necesita utilizar {{site.data.keyword.datashield_full}}, puede suprimir el servicio y los certificados TLS que se hayan creado.


## Desinstalación con Helm

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión.

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

3. Suprima el servicio.

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. Suprima los certificados TLS ejecutando cada uno de los mandatos siguientes.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. El proceso de desinstalación utiliza "hooks" de Helm para ejecutar un desinstalador. Puede suprimir el desinstalador después de que se ejecute.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

Es posible que también desee suprimir la instancia de `cert-manager` y el secreto de configuración de Docker si ha creado uno.
{: tip}



## Desinstalación con el instalador beta
{: #uninstall-installer}

Si ha instalado {{site.data.keyword.datashield_short}} utilizando el instalador beta, también puede desinstalar el servicio con el instalador.

Para desinstalar {{site.data.keyword.datashield_short}}, inicie sesión en la CLI `ibmcloud` y, con su clúster como objetivo, ejecute el mandato siguiente:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
