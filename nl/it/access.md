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

# Gestione dell'accesso
{: #access}

Puoi controllare l'accesso all'{{site.data.keyword.datashield_full}} Enclave Manager. Questo controllo dell'accesso è separato dai tipici ruoli IAM (Identity and Access Management) che utilizzi quando lavori con {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Utilizzo di una chiave API IAM per accedere alla console
{: #access-iam}

Nella console Enclave Manager, puoi visualizzare i nodi nel tuo cluster e il loro stato di attestazione. Puoi anche visualizzare le attività e i log di controllo degli eventi del cluster.

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

3. Verifica che il tuo servizio sia in esecuzione confermando che tutti i tuoi pod sono in uno stato che indica che sono in esecuzione (*running*).

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

8. Nel terminale, ottieni il tuo token IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. Copia il token e incollalo nella GUI Enclave Manager. Non hai bisogno di copiare la parte `Bearer` del token stampato.

9. Fai clic su **Sign in**.


## Impostazione dei ruoli per gli utenti di Enclave Manager
{: #enclave-roles}

L'amministrazione{{site.data.keyword.datashield_short}} viene eseguita nell'Enclave Manager. In quanto amministratore, ti viene automaticamente assegnato il ruolo di *gestore*, ma puoi anche assegnare dei ruoli ad altri utenti.
{: shortdesc}

Tieni presente che questi ruoli sono diversi dai ruoli IAM della piattaforma utilizzati per controllare l'accesso ai servizi {{site.data.keyword.cloud_notm}}. Per ulteriori informazioni sulla configurazione dell'accesso per {{site.data.keyword.containerlong_notm}}, vedi [Assegnazione dell'accesso al cluster](/docs/containers?topic=containers-users#users).
{: tip}

Consulta la seguente tabella per vedere quali ruoli sono supportati e qualche azione di esempio che può essere eseguita da ciascun utente:

<table>
  <tr>
    <th>Ruolo</th>
    <th>Azioni</th>
    <th>Esempio</th>
  </tr>
  <tr>
    <td>Lettore</td>
    <td>Può eseguire azioni di sola lettura quali la visualizzazione di nodi, build, informazioni sull'utente, applicazioni, attività e log di controllo.</td>
    <td>Download di un certificato di attestazione del nodo.</td>
  </tr>
  <tr>
    <td>Scrittore</td>
    <td>Può eseguire le stesse azioni di un Lettore e altre ancora, compresi la disattivazione e il rinnovo dell'attestazione del nodo, l'aggiunta di una build, l'approvazione o il rifiuto di azioni o attività.</td>
    <td>Certificazione di un'applicazione.</td>
  </tr>
  <tr>
    <td>Gestore</td>
    <td>Può eseguire le stesse azioni di uno Scrittore e altre ancora, compresi l'aggiornamento di nomi e ruoli utente, l'aggiunta di utenti al cluster, l'aggiornamento delle impostazioni del cluster e qualsiasi altra azione privilegiata.</td>
    <td>Aggiornamento di un ruolo utente.</td>
  </tr>
</table>

### Impostazione dei ruoli utente
{: #set-roles}

Puoi impostare o aggiornare i ruoli utente per il tuo gestore della console.
{: shortdesc}

1. Vai all'[IU Enclave Manager](/docs/services/data-shield?topic=data-shield-access#access-iam).
2. Dal menu a discesa, apri la schermata di gestione degli utenti.
3. Seleziona **Settings**. Da questa schermata, puoi esaminare l'elenco di utenti o aggiungere un utente.
4. Per modificare le autorizzazioni utente, passa il puntatore del mouse su un utente finché non viene visualizzata un'icona che rappresenta una matita.
5. Fai clic sull'icona che rappresenta una matita per modificare le sue autorizzazioni. Le eventuali modifiche alle autorizzazioni di un utente sono immediatamente effettive.
