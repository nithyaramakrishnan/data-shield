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

# Installation
{: #deploying}

Vous pouvez installer {{site.data.keyword.datashield_full}} à l'aide de la charte Helm ou du programme d'installation fournis. Vous pouvez utiliser les commandes d'installation avec lesquelles vous vous sentez le plus à l'aise.
{: shortdesc}

## Avant de commencer
{: #begin}

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

* Une instance du service [cert-manager](https://cert-manager.readthedocs.io/en/latest/) de version 0.5.0 ou plus récente. Pour installer l'instance à l'aide d'une charte Helm, exécutez la commande suivante.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Facultatif : Création d'un espace de nom Kubernetes
{: #create-namespace}

Par défaut, {{site.data.keyword.datashield_short}} est installé dans l'espace de nom `kube-system`. Vous pouvez également utiliser un espace de nom alternatif en le créant.
{: shortdesc}


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

3. Créez un espace de nom.

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. Copiez les secrets pertinents de l'espace de nom par défaut vers votre nouvel espace de nom.

  1. Affichez une liste de vos secrets disponibles.

    ```
    kubectl get secrets
    ```
    {: pre}

    Tous les secrets commençant par `bluemix*` doivent être copiés.
    {: tip}

  2. Copiez les secrets un par un.

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. Vérifiez que vos secrets ont été copiés.

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. Créez un compte de service. Pour voir toutes vos options de personnalisation, consultez la [page RBAC dans le référentiel GitHub de la charte Helm](https://github.com/helm/helm/blob/master/docs/rbac.md).

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. Générez les certificats et activez Helm avec TLS en suivant les instructions du [référentiel GitHub Tiller SSL](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Veillez à spécifier l'espace de nom que vous avez créé.

Et voilà ! Vous êtes maintenant prêt à installer {{site.data.keyword.datashield_short}} dans votre nouvel espace de nom. A partir de maintenant, assurez-vous d'ajouter `--tiller-namespace <namespace_name>` à toutes les commandes Helm que vous exécutez.


## Installation avec une charte Helm
{: #install-chart}

Vous pouvez utiliser la charte Helm fournie pour installer {{site.data.keyword.datashield_short}} sur votre cluster bare metal compatible SGX.
{: shortdesc}

La charte Helm installe les composants suivants :

*	Le logiciel de prise en charge de SGX, qui est installé sur les hôtes bare metal par un conteneur privilégié.
*	La console Enclave Manager d'{{site.data.keyword.datashield_short}}, qui gère les enclaves SGX dans l'environnement {{site.data.keyword.datashield_short}}.
*	Le service de conversion des conteneurs EnclaveOS®, qui permet aux applications conteneurisées de s'exécuter dans l'environnement {{site.data.keyword.datashield_short}}.


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

  Si vous avez [configuré un registre {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) pour votre convertisseur, vous devez ajouter `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Pour surveiller le démarrage de vos composants, exécutez la commande suivante.

  ```
  kubectl get pods
  ```
  {: pre}



## Installation avec le programme d'installation {{site.data.keyword.datashield_short}}
{: #installer}

Vous pouvez utiliser le programme d'installation pour installer rapidement {{site.data.keyword.datashield_short}} sur votre cluster bare metal compatible SGX.
{: shortdesc}

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Définissez le contexte de votre cluster.

  1. Utilisez la commande permettant de définir la variable d'environnement et de télécharger les fichiers de configuration Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copiez la sortie et collez-la dans votre terminal.

3. Connectez-vous à l'interface de ligne de commande de Container Registry.

  ```
  ibmcloud cr login
  ```
  {: pre}

4. Extrayez l'image vers votre machine locale.

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: pre}

5. Installez {{site.data.keyword.datashield_short}} en exécutant la commande suivante.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Pour installer la version la plus récente d'{{site.data.keyword.datashield_short}}, utilisez `latest` pour l'indicateur `--version`.


## Mise à jour du service
{: #update}

Lorsque {{site.data.keyword.datashield_short}} est installé sur votre cluster, vous pouvez effectuer une mise à jour à tout moment.

Pour effectuer une mise à jour à la dernière version avec la charte, exécutez la commande suivante.

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: pre}


Pour effectuer une mise à jour à la dernière version avec le programme d'installation, exécutez la commande suivante :

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  Pour installer la version la plus récente d'{{site.data.keyword.datashield_short}}, utilisez `latest` pour l'indicateur `--version`.

