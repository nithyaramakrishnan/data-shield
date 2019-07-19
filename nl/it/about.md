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

# Informazioni sul servizio
{: #about}

Con {{site.data.keyword.datashield_full}}, Fortanix® e Intel® SGX, puoi proteggere i dati nei tuoi carichi di lavoro del contenitore che vengono eseguiti su {{site.data.keyword.cloud_notm}} mentre i tuoi dati sono in uso.
{: shortdesc}

Quando si tratta di proteggere i tuoi dati, la crittografia è uno dei controlli più diffusi ed efficaci. Per essere veramente protetti, però, i dati devono essere crittografati in ogni fase del loro ciclo di vita. Durante il loro ciclo di vita, i dati hanno tre fasi. Possono essere inattivi, in transito o in uso. Nell'ambito della protezione dati, in genere ci si focalizza sui dati inattivi e in transito. Tuttavia, dopo l'avvio dell'applicazione, i dati utilizzati dalla CPU e dalla memoria sono vulnerabili a vari attacchi. Gli attacchi potrebbero includere gli utenti interni malintenzionati, gli utenti root, la compromissione delle credenziali, gli attacchi di tipo zero-day del sistema operativo, gli intrusi nella rete e altri ancora. Portando la protezione un ulteriore passo avanti, puoi ora crittografare i dati in uso. 

Con {{site.data.keyword.datashield_short}}, il codice e i dati della tua applicazione vengono eseguiti in enclave con una protezione avanzata della CPU. Le enclave sono aree di memoria ritenute attendibili, sul nodo di lavoro, che proteggono gli aspetti critici delle tue applicazioni. Le enclave aiutano a mantenere riservati il codice e i dati e ad impedire modifiche. Se tu o la tua azienda avete bisogno della riservatezza dei dati a causa di politiche interne, regolamenti governativi o requisiti di conformità del settore, questa soluzione potrebbe aiutarvi a passare al cloud. I casi di utilizzo di esempio includono le istituzioni finanziarie e sanitarie o i paesi con politiche governative che richiedono soluzioni cloud in loco.


## Integrazioni
{: #integrations}

Per fornirti l'esperienza più fluida possibile, {{site.data.keyword.datashield_short}} è integrato con altri servizi {{site.data.keyword.cloud_notm}}, Fortanix® e Intel® SGX.

<dl>
  <dt>Fortanix®</dt>
    <dd>Con [Fortanix Runtime Encryption](https://fortanix.com/){: external} puoi tenere al sicuro le tue applicazioni e i tuoi dati più preziosi, anche quando l'infrastruttura è compromessa. Sviluppato su Intel SGX, Fortanix fornisce una nuova categoria di sicurezza dei dati denominata Runtime Encryption (crittografia di runtime). Analogamente al modo in cui funziona la crittografia per i dati inattivi e i dati in transito, la Runtime Encryption protegge le chiavi, i dati e le applicazioni da minacce esterne ed interne. Le minacce potrebbero includere utenti interni malintenzionati, attacchi informatici a livello del sistema operativo o intrusi nella rete.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} è un'estensione dell'architettura x86 che ti consente di eseguire le applicazioni in un'enclave completamente isolata e sicura. L'applicazione non è isolata solo da altre applicazioni eseguite sullo stesso sistema, ma anche dal sistema operativo e da un possibile hypervisor. L'isolamento impedisce inoltre agli amministratori di manomettere l'applicazione dopo che è stata avviata. La memoria delle enclave sicure è anch'essa crittografata per vanificare gli attacchi fisici. La tecnologia supporta anche l'archiviazione di dati persistenti in modo sicuro affinché possano essere letti solo dall'enclave sicura. </dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) offre potenti strumenti combinando i contenitori Docker, la tecnologia Kubernetes, un'esperienza utente intuitiva e la sicurezza e l'isolamento integrati per automatizzare il lavoro con le applicazioni inserite nei contenitori.</dd>
  <dt>{{site.data.keyword.cloud_notm}} IAM (Identity and Access Management)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) ti consente di autenticare in modo protetto gli utenti per i servizi e di controllare l'accesso alle risorse in modo congruente in tutto {{site.data.keyword.cloud_notm}}. Quando un utente tenta di completare un'azione specifica, il sistema di controllo utilizza gli attributi definiti nella politica per determinare se l'utente dispone dell'autorizzazione per eseguire tale attività. Le chiavi API {{site.data.keyword.cloud_notm}} sono disponibili tramite Tivoli Information Archive Manager che puoi utilizzare per l'autenticazione tramite la CLI o come parte dell'automazione dell'accesso come tua identità utente.</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>Puoi espandere le tue capacità di raccolta, conservazione e ricerca dei log creando una [configurazione di registrazione](/docs/containers?topic=containers-health) attraverso {{site.data.keyword.containerlong_notm}} che inoltra i tuoi log a [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started).
    Con il servizio, puoi anche usufruire di informazioni approfondite centralizzate, crittografia dei log e conservazione dei dati di log per tutto il tempo necessario.</dd>
</dl>
