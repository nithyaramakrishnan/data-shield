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

# Deinstallieren
{: #uninstall}

Wenn Sie {{site.data.keyword.datashield_full}} nicht mehr verwenden müssen, können Sie den Service und die TLS-Zertifikate löschen, die erstellt wurden.


## Deinstallieren mit Helm

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

3. Löschen Sie den Service.

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. Löschen Sie die TLS-Zertifikate, indem Sie jeden der folgenden Befehle ausführen.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. Der Deinstallationsprozess verwendet Helm "Hooks", um ein Deinstallationsprogramm auszuführen. Sie können das Deinstallationsprogramm nach der Ausführung löschen.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

Sie können auch die Instanz `cert-manager` sowie den geheimen Docker-Konfigurationsschlüssel, wenn Sie einen erstellt haben, löschen.
{: tip}



## Deinstallieren mit dem Beta-Installationsprogramm
{: #uninstall-installer}

Wenn Sie {{site.data.keyword.datashield_short}} mit dem Beta-Installationsprogramm installiert haben, können Sie den Service auch mit dem Installationsprogramm deinstallieren.

Um {{site.data.keyword.datashield_short}} zu deinstallieren, melden Sie sich an der `ibmcloud`-CLI an, geben Sie Ihren Cluster als Ziel an und führen Sie den folgenden Befehl aus:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
