# IBM Cloud Data Shield

Con IBM Cloud Data Shield, Fortanix® e Intel® SGX, puoi proteggere i dati nei tuoi carichi di lavoro del contenitore che vengono eseguiti su IBM Cloud mentre i dati sono in uso.

## Introduzione

Quando si tratta di proteggere i tuoi dati, la crittografia è uno dei modi più diffusi ed efficaci. Per essere veramente protetti, però, i dati devono essere crittografati in ogni fase del loro ciclo di vita. Le tre fasi del ciclo di vita dei dati includono i dati inattivi, i dati in transito e i dati in uso. I tuoi dati sono di norma protetti quando sono archiviati (inattivi) e quando sono in movimento (in transito).

Tuttavia, quando viene avviata l'esecuzione di un'applicazione, i dati utilizzati da CPU e memoria sono vulnerabili agli attacchi. Utenti interni malintenzionati, utenti root, compromissione delle credenziali, attacchi di tipo zero-day del sistema operativo e intrusi nella rete sono tutte minacce per i dati. Portando la crittografia un ulteriore passo avanti, puoi ora proteggere i dati in uso. 

Per ulteriori informazioni sul servizio e su cosa significhi proteggere i tuoi dati in uso, puoi consultare le [informazioni sul servizio](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about).



## Dettagli del grafico

Il grafico Helm installa i seguenti componenti nel tuo cluster del Kubernetes Service IBM Cloud abilitato a SGX:

 * Il software di supporto per SGX, che è installato sugli host bare metal da un contenitore privilegiato.
 * L'Enclave Manager di IBM Cloud Data Shield, che gestisce le enclave SGX nell'ambiente IBM Cloud Data Shield.
 * Il servizio di conversione dei contenitori EnclaveOS®, che converte le applicazioni inserite nei contenitori in modo che possano essere eseguite nell'ambiente IBM Cloud Data Shield. 



## Risorse richieste

