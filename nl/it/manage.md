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

# Utilizzo di Enclave Manager
{: #enclave-manager}

Puoi utilizzare l'IU Enclave Manager per gestire le applicazioni che proteggi con {{site.data.keyword.datashield_full}}. Dall'IU puoi gestire la distribuzione della tua applicazione, assegnare l'accesso, gestire le richieste di inserimento in whitelist e convertire le tue applicazioni.
{: shortdesc}


## Accesso
{: #em-signin}

Nella console Enclave Manager, puoi visualizzare i nodi nel tuo cluster e il loro stato di attestazione. Puoi anche visualizzare le attività e i log di controllo degli eventi del cluster. Per iniziare, esegui l'accesso.
{: shortdesc}

1. Assicurati di disporre dell'[accesso corretto](/docs/services/data-shield?topic=data-shield-access).

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

3. Verifica che il tuo servizio sia in esecuzione confermando che tutti i tuoi pod sono in uno stato *attivo*.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Cerca l'URL front-end per il tuo Enclave Manager eseguendo questo comando.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Ottieni il tuo dominio secondario Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. In un browser, immetti il dominio secondario Ingress dove è disponibile il tuo Enclave Manager.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

7. Nel terminale, ottieni il tuo token IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. Copia il token e incollalo nella GUI Enclave Manager. Non hai bisogno di copiare la parte `Bearer` del token stampato.

9. Fai clic su **Sign in**.






## Gestione dei nodi
{: #em-nodes}

Puoi utilizzare l'IU Enclave Manager per monitorare lo stato, disattivare o scaricare i certificati per i nodi che eseguono IBM Cloud Data Shield nel tuo cluster.
{: shortdesc}


1. Accedi a Enclave Manager.

2. Vai alla scheda **Nodes**.

3. Fai clic sull'indirizzo IP del nodo che vuoi esaminare. Si apre una schermata di informazioni.

4. Nella schermata delle informazioni, puoi scegliere di disattivare il nodo o di scaricare il certificato utilizzato.




## Distribuzione di applicazioni
{: #em-apps}

Puoi utilizzare l'IU Enclave Manager per distribuire le tue applicazioni.
{: shortdesc}


### Aggiunta di un'applicazione
{: #em-app-add}

Puoi eseguire contemporaneamente la conversione, la distribuzione e l'inserimento in whitelist della tua applicazione utilizzando l'IU Enclave Manager.
{: shortdesc}

1. Accedi a Enclave Manager e vai alla scheda **Apps**.

2. Fai clic su **Add new application**.

3. Fornisci un nome e una descrizione per la tua applicazione.

4. Immetti il nome di input e di output per le tue immagini. L'input è il nome della tua applicazione corrente. L'output è dove puoi trovare l'applicazione convertita.

5. Immetti un valore **ISVPRDID** e **ISVSVN**.

6. Immetti tutti i domini consentiti.

7. Modifica le impostazioni avanzate che potresti voler cambiare.

8. Fai clic su **Create new application**. L'applicazione viene distribuita e aggiunta alla tua whitelist. Puoi approvare la richiesta di build nella scheda **tasks**.




### Modifica di un'applicazione
{: #em-app-edit}

Puoi modificare un'applicazione dopo averla aggiunta al tuo elenco.
{: shortdesc}


1. Accedi a Enclave Manager e vai alla scheda **Apps**.

2. Fai clic sul nome dell'applicazione che vuoi modificare. Si apre una nuova schermata in cui puoi riesaminare la configurazione, inclusi i certificati e le build distribuite.

3. Fai clic su **Edit application**.

4. Aggiorna la configurazione che vuoi effettuare. Prima di apportare qualsiasi modifica, assicurati di comprendere il modo in cui la modifica delle impostazioni avanzate influisce sulla tua applicazione.

5. Fai clic su **Edit application**.


## Creazione di applicazioni
{: #em-builds}

Puoi utilizzare l'IU Enclave Manager per ricreare la tue applicazioni dopo aver apportato le modifiche.
{: shortdesc}

1. Accedi a Enclave Manager e vai alla scheda **Builds**.

2. Fai clic su **Create new build**.

3. Seleziona un'applicazione dall'elenco a discesa o aggiungi un'applicazione.

4. Immetti il nome della tua immagine Docker e contrassegnala con una tag specifica 

5. Fai clic su **Build**. La build viene aggiunta alla whitelist. Puoi approvare la build nella scheda **Tasks**.



## Approvazione di attività
{: #em-tasks}

Quando un'applicazione è inserita in whitelist, viene aggiunta all'elenco di richieste in sospeso nella scheda **tasks** dell'IU Enclave Manager. Puoi utilizzare l'IU per approvare o rifiutare la richiesta.
{: shortdesc}

1. Accedi a Enclave Manager e vai alla scheda **Tasks**.

2. Fai clic sulla riga che contiene la richiesta che vuoi approvare o rifiutare. Si apre una schermata con ulteriori informazioni.

3. Esamina la richiesta e fai clic su **Approve** o su **Deny**. Il tuo nome viene aggiunto all'elenco di **Reviewers**.


## Visualizzazione dei log
{: #em-view}

Puoi controllare la tua istanza Enclave Manager per verificare diversi tipi di attività.
{: shortdesc}

1. Vai alla scheda **Audit log** dell'IU Enclave Manager.
2. Filtra i risultati della registrazione per restringere la ricerca. Puoi scegliere di filtrare in base a un intervallo temporale o a uno dei seguenti tipi.

  * Stato applicazione: attività pertinente alla tua applicazione, come le richieste di inserimento in whitelist e le nuove build.
  * Approvazione utente: attività pertinente all'accesso di un utente, ad esempio l'approvazione o il rifiuto di utilizzo dell'account.
  * Attestazione del nodo: attività pertinente all'attestazione del nodo.
  * Autorità di certificazione: attività pertinente a un'autorità di certificazione.
  * Amministrazione: attività pertinente all'amministrazione. 

Se vuoi conservare un record dei log per oltre 1 mese, puoi esportare le informazioni come file `.csv`.

