# IBM Cloud Data Shield

Mit IBM Cloud Data Shield, Fortanix® und Intel® SGX können Sie die Daten in Ihren Containerworkloads schützen, die in IBM Cloud ausgeführt werden, während die Daten in Gebrauch sind.

## Einführung

Wenn es um den Schutz Ihrer Daten geht, ist Verschlüsselung eine der beliebtesten und effektivsten Methoden. Die Daten müssen jedoch in jedem Schritt des Lebenszyklus verschlüsselt werden, damit Ihre Daten wirklich sicher sind. Die drei Phasen des Datenlebenszyklus sind ruhende Daten, bewegte Daten und in Gebrauch befindliche Daten. Ruhende und bewegte Daten werden häufig verwendet, um Daten zu schützen, wenn sie gespeichert und übermittelt werden. 

Wenn jedoch eine Anwendung gestartet wird, sind die Daten, die von CPU und Speicher verwendet werden, anfällig für Angriffe. Böswillige Insider, Rootbenutzer, kompromittierte Berechtigungsnachweis, OS-Zero-Day und Netzwerk-Eindringlinge stellen Bedrohungen für Daten dar. Wenn Sie diese Verschlüsselung noch weiter verbessern möchten, können Sie die Daten in Gebrauch jetzt auch schützen. 

Weitere Informationen zum Service und zu den Möglichkeiten zum Schutz Ihrer in Gebrauch befindlichen Daten sind in diesem Bereich enthalten. Erfahren Sie mehr im Abschnitt [Informationen zum Service](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about).



## Diagrammdetails

Dieses Helm-Diagramm installiert die folgenden Komponenten auf Ihrem SGX-fähigen IBM Cloud Kubernetes Service-Cluster:

 * Die unterstützende Software für SGX, die auf den Bare-Metal-Hosts von einem privilegierten Container installiert wird.
 * Der IBM Cloud Data Shield Enclave Manager, der die SGX-Enklaven in der IBM Cloud Data Shield-Umgebung verwaltet.
 * Der EnclaveOS®-Container-Konvertierungsservice, der containerisierte Anwendungen konvertiert, so dass sie in der IBM Cloud Data Shield-Umgebung ausgeführt werden können.



## Erforderliche Ressourcen

