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
{:faq: data-hd-content-type='faq'}

# Domande frequenti (FAQ, Frequently Asked Questions)
{: #faq}

Questa sezione dedicata alle domande frequenti (FAQ) fornisce risposte a domande comuni sul servizio {{site.data.keyword.datashield_full}}.
{: shortdesc}


## Cos'è l'attestazione dell'enclave? Quando e perché è necessaria?
{: #enclave-attestation}
{: faq}

Le enclave sono istanziate sulle piattaforme da codice non ritenuto attendibile. Quindi, prima che venga eseguito il provisioning delle enclave con le informazioni riservate sulle applicazioni, è essenziale poter confermare che l'enclave è stata istanziata correttamente su una piattaforma protetta da Intel® SGX. Tale operazione viene eseguita da un processo di attestazione remota. L'attestazione remota consiste nell'utilizzo delle istruzioni e del software della piattaforma Intel® SGX per generare una “quota”. La quota combina la selezione dell'enclave con una selezione dei dati dell'enclave pertinenti e una chiave asimmetrica univoca per la piattaforma in una struttura di dati che viene inviata a un server remoto su un canale autenticato. Se il server remoto conclude che l'enclave era stata istanziata come previsto e che è in esecuzione su un autentico processore compatibile con Intel® SGX, esegue il provisioning dell'enclave come richiesto.


## Quali linguaggi sono attualmente supportati da {{site.data.keyword.datashield_short}}?
{: #language-support}
{: faq}

Il servizio estende il supporto del linguaggio SGX da C e C++ a Python e Java®. Fornisce anche delle applicazioni SGX preconvertite per MariaDB, NGINX e Vault, con una modifica del codice minima o nulla.


##	Come faccio a sapere se Intel SGX è abilitato sul mio nodo di lavoro?
{: #sgx-enabled}
{: faq}

Il software {{site.data.keyword.datashield_short}} verifica la disponibilità di SGX sul nodo di lavoro durante il processo di installazione. Se l'installazione riesce, le informazioni dettagliate sul nodo e il report di attestazione SGX possono essere visualizzati nell'interfaccia utente Enclave Manager.


##	Come faccio a sapere che la mia applicazione è in esecuzione in un'enclave SGX?
{: #running-app}
{: faq}

[Accedi](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) al tuo account Enclave Manager e vai alla scheda **Apps**. Nella scheda **Apps**, puoi vedere le informazioni sull'attestazione Intel® SGX per le tue applicazioni sotto forma di certificato. L'enclave delle applicazioni può essere verificata in qualsiasi momento utilizzando l'IAS (Intel Remote Attestation Service) per verificare che l'applicazione è in esecuzione in una enclave verificata.



## Qual è l'impatto sulle prestazioni dell'esecuzione dell'applicazione su {{site.data.keyword.datashield_short}}?
{: #impact}
{: faq}


Le prestazioni della tua applicazione dipendono dalla natura del tuo carico di lavoro. Se hai un carico di lavoro che utilizza in modo intensivo la CPU, l'effetto che {{site.data.keyword.datashield_short}} ha sulla tua applicazione è minimo. Se invece hai delle applicazioni che utilizzano in modo intensivo la memoria o l'I/O, potresti notare un effetto dovuto a commutazione di contesto e paginazione. La dimensione del footprint di memoria della tua applicazione in relazione alla cache di pagina dell'enclave SGX è generalmente il modo in cui puoi determinare l'impatto di {{site.data.keyword.datashield_short}}.
