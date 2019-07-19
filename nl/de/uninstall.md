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

# Deinstallieren
{: #uninstall}

Wenn Sie {{site.data.keyword.datashield_full}} nicht mehr verwenden müssen, können Sie den Service und die TLS-Zertifikate löschen, die erstellt wurden.


## Deinstallieren mit Helm
{: #uninstall-helm}

1. Melden Sie sich bei der {{site.data.keyword.cloud_notm}}-Befehlszeilenschnittstelle (CLI) an. Folgen Sie den Eingabeaufforderungen in der Befehlszeilenschnittstelle, um die Anmeldung abzuschließen. Wenn Sie über eine eingebundene ID verfügen, hängen Sie die Option `-- sso` an das Ende des Befehls an.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>{{site.data.keyword.cloud_notm}}-Endpunkt</th>
      <th>{{site.data.keyword.containershort_notm}}-Region</th>
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
    {: codeblock}

  2. Kopieren Sie die Ausgabe und fügen Sie sie in Ihre Konsole ein.

3. Löschen Sie den Service.

  ```
  helm delete <chart-name> --purge
  ```
  {: codeblock}

4. Löschen Sie die TLS-Zertifikate, indem Sie jeden der folgenden Befehle ausführen.

  ```
  kubectl delete secret <chart-name>-enclaveos-converter-tls
  kubectl delete secret <chart-name>-enclaveos-frontend-tls
  kubectl delete secret <chart-name>-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. Der Deinstallationsprozess verwendet Helm "Hooks", um ein Deinstallationsprogramm auszuführen. Sie können das Deinstallationsprogramm nach der Ausführung löschen.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

Sie können auch die Instanz `cert-manager` sowie den geheimen Docker-Konfigurationsschlüssel, wenn Sie einen erstellt haben, löschen.
{: tip}


## Deinstallation mit dem Installationsprogramm
{: #uninstall-installer}

Wenn Sie {{site.data.keyword.datashield_short}} mit dem Installationsprogramm installiert haben, können Sie den Service auch mit dem Installationsprogramm deinstallieren.

Um {{site.data.keyword.datashield_short}} zu deinstallieren, melden Sie sich an der `ibmcloud`-CLI an, geben Sie Ihren Cluster als Ziel an und führen Sie den folgenden Befehl aus:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

