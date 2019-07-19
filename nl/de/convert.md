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

# Images konvertieren
{: #convert}

Sie können Ihre Images in einer EnclaveOS®-Umgebung konvertieren, indem Sie den {{site.data.keyword.datashield_short}} Container Converter verwenden. Nachdem Ihre Images konvertiert wurden, können Sie sie in Ihrem SGX-fähigen Kubernetes-Cluster bereitstellen.
{: shortdesc}

Sie können Ihre Anwendungen konvertieren, ohne den Code zu ändern. Wenn Sie die Konvertierung durchführen, bereiten Sie Ihre Anwendung auf die Ausführung in einer EnclaveOS-Umgebung vor. Beachten Sie, dass Ihre Anwendung beim Konvertierungsprozess nicht verschlüsselt wird. Nur Daten, die während der Ausführung generiert werden, werden durch IBM Cloud Data Shield geschützt, nämlich nachdem die Anwendung innerhalb einer SGX-Enklave gestartet wurde. 

Während des Konvertierungsprozesses wird Ihre Anwendung nicht verschlüsselt.
{: important}


## Vorbemerkungen
{: #convert-before}

Bevor Sie Ihre Anwendungen konvertieren, müssen Sie die folgenden Hinweise vollständig verstanden haben.
{: shortdesc}

* Aus Sicherheitsgründen müssen die geheimen Schlüssel während der Ausführung bereitgestellt und nicht in dem Container-Image platziert werden, das Sie konvertieren möchten. Wird die App nach der Konvertierung ausgeführt, können Sie mittels Attestierung überprüfen, ob die Anwendung in einer Enklave ausgeführt wird, bevor Sie irgendwelche geheimen Schlüssel bereitstellen.

* Die Containergastmaschine muss als Rootbenutzer des Containers ausgeführt werden.

* Die Tests umfassten Container, die auf Debian, Ubuntu und Java mit unterschiedlichen Ergebnissen basieren. Andere Umgebungen funktionieren möglicherweise, wurden jedoch nicht getestet.


## Registry-Berechtigungsnachweise konfigurieren
{: #configure-credentials}

Sie können allen Benutzern des {{site.data.keyword.datashield_short}} Container Converters gestatten, Eingabe-Images von den konfigurierten privaten Registrys abzurufen und Ausgabe-Images dorthin zu übertragen, indem Sie ihn mit den Registry-Berechtigungsnachweisen konfigurieren. Wenn Sie die Container-Registry vor dem 4. Oktober 2018 verwendet haben, möchten Sie möglicherweise [die Richtliniendurchsetzung für den IAM-Zugriff für Ihre Registry aktivieren](/docs/services/Registry?topic=registry-user#existing_users).
{: shortdesc}

### {{site.data.keyword.cloud_notm}} Container Registry-Berechtigungsnachweise konfigurieren
{: #configure-ibm-registry}

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen. Wenn Sie über eine eingebundene ID verfügen, hängen Sie die Option `-- sso` an das Ende des Befehls an.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Erstellen Sie eine Service-ID und einen Service-ID-API-Schlüssel für den {{site.data.keyword.datashield_short}} Container Converter.

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. Erteilen Sie der Service-ID die Berechtigung zum Zugriff auf Ihre Container-Registry.

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. Erstellen Sie eine JSON-Konfigurationsdatei mit dem API-Schlüssel, den Sie erstellt haben. Ersetzen Sie die Variable `<api key>` und führen Sie den folgenden Befehl aus. Wenn `openssl` nicht vorhanden ist, können Sie einen beliebigen Base64-Befehlszeilen-Encoder mit den entsprechenden Optionen verwenden. Stellen Sie sicher, dass keine neuen Zeilen in der Mitte oder am Ende der codierten Zeichenfolge vorhanden sind.

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### Berechtigungsnachweise für eine andere Registry konfigurieren
{: #configure-other-registry}

Wenn Sie bereits die Datei `~/.docker/config.json` haben, die sich gegenüber der Registry authentifiziert, die Sie verwenden möchten, können Sie diese Datei verwenden. Dateien unter OS X werden derzeit nicht unterstützt.

1. Konfigurieren Sie [geheime Schlüssel für Pull-Operationen](/docs/containers?topic=containers-images#other).

2. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen. Wenn Sie über eine eingebundene ID verfügen, hängen Sie die Option `-- sso` an das Ende des Befehls an.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. Führen Sie den folgenden Befehl aus.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## Ihre Images konvertieren
{: #converting-images}

Sie können die Enclave Manager-API verwenden, um eine Verbindung zum Converter herzustellen.
{: shortdesc}

Sie können Ihre Container auch konvertieren, wenn Sie Ihre Apps über die [Benutzerschnittstelle von Enclave Manager](/docs/services/data-shield?topic=enclave-manager#em-apps) erstellen.
{: tip}

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen. Wenn Sie über eine eingebundene ID verfügen, hängen Sie die Option `-- sso` an das Ende des Befehls an.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Rufen Sie ein IAM-Token ab und exportieren Sie es.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. Konvertieren Sie Ihr Image. Stellen Sie sicher, dass die Variablen durch die Informationen für Ihre Anwendung ersetzt werden.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Java-Anwendungen konvertieren
{: #convert-java}

Wenn Sie Java-basierte Anwendungen konvertieren, gibt es ein paar zusätzliche Anforderungen und Einschränkungen. Wenn Sie Java-Anwendungen mithilfe der Benutzerschnittstelle von Enclave Manager konvertieren, können Sie den `Java-Modus` auswählen. Beachten Sie die folgenden Einschränkungen und Optionen, wenn Sie Java-Apps über die API konvertieren möchten.

**Einschränkungen**

* Die empfohlene maximale Enklave-Größe für Java-Apps beträgt 4 GB. Größere Enklaven funktionieren möglicherweise, es kann aber zu einer verminderten Leistung kommen.
* Der Wert für die empfohlene Heapspeichergröße liegt unter der Enklave-Größe. Zur Reduzierung der Heapspeichergröße empfehlen wir, sämtliche Optionen des Typs `-Xmx` zu entfernen.
* Die folgenden Java-Bibliotheken wurden getestet:
  - MySQL Java Connector
  - Crypto (`JCA`)
  - Messaging (`JMS`)
  - Hibernate (`JPA`)

  Wenn Sie mit einer anderen Bibliothek arbeiten, wenden Sie sich an unser Team; verwenden Sie hierbei die verfügbaren Foren oder klicken Sie auf die Feedback-Schaltfläche auf dieser Seite. Achten Sie darauf, Ihre Kontaktinformationen und die Bibliothek anzugeben, an der Sie interessiert sind.


**Optionen**

Zur Verwendung der Konvertierung über den `Java-Modus` müssen Sie Ihre Docker-Datei ändern, um die folgenden Optionen anzugeben. Damit die Java-Konvertierung funktioniert, müssen Sie alle Variablen so festlegen, wie sie in diesem Abschnitt definiert sind. 


* Legen Sie für die Umgebungsvariable MALLOC_ARENA_MAX den Wert 1 fest.

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* Bei der Verwendung von `OpenJDK JVM` müssen Sie die folgenden Optionen festlegen.

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* Bei der Verwendung von `OpenJ9 JVM` müssen Sie die folgenden Optionen festlegen.

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## Ein Anwendungszertifikat anfordern
{: #request-cert}

Eine konvertierte Anwendung kann ein Zertifikat von Enclave Manager anfordern, wenn Ihre Anwendung gestartet wird. Die Zertifikate werden von der Enclave Manager-Zertifizierungsstelle signiert und enthalten den Bericht von IAS (Intel Remote Attestation Service) für die SGX-Enklave Ihrer App.
{: shortdesc}

Im folgenden Beispiel erfahren Sie, wie Sie eine Anforderung zum Generieren eines privaten RSA-Schlüssels und zum Generieren des Zertifikats für den Schlüssel konfigurieren. Der Schlüssel wird im Stammverzeichnis des Anwendungscontainers gespeichert. Wenn Sie keinen ephemeren Schlüssel oder kein ephemeres Zertifikat wünschen, können Sie `keyPath` und `certPath` für Ihre Apps anpassen und sie auf einem permanenten Datenträger speichern.

1. Speichern Sie die folgende Vorlage als `app.json` und nehmen Sie die erforderlichen Änderungen so vor, dass sie den Zertifikatsanforderungen Ihrer Anwendung entsprechen.

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. Geben Sie Ihre Variablen ein und führen Sie den folgenden Befehl aus, um den Converter erneut mit Ihren Zertifikatsinformationen auszuführen.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## Anwendungen in die Whitelist aufnehmen
{: #convert-whitelist}

Wenn ein Docker-Image für die Ausführung in Intel® SGX konvertiert wird, kann es in die Whitelist aufgenommen werden. Durch das Whitelisting Ihres Images ordnen Sie Administratorberechtigungen zu, die der Anwendung eine Ausführung auf dem Cluster ermöglichen, auf dem {{site.data.keyword.datashield_short}} installiert ist.
{: shortdesc}


1. Rufen Sie ein Enclave Manager-Zugriffstoken mit dem IAM-Authentifizierungstoken ab:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. Erstellen Sie eine Whitelist-Anforderung an Enclave Manager. Stellen Sie sicher, dass Sie Ihre Informationen eingeben, wenn Sie den folgenden Befehl ausführen.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. Verwenden Sie die grafische Enclave Manager-Benutzerschnittstelle, um Whitelist-Anfragen zu genehmigen oder zu verweigern. Im Abschnitt **Tasks** der grafischen Benutzerschnittstelle können Sie in der Whitelist aufgeführte Builds verfolgen und verwalten.

