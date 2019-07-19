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

# Conversione delle immagini
{: #convert}

Puoi convertire le tue immagini per l'esecuzione in un ambiente EnclaveOS® utilizzando il {{site.data.keyword.datashield_short}} Container Converter. Dopo che le tue immagini sono state convertite, puoi distribuirle al tuo cluster Kubernetes abilitato per SGX.
{: shortdesc}

Puoi convertire le applicazioni senza modificare il tuo codice. Effettuando la conversione, prepari la tua applicazione per l'esecuzione in un ambiente EnclaveOS. È importante notare che il processo di conversione non crittografa la tua applicazione. Solo i dati generati in fase di runtime, dopo l'avvio dell'applicazione all'interno di un'enclave SGX, sono protetti da IBM Cloud Data Shield. 

Il processo di conversione non crittografa la tua applicazione.
{: important}


## Prima di iniziare
{: #convert-before}

Prima di convertire le tue applicazioni, devi assicurarti di comprendere appieno le seguenti considerazioni.
{: shortdesc}

* Per motivi di sicurezza, i segreti devono essere forniti in fase di runtime e non devono essere collocati nell'immagine del contenitore che vuoi convertire. Quando l'applicazione viene convertita ed è in esecuzione, puoi verificare attraverso l'attestazione che l'applicazione sia in esecuzione in un'enclave prima di fornire eventuali segreti.

* Il guest del contenitore deve essere eseguito come utente root del contenitore.

* I test includevano contenitori basati su Debian, Ubuntu e Java con risultati variabili. Altri ambienti potrebbero funzionare, ma non sono stati testati.


## Configurazione delle credenziali di registro
{: #configure-credentials}

Puoi consentire a tutti gli utenti del programma di conversione del contenitore {{site.data.keyword.datashield_short}} di ottenere immagini di input e inviare immagini di output ai registri privati configurati configurandolo con le credenziali del registro. Se hai utilizzato Container Registry prima del 4 ottobre 2018, potresti voler [abilitare l'applicazione della politica di accesso IAM per il tuo registro](/docs/services/Registry?topic=registry-user#existing_users).
{: shortdesc}

### Configurazione delle tue credenziali {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}. Segui i prompt nella CLI per completare l'accesso. Se hai un ID federato, aggiungi l'opzione `--sso` alla fine del comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Crea un ID servizio e una chiave API dell'ID servizio per il programma di conversione del contenitore {{site.data.keyword.datashield_short}}.

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. Concedi all'ID servizio l'autorizzazione per accedere al tuo registro del contenitore.

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. Crea un file di configurazione JSON utilizzando la chiave API che hai creato. Sostituisci la variabile `<api key>` ed esegui quindi questo comando. Se non hai `openssl`, puoi utilizzare qualsiasi codificatore base64 della riga di comando con le opzioni appropriate. Assicurati che non esistano nuove righe nel mezzo o alla fine della stringa codificata.

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### Configurazione delle credenziali per un altro registro
{: #configure-other-registry}

Se già hai un file `~/.docker/config.json` che esegue l'autenticazione presso il registro che desideri utilizzare, puoi utilizzare tale file. I file su OS X non sono attualmente supportati.

1. Configura i [segreti di pull](/docs/containers?topic=containers-images#other).

2. Accedi alla CLI {{site.data.keyword.cloud_notm}}. Segui i prompt nella CLI per completare l'accesso. Se hai un ID federato, aggiungi l'opzione `--sso` alla fine del comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. Esegui il seguente comando.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## Conversione delle tue immagini
{: #converting-images}

Puoi utilizzare l'API Enclave Manager per stabilire una connessione al programma di conversione.
{: shortdesc}

Puoi anche convertire i tuoi contenitori quando crei le tue applicazioni attraverso l'[IU Enclave Manager](/docs/services/data-shield?topic=enclave-manager#em-apps).
{: tip}

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}. Segui i prompt nella CLI per completare l'accesso. Se hai un ID federato, aggiungi l'opzione `--sso` alla fine del comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Ottieni ed esporta un token IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. Converti la tua immagine. Assicurati di sostituire le variabili con le informazioni per la tua applicazione.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Conversione di applicazioni Java
{: #convert-java}

Quando converti le applicazioni basate su Java, ci sono alcuni requisiti e limitazioni supplementari. Se converti le applicazioni Java utilizzando l'IU Enclave Manager, puoi selezionare `Java-Mode`. Per convertire le applicazioni Java utilizzando l'API, tieni presenti le seguenti limitazioni e opzioni.

**Limitazioni**

* La dimensione massima dell'enclave consigliata per le applicazioni Java è 4 GB. Le enclave più grandi potrebbero funzionare ma potresti riscontrare una riduzione delle prestazioni.
* La dimensione dell'heap consigliata è inferiore alla dimensione dell'enclave. Consigliamo di rimuovere qualsiasi opzione `-Xmx` come metodo per ridurre la dimensione dell'heap.
* Le seguenti librerie Java sono state testate:
  - MySQL Java Connector
  - Crypto (`JCA`)
  - Messaging (`JMS`)
  - Hibernate (`JPA`)

  Se stai lavorando con un'altra libreria, contatta il nostro team utilizzando i forum o facendo clic sul pulsante di feedback in questa pagina. Assicurati di includere le tue informazioni di contatto e la libreria con cui vuoi lavorare.


**Opzioni**

Per utilizzare la conversione `Java-Mode`, modifica il tuo file Docker per fornire le seguenti opzioni. Affinché la conversione Java funzioni, devi impostare tutte le variabili come definito in questa sezione. 


* Imposta la variabile di ambiente MALLOC_ARENA_MAX uguale a 1.

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* Se utilizzi `OpenJDK JVM`, imposta le seguenti opzioni.

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* Se utilizzi `OpenJ9 JVM`, imposta le seguenti opzioni.

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## Richiesta di un certificato dell'applicazione
{: #request-cert}

Un'applicazione convertita può richiedere un certificato dall'Enclave Manager quando viene avviata. I certificati sono firmati dalla CA (Certificate Authority) dell'Enclave Manager e includono il report di attestazione remota di Intel per l'enclave SGX della tua applicazione.
{: shortdesc}

Consulta il seguente esempio per vedere come configurare una richiesta per generare una chiave privata RSA e generare il certificato per la chiave. La chiave viene conservata nella root del contenitore dell'applicazione. Se non vuoi una chiave o un certificato temporanei, puoi personalizzare `keyPath` e `certPath` per le tue applicazioni e archiviarli in un volume persistente.

1. Salva il seguente template come `app.json` e apporta le modifiche necessarie per rispondere ai requisiti di certificato della tua applicazione.

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. Immetti le tue variabili ed esegui questo comando per eseguire nuovamente il programma di conversione con le informazioni del tuo certificato.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## Inserimento di applicazioni in whitelist
{: #convert-whitelist}

Quando un'immagine Docker viene convertita per l'esecuzione all'interno di Intel® SGX, è possibile inserirla in whitelist. Inserendo in whitelist la tua immagine, stai assegnando dei privilegi di amministratore che consentono l'esecuzione dell'applicazione sul cluster dove è installato {{site.data.keyword.datashield_short}}.
{: shortdesc}


1. Ottieni un token di accesso Enclave Manager utilizzando il token di autenticazione IAM:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. Effettua una richiesta di inserimento in whitelist all'Enclave Manager. Assicurati di immettere le tue informazioni quando esegui questo comando.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. Utilizza la GUI Enclave Manager per approvare o rifiutare le richieste di inserimento in whitelist. Puoi tracciare e gestire le build inserite in whitelist nella sezione **Tasks** della GUI.

