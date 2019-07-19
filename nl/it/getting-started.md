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

# Esercitazione introduttiva
{: #getting-started}

Con {{site.data.keyword.datashield_full}}, con tecnologia Fortanix®, puoi proteggere i dati nei tuoi carichi di lavoro del contenitore che vengono eseguiti su {{site.data.keyword.cloud_notm}} mentre i dati sono in uso.
{: shortdesc}

Per ulteriori informazioni su {{site.data.keyword.datashield_short}} e su cosa significhi proteggere i tuoi dati in uso, puoi consultare le [informazioni sul servizio](/docs/services/data-shield?topic=data-shield-about).

## Prima di iniziare
{: #gs-begin}

Prima di poter iniziare a lavorare con {{site.data.keyword.datashield_short}}, devi disporre dei seguenti prerequisiti.

Per informazioni sul download delle CLI o sulla configurazione del tuo ambiente {{site.data.keyword.containershort}}, consulta l'esercitazione [Creazione dei cluster Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).
{: tip}

* Le seguenti CLI:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* I seguenti [plugin della CLI](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins):

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}

* Un cluster Kubernetes abilitato a SGX. Attualmente, SGX può essere abilitato su un cluster bare metal con il tipo di nodo: mb2c.4x32. Se non ne hai uno, puoi attenerti alla seguente procedura per assicurarti di creare il cluster di cui hai bisogno.
  1. Preparati a [creare il tuo cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Assicurati di disporre delle [autorizzazioni necessarie](/docs/containers?topic=containers-users) per creare un cluster.

  3. Crea il [cluster](/docs/containers?topic=containers-clusters).

* Un'istanza del servizio [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} versione 0.5.0 o più recente. L'installazione predefinita utilizza <code>cert-manager</code> per configurare i [certificati TLS](/docs/services/data-shield?topic=data-shield-tls-certificates) per le comunicazioni interne tra i servizi {{site.data.keyword.datashield_short}}. Per installare un'istanza utilizzando Helm, puoi eseguire questo comando.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Vuoi vedere le informazioni di registrazione per Data Shield? Configura un'istanza {{site.data.keyword.la_full_notm}} per il tuo cluster.
{: tip}

## Installazione del servizio
{: #gs-install}

Puoi utilizzare il grafico Helm fornito per installare {{site.data.keyword.datashield_short}} sul tuo cluster bare metal abilitato a SGX.
{: shortdesc}

Il grafico Helm installa i seguenti componenti:

*	Il software di supporto per SGX, che è installato sugli host bare metal da un contenitore privilegiato.
*	L'{{site.data.keyword.datashield_short}} Enclave Manager, che gestisce le enclave SGX nell'ambiente {{site.data.keyword.datashield_short}}.
*	Il servizio di conversione dei contenitori EnclaveOS®, che consente alle applicazioni inserite nei contenitori di essere eseguite nell'ambiente {{site.data.keyword.datashield_short}}.


Per installare {{site.data.keyword.datashield_short}} sul tuo cluster, completa la seguente procedura.

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

  2. Copia l'output che inizia con `export` e incollalo nella tua console per impostare la variabile di ambiente `KUBECONFIG`.

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

6. Inizializza Helm creando una politica di bind del ruolo per Tiller. 

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

7. Installa il grafico.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Se hai [configurato un {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) per il tuo programma di conversione, devi aggiungere `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Per monitorare l'avvio dei tuoi componenti, puoi eseguire questo comando.

  ```
  kubectl get pods
  ```
  {: codeblock}

## Passi successivi
{: #gs-next}

Ora che il servizio è installato sul tuo cluster, puoi iniziare a proteggere i tuoi dati. Successivamente, puoi provare a [convertire](/docs/services/data-shield?topic=data-shield-convert) e [distribuire](/docs/services/data-shield?topic=data-shield-deploying) le tue applicazioni. 

Se non hai una tua immagine da distribuire, prova a distribuire una delle immagini {{site.data.keyword.datashield_short}} preconfezionate.

* [Repository GitHub di esempi](https://github.com/fortanix/data-shield-examples/tree/master/ewallet){: external}
* Container Registry: [immagine Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter), [immagine MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter), [immagine NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter) o [immagine Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter).


