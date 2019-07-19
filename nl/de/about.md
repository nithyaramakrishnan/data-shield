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

# Informationen zum Service
{: #about}

Mit {{site.data.keyword.datashield_full}}, Fortanix® und Intel® SGX können Sie die Daten in Ihren Containerworkloads schützen, die in {{site.data.keyword.cloud_notm}} ausgeführt werden, und zwar während der Ausführungszeit.
{: shortdesc}

Wenn es um den Schutz Ihrer Daten geht, ist Verschlüsselung einer der beliebtesten und effektivsten Kontrollmechanismen. Die Daten müssen jedoch in jedem Schritt des Lebenszyklus verschlüsselt werden, damit sie wirklich sicher sind. Während ihres Lebenszyklus durchlaufen die Daten drei Phasen: Ruhephase, Bewegungsphase oder Gebrauchsphase. Ruhende und bewegte Daten stehen im Allgemeinen beim Thema 'Datensicherung' im Fokus. Wenn jedoch eine Anwendung gestartet wird, sind die Daten, die von CPU und Speicher verwendet werden, anfällig für unterschiedliche Angriffe. Böswillige Insider, Rootbenutzer, kompromittierte Berechtigungsnachweise, OS-Zero-Day und Netzeindringlinge usw. stellen Bedrohungen für Daten dar. Wenn Sie diesen Schutz noch weiter verbessern möchten, können Sie die Daten in Gebrauch jetzt auch verschlüsseln. 

Mit {{site.data.keyword.datashield_short}} werden Ihr App-Code und Ihre Daten in auf CPUs permanent gespeicherten Enklaven ausgeführt. Dies sind vertrauenswürdige Speicherbereiche auf dem Workerknoten, die kritische Aspekte der Apps schützen. Die Enklaven tragen dazu bei, dass Code und Daten vertraulich bleiben, und sie verhindern Modifizierungen. Wenn Sie oder Ihr Unternehmen aufgrund interner Richtlinien, behördlicher Auflagen oder der Einhaltung gesetzlicher Auflagen zur Datensicherheit verpflichtet werden, kann diese Lösung Ihnen helfen, in die Cloud zu wechseln. Beispielanwendungsfälle sind Finanz- und Gesundheitseinrichtungen oder Länder mit Regierungsrichtlinien, die On-Premises-Cloud-Lösungen fordern.


## Integrationen
{: #integrations}

Für einen möglichst reibungslosen Ablauf ist {{site.data.keyword.datashield_short}} in andere {{site.data.keyword.cloud_notm}}-Services, Fortanix® und Intel SGX® integriert.

<dl>
  <dt>Fortanix®</dt>
    <dd>Mit [Fortanix Runtime Encryption](https://fortanix.com/){: external} können Sie Ihre wertvollsten Apps und Daten schützen, auch wenn die Infrastruktur Beeinträchtigungen unterliegt. Fortanix basiert auf Intel SGX und bietet eine neue Kategorie der Datensicherheit, die als "Runtime Encryption" bezeichnet wird. Ähnlich wie die Verschlüsselung für ruhende Daten und Daten in Gebrauch werden bei der Laufzeitverschlüsselung Schlüssel, Daten und Anwendungen vor externen und internen Bedrohungen geschützt. Diese Bedrohungen können böswillige Insider, Cloud-Provider, Hacks auf Betriebssystemebene oder Netzwerk-Eindringlinge sein.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} ist eine Erweiterung der x86-Architektur, mit der Sie Anwendungen in einer vollständig isolierten sicheren Enklave ausführen können. Die Anwendung wird nicht nur von anderen Anwendungen isoliert, die auf demselben System ausgeführt werden, sondern auch vom Betriebssystem und von einem eventuellen Hypervisor. Durch die Isolation wird auch verhindert, dass Administratoren die Anwendung nach dem Start manipulieren. Der Speicher von sicheren Enklaven ist auch verschlüsselt, um physische Angriffe zu verhindern. Die Technologie unterstützt auch die sichere Speicherung persistenter Daten, sodass sie nur von der sicheren Enklave gelesen werden können.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) bietet leistungsstarke Tools durch die Kombination von Docker-Containern, der Kubernetes-Technologie, einer intuitiven Benutzerschnittstelle sowie integrierten Sicherheits- und Isolationsfunktionen, um die Arbeit mit containerisierten Apps zu automatisieren.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) ermöglicht es Ihnen, Benutzer für Services sicher zu authentifizieren und den Zugriff auf Ressourcen konsistent über {{site.data.keyword.cloud_notm}} zu steuern. Wenn ein Benutzer versucht, eine bestimmte Aktion auszuführen, dann verwendet das Steuersystem die Attribute, die in der Richtlinie definiert sind, um festzustellen, ob der Benutzer über die Berechtigung zur Ausführung dieser Task verfügt. {{site.data.keyword.cloud_notm}}-API-Schlüssel sind über Tivoli Information Archive Manager verfügbar; mit deren Hilfe können Sie sich über die Befehlszeilenschnittstelle authentifizieren oder sie im Rahmen der Automatisierung zur Anmeldung mit Ihrer Benutzeridentität nutzen.</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>Sie können die Funktionen der Protokollerfassung, Protokollspeicherung und Protokollsuche durch die Erstellung einer [Protokollierungskonfiguration](/docs/containers?topic=containers-health) über {{site.data.keyword.containerlong_notm}} erstellen; dieser Service leitet Ihre Protokolle an [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started) weiter.
    Mit dem Service können Sie auch die Vorteile der zentralen Insights, der Protokollverschlüsselung und der Protokolldatenspeicherung nutzen, und zwar so lange wie Sie diese benötigen.</dd>
</dl>
