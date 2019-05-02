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

# Installieren
{: #deploying}

Sie können {{site.data.keyword.datashield_full}} entweder mit Hilfe des bereitgestellten Helms-Diagramms oder mithilfe des bereitgestellten Installationsprogramms installieren. Sie können mit den Installationsbefehlen arbeiten, mit denen Sie sich am wohlsten fühlen.
{: shortdesc}

## Vorbemerkungen
{: #begin}

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

* Eine Instanz der [cert-manager](https://cert-manager.readthedocs.io/en/latest/)-Serviceversion 0.5.0 oder höher. Wenn Sie eine Instanz mit Helm installieren möchten, können Sie den folgenden Befehl ausführen.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Optional: Kubernetes-Namensbereich erstellen
{: #create-namespace}

Standardmäßig wird {{site.data.keyword.datashield_short}} im Namensbereich `kube-system` installiert. Optional können Sie einen alternativen Namensbereich verwenden, indem Sie einen neuen Namensbereich erstellen.
{: shortdesc}


1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
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

  2. Kopieren Sie die Ausgabe und fügen Sie sie in Ihr Terminal ein.

3. Erstellen Sie einen Namensbereich.

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. Kopieren Sie alle relevanten geheimen Schlüssel aus dem Standardnamensbereich in Ihren neuen Namensbereich.

  1. Listen Sie Ihre verfügbaren geheimen Schlüssel auf.

    ```
    kubectl get secrets
    ```
    {: pre}

    Alle geheimen Schlüssel, die mit `bluemix*` beginnen, müssen kopiert werden.
    {: tip}

  2. Kopieren Sie nacheinander jeweils einen geheimen Schlüssel.

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. Überprüfen Sie, dass Ihre geheimen Schlüssel kopiert wurden.

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. Erstellen Sie ein Servicekonto. Um alle Ihre Anpassungsoptionen anzuzeigen, informieren Sie sich auf der [RBAC-Seite im Helm-GitHub-Repository](https://github.com/helm/helm/blob/master/docs/rbac.md).

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. Generieren Sie Zertifikate und aktivieren Sie Helm mit TLS, indem Sie die Anweisungen im [Tiller SSL GitHub-Repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md) befolgen. Stellen Sie sicher, dass der von Ihnen erstellte Namensbereich angegeben ist.

Ausgezeichnet! Jetzt können Sie {{site.data.keyword.datashield_short}} in Ihren neuen Namensbereich installieren. Stellen Sie hier sicher, dass Sie jedem Helm-Befehl, den Sie ausführen, `--tiller-namespace <namespace_name>` hinzufügen.


## Mit einem Helm-Diagramm installieren
{: #install-chart}

Sie können das bereitgestellte Helm-Diagramm verwenden, um {{site.data.keyword.datashield_short}} auf Ihrem SGX-fähigen Bare-Metal-Cluster zu installieren.
{: shortdesc}

Das Helm-Diagramm installiert die folgenden Komponenten:

*	Die unterstützende Software für SGX, die auf den Bare-Metal-Hosts von einem privilegierten Container installiert wird.
*	Der {{site.data.keyword.datashield_short}} Enclave Manager, der die SGX-Enklaven in der {{site.data.keyword.datashield_short}}-Umgebung verwaltet.
*	Der EnclaveOS®-Container-Konvertierungsservice, mit dem containerisierte Anwendungen in der {{site.data.keyword.datashield_short}}-Umgebung ausgeführt werden können.


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

  Wenn Sie [eine Instanz von {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) für Ihren Converter konfiguriert haben, müssen Sie Folgendes hinzufügen: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Um den Start Ihrer Komponenten zu überwachen, können Sie den folgenden Befehl ausführen.

  ```
  kubectl get pods
  ```
  {: pre}



## Installation mit dem {{site.data.keyword.datashield_short}}-Installationsprogramm
{: #installer}

Sie können das Installationsprogramm verwenden, um {{site.data.keyword.datashield_short}} auf Ihrem SGX-fähigen Bare-Metal-Cluster schnell zu installieren.
{: shortdesc}

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Legen Sie den Kontext für Ihren Cluster fest.

  1. Rufen Sie den Befehl ab, um die Umgebungsvariable festzulegen, und laden Sie die Kubernetes-Konfigurationsdateien herunter.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Kopieren Sie die Ausgabe und fügen Sie sie in Ihr Terminal ein.

3. Melden Sie sich bei der Container Registry-CLI an.

  ```
  ibmcloud cr login
  ```
  {: pre}

4. Extrahieren Sie das Image auf Ihrer lokalen Maschine.

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: pre}

5. Installieren Sie {{site.data.keyword.datashield_short}}, indem Sie den folgenden Befehl ausführen.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Wenn Sie die aktuellste Version von {{site.data.keyword.datashield_short}} installieren möchten, verwenden Sie `latest` für das Flag `--version`.


## Service aktualisieren
{: #update}

Wenn {{site.data.keyword.datashield_short}} in Ihrem Cluster installiert ist, können Sie jederzeit eine Aktualisierung durchführen.

Führen Sie den folgenden Befehl aus, um die aktuellste Version mit dem Helm-Diagramm zu aktualisieren.

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: pre}


Führen Sie den folgenden Befehl aus, um die aktuellste Version mit dem Installationsprogramm zu aktualisieren:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Wenn Sie die aktuellste Version von {{site.data.keyword.datashield_short}} installieren möchten, verwenden Sie `latest` für das Flag `--version`.