* Un cluster Kubernetes abilitato a SGX. Attualmente, SGX può essere abilitato su un cluster bare metal con il tipo di nodo: mb2c.4x32. Se non ne hai uno, puoi attenerti alla seguente procedura per assicurarti di creare il cluster di cui hai bisogno.
  1. Preparati a [creare il tuo cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Assicurati di disporre delle [autorizzazioni necessarie](https://cloud.ibm.com/docs/containers?topic=containers-users#users) per creare un cluster.

  3. Crea il [cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters).

* Un'istanza del servizio [cert-manager](https://cert-manager.readthedocs.io/en/latest/) versione 0.5.0 o più recente. Per installare l'istanza utilizzando Helm, puoi eseguire questo comando.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## Prerequisiti

Prima di poter iniziare a utilizzare IBM Cloud Data Shield, devi disporre dei seguenti prerequisiti. Per assistenza nel download di CLI e plugin e nella configurazione del tuo ambiente Kubernetes Service, consulta l'esercitazione di [creazione di cluster Kubernetes](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Le seguenti CLI:

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  Potresti voler configurare Helm per utilizzare la modalità `--tls`. Per assistenza nell'abilitazione di TLS, consulta il [repository Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Se abiliti TLS, assicurati di accodare `--tls` a ogni comando Helm che esegui.
  {: tip}

* I seguenti plugin della CLI [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes Service
  * Container Registry



## Installazione del grafico

Quando installi un grafico Helm, disponi di diverse opzioni e diversi parametri che puoi utilizzare per personalizzare la tua installazione. Le seguenti istruzioni ti assistono nell'installazione predefinita più elementare del grafico. Per ulteriori informazioni sulle tue opzioni, vedi [la documentazione di IBM Cloud Data Shield](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started).

Suggerimento: le tue immagini sono archiviate in un registro privato? Puoi utilizzare l'EnclaveOS Container Converter per configurare le immagini per lavorare con IBM Cloud Data Shield. Assicurati di convertire le tue immagini prima di distribuire il grafico in modo da disporre delle informazioni di configurazione necessarie. Per ulteriori informazioni sulla conversione delle immagini, vedi [la documentazione](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert).


**Per installare IBM Cloud Data Shield sul tuo cluster:**

1. Accedi alla CLI IBM Cloud. Segui i prompt nella CLI per completare l'accesso.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

  2. Copia l'output che inizia con `export` e incollalo nel tuo terminale per impostare la variabile di ambiente `KUBECONFIG`.

3. Se non lo hai già fatto, aggiungi il repository `ibm`.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. Facoltativo: se non conosci l'email che è associata all'amministratore o all'ID dell'account di amministrazione, esegui questo comando.

  ```
  ibmcloud account show
  ```

5. Ottieni il dominio secondario Ingress per il tuo cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. Installa il grafico.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  Nota: se hai [configurato un IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert) per il tuo programma di conversione, aggiungi questa opzione: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. Per monitorare l'avvio dei tuoi componenti, puoi eseguire questo comando.

  ```
  kubectl get pods
  ```

## Esecuzione delle tue applicazioni nell'ambiente IBM Cloud Data Shield

Per eseguire le tue applicazioni nell'ambiente IBM Cloud Data Shield, devi convertire, inserire in whitelist e quindi distribuire la tua immagine del contenitore.

### Conversione delle tue immagini
{: #converting-images}

Puoi utilizzare l'API Enclave Manager per stabilire una connessione al programma di conversione.
{: shortdesc}

1. Accedi alla CLI IBM Cloud. Segui i prompt nella CLI per completare l'accesso.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. Ottieni ed esporta un token IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. Converti la tua immagine. Assicurati di sostituire le variabili con le informazioni per la tua applicazione.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### Inserimento in whitelist della tua applicazione
{: #convert-whitelist}

Quando un'immagine Docker viene convertita per l'esecuzione all'interno di Intel SGX, è possibile inserirla in whitelist. Inserendo in whitelist la tua immagine, stai assegnando dei privilegi di amministratore che consentono l'esecuzione dell'applicazione sul cluster dove è installato IBM Cloud Data Shield.
{: shortdesc}

1. Ottieni un token di accesso Enclave Manager utilizzando il token di autenticazione IAM con la seguente richiesta curl:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. Effettua una richiesta di inserimento in whitelist all'Enclave Manager. Assicurati di immettere le tue informazioni quando esegui questo comando.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. Utilizza la GUI Enclave Manager per approvare o rifiutare le richieste di inserimento in whitelist. Puoi tracciare e gestire le build inserite in whitelist nella sezione **Builds** della GUI.



### Distribuzione dei contenitori IBM Cloud Data Shield

Dopo che hai convertito le tue immagini, devi distribuire nuovamente i tuoi contenitori IBM Cloud Data Shield al tuo cluster Kubernetes.
{: shortdesc}

Quando distribuisci i contenitori IBM Cloud Data Shield al tuo cluster Kubernetes, la specifica del contenitore deve includere i montaggi di volume. I volumi consentono ai dispositivi SGX e al socket AESM di essere disponibile nel contenitore.

1. Salva la seguente specifica del pod come template.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. Aggiorna i campi `your-app-sgx` e `your-registry-server` alla tua applicazione e al tuo server.

3. Crea il pod Kubernetes.

   ```
   kubectl create -f template.yml
   ```

Non hai un'applicazione per provare il servizio? Nessun problema. Offriamo diverse applicazioni di esempio che puoi provare, tra cui MariaDB e NGINX. Tutte le [immagini "datashield"](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter) in IBM Container Registry possono essere utilizzate come un esempio.



## Accesso alla GUI Enclave Manager

Puoi vedere una panoramica di tutte le applicazioni che vengono eseguite in un ambiente IBM Cloud Data Shield utilizzando la GUI Enclave Manager. Nella console Enclave Manager, puoi visualizzare i nodi nel tuo cluster, il loro stato dell'attestazione, le attività e un log di controllo degli eventi del cluster. Puoi anche approvare e rifiutare le richieste di inserimento in whitelist.

Per ottenere la GUI:

1. Accedi a IBM Cloud e imposta il contesto per il tuo cluster.

2. Verifica se il servizio è in esecuzione confermando che tutti i tuoi pod sono in uno stato che indica che sono in esecuzione (*running*).

  ```
  kubectl get pods
  ```

3. Cerca l'URL front-end per il tuo Enclave Manager eseguendo questo comando.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Ottieni il tuo dominio secondario Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. In un browser, immetti il dominio secondario Ingress dove è disponibile il tuo Enclave Manager.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. Nel terminale, ottieni il tuo token IAM.

  ```
  ibmcloud iam oauth-tokens
  ```

7. Copia il token e incollalo nella GUI Enclave Manager. Non hai bisogno di copiare la parte `Bearer` del token stampato.

8. Fai clic su **Sign in**.

Per informazioni sui ruoli di cui un utente ha bisogno per eseguire le diverse azioni, vedi [Impostazione dei ruoli per gli utenti di Enclave Manager](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles).

## Utilizzo delle immagini schermate preconfezionate

Il team di IBM Cloud Data Shield ha messo insieme quattro diverse immagini pronte per la produzione che possono essere eseguite negli ambienti IBM Cloud Data Shield. Puoi provare tutte le seguenti immagini:

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## Disinstallazione e risoluzione dei problemi

Se riscontri un problema mentre lavori con IBM Cloud Data Shield, prova a consultare le sezioni di [risoluzione dei problemi](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting) o delle [domande frequenti](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq) della documentazione. Se non vedi la tua domanda o una soluzione al tuo problema, contatta il [supporto IBM](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).

Se non hai più bisogno di utilizzare IBM Cloud Data Shield, puoi [eliminare il servizio e i certificati TLS che erano stati creati](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall).

