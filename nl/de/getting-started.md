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

# Lernprogramm zur Einführung
{: #getting-started}

Mit {{site.data.keyword.datashield_full}}, das von Fortanix® unterstützt wird, können Sie die Daten in Ihren Containerworkloads schützen, die auf {{site.data.keyword.cloud_notm}} ausgeführt werden, während Ihre Daten im Gebrauch sind.
{: shortdesc}

Weitere Informationen zu {{site.data.keyword.datashield_short}} und zum Schutz Ihrer Daten in Gebrauch können Sie in [Informationen zum Service](/docs/services/data-shield?topic=data-shield-about#about) erfahren.

## Vorbemerkungen
{: #gs-begin}

Bevor Sie mit der Arbeit mit {{site.data.keyword.datashield_short}} beginnen können, müssen Sie die folgenden Voraussetzungen erfüllen. Hilfe zum Herunterladen der CLIs und Plug-ins oder zum Konfigurieren Ihrer Kubernetes Service-Umgebung finden Sie im Lernprogramm [Kubernetes-Cluster erstellen](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Die folgenden CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  Möglicherweise möchten Sie Helm so konfigurieren, dass der Modus `--tls` verwendet wird. Hilfe zum Aktivieren von TLS-Check-out für das [Helm-Repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Wenn Sie TLS aktivieren, müssen Sie sicherstellen, dass `--tls` an jeden Steuerbefehl angehängt wird, den Sie ausführen.
  {: tip}

* Die folgenden [{{site.data.keyword.cloud_notm}}-CLI-Plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes Service
  * Container Registry

* Ein SGX-fähiger Kubernetes-Cluster. Derzeit kann SGX auf einem Bare-Metal-Cluster mit dem Knotentyp mb2c.4x32 aktiviert werden. Wenn keiner vorhanden ist, können Sie die folgenden Schritte ausführen, um sicherzustellen, dass Sie den benötigten Cluster erstellen.
  1. Bereiten Sie die [Erstellung des Clusters](/docs/containers?topic=containers-clusters#cluster_prepare) vor.

  2. Stellen Sie sicher, dass Sie über die [erforderlichen Berechtigungen](/docs/containers?topic=containers-users#users) verfügen, um einen Cluster zu erstellen.

  3. Erstellen Sie den [Cluster](/docs/containers?topic=containers-clusters#clusters).

* Eine Instanz der [cert-manager](https://cert-manager.readthedocs.io/en/latest/)-Serviceversion 0.5.0 oder höher. Die Standardinstallation verwendet <code>cert-manager</code>, um [TLS-Zertifikate](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates) für die interne Kommunikation zwischen den {{site.data.keyword.datashield_short}}-Services einzurichten. Wenn Sie eine Instanz mit Helm installieren möchten, können Sie den folgenden Befehl ausführen.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Mit einem Helm-Diagramm installieren
{: #gs-install-chart}

Sie können das bereitgestellte Helm-Diagramm verwenden, um {{site.data.keyword.datashield_short}} auf Ihrem SGX-fähigen Bare-Metal-Cluster zu installieren.
{: shortdesc}

Das Helm-Diagramm installiert die folgenden Komponenten:

*	Die unterstützende Software für SGX, die auf den Bare-Metal-Hosts von einem privilegierten Container installiert wird.
*	Der {{site.data.keyword.datashield_short}} Enclave Manager, der die SGX-Enklaven in der {{site.data.keyword.datashield_short}}-Umgebung verwaltet.
*	Der EnclaveOS®-Container-Konvertierungsservice, mit dem containerisierte Anwendungen in der {{site.data.keyword.datashield_short}}-Umgebung ausgeführt werden können.

Wenn Sie ein Helm-Diagramm installieren, stehen Ihnen mehrere Optionen und Parameter zur Verfügung, um Ihre Installation anzupassen. Das folgende Lernprogramm führt Sie durch die grundlegendste Standardinstallation des Diagramms. Weitere Informationen zu Ihren Optionen finden Sie unter [{{site.data.keyword.datashield_short}} installieren](/docs/services/data-shield?topic=data-shield-deploying).
{: tip}

Gehen Sie wie folgt vor, um {{site.data.keyword.datashield_short}} in Ihrem Cluster zu installieren:

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

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

2. Legen Sie den Kontext für Ihren Cluster fest.

  1. Rufen Sie den Befehl ab, um die Umgebungsvariable festzulegen, und laden Sie die Kubernetes-Konfigurationsdateien herunter.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Kopieren Sie die Ausgabe, die mit `export` beginnt, und fügen Sie sie in Ihr Terminal ein, um die Umgebungsvariable `KUBECONFIG` festzulegen.

3. Wenn Sie dies noch nicht getan haben, fügen Sie das `ibm`-Repository hinzu.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. Optional: Wenn Sie die E-Mail nicht kennen, die dem Administrator oder der Administratorkonto-ID zugeordnet ist, führen Sie den folgenden Befehl aus.

  ```
  ibmcloud account show
  ```
  {: pre}

5. Rufen Sie die Ingress-Unterdomäne für Ihren Cluster ab.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. Installieren Sie das Diagramm.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  Wenn Sie [eine Instanz von {{site.data.keyword.cloud_notm}}Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) für Ihren Converter konfiguriert haben, können Sie die folgende Option hinzufügen: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. Um den Start Ihrer Komponenten zu überwachen, können Sie den folgenden Befehl ausführen.

  ```
  kubectl get pods
  ```
  {: pre}


## Nächste Schritte
{: #gs-next}

Großartiger Job! Nachdem der Service in Ihrem Cluster installiert ist, können Sie Ihre Apps in der {{site.data.keyword.datashield_short}}-Umgebung ausführen. 

Wenn Sie Ihre Apps in einer {{site.data.keyword.datashield_short}}-Umgebung ausführen möchten, müssen Sie [convert](/docs/services/data-shield?topic=data-shield-convert#convert), [whitelist](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist) und anschließend [deploy](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers) für das Container-Image verwenden.

Wenn Sie nicht über ein eigenes Image zur Bereitstellung verfügen, versuchen Sie, eines der vordefinierten {{site.data.keyword.datashield_short}}-Images bereitzustellen:

* [{{site.data.keyword.datashield_short}}-Beispiele GitHub-Repo](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* MariaDB oder NGINX in {{site.data.keyword.cloud_notm}} Container Registry
