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

# Disinstallazione
{: #uninstall}

Se non hai più bisogno di utilizzare {{site.data.keyword.datashield_full}}, puoi eliminare il servizio e i certificati TLS che erano stati creati.


## Disinstallazione con Helm
{: #uninstall-helm}

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}. Segui i prompt nella CLI per completare l'accesso. Se hai un ID federato, aggiungi l'opzione `--sso` alla fine del comando.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Regione</th>
      <th>Endpoint {{site.data.keyword.cloud_notm}}</th>
      <th>Regione {{site.data.keyword.containershort_notm}}</th>
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
    {: codeblock}

  2. Copia l'output e incollalo nella tua console.

3. Elimina il servizio.

  ```
  helm delete <chart-name> --purge
  ```
  {: codeblock}

4. Elimina i certificati TLS eseguendo ognuno dei seguenti comandi.

  ```
  kubectl delete secret <chart-name>-enclaveos-converter-tls
  kubectl delete secret <chart-name>-enclaveos-frontend-tls
  kubectl delete secret <chart-name>-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. Il processo di disinstallazione utilizza gli "hook" Helm per eseguire un programma di disinstallazione. Puoi eliminare il programma di disinstallazione dopo che è stato eseguito.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

Potresti voler eliminare l'istanza `cert-manager` e il segreto di configurazione di Docker, se ne hai creato uno.
{: tip}


## Disinstallazione con il programma di installazione
{: #uninstall-installer}

Se hai installato {{site.data.keyword.datashield_short}} utilizzando il programma di installazione, puoi anche disinstallare il servizio con lo stesso programma.

Per disinstallare {{site.data.keyword.datashield_short}}, accedi alla CLI `ibmcloud`, indica come destinazione il tuo cluster ed esegui questo comando:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

