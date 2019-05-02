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

# Désinstallation
{: #uninstall}

Si vous n'avez plus besoin d'utiliser {{site.data.keyword.datashield_full}}, vous pouvez supprimer le service et les certificats TLS qui ont été créés.


## Désinstallation avec Helm

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: pre}

  <table>
    <tr>
      <th>Région</th>
      <th>Noeud final IBM Cloud</th>
      <th>Région de Kubernetes Service</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>Sud des Etats-Unis</td>
    </tr>
    <tr>
      <td>Francfort</td>
      <td><code>eu-de</code></td>
      <td>Europe centrale</td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
      <td>Asie-Pacifique sud</td>
    </tr>
    <tr>
      <td>Londres</td>
      <td><code>eu-gb</code></td>
      <td>Sud du Royaume-Uni</td>
    </tr>
    <tr>
      <td>Tokyo</td>
      <td><code>jp-tok</code></td>
      <td>Asie-Pacifique nord</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>Est des Etats-Unis</td>
    </tr>
  </table>

2. Définissez le contexte de votre cluster.

  1. Utilisez la commande permettant de définir la variable d'environnement et de télécharger les fichiers de configuration Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copiez la sortie et collez-la dans votre terminal.

3. Supprimez le service.

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. Supprimez les certificats TLS en exécutant chacune des commandes suivantes.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. Le processus de désinstallation utilise les "points d'ancrage" Helm pour exécuter un programme de désinstallation. Vous pouvez supprimer le programme de désinstallation après l'avoir exécuté.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

Si vous le souhaitez, vous pouvez également supprimer l'instance `cert-manager` et le secret de configuration Docker, si vous en avez créé un.
{: tip}



## Désinstallation avec le programme d'installation bêta
{: #uninstall-installer}

Si vous avez installé {{site.data.keyword.datashield_short}} à l'aide du programme d'installation bêta, vous pouvez également désinstaller le service avec le programme d'installation.

Pour désinstaller {{site.data.keyword.datashield_short}}, connectez-vous à l'interface de ligne de commande `ibmcloud`, ciblez votre cluster, et exécutez la commande suivante :

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
