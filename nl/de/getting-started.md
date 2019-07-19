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

# Lernprogramm zur Einführung
{: #getting-started}

Mit {{site.data.keyword.datashield_full}}, das von Fortanix® unterstützt wird, können Sie die Daten in Ihren Containerworkloads schützen, die auf {{site.data.keyword.cloud_notm}} ausgeführt werden, während Ihre Daten im Gebrauch sind.
{: shortdesc}

Weitere Informationen zu {{site.data.keyword.datashield_short}} und zum Schutz Ihrer Daten in Gebrauch können Sie in [Informationen zum Service](/docs/services/data-shield?topic=data-shield-about) erfahren.

## Vorbemerkungen
{: #gs-begin}

Bevor Sie mit der Arbeit mit {{site.data.keyword.datashield_short}} beginnen können, müssen Sie die folgenden Voraussetzungen erfüllen.

Hilfe zum Herunterladen der CLIs oder zum Konfigurieren Ihrer {{site.data.keyword.containershort}}-Umgebung finden Sie im Lernprogramm [Kubernetes-Cluster erstellen](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).
{: tip}

* Die folgenden CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* Die folgenden [-CLI-Plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins):

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}

* Ein SGX-fähiger Kubernetes-Cluster. Derzeit kann SGX auf einem Bare-Metal-Cluster mit dem Knotentyp mb2c.4x32 aktiviert werden. Wenn keiner vorhanden ist, können Sie die folgenden Schritte ausführen, um sicherzustellen, dass Sie den benötigten Cluster erstellen.
  1. Bereiten Sie die [Erstellung des Clusters](/docs/containers?topic=containers-clusters#cluster_prepare) vor.

  2. Stellen Sie sicher, dass Sie über die [erforderlichen Berechtigungen](/docs/containers?topic=containers-users) verfügen, um einen Cluster zu erstellen.

  3. Erstellen Sie den [Cluster](/docs/containers?topic=containers-clusters).

* Eine Instanz der [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external}-Serviceversion 0.5.0 oder höher. Die Standardinstallation verwendet <code>cert-manager</code>, um [TLS-Zertifikate](/docs/services/data-shield?topic=data-shield-tls-certificates) für die interne Kommunikation zwischen den {{site.data.keyword.datashield_short}}-Services einzurichten. Wenn Sie eine Instanz mit Helm installieren möchten, können Sie den folgenden Befehl ausführen.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Möchten Sie die Protokollinformationen für Data Shield anzeigen? Richten Sie hierfür eine {{site.data.keyword.la_full_notm}}-Instanz für Ihren Cluster ein.
{: tip}

## Service installieren
{: #gs-install}

Sie können das bereitgestellte Helm-Diagramm verwenden, um {{site.data.keyword.datashield_short}} auf Ihrem SGX-fähigen Bare-Metal-Cluster zu installieren.
{: shortdesc}

Das Helm-Diagramm installiert die folgenden Komponenten:

*	Die unterstützende Software für SGX, die auf den Bare-Metal-Hosts von einem privilegierten Container installiert wird.
*	Der {{site.data.keyword.datashield_short}} Enclave Manager, der die SGX-Enklaven in der {{site.data.keyword.datashield_short}}-Umgebung verwaltet.
*	Der EnclaveOS®-Container-Konvertierungsservice, mit dem containerisierte Anwendungen in der {{site.data.keyword.datashield_short}}-Umgebung ausgeführt werden können.


Führen Sie die folgenden Schritte aus, um {{site.data.keyword.datashield_short}} in Ihrem Cluster zu installieren.

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

  2. Kopieren Sie die Ausgabe, die mit `export` beginnt, und fügen Sie sie in Ihre Konsole ein, um die Umgebungsvariable `KUBECONFIG` festzulegen.

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

6. Initialisieren Sie Helm, indem Sie eine Rollenbindungsrichtlinie für Tiller erstellen. 

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

  Möglicherweise möchten Sie Helm so konfigurieren, dass der Modus `--tls` verwendet wird. Hilfe zum Aktivieren von TLS-Check-out für das [Helm-Repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}. Wenn Sie TLS aktivieren, müssen Sie sicherstellen, dass `--tls` an jeden Steuerbefehl angehängt wird, den Sie ausführen. Weitere Informationen zur Verwendung von Helm mit dem Kubernetes-Service von IBM Cloud finden Sie unter [Services unter Verwendung von Helm-Diagrammen hinzufügen](/docs/containers?topic=containers-helm#public_helm_install).
{: tip}

7. Installieren Sie das Diagramm.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Wenn Sie [eine Instanz von {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) für Ihren Converter konfiguriert haben, müssen Sie Folgendes hinzufügen: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Um den Start Ihrer Komponenten zu überwachen, können Sie den folgenden Befehl ausführen.

  ```
  kubectl get pods
  ```
  {: codeblock}

## Nächste Schritte
{: #gs-next}

Nachdem der Service in Ihrem Cluster installiert ist, kann es mit dem Schutz Ihrer Daten losgehen! Als Nächstes können Sie versuchen, Ihre Anwendungen [zu konvertieren](/docs/services/data-shield?topic=data-shield-convert) und [bereitzustellen](/docs/services/data-shield?topic=data-shield-deploying). 

Wenn Sie nicht über ein eigenes Image zur Bereitstellung verfügen, versuchen Sie, eines der vordefinierten {{site.data.keyword.datashield_short}}-Images bereitzustellen:

* [-Beispiele GitHub-Repo](https://github.com/fortanix/data-shield-examples/tree/master/ewallet){: external}
* Container-Registry: [Barbican-Image](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter), [MariaDB-Image](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter), [NGINX-Image](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter) oder [Vault-Image](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter).


