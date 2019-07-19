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

# Installieren
{: #install}

Sie können {{site.data.keyword.datashield_full}} entweder mit Hilfe des bereitgestellten Helms-Diagramms oder mithilfe des bereitgestellten Installationsprogramms installieren. Sie können mit den Installationsbefehlen arbeiten, die Ihnen am meisten zusagen.
{: shortdesc}

## Vorbemerkungen
{: #begin}

Bevor Sie mit der Arbeit mit {{site.data.keyword.datashield_short}} beginnen können, müssen Sie die folgenden Voraussetzungen erfüllen. Hilfe zum Herunterladen der CLIs und Plug-ins oder zum Konfigurieren Ihrer Kubernetes Service-Umgebung finden Sie im Lernprogramm [Kubernetes-Cluster erstellen](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Die folgenden CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* Die folgenden [{{site.data.keyword.cloud_notm}}-CLI-Plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* Ein SGX-fähiger Kubernetes-Cluster. Derzeit kann SGX auf einem Bare-Metal-Cluster mit dem Knotentyp mb2c.4x32 aktiviert werden. Wenn keiner vorhanden ist, können Sie die folgenden Schritte ausführen, um sicherzustellen, dass Sie den benötigten Cluster erstellen.
  1. Bereiten Sie die [Erstellung des Clusters](/docs/containers?topic=containers-clusters#cluster_prepare) vor.

  2. Stellen Sie sicher, dass Sie über die [erforderlichen Berechtigungen](/docs/containers?topic=containers-users) verfügen, um einen Cluster zu erstellen.

  3. Erstellen Sie den [Cluster](/docs/containers?topic=containers-clusters).

* Eine Instanz der [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external}-Serviceversion 0.5.0 oder höher. Wenn Sie eine Instanz mit Helm installieren möchten, können Sie den folgenden Befehl ausführen.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Möchten Sie die Protokollinformationen für Data Shield anzeigen? Richten Sie hierfür eine {{site.data.keyword.la_full_notm}}-Instanz für Ihren Cluster ein.
{: tip}


## Installation mit Helm
{: #install-chart}

Sie können das bereitgestellte Helm-Diagramm verwenden, um {{site.data.keyword.datashield_short}} auf Ihrem SGX-fähigen Bare-Metal-Cluster zu installieren.
{: shortdesc}

Das Helm-Diagramm installiert die folgenden Komponenten:

*	Die unterstützende Software für SGX, die auf den Bare-Metal-Hosts von einem privilegierten Container installiert wird.
*	Der {{site.data.keyword.datashield_short}} Enclave Manager, der die SGX-Enklaven in der {{site.data.keyword.datashield_short}}-Umgebung verwaltet.
*	Der EnclaveOS®-Container-Konvertierungsservice, mit dem containerisierte Anwendungen in der {{site.data.keyword.datashield_short}}-Umgebung ausgeführt werden können.


Gehen Sie wie folgt vor, um {{site.data.keyword.datashield_short}} in Ihrem Cluster zu installieren:

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen. Wenn Sie über eine eingebundene ID verfügen, hängen Sie die Option `-- sso` an das Ende des Befehls an.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Legen Sie den Kontext für Ihren Cluster fest.

  1. Rufen Sie den Befehl ab, um die Umgebungsvariable festzulegen, und laden Sie die Kubernetes-Konfigurationsdateien herunter.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Kopieren Sie die Ausgabe, die mit `export` beginnt, und fügen Sie sie in Ihr Terminal ein, um die Umgebungsvariable `KUBECONFIG` festzulegen.

3. Wenn Sie dies noch nicht getan haben, fügen Sie das Repository `iks-charts` hinzu.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. Optional: Wenn Sie die E-Mail nicht kennen, die dem Administrator oder der Administratorkonto-ID zugeordnet ist, führen Sie den folgenden Befehl aus.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. Rufen Sie die Ingress-Unterdomäne für Ihren Cluster ab.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

6. Rufen Sie die Informationen ab, die Sie zum Einrichten von [Sicherungs- und Wiederherstellungsfunktionen](/docs/services/data-shield?topic=data-shield-backup-restore) benötigen. 

7. Initialisieren Sie Helm, indem Sie eine Rollenbindungsrichtlinie für Tiller erstellen. 

  1. Erstellen Sie ein Servicekonto für Tiller.
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. Erstellen Sie die Rollenbindung, um den Tiller-Administratorzugriff im Cluster zuzuordnen.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Initialisieren Sie Helm.

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  Möglicherweise möchten Sie Helm so konfigurieren, dass der Modus `--tls` verwendet wird. Informationen zur Unterstützung für die Aktivierung von TLS finden Sie im [Helm-Repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}. Wenn Sie TLS aktivieren, müssen Sie sicherstellen, dass `--tls` an jeden Steuerbefehl angehängt wird, den Sie ausführen. Weitere Informationen zur Verwendung von Helm mit dem Kubernetes-Service von IBM Cloud finden Sie unter [Services unter Verwendung von Helm-Diagrammen hinzufügen](/docs/containers?topic=containers-helm#public_helm_install).
  {: tip}

8. Installieren Sie das Diagramm.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Wenn Sie [eine Instanz von {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) für Ihren Converter konfiguriert haben, müssen Sie Folgendes hinzufügen: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

9. Um den Start Ihrer Komponenten zu überwachen, können Sie den folgenden Befehl ausführen.

  ```
  kubectl get pods
  ```
  {: codeblock}



## Installation mit dem Installationsprogramm
{: #installer}

Sie können das Installationsprogramm verwenden, um {{site.data.keyword.datashield_short}} auf Ihrem SGX-fähigen Bare-Metal-Cluster schnell zu installieren.
{: shortdesc}

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. Legen Sie den Kontext für Ihren Cluster fest.

  1. Rufen Sie den Befehl ab, um die Umgebungsvariable festzulegen, und laden Sie die Kubernetes-Konfigurationsdateien herunter.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Kopieren Sie die Ausgabe und fügen Sie sie in Ihre Konsole ein.

3. Melden Sie sich bei der Container Registry-CLI an.

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. Extrahieren Sie das Image auf Ihrem lokalen System.

  ```
  docker pull <region>.icr.io/ibm/datashield-installer
  ```
  {: codeblock}

5. Installieren Sie {{site.data.keyword.datashield_short}}, indem Sie den folgenden Befehl ausführen.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  Wenn Sie die aktuellste Version von {{site.data.keyword.datashield_short}} installieren möchten, verwenden Sie `latest` für das Flag `--version`.

