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

# Informationen zum Service
{: #about}

Mit {{site.data.keyword.datashield_full}}, Fortanix®, and Intel® SGX können Sie die Daten in Ihren Containerworkloads schützen, die auf {{site.data.keyword.cloud_notm}} ausgeführt werden, während Ihre Daten im Gebrauch sind.
{: shortdesc}

Wenn es um den Schutz Ihrer Daten geht, ist Verschlüsselung einer der beliebtesten und effektivsten Kontrollmechanismen. Die Daten müssen jedoch in jedem Schritt des Lebenszyklus verschlüsselt werden, damit Ihre Daten wirklich sicher sind. Die Daten durchlaufen während ihres Lebenszyklus drei Phasen: ruhende Daten, bewegte Daten und in Gebrauch befindliche Daten. Ruhende und bewegte Daten werden häufig verwendet, um Daten zu schützen, wenn sie gespeichert und übermittelt werden. Nachdem eine Anwendung gestartet wurde, sind die Daten, die von CPU und Speicher verwendet werden, anfällig für eine Reihe von Angriffen, einschließlich böswilliger Insider, Rootbenutzer, kompromittierte Berechtigungsnachweise, OS-Zero-Day, Netzwerk-Eindringlinge und andere. Wenn Sie diesen Schutz noch weiter verbessern möchten, können Sie die Daten in Gebrauch jetzt auch verschlüsseln. 

Mit {{site.data.keyword.datashield_short}} laufen Ihr App-Code und Daten in CPU-gehärteten Enklaven. Dies sind vertrauenswürdige Speicherbereiche auf dem Workerknoten, die kritische Aspekte der App schützen. Die Enklaven tragen dazu bei, den Code und die Daten vertraulich und unveränderlich zu erhalten. Wenn Sie oder Ihr Unternehmen aufgrund interner Richtlinien, behördlicher Auflagen oder der Einhaltung gesetzlicher Auflagen zur Datensicherheit sensibilisiert werden müssen, kann diese Lösung Ihnen helfen, in die Cloud zu wechseln. Beispielanwendungsfälle sind Finanz- und Gesundheitseinrichtungen oder Länder mit Regierungsrichtlinien, die On-Premises-Cloud-Lösungen fordern.


## Integrationen
{: #integrations}

Um Ihnen ein möglichst nahtloses Erlebnis zu bieten, ist {{site.data.keyword.datashield_short}} in andere {{site.data.keyword.cloud_notm}}-Services, Fortanix® Runtime Encryption und Intel SGX® integriert.

<dl>
  <dt>Fortanix®</dt>
    <dd>Mit [Fortanix](http://fortanix.com/) können Sie Ihre wertvollsten Apps und Daten schützen, auch wenn die Infrastruktur kompromittiert wurde. Fortanix basiert auf Intel SGX und bietet eine neue Kategorie der Datensicherheit, die als "Runtime Encryption" bezeichnet wird. Ähnlich wie die Verschlüsselung für ruhende Daten und Daten in Gebrauch werden bei der Laufzeit-Verschlüsselung Schlüssel, Daten und Anwendungen vollständig vor externen und internen Bedrohungen geschützt. Diese Bedrohungen können böswillige Insider, Cloud-Provider, Hacks auf Betriebssystemebene oder Netzwerk-Eindringlinge sein.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx) ist eine Erweiterung der x86-Architektur, mit der Sie Anwendungen in einer vollständig isolierten sicheren Enklave ausführen können. Die Anwendung wird nicht nur von anderen Anwendungen isoliert, die auf demselben System ausgeführt werden, sondern auch vom Betriebssystem und vom möglichen Hypervisor. Dadurch wird verhindert, dass Administratoren die Anwendung nach dem Start der Anwendung manipulieren. Der Speicher von sicheren Enklaven ist auch verschlüsselt, um physische Angriffe zu verhindern. Die Technologie unterstützt auch die sichere Speicherung persistenter Daten, so dass sie nur von der sicheren Enklave gelesen werden können.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started) bietet leistungsstarke Tools durch die Kombination von Docker-Containern, der Kubernetes-Technologie, einer intuitiven Benutzererfahrung sowie integrierten Sicherheits- und Isolationsfunktionen, um die Bereitstellung, den Betrieb, die Skalierung und die Überwachung von Container-Apps in einem Cluster von Rechenhosts zu automatisieren.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted) ermöglicht es Ihnen, Benutzer für Services sicher zu authentifizieren und den Zugriff auf Ressourcen konsistent über {{site.data.keyword.cloud_notm}} zu steuern. Wenn ein Benutzer versucht, eine bestimmte Aktion auszuführen, dann verwendet das Steuersystem die Attribute, die in der Richtlinie definiert sind, um festzustellen, ob der Benutzer über die Berechtigung zur Ausführung dieser Task verfügt. {{site.data.keyword.cloud_notm}}-API-Schlüssel sind über Cloud IAM verfügbar, damit Sie sich authentifizieren können, indem Sie die Befehlszeilenschnittstelle oder einen Teil der Automatisierung verwenden, um sich mit Ihrer Benutzeridentität anzumelden.</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>Sie können eine [Protokollierungskonfiguration](/docs/containers?topic=containers-health#health) über {{site.data.keyword.containerlong_notm}} erstellen, wodurch Ihre Protokolle an [{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla) weitergeleitet werden. Sie können die Funktionen der Protokollerfassung, Protokollspeicherung und Protokollsuche in {{site.data.keyword.cloud_notm}} erweitern. Ermächtigen Sie Ihr DevOps-Team für Funktionen wie der Aggregation von Anwendungs- und Umgebungsprotokollen für konsolidierte Anwendungs- oder Umgebungsinformationen, Verschlüsselung von Protokollen, Aufbewahrung von Protokolldaten, solange sie benötigt werden, und für die schnelle Erkennung und Behebung von Problemen.</dd>
</dl>
