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

# Informazioni sul servizio
{: #about}

Con {{site.data.keyword.datashield_full}}, Fortanix® e Intel® SGX, puoi proteggere i dati nei tuoi carichi di lavoro del contenitore che vengono eseguiti su {{site.data.keyword.cloud_notm}} mentre i tuoi dati sono in uso.
{: shortdesc}

Quando si tratta di proteggere i tuoi dati, la crittografia è uno dei controlli più diffusi ed efficaci. Per essere veramente protetti, però, i dati devono essere crittografati in ogni fase del loro ciclo di vita. I dati passano per tre fasi durante il loro ciclo di vita: dati inattivi, dati in transito e dati in uso. I tuoi dati sono di norma protetti quando sono archiviati (inattivi) e quando sono in movimento (in transito). Quando viene avviata l'esecuzione di un'applicazione, i dati utilizzati da CPU e memoria sono vulnerabili a diversi attacchi, compresi gli utenti interni malintenzionati, gli utenti root, la compromissione delle credenziali, gli attacchi di tipo zero-day del sistema operativo, gli intrusi nella rete e altri ancora. Portando la protezione un ulteriore passo avanti, puoi ora crittografare i dati in uso. 

Con {{site.data.keyword.datashield_short}}, il codice e i dati della tua applicazione vengono eseguiti in enclave con una protezione avanzata della CPU, che sono aree di memoria ritenute attendibili sul nodo di lavoro che proteggono aspetti critici dell'applicazione. Le enclave aiutano a mantenere la riservatezza e la non modificabilità di dati e codice. Se tu o la tua azienda avete bisogno della riservatezza dei dati per politiche interne, regolamenti governativi o requisiti di conformità del settore, questa soluzione potrebbe aiutarvi a passare al cloud. I casi di utilizzo di esempio includono le istituzioni finanziarie e sanitarie o i paesi con politiche governative che richiedono soluzioni cloud in loco.


## Integrazioni
{: #integrations}

Per fornirti l'esperienza più fluida possibile, {{site.data.keyword.datashield_short}} è integrato con altri servizi {{site.data.keyword.cloud_notm}}, Fortanix® Runtime Encryption e Intel SGX®.

<dl>
  <dt>Fortanix®</dt>
    <dd>Con [Fortanix](http://fortanix.com/) puoi tenere al sicuro le tue applicazioni e i tuoi dati più preziosi, anche quando l'infrastruttura è compromessa. Sviluppato su Intel SGX, Fortanix fornisce una nuova categoria di sicurezza dei dati denominata Runtime Encryption (crittografia di runtime). Analogamente al modo in cui funziona la crittografia per i dati inattivi e i dati in transito, la crittografia di runtime mantiene le chiavi, i dati e le applicazioni completamente protetti da minacce esterne ed interne. Le minacce potrebbero includere utenti interni malintenzionati, attacchi informatici a livello del sistema operativo o intrusi nella rete.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx) è un'estensione dell'architettura x86 che ti consente di eseguire le applicazioni in un'enclave sicura completamente isolata. L'applicazione non è isolata solo dalle altre applicazioni in esecuzione sullo stesso sistema ma anche dal sistema operativo e da un possibile Hypervisor. Ciò impedisce agli amministratori di manomettere l'applicazione dopo che è stata avviata. La memoria delle enclave sicure è anch'essa crittografata per vanificare gli attacchi fisici. La tecnologia supporta anche l'archiviazione di dati persistenti in modo sicuro per consentirne la lettura solo all'enclave sicura.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started) offre potenti strumenti combinando i contenitori Docker e la tecnologia Kubernetes, un'esperienza utente intuitiva e la sicurezza e l'isolamento integrati per automatizzare la distribuzione, il funzionamento, il ridimensionamento e il monitoraggio di applicazioni caricate nei contenitori in un cluster di host di calcolo. </dd>
  <dt>{{site.data.keyword.cloud_notm}} IAM (Identity and Access Management)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted) ti consente di autenticare in modo protetto gli utenti per i servizi e di controllare l'accesso alle risorse in modo congruente in tutto {{site.data.keyword.cloud_notm}}. Quando un utente tenta di completare un'azione specifica, il sistema di controllo utilizza gli attributi definiti nella politica per determinare se l'utente dispone dell'autorizzazione per eseguire tale attività.Le chiavi API {{site.data.keyword.cloud_notm}} sono disponibili tramite IAM Cloud per consentirti di farne uso per eseguire l'autenticazione utilizzando la CLI oppure come parte dell'automazione per eseguire l'accesso come tua identità utente.</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>Puoi creare una [configurazione di registrazione](/docs/containers?topic=containers-health#health) tramite {{site.data.keyword.containerlong_notm}} che inoltra i tuoi log a [{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla). Puoi espandere le tue capacità di raccolta dei log, conservazione dei log e ricerca nei log in {{site.data.keyword.cloud_notm}}. Metti a disposizione del tuo team DevOps funzioni quali l'aggregazione dei log di applicazione e ambiente per informazioni approfondite e consolidate sulle applicazioni o sull'ambiente, una crittografia dei log, la conservazione dei dati di log per tutto il tempo necessario e un rilevamento e una risoluzione dei problemi in tempi ridotti.</dd>
</dl>