* Ein SGX-fähiger Kubernetes-Cluster. Derzeit kann SGX auf einem Bare-Metal-Cluster mit dem Knotentyp mb2c.4x32 aktiviert werden. Wenn keiner vorhanden ist, können Sie die folgenden Schritte ausführen, um sicherzustellen, dass Sie den benötigten Cluster erstellen.
  1. Bereiten Sie die [Erstellung des Clusters](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare) vor.

  2. Stellen Sie sicher, dass Sie über die [erforderlichen Berechtigungen](https://cloud.ibm.com/docs/containers?topic=containers-users#users) verfügen, um einen Cluster zu erstellen.

  3. Erstellen Sie den [Cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters).

* Eine Instanz der [cert-manager](https://cert-manager.readthedocs.io/en/latest/)-Serviceversion 0.5.0 oder höher. Wenn Sie eine Instanz mit Helm installieren möchten, können Sie den folgenden Befehl ausführen.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## Voraussetzungen

Bevor Sie mit der Verwendung von IBM Cloud Data Shield beginnen können, müssen Sie die folgenden Voraussetzungen erfüllen. Wenn Sie Hilfe beim Abrufen der heruntergeladenen CLIs und Plug-ins sowie der konfigurierten Kubernetes Service-Umgebung erhalten möchten, verwenden Sie das Lernprogramm [Kubernetes-Cluster erstellen](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Die folgenden CLIs:

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  Möglicherweise möchten Sie Helm so konfigurieren, dass der Modus `--tls` verwendet wird. Hilfe zum Aktivieren von TLS-Check-out für das [Helm-Repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Wenn Sie TLS aktivieren, müssen Sie sicherstellen, dass `--tls` an jeden Steuerbefehl angehängt wird, den Sie ausführen.
  {: tip}

* Die folgenden [{{site.data.keyword.cloud_notm}}-CLI-Plug-ins](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes Service
  * Container Registry



## Diagramm installieren

Wenn Sie ein Helm-Diagramm installieren, stehen Ihnen mehrere Optionen und Parameter zur Verfügung, um Ihre Installation anzupassen. Die folgenden Anweisungen führen Sie durch die grundlegendste Standardinstallation des Diagramms. Weitere Informationen zu Ihren Optionen finden Sie in der [Dokumentation zu IBM Cloud Data Shield](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started).

Tipp: Sind Ihre Images in einer privaten Registry gespeichert? Sie können den EnclaveOS Container Converter verwenden, um die Images für die Arbeit mit IBM Cloud Data Shield zu konfigurieren. Stellen Sie sicher, dass Sie Ihre Images konvertieren, bevor Sie das Diagramm bereitstellen, damit Sie die erforderlichen Konfigurationsinformationen haben. Weitere Informationen zum Konvertieren von Images finden Sie in den [Dokumentationen](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert). 


**Gehen Sie wie folgt vor, um IBM Cloud Data Shield auf Ihrem Cluster zu installieren:**

1. Melden Sie sich bei der IBM Cloud-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

2. Legen Sie den Kontext für Ihren Cluster fest.

  1. Rufen Sie den Befehl ab, um die Umgebungsvariable festzulegen, und laden Sie die Kubernetes-Konfigurationsdateien herunter.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```

  2. Kopieren Sie die Ausgabe, die mit `export` beginnt, und fügen Sie sie in Ihr Terminal ein, um die Umgebungsvariable `KUBECONFIG` festzulegen.

3. Wenn Sie dies noch nicht getan haben, fügen Sie das `ibm`-Repository hinzu.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. Optional: Wenn Sie die E-Mail nicht kennen, die dem Administrator oder der Administratorkonto-ID zugeordnet ist, führen Sie den folgenden Befehl aus.

  ```
  ibmcloud account show
  ```

5. Rufen Sie die Ingress-Unterdomäne für Ihren Cluster ab.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. Installieren Sie das Diagramm.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  Hinweis: Wenn Sie eine Instanz von [IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert) für Ihren Converter konfiguriert haben, fügen Sie die folgende Option hinzu: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. Um den Start Ihrer Komponenten zu überwachen, können Sie den folgenden Befehl ausführen.

  ```
  kubectl get pods
  ```

## Ihre Apps in der IBM Cloud Data Shield-Umgebung ausführen

Wenn Sie Ihre Anwendungen in der IBM Cloud Data Shield-Umgebung ausführen möchten, müssen Sie das Container-Image konvertieren, in die Whitelist aufnehmen und anschließend Ihr Container-Image bereitstellen.

### Ihre Images konvertieren
{: #converting-images}

Sie können die Enclave Manager-API verwenden, um eine Verbindung zum Converter herzustellen.
{: shortdesc}

1. Melden Sie sich bei der IBM Cloud-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. Rufen Sie ein IAM-Token ab und exportieren Sie es.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. Konvertieren Sie Ihr Image. Stellen Sie sicher, dass die Variablen durch die Informationen für Ihre Anwendung ersetzt werden.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### Whitelisting Ihrer Anwendung
{: #convert-whitelist}

Wenn ein Docker-Image für die Ausführung in Intel® SGX konvertiert wird, kann es in die Whitelist aufgenommen werden. Durch das Whitelisting Ihres Images ordnen Sie Administratorberechtigungen zu, die der Anwendung eine Ausführung auf dem Cluster ermöglichen, auf dem IBM Cloud Data Shield installiert ist.
{: shortdesc}

1. Rufen Sie ein Enclave Manager-Zugriffstoken mit dem IAM-Authentifizierungstoken unter Verwendung der folgenden curl-Anforderung ab:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. Erstellen Sie eine Whitelist-Anforderung an Enclave Manager. Stellen Sie sicher, dass Sie Ihre Informationen eingeben, wenn Sie den folgenden Befehl ausführen.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. Verwenden Sie die grafische Enclave Manager-Benutzerschnittstelle, um Whitelist-Anfragen zu genehmigen oder zu verweigern. Im Abschnitt **Builds** der grafischen Benutzerschnittstelle können Sie mit in Whitelist aufgeführte Builds verfolgen und verwalten.



### IBM Cloud Data Shield-Container bereitstellen

Nachdem Sie Ihre Bilder konvertiert haben, müssen Sie Ihre IBM Cloud Data Shield-Container erneut in Ihren Kubernetes-Cluster implementieren.
{: shortdesc}

Wenn Sie IBM Cloud Data Shield-Container in Ihrem Kubernetes-Cluster implementieren, muss die Containerspezifikation Datenträgermounts enthalten. Die Datenträgermounts ermöglichen es, dass die SGX-Einheiten und der AESM-Socket im Container verfügbar sind.

1. Speichern Sie die folgende Pod-Spezifikation als Vorlage.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. Aktualisieren Sie die Felder `your-app-sgx` und `your-registry-server` entsprechend Ihrer App und Ihrem Server.

3. Erstellen Sie das Kubernetes-Pod.

   ```
   kubectl create -f template.yml
   ```

Sie haben keine Anwendung, um den Service zu testen? Kein Problem. Wir bieten verschiedene Beispielapps an, die Sie ausprobieren können, einschließlich MariaDB und NGINX. Jedes der ["datashield"-Images](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter) in IBM Container Registry kann als Beispiel verwendet werden.



## Auf die grafische Benutzerschnittstelle von Enclave Manager zugreifen

Sie können eine Übersicht über alle Ihre Anwendungen anzeigen, die in einer IBM Cloud Data Shield-Umgebung ausgeführt werden, indem Sie die grafische Benutzerschnittstelle von Enclave Manager verwenden. In der Enclave Manager-Konsole können Sie die Knoten in Ihrem Cluster anzeigen, deren Attestierungsstatus, die Tasks und ein Auditprotokoll von Clusterereignissen. Sie können auch Whitelist-Anforderungen genehmigen und verweigern.

Gehen Sie wie folgt vor, um die grafische Benutzerschnittstelle aufzurufen:

1. Melden Sie sich bei IBM Cloud an, und legen Sie den Kontext für Ihren Cluster fest.

2. Überprüfen Sie, ob der gesamte Service ausgeführt wird, indem Sie bestätigen, dass alle Ihre Pods in einem *aktiven* Status sind.

  ```
  kubectl get pods
  ```

3. Führen Sie den folgenden Befehl aus, um die Frontend-URL für Ihre Instanz von Enclave Manager zu suchen.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Fordern Sie Ihre Ingress-Unterdomäne an.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. Geben Sie in einem Browser die Unterdomäne "Ingress" ein, in der Enclave Manager verfügbar ist.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. Rufen Sie im Terminal Ihr IAM-Token ab.

  ```
  ibmcloud iam oauth-tokens
  ```

7. Kopieren Sie das Token, und fügen Sie es in die grafische Benutzerschnittstelle von Enclave Manager ein. Sie müssen den Abschnitt `Bearer` des gedruckten Tokens nicht kopieren.

8. Klicken Sie auf **Melden Sie sich an**.

Informationen zu den Rollen, die ein Benutzer für verschiedene Aktionen ausführen muss, finden Sie im Abschnitt [Rollen für Enclave Manager-Benutzer festlegen](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles).

## Vordefinierte abgeschirmte Images verwenden

Das IBM Cloud Data Shield-Team hat vier verschiedene produktionsbereite Images zusammengestellt, die in IBM Cloud Data Shield-Umgebungen ausgeführt werden können. Sie können die folgenden Images ausprobieren:

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## Deinstallation und Fehlerbehebung

Wenn beim Arbeiten mit IBM Cloud Data Shield ein Problem auftritt, lesen Sie die Abschnitte [Fehlerbehebung](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting) oder [Häufig gestellte Fragen](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq) in der Dokumentation. Wenn Sie Ihre Frage oder die Lösung für Ihr Problem nicht finden, wenden Sie sich an den [IBM Support](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).

Wenn Sie IBM Cloud Data Shield nicht mehr verwenden müssen, können Sie [den Service löschen und die erstellten TLS-Zertifikate löschen](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall).

