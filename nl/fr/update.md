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

# Mise à jour
{: #update}

Une fois {{site.data.keyword.datashield_short}} installé sur votre cluster, vous pouvez à tout moment effectuer une mise à jour.
{: shortdesc}

## Définition du contexte de cluster
{: #update-context}

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

  2. Copiez la sortie et collez-la dans votre console.

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

## Mise à jour avec Helm
{: #update-helm}

Pour effectuer une mise à jour vers la version la plus récente avec la charte Helm, exécutez la commande suivante.

  ```
  helm upgrade <chart-name> ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

## Mise à jour à l'aide du programme d'installation
{: #update-installer}

Pour effectuer une mise à jour vers la version la plus récente avec le programme d'installation, exécutez la commande suivante.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer upgrade [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ] [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  Pour installer la version la plus récente d'{{site.data.keyword.datashield_short}}, utilisez `latest` pour l'indicateur `--version`.


