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

# Häufig gestellte Fragen (FAQ)
{: #faq}

Diese FAQ enthält Antworten auf häufig gestellte Fragen zum {{site.data.keyword.datashield_full}}-Service.
{: shortdesc}


## Was ist eine Enklave-Attestierung? Wann und warum ist sie erforderlich?
{: #enclave-attestation}
{: faq}

Enklaven werden auf Plattformen durch nicht vertrauenswürdigen Code instanziiert. Bevor Enklaven mit vertraulichen Informationen zur Anwendung bereitgestellt werden, ist es daher unerlässlich zu bestätigen, dass die Enklave auf einer von Intel ® SGX-geschützten Plattform korrekt instanziiert wurde. Dies wird durch einen fernen Attestierungsvorgang ausgeführt. Die ferne Attestierung besteht aus der Verwendung von Intel® SGX-Anweisungen und Plattform-Software, um ein "Angebot" zu generieren. Das Angebot kombiniert den Enklave-Digest mit einem Digest der relevanten Enklave-Daten und einem plattformspezifischen asymmetrischen Schlüssel in eine Datenstruktur, die über einen authentifizierten Kanal an einen fernen Server gesendet wird. Wenn der ferne Server zu dem Schluss kommt, dass die Enklave wie beabsichtigt instanziiert wurde und auf einem echten Intel® SGX-fähigen Prozessor ausgeführt wird, wird die Enklave wie erforderlich bereitgestellt.


## Welche Sprachen werden derzeit von {{site.data.keyword.datashield_short}} unterstützt?
{: #language-support}
{: faq}

Der Service erweitert die SGX-Sprachunterstützung von C und C++ auf Python und Java®.  Er stellt auch vorab konvertierte SGX-Anwendungen für MariaDB, NGINX und Vault bereit, wobei der Code nicht oder kaum geändert wird.


##	Wie kann ich wissen, ob Intel SGX auf meinem Workerknoten aktiviert ist?
{: #sgx-enabled}
{: faq}

Die {{site.data.keyword.datashield_short}}-Software überprüft während des Installationsprozesses die SGX-Verfügbarkeit auf dem Workerknoten. Wenn die Installation erfolgreich ist, können die detaillierten Informationen des Knotens sowie der Bericht des SGX-Attestierungsberichts auf der Benutzerschnittstelle von Enclave Manager angezeigt werden.


##	Wie kann ich wissen, dass meine Anwendung in einer SGX-Enklave ausgeführt wird?
{: #running-app}
{: faq}

[Melden Sie sich an Ihrem Enclave Manager-Konto an](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) und navigieren Sie zur Registerkarte **Apps**. Auf der Registerkarte **Apps** können Sie Informationen zu der Intel® SGX-Attestierung für Ihre Anwendungen in Form eines Zertifikats anzeigen. Die Enklave der Anwendung kann jederzeit mithilfe von IAS (Intel Remote Attestation Service) geprüft werden, um zu überprüfen, ob die Anwendung in einer geprüften Enklave ausgeführt wird.



## Wie wirkt sich die Ausführung der Anwendung auf {{site.data.keyword.datashield_short}} auf die Leistung aus?
{: #impact}
{: faq}


Die Leistung Ihrer Anwendung hängt von der Art des Workloads ab. Wenn Sie über eine CPU-intensive Workload verfügen, ist der Effekt minimal, den {{site.data.keyword.datashield_short}} auf Ihre App hat. Wenn Sie jedoch über speicher- oder E/A-intensive Anwendungen verfügen, bemerken Sie möglicherweise Auswirkungen aufgrund von Paging- und Kontextwechsel. Die Größe des Speicherfußabdrucks Ihrer App im Verhältnis zum SGX-Enklaven-Seitencache bestimmt in der Regel, wie Sie die Auswirkungen von {{site.data.keyword.datashield_short}} bestimmen können.
