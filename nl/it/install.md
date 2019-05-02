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

# Installazione
{: #deploying}

Puoi installare {{site.data.keyword.datashield_full}} utilizzando il grafico Helm fornito oppure utilizzando il programma di installazione fornito. Puoi lavorare con i comandi di installazione con cui ti senti più a tuo agio.
{: shortdesc}

## Prima di iniziare
{: #begin}

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

* Un'istanza del servizio [cert-manager](https://cert-manager.readthedocs.io/en/latest/) versione 0.5.0 o più recente. Per installare l'istanza utilizzando Helm, puoi eseguire questo comando.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Facoltativo: creazione di uno spazio dei nomi Kubernetes
{: #create-namespace}

Per impostazione predefinita, {{site.data.keyword.datashield_short}} è installato nello spazio dei nomi `kube-system`. Facoltativamente, puoi utilizzare uno spazio dei nomi alternativo creandone uno nuovo.
{: shortdesc}


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

3. Crea uno spazio dei nomi.

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. Copia i segreti pertinenti dallo spazio dei nomi predefinito al tuo nuovo spazio dei nomi.

  1. Elenca i tuoi segreti disponibili.

    ```
    kubectl get secrets
    ```
    {: pre}

    I segreti che iniziano con `bluemix*` devono essere copiati.
    {: tip}

  2. Copia i segreti uno per volta.

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. Verifica che i tuoi segreti siano stati copiati nella loro destinazione.

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. Crea un account di servizio. Per vedere tutte le tue opzioni di personalizzazione, consulta la [pagina RBAC nel repository Helm GitHub](https://github.com/helm/helm/blob/master/docs/rbac.md).

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. Genera i certificati e abilita Helm con TLS attenendoti alle istruzioni disponibili nel [repository Tiller SSL GitHub](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Assicurati di specificare lo spazio dei nomi che hai creato.

Eccellente. Ora sei pronto a installare {{site.data.keyword.datashield_short}} nel tuo spazio dei nomi. Da questo punto in poi, assicurati di aggiungere `--tiller-namespace <namespace_name>` a tutti i comandi Helm che esegui.


## Installazione con un grafico Helm
{: #install-chart}

Puoi utilizzare il grafico Helm fornito per installare {{site.data.keyword.datashield_short}} sul tuo cluster bare metal abilitato a SGX.
{: shortdesc}

Il grafico Helm installa i seguenti componenti:

*	Il software di supporto per SGX, che è installato sugli host bare metal da un contenitore privilegiato.
*	L'{{site.data.keyword.datashield_short}} Enclave Manager, che gestisce le enclave SGX nell'ambiente {{site.data.keyword.datashield_short}}.
*	Il servizio di conversione dei contenitori EnclaveOS®, che consente alle applicazioni inserite nei contenitori di essere eseguite nell'ambiente {{site.data.keyword.datashield_short}}.


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

  Se hai [configurato un {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) per il tuo programma di conversione, devi aggiungere `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Per monitorare l'avvio dei tuoi componenti, puoi eseguire questo comando.

  ```
  kubectl get pods
  ```
  {: pre}



## Installazione con il programma di installazione {{site.data.keyword.datashield_short}}
{: #installer}

Puoi utilizzare il programma di installazione per installare rapidamente {{site.data.keyword.datashield_short}} sul tuo cluster bare metal abilitato a SGX.
{: shortdesc}

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}.Segui i prompt nella CLI per completare l'accesso.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Imposta il contesto per il tuo cluster.

  1. Ottieni il comando per impostare la variabile di ambiente e scaricare i file di configurazione Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copia l'output e incollalo nel tuo terminale.

3. Accedi alla CLI Container Registry.

  ```
  ibmcloud cr login
  ```
  {: pre}

4. Effettua il pull dell'immagine alla tua macchina locale.

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: pre}

5. Installa {{site.data.keyword.datashield_short}} eseguendo questo comando.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Per installare la versione più recente di {{site.data.keyword.datashield_short}}, utilizza `latest` per l'indicatore `--version`.


## Aggiornamento del servizio
{: #update}

Quando {{site.data.keyword.datashield_short}} è installato sul tuo cluster, puoi eseguire l'aggiornamento in qualsiasi momento.

Per eseguire l'aggiornamento alla versione più recente con il grafico Helm, esegui questo comando.

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: pre}


Per eseguire l'aggiornamento alla versione più recente con il programma di installazione, esegui questo comando:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Per installare la versione più recente di {{site.data.keyword.datashield_short}}, utilizza `latest` per l'indicatore `--version`.

