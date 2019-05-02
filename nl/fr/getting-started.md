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

# Tutoriel d'initiation
{: #getting-started}

{{site.data.keyword.datashield_full}} optimisé par Fortanix® vous permet de protéger les données des charges de travail de vos conteneurs qui s'exécutent sur {{site.data.keyword.cloud_notm}} lorsque vos données de trouvent en cours d'utilisation.
{: shortdesc}

Pour en savoir plus sur {{site.data.keyword.datashield_short}}, et sur ce que cela signifie de protéger vos données en cours d'utilisation, consultez [A propos du service](/docs/services/data-shield?topic=data-shield-about#about).

## Avant de commencer
{: #gs-begin}

Avant de commencer à utiliser {{site.data.keyword.datashield_short}}, vérifiez que vous possédez les composants requis répertoriés ci-dessous. Pour obtenir de l'aide lors du téléchargement des interfaces de ligne de commande et des plug-ins ou lors de la configuration de votre environnement Kubernetes Service, consultez le tutoriel [Création de clusters Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Les interfaces de ligne de commande suivantes :

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  Si vous le souhaitez, vous pouvez configurer Helm pour utiliser le mode `--tls`. Pour obtenir de l'aide pour activer TLS, consultez le [référentiel Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Si vous activez TLS, assurez-vous d'ajouter `--tls` à chaque commande Helm que vous exécutez.
  {: tip}

* Les [plug-ins d'interface de ligne de commande {{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) suivants :

  * Kubernetes Service
  * Container Registry

* Un cluster Kubernetes compatible SGX. Actuellement, SGX peut être activé sur un cluster bare metal avec le type de noeud mb2c.4x32. Si vous n'en avez pas, vous pouvez utiliser la procédure suivante pour être sûr de créer le cluster dont vous avez besoin.
  1. Préparez-vous pour la [création de votre cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Vérifiez que vous disposez des [droits requis](/docs/containers?topic=containers-users#users) pour créer un cluster.

  3. Créez le [cluster](/docs/containers?topic=containers-clusters#clusters).

* Une instance du service [cert-manager](https://cert-manager.readthedocs.io/en/latest/) de version 0.5.0 ou plus récente. L'installation par défaut utilise <code>cert-manager</code> pour configurer les [certificats TLS](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates) pour la communication interne entre les services d'{{site.data.keyword.datashield_short}}. Pour installer une instance à l'aide de la charte Helm, vous pouvez exécuter la commande suivante.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Installation avec une charte Helm
{: #gs-install-chart}

Vous pouvez utiliser la charte Helm fournie pour installer {{site.data.keyword.datashield_short}} sur votre cluster bare metal compatible SGX.
{: shortdesc}

La charte Helm installe les composants suivants :

*	Le logiciel de prise en charge de SGX, qui est installé sur les hôtes bare metal par un conteneur privilégié.
*	La console Enclave Manager d'{{site.data.keyword.datashield_short}}, qui gère les enclaves SGX dans l'environnement {{site.data.keyword.datashield_short}}.
*	Le service de conversion des conteneurs EnclaveOS®, qui permet aux applications conteneurisées de s'exécuter dans l'environnement {{site.data.keyword.datashield_short}}.

Lorsque vous installez une charte Helm, vous disposez de plusieurs options et paramètres pour personnaliser votre installation. Le tutoriel suivant vous guide à travers l'installation de base de la charte, qui est configurée par défaut. Pour en savoir plus sur vos options, voir [Installation d'{{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-deploying).
{: tip}

Pour installer {{site.data.keyword.datashield_short}} sur votre cluster :

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
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

  2. Copiez la sortie commençant par `export` et collez-la dans votre terminal pour définir la variable d'environnement `KUBECONFIG`.

3. Si vous ne l'avez pas déjà fait, ajoutez le référentiel `ibm`.

  ```
  helm repo add ibm  https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. Facultatif : si vous ne connaissez pas l'e-mail qui est associé à l'administrateur ou l'ID de compte administrateur, exécutez la commande suivante.

  ```
  ibmcloud account show
  ```
  {: pre}

5. Obtenez le sous-domaine Ingress correspondant à votre cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. Installez la charte.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  Si vous avez [configuré un registre {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) pour votre convertisseur, vous pouvez ajouter l'option suivante : `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. Pour surveiller le démarrage de vos composants, exécutez la commande suivante.

  ```
  kubectl get pods
  ```
  {: pre}


## Etapes suivantes
{: #gs-next}

Félicitations ! Maintenant que le service est installé sur votre cluster, vous pouvez exécuter vos applications dans l'environnement {{site.data.keyword.datashield_short}}. 

Pour exécuter vos applications dans un environnement {{site.data.keyword.datashield_short}}, vous devez [convertir ](/docs/services/data-shield?topic=data-shield-convert#convert), [mettre sur liste blanche](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist), puis [déployer](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers) votre image de conteneur.

Si vous ne disposez pas d'une image propre, essayez de déployer l'une des images prépackagées d'{{site.data.keyword.datashield_short}} :

* [Exemples de référentiels GitHub dans {{site.data.keyword.datashield_short}}](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* MariaDB ou NGINX dans {{site.data.keyword.cloud_notm}} Container Registry
