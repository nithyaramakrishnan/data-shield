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

# Tutoriel d'initiation
{: #getting-started}

{{site.data.keyword.datashield_full}} optimisé par Fortanix® vous permet de protéger les données des charges de travail de vos conteneurs qui s'exécutent sur {{site.data.keyword.cloud_notm}} lorsque vos données de trouvent en cours d'utilisation.
{: shortdesc}

Pour en savoir plus sur {{site.data.keyword.datashield_short}}, et sur ce que cela signifie de protéger vos données en cours d'utilisation, consultez [A propos du service](/docs/services/data-shield?topic=data-shield-about).

## Avant de commencer
{: #gs-begin}

Avant de commencer à utiliser {{site.data.keyword.datashield_short}}, vérifiez que vous possédez les composants requis répertoriés ci-dessous.

Pour obtenir de l'aide lors du téléchargement des interfaces de ligne de commande lors de la configuration de votre environnement {{site.data.keyword.containershort}}, consultez le tutoriel [Création de clusters Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).
{: tip}

* Les interfaces de ligne de commande suivantes :

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* Les [plug-ins d'interface CLI](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins) suivants :

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}

* Un cluster Kubernetes compatible SGX. Actuellement, SGX peut être activé sur un cluster bare metal avec le type de noeud mb2c.4x32. Si vous n'en avez pas, vous pouvez utiliser la procédure suivante pour être sûr de créer le cluster dont vous avez besoin.
  1. Préparez-vous pour la [création de votre cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Vérifiez que vous disposez des [droits requis](/docs/containers?topic=containers-users) pour créer un cluster.

  3. Créez le [cluster](/docs/containers?topic=containers-clusters).

* Une instance du service [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} de version 0.5.0 ou plus récente. L'installation par défaut utilise <code>cert-manager</code> pour configurer les [certificats TLS](/docs/services/data-shield?topic=data-shield-tls-certificates) pour la communication interne entre les services d'{{site.data.keyword.datashield_short}}. Pour installer une instance à l'aide de la charte Helm, vous pouvez exécuter la commande suivante.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Vous souhaitez voir les informations de consignation pour Data Shield ? Configurez une instance {{site.data.keyword.la_full_notm}} pour votre cluster.
{: tip}

## Installation du service
{: #gs-install}

Vous pouvez utiliser la charte Helm fournie pour installer {{site.data.keyword.datashield_short}} sur votre cluster bare metal compatible SGX.
{: shortdesc}

La charte Helm installe les composants suivants :

*	Le logiciel de prise en charge de SGX, qui est installé sur les hôtes bare metal par un conteneur privilégié.
*	La console Enclave Manager d'{{site.data.keyword.datashield_short}}, qui gère les enclaves SGX dans l'environnement {{site.data.keyword.datashield_short}}.
*	Le service de conversion des conteneurs EnclaveOS®, qui permet aux applications conteneurisées de s'exécuter dans l'environnement {{site.data.keyword.datashield_short}}.


Pour installer {{site.data.keyword.datashield_short}} sur votre cluster, exécutez la procédure suivante.

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

  2. Copiez la sortie commençant par `export` et collez-la dans votre console pour définir la variable d'environnement `KUBECONFIG`.

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

6. Initialisez Helm en créant une politique de liaison de rôle pour Tiller. 

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

7. Installez la charte.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Si vous avez [configuré un registre {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) pour votre convertisseur, vous devez ajouter `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Pour surveiller le démarrage de vos composants, exécutez la commande suivante.

  ```
  kubectl get pods
  ```
  {: codeblock}

## Etapes suivantes
{: #gs-next}

A présent que le service est installé sur votre cluster, vous pouvez commencer à protéger vos données. Vous pourrez ensuite essayer de [convertir](/docs/services/data-shield?topic=data-shield-convert), [déployer](/docs/services/data-shield?topic=data-shield-deploying) vos applications. 

Si vous ne disposez pas d'une image propre, essayez de déployer l'une des images prépackagées d'{{site.data.keyword.datashield_short}} :

* [Exemples de référentiel GitHub](https://github.com/fortanix/data-shield-examples/tree/master/ewallet){: external}
* Registre de conteneurs : [image Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter), [image MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter), [image NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter) ou [image Vault](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter).


