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

# Images konvertieren
{: #convert}

Sie können Ihre Images in einer EnclaveOS®-Umgebung konvertieren, indem Sie den {{site.data.keyword.datashield_short}} Container Converter verwenden. Nachdem Ihre Images konvertiert wurden, können Sie sie in Ihrem SGX-fähigen Kubernetes-Cluster implementieren.
{: shortdesc}


## Registry-Berechtigungsnachweise konfigurieren
{: #configure-credentials}

Sie können allen Benutzern des Konverters gestatten, Eingabe-Images von den konfigurierten privaten Registrys abzurufen und Ausgabebilder zu verschieben, indem Sie den Konverter mit den Registry-Berechtigungsnachweisen konfigurieren.
{: shortdesc}

### {{site.data.keyword.cloud_notm}} Container Registry-Berechtigungsnachweise konfigurieren
{: #configure-ibm-registry}

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>Region</th>
      <th>IBM Cloud-Endpunkt</th>
      <th>Kubernetes Service-Region</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>Vereinigte Staaten (Süden)</td>
    </tr>
    <tr>
      <td>Frankfurt</td>
      <td><code>eu-de</code></td>
      <td>Mitteleuropa</td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
      <td>Asien-Pazifik (Süden)</td>
    </tr>
    <tr>
      <td>London</td>
      <td><code>eu-gb</code></td>
      <td>Vereinigtes Königreich (Süden)</td>
    </tr>
    <tr>
      <td>Tokio</td>
      <td><code>jp-tok</code></td>
      <td>Asien-Pazifik (Norden)</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>Vereinigte Staaten (Osten)</td>
    </tr>
  </table>

2. Fordern Sie ein Authentifizierungstoken für Ihre Instanz von {{site.data.keyword.cloud_notm}} Container Registry an.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. Erstellen Sie eine JSON-Konfigurationsdatei mit dem Token, das Sie erstellt haben. Ersetzen Sie die Variable `<token>` und führen Sie den folgenden Befehl aus. Wenn `openssl` nicht vorhanden ist, können Sie einen beliebigen Base64-Befehlszeilen-Encoder mit den entsprechenden Optionen verwenden. Stellen Sie sicher, dass keine neuen Zeilen in der Mitte oder am Ende der codierten Zeichenfolge vorhanden sind.

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### Berechtigungsnachweise für eine andere Registry konfigurieren
{: #configure-other-registry}

Wenn Sie bereits die Datei `~/.docker/config.json` haben, die sich gegenüber der Registry authentifiziert, die Sie verwenden möchten, können Sie diese Datei verwenden.

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Führen Sie den folgenden Befehl aus.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## Ihre Images konvertieren
{: #converting-images}

Sie können die Enclave Manager-API verwenden, um eine Verbindung zum Converter herzustellen.
{: shortdesc}

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Rufen Sie ein IAM-Token ab und exportieren Sie es.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. Konvertieren Sie Ihr Image. Stellen Sie sicher, dass die Variablen durch die Informationen für Ihre Anwendung ersetzt werden.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## Ein Anwendungszertifikat anfordern
{: #request-cert}

Eine konvertierte Anwendung kann ein Zertifikat von Enclave Manager anfordern, wenn Ihre Anwendung gestartet wird. Die Zertifikate werden von der Enclave Manager-Zertifizierungsstelle signiert und enthalten den Bericht von IAS (Intel Remote Attestation Service) für die SGX-Enklave Ihrer App.
{: shortdesc}

Im folgenden Beispiel erfahren Sie, wie Sie eine Anforderung zum Generieren eines privaten RSA-Schlüssels und zum Generieren des Zertifikats für den Schlüssel konfigurieren. Der Schlüssel wird im Stammverzeichnis des Anwendungscontainers gespeichert. Wenn Sie keinen ephemeren Schlüssel/kein ephemeres Zertifikat wünschen, können Sie `keyPath` und `certPath` für Ihre Apps anpassen und sie auf einem permanenten Datenträger speichern.

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
 {: pre}


## Whitelisting Ihrer Anwendungen
{: #convert-whitelist}

Wenn ein Docker-Image für die Ausführung in Intel® SGX konvertiert wird, kann es in die Whitelist aufgenommen werden. Durch das Whitelisting Ihres Images ordnen Sie Administratorberechtigungen zu, die der Anwendung eine Ausführung auf dem Cluster ermöglichen, auf dem {{site.data.keyword.datashield_short}} installiert ist.
{: shortdesc}

1. Rufen Sie ein Enclave Manager-Zugriffstoken mit dem IAM-Authentifizierungstoken unter Verwendung der folgenden curl-Anforderung ab:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. Erstellen Sie eine Whitelist-Anforderung an Enclave Manager. Stellen Sie sicher, dass Sie Ihre Informationen eingeben, wenn Sie den folgenden Befehl ausführen.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. Verwenden Sie die grafische Enclave Manager-Benutzerschnittstelle, um Whitelist-Anfragen zu genehmigen oder zu verweigern. Im Abschnitt **Builds** der grafischen Benutzerschnittstelle können Sie mit in Whitelist aufgeführte Builds verfolgen und verwalten.
