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

# Disinstallazione
{: #uninstall}

Se non hai più bisogno di utilizzare {{site.data.keyword.datashield_full}}, puoi eliminare il servizio e i certificati TLS che erano stati creati.


## Disinstallazione con Helm

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}.Segui i prompt nella CLI per completare l'accesso.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: pre}

  <table>
    <tr>
      <th>Regione </th>
      <th>Endpoint IBM Cloud</th>
      <th>Regione del Kubernetes Service</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>Stati Uniti Sud</td>
    </tr>
    <tr>
      <td>Francoforte</td>
      <td><code>eu-de</code></td>
      <td>Europa Centrale</td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
      <td>Asia Pacifico Sud</td>
    </tr>
    <tr>
      <td>Londra</td>
      <td><code>eu-gb</code></td>
      <td>Regno Unito Sud</td>
    </tr>
    <tr>
      <td>Tokyo</td>
      <td><code>jp-tok</code></td>
      <td>Asia Pacifico Nord</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>Stati Uniti Est</td>
    </tr>
  </table>

2. Imposta il contesto per il tuo cluster.

  1. Ottieni il comando per impostare la variabile di ambiente e scaricare i file di configurazione Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copia l'output e incollalo nel tuo terminale.

3. Elimina il servizio.

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. Elimina i certificati TLS eseguendo ognuno dei seguenti comandi.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. Il processo di disinstallazione utilizza gli "hook" Helm per eseguire un programma di disinstallazione. Puoi eliminare il programma di disinstallazione dopo che è stato eseguito.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

Potresti voler eliminare l'istanza `cert-manager` e il segreto di configurazione di Docker, se ne hai creato uno.
{: tip}



## Disinstallazione con il programma di installazione beta
{: #uninstall-installer}

Se hai installato {{site.data.keyword.datashield_short}} utilizzando il programma di installazione beta, puoi anche disinstallare il servizio con il programma di installazione.

Per disinstallare {{site.data.keyword.datashield_short}}, accedi alla CLI `ibmcloud`, indica come destinazione il tuo cluster ed esegui questo comando:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
