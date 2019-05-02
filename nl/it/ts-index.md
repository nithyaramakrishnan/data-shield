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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# Risoluzione dei problemi
{: #troubleshooting}

Se hai dei problemi quando utilizzi {{site.data.keyword.datashield_full}}, considera queste tecniche per la risoluzione dei problemi e per ottenere assistenza.
{: shortdesc}

## Richiesta di supporto e assistenza
{: #gettinghelp}

Per assistenza, puoi cercare informazioni nella documentazione oppure facendo domande tramite un forum. Puoi anche aprire un ticket di supporto. Quando utilizzi il forum per fare una domanda, contrassegna con una tag la tua domanda in modo che sia visualizzabile dai team di sviluppo {{site.data.keyword.Bluemix_notm}}.
  * Se hai delle domande tecniche su {{site.data.keyword.datashield_short}}, inserisci la tua domanda in <a href="https://stackoverflow.com/search?q=ibm-data-shield" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="Icona link esterno"></a> e contrassegnala con la tag "ibm-data-shield".
  * Per domande sul servizio e sulle istruzioni per l'utilizzo iniziale, utilizza il forum <a href="https://developer.ibm.com/answers/topics/data-shield/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="Icona link esterno"></a>. Includi la tag `data-shield`.

Per ulteriori informazioni su come ottenere supporto, consulta [come posso ottenere il supporto di cui ho bisogno?](/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).


## Non conosco le opzioni che posso utilizzare con il programma di installazione
{: #options}

Per visualizzare tutti i comandi e ulteriori informazioni di aiuto, puoi eseguire il seguente comando ed esaminare l'output.

```
docker run registry.bluemix.net/ibm/datashield-installer help
```
{: pre}

## Non riesco ad accedere all'IU Enclave Manager
{: #ts-log-in}

{: tsSymptoms}
Provi ad accedere all'IU Enclave Manager e non ci riesci.

{: tsCauses}
L'accesso potrebbe non riuscire per i seguenti motivi:

* È possibile che tu stia utilizzando un ID email che non è autorizzato ad accedere al cluster Enclave Manager.
* Il token che stai usando potrebbe essere scaduto.

{: tsResolve}
Per risolvere il problema, verifica che stai usando l'ID email corretto. In caso affermativo, verifica che l'email disponga delle autorizzazioni corrette per accedere all'Enclave Manager. Se disponi delle autorizzazioni corrette, il tuo token di accesso potrebbe essere scaduto. I token sono validi per 60 minuti alla volta. Per ottenere un nuovo token, esegui `ibmcloud iam oauth-tokens`.


## L'API Container Converter restituisce un errore Forbidden
{: #ts-converter-forbidden-error}

{: tsSymptoms}
Provi ad eseguire il programma di conversione del contenitore e ricevi un errore: `Forbidden`.

{: tsCauses}
Potresti non essere in grado di accedere al programma di conversione se il tuo token IAM o Bearer manca o è scaduto.

{: tsResolve}
Per risolvere il problema, devi verificare che stai utilizzando un token IBM IAM OAuth o un token di autenticazione Enclave Manager nell'intestazione della tua richiesta. I token assumerebbero il seguente formato:

* IAM: `Authentication: Basic <IBM IAM Token>`
* Enclave Manager: `Authentication: Bearer <E.M. Token>`

Se il tuo token è presente, verifica che sia ancora valido ed esegui di nuovo la richiesta.


## Il programma di conversione del contenitore non è in grado di connettersi a un registro Docker privato
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
Provi ad eseguire il programma di conversione del contenitore su un'immagine da un registro Docker privato e il programma di conversione non è in grado di stabilire la connessione.

{: tsCauses}
le tue credenziali del registro privato potrebbero non essere configurate correttamente. 

{: tsResolve}
Per risolvere il problema, puoi attenerti alle seguenti procedure:

1. Verifica che le tue credenziali del registro privato siano state precedentemente configurate. In caso negativo, configurale ora.
2. Esegui il seguente comando per eseguire il dump delle tue credenziali del registro Docker. Se necessario, puoi modificare il nome del segreto.

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: pre}

3. Utilizza un decodificatore Base64 per decodificare il contenuto del segreto di `.dockerconfigjson` e verifica che sia corretto.


## Impossibile montare AESM-socket o i dispositivi SGX
{: #ts-problem-mounting-device}

{: tsSymptoms}
Riscontri dei problemi mentre provi a montare contenitori {{site.data.keyword.datashield_short}} sui volumi `/var/run/aesmd/aesm.socket` o `/dev/isgx`.

{: tsCauses}
Il montaggio può non riuscire a causa di problemi con la configurazione dell'host.

{: tsResolve}
Per risolvere il problema, verifica entrambi i seguenti elementi:

* Che `/var/run/aesmd/aesm.socket` non sia una directory sull'host. In caso affermativo, elimina il file, disinstalla il software {{site.data.keyword.datashield_short}} ed esegui nuovamente la procedura di installazione. 
* Che SGX sia abilitato nel BIOS delle macchine host. Se non è abilitato, contatta il supporto IBM.


## Errore durante la conversione dei contenitori
{: #ts-container-convert-fails}

{: tsSymptoms}
Riscontri il seguente errore quando provi a convertire il tuo contenitore.

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: pre}

{: tsCauses}
Su MacOS, se la keychain OSX viene utilizzata nel tuo file config.json, si verifica un malfunzionamento del programma di conversione del contenitore. 

{: tsResolve}
Per risolvere il problema, puoi utilizzare la seguente procedura:

1. Disabilita la keychain OSX sul tuo sistema locale. Vai a **System preferences > iCloud** e deseleziona la casella per **Keychain**.

2. Elimina il segreto che hai creato. Assicurati di aver effettuato l'accesso a IBM Cloud e di avere indicato come destinazione il tuo cluster prima di eseguire questo comando.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: pre}

3. Nel tuo file `$HOME/.docker/config.json`, elimina la riga `"credsStore": "osxkeychain"`.

4. Esegui l'accesso al tuo registro.

5. Crea un nuovo segreto.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}

6. Elenca i tuoi pod e annota il pod con `enclaveos-converter` nel nome.

  ```
  kubectl get pods
  ```
  {: pre}

7. Elimina il pod.

  ```
  kubectl delete pod <pod name>
  ```
  {: pre}

8. Converti la tua immagine.
