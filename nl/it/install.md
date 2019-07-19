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

# Installazione
{: #install}

Puoi installare {{site.data.keyword.datashield_full}} utilizzando il grafico Helm fornito oppure utilizzando il programma di installazione fornito. Puoi lavorare con i comandi di installazione che ritieni più adatti.
{: shortdesc}

## Prima di iniziare
{: #begin}

Prima di poter iniziare a lavorare con {{site.data.keyword.datashield_short}}, devi disporre dei seguenti prerequisiti. Per assistenza nel download di CLI e plugin o nella configurazione del tuo ambiente Kubernetes Service, consulta l'esercitazione di [creazione dei cluster Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Le seguenti CLI:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* I seguenti plugin della CLI [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* Un cluster Kubernetes abilitato a SGX. Attualmente, SGX può essere abilitato su un cluster bare metal con il tipo di nodo: mb2c.4x32. Se non ne hai uno, puoi attenerti alla seguente procedura per assicurarti di creare il cluster di cui hai bisogno.
  1. Preparati a [creare il tuo cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Assicurati di disporre delle [autorizzazioni necessarie](/docs/containers?topic=containers-users) per creare un cluster.

  3. Crea il [cluster](/docs/containers?topic=containers-clusters).

* Un'istanza del servizio [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} versione 0.5.0 o più recente. Per installare l'istanza utilizzando Helm, puoi eseguire questo comando.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Vuoi vedere le informazioni di registrazione per Data Shield? Configura un'istanza {{site.data.keyword.la_full_notm}} per il tuo cluster.
{: tip}


## Installazione con Helm
{: #install-chart}

Puoi utilizzare il grafico Helm fornito per installare {{site.data.keyword.datashield_short}} sul tuo cluster bare metal abilitato a SGX.
{: shortdesc}

Il grafico Helm installa i seguenti componenti:

*	Il software di supporto per SGX, che è installato sugli host bare metal da un contenitore privilegiato.
*	L'{{site.data.keyword.datashield_short}} Enclave Manager, che gestisce le enclave SGX nell'ambiente {{site.data.keyword.datashield_short}}.
*	Il servizio di conversione dei contenitori EnclaveOS®, che consente alle applicazioni inserite nei contenitori di essere eseguite nell'ambiente {{site.data.keyword.datashield_short}}.


Per installare {{site.data.keyword.datashield_short}} nel tuo cluster:

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}. Segui i prompt nella CLI per completare l'accesso. Se hai un ID federato, aggiungi l'opzione `--sso` alla fine del comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Imposta il contesto per il tuo cluster.

  1. Ottieni il comando per impostare la variabile di ambiente e scaricare i file di configurazione Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copia l'output che inizia con `export` e incollalo nel tuo terminale per impostare la variabile di ambiente `KUBECONFIG`.

3. Se non lo hai già fatto, aggiungi il repository `iks-charts`.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. Facoltativo: se non conosci l'email che è associata all'amministratore o all'ID dell'account di amministrazione, esegui questo comando.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. Ottieni il dominio secondario Ingress per il tuo cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

6. Ottieni le informazioni necessarie per configurare le funzionalità di [backup e ripristino](/docs/services/data-shield?topic=data-shield-backup-restore). 

7. Inizializza Helm creando una politica di bind del ruolo per Tiller. 

  1. Crea un account di servizio per Tiller.
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. Crea il bind del ruolo per assegnare l'accesso di amministratore Tiller nel cluster.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Inizializza Helm.

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  Potresti voler configurare Helm per utilizzare la modalità `--tls`. Per assistenza nell'abilitazione di TLS, consulta il [repository Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}. Se abiliti TLS, assicurati di accodare `--tls` a ogni comando Helm che esegui. Per ulteriori informazioni sull'utilizzo di Helm con IBM Cloud Kubernetes Service, vedi [Aggiunta di servizi attraverso i grafici Helm](/docs/containers?topic=containers-helm#public_helm_install).
  {: tip}

8. Installa il grafico.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Se hai [configurato un {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) per il tuo programma di conversione, devi aggiungere `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

9. Per monitorare l'avvio dei tuoi componenti, puoi eseguire questo comando.

  ```
  kubectl get pods
  ```
  {: codeblock}



## Installazione con il programma di installazione
{: #installer}

Puoi utilizzare il programma di installazione per installare rapidamente {{site.data.keyword.datashield_short}} sul tuo cluster bare metal abilitato a SGX.
{: shortdesc}

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}. Segui i prompt nella CLI per completare l'accesso.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. Imposta il contesto per il tuo cluster.

  1. Ottieni il comando per impostare la variabile di ambiente e scaricare i file di configurazione Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copia l'output e incollalo nella tua console.

3. Accedi alla CLI Container Registry.

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. Effettua il pull dell'immagine sul tuo sistema locale.

  ```
  docker pull <region>.icr.io/ibm/datashield-installer
  ```
  {: codeblock}

5. Installa {{site.data.keyword.datashield_short}} eseguendo questo comando.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  Per installare la versione più recente di {{site.data.keyword.datashield_short}}, utilizza `latest` per l'indicatore `--version`.

