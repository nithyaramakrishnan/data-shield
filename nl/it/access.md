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

# Assegnazione dell'accesso
{: #access}

Puoi controllare l'accesso all'{{site.data.keyword.datashield_full}} Enclave Manager. Questo tipo di controllo dell'accesso è separato dai tipici ruoli IAM (Identity and Access Management) che utilizzi quando lavori con {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Assegnazione dell'accesso al cluster
{: #access-cluster}

Prima di poter accedere a Enclave Manager, devi disporre dell'accesso al cluster su cui Enclave Manager è in esecuzione.
{: shortdesc}

1. Esegui l'accesso all'account che ospita il cluster a cui vuoi accedere.

2. Vai a **Gestisci > Accesso (IAM) > Utenti**.

3. Fai clic su **Invita utenti**.

4. Fornisci l'indirizzo email dell'utente che vuoi aggiungere.

5. Dall'elenco a discesa **Assegna accesso a**, seleziona **Risorsa**.

6. Dall'elenco a discesa **Servizi**, seleziona **Kubernetes Service**.

7. Seleziona una **Regione**, un **Cluster** e uno **Spazio dei nomi**.

8. Utilizzando come guida la documentazione di Kubernetes Service sull'[assegnazione dell'accesso al cluster](/docs/containers?topic=containers-users), assegna l'accesso di cui l'utente ha bisogno per completare le proprie attività.

9. Fai clic su **Salva**.

## Impostazione dei ruoli per gli utenti di Enclave Manager
{: #enclave-roles}

L'amministrazione{{site.data.keyword.datashield_short}} viene eseguita nell'Enclave Manager. In quanto amministratore, ti viene automaticamente assegnato il ruolo di *gestore*, ma puoi anche assegnare dei ruoli ad altri utenti.
{: shortdesc}

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
    <td>Può eseguire le stesse azioni che può svolgere un Lettore e altre ancora, tra cui la disattivazione e il rinnovo dell'attestazione del nodo, l'aggiunta di una build e l'approvazione o il rifiuto di qualsiasi azione o attività.</td>
    <td>Certificazione di un'applicazione.</td>
  </tr>
  <tr>
    <td>Gestore</td>
    <td>Può eseguire le stesse azioni che può svolgere uno Scrittore e altro ancora, tra cui l'aggiornamento di nomi e ruoli utente, l'aggiunta di utenti al cluster, l'aggiornamento delle impostazioni del cluster e qualsiasi altra azione privilegiata.</td>
    <td>Aggiornamento di un ruolo utente.</td>
  </tr>
</table>


### Aggiunta di un utente
{: #set-roles}

Utilizzando la GUI Enclave Manager, puoi fornire a un nuovo utente l'accesso alle informazioni.
{: shortdesc}

1. Accedi a Enclave Manager.

2. Fai clic su **Your name > Settings**.

3. Fai clic su **Add user**.

4. Immetti un indirizzo email e un nome per l'utente. Seleziona un ruolo dall'elenco a discesa **Role**.

5. Fai clic su **Salva**.



### Aggiornamento di un utente
{: #update-roles}

Puoi aggiornare i ruoli assegnati ai tuoi utenti e il loro nome.
{: shortdesc}

1. Accedi all'[IU Enclave Manager](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin).

2. Fai clic su **Your name > Settings**.

3. Passa il puntatore del mouse sull'utente di cui vuoi modificare le autorizzazioni. Viene visualizzata un'icona di matita.

4. Fai clic sull'icona di matita. Si apre la schermata per modificare l'utente.

5. Dall'elenco a discesa **Role**, seleziona i ruoli che vuoi assegnare.

6. Aggiorna il nome dell'utente.

7. Fai clic su **Salva**. Le eventuali modifiche alle autorizzazioni di un utente sono immediatamente effettive.


