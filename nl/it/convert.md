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

# Conversione delle immagini
{: #convert}

Puoi convertire le tue immagini per l'esecuzione in un ambiente EnclaveOS® utilizzando il {{site.data.keyword.datashield_short}} Container Converter. Dopo che le tue immagini sono state convertite, puoi eseguire la distribuzione al tuo cluster Kubernetes compatibile con SGX.
{: shortdesc}


## Configurazione delle credenziali di registro
{: #configure-credentials}

Puoi consentire a tutti gli utenti del programma di conversione di ottenere delle immagini di input dai, e di eseguire il push delle immagini di output ai, registri privati configurati configurando il programma di conversione con le credenziali di registro.
{: shortdesc}

### Configurazione delle tue credenziali {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}.

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

2. Ottieni un token di autenticazione per il tuo {{site.data.keyword.cloud_notm}} Container Registry.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. Crea un file di configurazione JSON utilizzando il token che hai creato. Sostituisci la variabile `<token>` ed esegui quindi questo comando. Se non hai `openssl`, puoi utilizzare qualsiasi codificatore base64 della riga di comando con le opzioni appropriate. Assicurati che non ci siano nuove righe in mezzo alla stringa codificata o alla sua fine.

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### Configurazione delle credenziali per un altro registro
{: #configure-other-registry}

Se già hai un file `~/.docker/config.json` che esegue l'autenticazione presso il registro che desideri utilizzare, puoi utilizzare tale file.

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Esegui il seguente comando.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## Conversione delle tue immagini
{: #converting-images}

Puoi utilizzare l'API Enclave Manager per stabilire una connessione al programma di conversione.
{: shortdesc}

1. Accedi alla CLI {{site.data.keyword.cloud_notm}}.Segui i prompt nella CLI per completare l'accesso.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Ottieni ed esporta un token IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. Converti la tua immagine. Assicurati di sostituire le variabili con le informazioni per la tua applicazione.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## Richiesta di un certificato dell'applicazione
{: #request-cert}

Un'applicazione convertita può richiedere un certificato dall'Enclave Manager quando viene avviata. I certificati sono firmati dalla CA (Certificate Authority) dell'Enclave Manager e includono il report di attestazione remota di Intel per l'enclave SGX della tua applicazione.
{: shortdesc}

Consulta il seguente esempio per vedere come configurare una richiesta per generare una chiave privata RSA e generare il certificato per la chiave. La chiave viene conservata nella root del contenitore dell'applicazione. Se non desideri una chiave e un certificato temporanei, puoi personalizzare `keyPath` e `certPath` per le tue applicazioni e archiviarli in un volume persistente.

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

2. Immetti le tue variabili ed esegui questo comando per eseguire nuovamente il programma di conversione con le tue informazioni del certificato.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: pre}


## Inserimento in whitelist delle tue applicazioni
{: #convert-whitelist}

Quando un'immagine Docker viene convertita per l'esecuzione all'interno di Intel® SGX, è possibile inserirla in whitelist. Inserendo in whitelist la tua immagine, stai assegnando dei privilegi di amministratore che consentono l'esecuzione dell'applicazione sul cluster dove è installato {{site.data.keyword.datashield_short}}.
{: shortdesc}

1. Ottieni un token di accesso Enclave Manager utilizzando il token di autenticazione IAM con la seguente richiesta curl:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. Effettua una richiesta di inserimento in whitelist all'Enclave Manager. Assicurati di immettere le tue informazioni quando esegui questo comando.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. Utilizza la GUI Enclave Manager per approvare o rifiutare le richieste di inserimento in whitelist. Puoi tracciare e gestire le build inserite in whitelist nella sezione **Builds** della GUI.
