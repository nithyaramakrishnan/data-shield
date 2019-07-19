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

# Installation
{: #install}

Vous pouvez installer {{site.data.keyword.datashield_full}} à l'aide de la charte Helm ou du programme d'installation fournis. Vous pouvez utiliser les commandes d'installation avec lesquelles vous vous sentez le plus à l'aise.
{: shortdesc}

## Avant de commencer
{: #begin}

Avant de commencer à utiliser {{site.data.keyword.datashield_short}}, vérifiez que vous possédez les composants requis répertoriés ci-dessous. Pour obtenir de l'aide lors du téléchargement des interfaces de ligne de commande et des plug-ins ou lors de la configuration de votre environnement Kubernetes Service, consultez le tutoriel [Création de clusters Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Les interfaces de ligne de commande suivantes :

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* Les [plug-ins d'interface de ligne de commande {{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) suivants :

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* Un cluster Kubernetes compatible SGX. Actuellement, SGX peut être activé sur un cluster bare metal avec le type de noeud mb2c.4x32. Si vous n'en avez pas, vous pouvez utiliser la procédure suivante pour être sûr de créer le cluster dont vous avez besoin.
  1. Préparez-vous pour la [création de votre cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Vérifiez que vous disposez des [droits requis](/docs/containers?topic=containers-users) pour créer un cluster.

  3. Créez le [cluster](/docs/containers?topic=containers-clusters).

* Une instance du service [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} de version 0.5.0 ou plus récente. Pour installer l'instance à l'aide d'une charte Helm, exécutez la commande suivante.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Vous souhaitez voir les informations de consignation pour Data Shield ? Configurez une instance {{site.data.keyword.la_full_notm}} pour votre cluster.
{: tip}


## Installation avec Helm
{: #install-chart}

Vous pouvez utiliser la charte Helm fournie pour installer {{site.data.keyword.datashield_short}} sur votre cluster bare metal compatible SGX.
{: shortdesc}

La charte Helm installe les composants suivants :

*	Le logiciel de prise en charge de SGX, qui est installé sur les hôtes bare metal par un conteneur privilégié.
*	La console Enclave Manager d'{{site.data.keyword.datashield_short}}, qui gère les enclaves SGX dans l'environnement {{site.data.keyword.datashield_short}}.
*	Le service de conversion des conteneurs EnclaveOS®, qui permet aux applications conteneurisées de s'exécuter dans l'environnement {{site.data.keyword.datashield_short}}.


Pour installer {{site.data.keyword.datashield_short}} sur votre cluster :

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion. Si vous disposez d'un ID fédéré, ajoutez l'option `--sso` à la fin de la commande.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Définissez le contexte de votre cluster.

  1. Utilisez la commande permettant de définir la variable d'environnement et de télécharger les fichiers de configuration Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copiez la sortie commençant par `export` et collez-la dans votre terminal pour définir la variable d'environnement `KUBECONFIG`.

3. Si vous ne l'avez pas déjà fait, ajoutez le référentiel `iks-charts`.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. Facultatif : si vous ne connaissez pas l'e-mail qui est associé à l'administrateur ou l'ID de compte administrateur, exécutez la commande suivante.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. Obtenez le sous-domaine Ingress correspondant à votre cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

6. Obtenez les informations dont vous avez besoin pour configurer les fonctions de [sauvegarde et restauration](/docs/services/data-shield?topic=data-shield-backup-restore). 

7. Initialisez Helm en créant une politique de liaison de rôle pour Tiller. 

  1. Créez un compte de service pour Tiller.
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. Créez une liaison de rôle pour affecter l'accès administrateur Tiller dans le cluster.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Initialisez Helm.

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  Si vous le souhaitez, vous pouvez configurer Helm pour utiliser le mode `--tls`. Pour obtenir de l'aide pour activer TLS, consultez le [référentiel Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}. Si vous activez TLS, assurez-vous d'ajouter `--tls` à chaque commande Helm que vous exécutez. Pour plus d'informations sur l'utilisation de Helm avec IBM Cloud Kubernetes Service, voir [Ajout de services via les chartes Helm](/docs/containers?topic=containers-helm#public_helm_install).
  {: tip}

8. Installez la charte.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Si vous avez [configuré un registre {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) pour votre convertisseur, vous devez ajouter `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

9. Pour surveiller le démarrage de vos composants, exécutez la commande suivante.

  ```
  kubectl get pods
  ```
  {: codeblock}



## Installation à l'aide du programme d'installation
{: #installer}

Vous pouvez utiliser le programme d'installation pour installer rapidement {{site.data.keyword.datashield_short}} sur votre cluster bare metal compatible SGX.
{: shortdesc}

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. Définissez le contexte de votre cluster.

  1. Utilisez la commande permettant de définir la variable d'environnement et de télécharger les fichiers de configuration Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copiez la sortie et collez-la dans votre console.

3. Connectez-vous à l'interface de ligne de commande de Container Registry.

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. Extrayez l'image vers votre système local.

  ```
  docker pull <region>.icr.io/ibm/datashield-installer
  ```
  {: codeblock}

5. Installez {{site.data.keyword.datashield_short}} en exécutant la commande suivante.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  Pour installer la version la plus récente d'{{site.data.keyword.datashield_short}}, utilisez `latest` pour l'indicateur `--version`.

