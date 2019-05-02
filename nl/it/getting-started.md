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

# Esercitazione introduttiva
{: #getting-started}

Con {{site.data.keyword.datashield_full}}, con tecnologia Fortanix®, puoi proteggere i dati nei tuoi carichi di lavoro del contenitore che vengono eseguiti su {{site.data.keyword.cloud_notm}} mentre i dati sono in uso.
{: shortdesc}

Per ulteriori informazioni su {{site.data.keyword.datashield_short}} e su cosa significhi proteggere i tuoi dati in uso, puoi consultare le [informazioni sul servizio](/docs/services/data-shield?topic=data-shield-about#about).

## Prima di iniziare
{: #gs-begin}

Prima di poter iniziare a lavorare con {{site.data.keyword.datashield_short}}, devi disporre dei seguenti prerequisiti. Per assistenza nel download di CLI e plugin o nella configurazione del tuo ambiente Kubernetes Service, consulta l'esercitazione di [creazione dei cluster Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Le seguenti CLI:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  Potresti voler configurare Helm per utilizzare la modalità `--tls`. Per assistenza nell'abilitazione di TLS, consulta il [repository Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Se abiliti TLS, assicurati di accodare `--tls` a ogni comando Helm che esegui.
  {: tip}

* I seguenti plugin della CLI [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes Service
  * Container Registry

* Un cluster Kubernetes abilitato a SGX. Attualmente, SGX può essere abilitato su un cluster bare metal con il tipo di nodo: mb2c.4x32. Se non ne hai uno, puoi attenerti alla seguente procedura per assicurarti di creare il cluster di cui hai bisogno.
  1. Preparati a [creare il tuo cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Assicurati di disporre delle [autorizzazioni necessarie](/docs/containers?topic=containers-users#users) per creare un cluster.

  3. Crea il [cluster](/docs/containers?topic=containers-clusters#clusters).

* Un'istanza del servizio [cert-manager](https://cert-manager.readthedocs.io/en/latest/) versione 0.5.0 o più recente. L'installazione predefinita utilizza <code>cert-manager</code> per configurare i [certificati TLS](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates) per le comunicazioni interne tra i servizi {{site.data.keyword.datashield_short}}. Per installare un'istanza utilizzando Helm, puoi eseguire questo comando.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Installazione con un grafico Helm
{: #gs-install-chart}

Puoi utilizzare il grafico Helm fornito per installare {{site.data.keyword.datashield_short}} sul tuo cluster bare metal abilitato a SGX.
{: shortdesc}

Il grafico Helm installa i seguenti componenti:

*	Il software di supporto per SGX, che è installato sugli host bare metal da un contenitore privilegiato.
*	L'{{site.data.keyword.datashield_short}} Enclave Manager, che gestisce le enclave SGX nell'ambiente {{site.data.keyword.datashield_short}}.
*	Il servizio di conversione dei contenitori EnclaveOS®, che consente alle applicazioni inserite nei contenitori di essere eseguite nell'ambiente {{site.data.keyword.datashield_short}}.

Quando installi un grafico Helm, disponi di diverse opzioni e diversi parametri per personalizzare la tua installazione. La seguente esercitazione ti assiste nell'installazione predefinita più elementare del grafico. Per ulteriori informazioni sulle tue opzioni, vedi [Installazione di {{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-deploying).
{: tip}

Per installare {{site.data.keyword.datashield_short}} nel tuo cluster:

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}.Segui i prompt nella CLI per completare l'accesso.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
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

  2. Copia l'output che inizia con `export` e incollalo nel tuo terminale per impostare la variabile di ambiente `KUBECONFIG`.

3. Se non lo hai già fatto, aggiungi il repository `ibm`.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. Facoltativo: se non conosci l'email che è associata all'amministratore o all'ID dell'account di amministrazione, esegui questo comando.

  ```
  ibmcloud account show
  ```
  {: pre}

5. Ottieni il dominio secondario Ingress per il tuo cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. Installa il grafico.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  Se hai [configurato un {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) per il tuo programma di conversione, puoi aggiungere la seguente opzione: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. Per monitorare l'avvio dei tuoi componenti, puoi eseguire questo comando.

  ```
  kubectl get pods
  ```
  {: pre}


## Passi successivi
{: #gs-next}

Ottimo lavoro. Ora che il servizio è installato sul tuo cluster, puoi eseguire le tue applicazioni nell'ambiente {{site.data.keyword.datashield_short}}. 

Per eseguire le tue applicazioni in un ambiente {{site.data.keyword.datashield_short}}, devi [convertire](/docs/services/data-shield?topic=data-shield-convert#convert), [inserire in whitelist](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist) e quindi [distribuire](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers) la tua immagine del contenitore.

Se non hai una tua immagine da distribuire, prova a distribuire una delle immagini {{site.data.keyword.datashield_short}} preconfezionate.

* [Repository GitHub di esempi {{site.data.keyword.datashield_short}}](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* MariaDB o NGINX in {{site.data.keyword.cloud_notm}} Container Registry
