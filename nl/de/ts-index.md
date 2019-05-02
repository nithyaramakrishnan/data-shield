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

# Fehlerbehebung
{: #troubleshooting}

Wenn Sie beim Arbeiten mit {{site.data.keyword.datashield_full}} Probleme haben, sollten Sie diese Verfahren bei der Fehlerbehebung und die Hilfe berücksichtigen.
{: shortdesc}

## Hilfe aufrufen und Support erhalten
{: #gettinghelp}

Um Hilfe zu erhalten, können Sie in der Dokumentation nach Informationen suchen oder in Fragen über ein Forum stellen. Sie können auch ein Support-Ticket öffnen. Wenn Sie eine Frage in einem Forum stellen, taggen Sie Ihre Frage, sodass sie von den {{site.data.keyword.Bluemix_notm}}-Entwicklungsteams gesehen wird.
  * Wenn Sie technische Fragen zu {{site.data.keyword.datashield_short}} haben, stellen Sie Ihre Frage über <a href="https://stackoverflow.com/search?q=ibm-data-shield" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="Symbol zum externen Link"></a> und versehen Sie sie mit dem Tag "ibm-data-shield".
  * Wenn Sie Fragen zum Service und zu Einführungsanweisungen haben, verwenden Sie das Forum <a href="https://developer.ibm.com/answers/topics/data-shield/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="Symbol zum externen Link"></a>. Geben Sie das Tag `data-shield` an.

Weitere Informationen zum Anfordern von Unterstützung finden Sie unter [Wie erhalte ich die gewünschte Unterstützung?](/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).


## Ich kenne die Optionen nicht, die ich mit dem Installationsprogramm verwenden kann.
{: #options}

Um alle Befehle und weitere Hilfeinformationen anzuzeigen, können Sie den folgenden Befehl ausführen und die Ausgabe überprüfen.

```
docker run registry.bluemix.net/ibm/datashield-installer help
```
{: pre}

## Ich kann mich nicht bei der Benutzerschnittstelle von Enclave Manager anmelden.
{: #ts-log-in}

{: tsSymptoms}
Sie versuchen, auf die Benutzerschnittstelle von Enclave Manager zuzugreifen, aber Sie können sich nicht anmelden.

{: tsCauses}
Das Anmelden kann aus den folgenden Gründen fehlschlagen:

* Möglicherweise verwenden Sie eine E-Mail-ID, die nicht zum Zugriff auf das Enclave Manager-Cluster berechtigt ist.
* Das von Ihnen verwendete Token ist möglicherweise abgelaufen.

{: tsResolve}
Stellen Sie sicher, dass Sie die richtige E-Mail-ID verwenden, um das Problem zu beheben. Wenn dies der Fall ist, prüfen Sie, ob die E-Mail über die korrekten Berechtigungen für den Zugriff auf den Enclave Manager verfügt. Wenn Sie über die entsprechenden Berechtigungen verfügen, ist Ihr Zugriffstoken möglicherweise abgelaufen. Token sind jeweils für 60 Minuten gültig. Um ein neues Token abzurufen, führen Sie `ibmcloud iam oauth-tokens` aus.


## Die Container Converter-API gibt einen unzulässigen Fehler zurück.
{: #ts-converter-forbidden-error}

{: tsSymptoms}
Beim Versuch, Container Converter auszuführen, wird ein Fehler angezeigt: `Forbidden`.

{: tsCauses}
Möglicherweise können Sie nicht auf den Converter zugreifen, wenn Ihr IAM- oder Bearer-Token fehlt oder abgelaufen ist.

{: tsResolve}
Um das Problem zu beheben, sollten Sie sicherstellen, dass Sie entweder ein IBM IAM OAuth-Token oder ein Enclave Manager-Authentifizierungstoken in der Kopfzeile Ihrer Anforderung verwenden. Die Token haben das folgende Format:

* IAM: `Authentication: Basic <IBM IAM Token>`
* Enclave Manager: `Authentication: Bearer <E.M. Token>`

Wenn Ihr Token vorhanden ist, überprüfen Sie, ob es noch gültig ist, und wiederholen Sie die Anforderung.


## Container Converter kann keine Verbindung zu einer privaten Docker-Registry herstellen.
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
Sie versuchen, Container Converter auf einem Image aus einer privaten Docker-Registry auszuführen, und der Converter kann keine Verbindung herstellen.

{: tsCauses}
Die Berechtigungsnachweise Ihrer privaten Registry sind möglicherweise falsch konfiguriert. 

{: tsResolve}
Um das Problem zu beheben, können Sie die folgenden Schritte ausführen:

1. Stellen Sie sicher, dass Ihre Berechtigungsnachweise für die private Registry zuvor konfiguriert wurden. Ist dies nicht der Fall, konfigurieren Sie sie jetzt.
2. Führen Sie den folgenden Befehl aus, um einen Speicherauszug Ihrer Berechtigungsnachweise der Docker-Registry zu erstellen. Falls erforderlich, können Sie den Namen des geheimen Schlüssels ändern.

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: pre}

3. Verwenden Sie einen Base64-Decoder, um den geheimen Inhalt von `.dockerconfigjson` zu dekodieren und zu überprüfen, ob er korrekt ist.


## AESM-Socket oder SGX-Einheiten können nicht angehängt werden
{: #ts-problem-mounting-device}

{: tsSymptoms}
Beim Versuch, {{site.data.keyword.datashield_short}} Container an Datenträgen `/var/run/aesmd/aesm.socket` oder `/dev/isgx` anzuhängen, treten Probleme auf.

{: tsCauses}
Die Mountvorgänge können aufgrund von Problemen mit der Konfiguration des Hosts fehlschlagen.

{: tsResolve}
Um das Problem zu beheben, überprüfen Sie diese beiden Punkte:

* `/var/run/aesmd/aesm.socket` darf kein Verzeichnis des Hosts sein. Ist dies der Fall, löschen Sie die Datei, deinstallieren Sie die {{site.data.keyword.datashield_short}}-Software, und führen Sie die Installationsschritte erneut aus. 
* SGX muss im BIOS der Hostmaschinen aktiviert sein. Wenn dies nicht der Fall ist, wenden Sie sich an den IBM Support.


## Fehler beim Konvertieren von Containern
{: #ts-container-convert-fails}

{: tsSymptoms}
Der folgende Fehler tritt auf, wenn Sie versuchen, den Container zu konvertieren.

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: pre}

{: tsCauses}
Unter MacOS schlägt Container Converter fehl, wenn die OSX-Schlüsselkette in Ihrer config.json-Datei verwendet wird. 

{: tsResolve}
Um das Problem zu beheben, können Sie die folgenden Schritte ausführen:

1. Inaktivieren Sie die OSX-Schlüsselkette auf Ihrem lokalen System. Wechseln Sie zu **Systemeinstellungen > iCloud** und wählen Sie das Kontrollkästchen für **Schlüsselkette** ab.

2. Löschen Sie den geheimen Schlüssel, den Sie erstellt haben. Stellen Sie sicher, dass Sie bei IBM Cloud angemeldet sind, und Ihren Cluster als Ziel angegeben haben, bevor Sie den folgenden Befehl ausführen.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: pre}

3. Löschen Sie in der Datei `$HOME/.docker/config.json` die Zeile `"credsStore": "osxkeychain"`.

4. Melden Sie sich bei Ihrer Registry an.

5. Erstellen Sie einen neuen geheimen Schlüssel.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}

6. Listen Sie Ihre Pods auf und notieren Sie im Namen den Pod mit `enclaveos-converter`.

  ```
  kubectl get pods
  ```
  {: pre}

7. Löschen Sie den Pod.

  ```
  kubectl delete pod <pod name>
  ```
  {: pre}

8. Konvertieren Sie Ihr Image. 
