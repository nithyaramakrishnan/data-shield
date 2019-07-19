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

# Utilisation d'Enclave Manager
{: #enclave-manager}

Vous pouvez utiliser l'interface utilisateur d'Enclave Manager pour gérer les applications que vous protégez avec {{site.data.keyword.datashield_full}}. Depuis l'interface utilisateur, vous pouvez gérer le déploiement de vos application, affecter des accès, gérer les demandes de placement sur liste blanche et convertir vos applications.
{: shortdesc}


## Connexion
{: #em-signin}

Dans la console Enclave Manager, vous pouvez afficher les noeuds de votre cluster ainsi que leur statut d'attestation. Vous pouvez également afficher les tâches et les journaux d'audit des événements du cluster. Pour commencer, connectez-vous.
{: shortdesc}

1. Veillez à disposer de l'[accès correct](/docs/services/data-shield?topic=data-shield-access).

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

3. Vérifiez que l'ensemble de votre service est exécuté en confirmant que tous vos pods se trouvent à l'état *actif*.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Recherchez l'URL frontale de votre console Enclave Manager en exécutant la commande suivante.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Obtenez votre sous-domaine Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. Dans un navigateur, entrez le sous-domaine Ingress dans lequel se trouve votre console Enclave Manager.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

7. Dans le terminal, obtenez votre jeton IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. Copiez le jeton et collez-le dans l'interface utilisateur de la console Enclave Manager. Vous n'avez pas besoin de copier la portion `Bearer` du jeton imprimé.

9. Cliquez sur **Se connecter**.






## Gestion des noeuds
{: #em-nodes}

Vous pouvez utiliser l'interface utilisateur d'Enclave Manager pour surveiller le statut, désactiver ou télécharger les certificats pour les noeuds exécutant IBM Cloud Data Shield dans votre cluster.
{: shortdesc}


1. Connectez-vous à Enclave Manager.

2. Accédez à l'onglet **Noeuds**.

3. Cliquez sur l'adresse IP du noeud que vous voulez analyser. Un écran d'information s'affiche.

4. Sur l'écran d'information, vous pouvez choisir de désactiver le nœud ou de télécharger le certificat utilisé.




## Déploiement d'applications
{: #em-apps}

Vous pouvez utiliser l'interface utilisateur d'Enclave Manager pour déployer vos applications.
{: shortdesc}


### Ajout d'une application
{: #em-app-add}

Vous pouvez convertir, déployer et placer sur liste blanche votre application simultanément via l'interface utilisateur d'Enclave Manager.
{: shortdesc}

1. Connectez-vous à Enclave Manager et accédez à l'onglet **Applications**.

2. Cliquez sur **Ajouter une nouvelle application**.

3. Donnez un nom et une description à votre application.

4. Entrez un nom pour l'entrée et la sortie de vos images. L'entrée est le nom de votre application en cours. La sortie est l'emplacement où vous trouverez l'application convertie.

5. Entrez un **ISVPRDID** et un **ISVSVN**.

6. Entrez tout domaine autorisé. 

7. Editez les paramètres avancés que vous souhaitez modifier.

8. Cliquez sur **Créer une application**. L'application est déployée et ajoutée à votre liste blanche. Vous pouvez approuver la demande de génération dans l'onglet **tâches**.




### Edition d'une application
{: #em-app-edit}

Vous pouvez éditer une application après l'avoir ajoutée à votre liste.
{: shortdesc}


1. Connectez-vous à Enclave Manager et accédez à l'onglet **Applications**.

2. Cliquez sur le nom de l'application que vous souhaitez modifier. Un nouvel écran s'ouvre, dans lequel vous pouvez examiner la configuration, y compris les certificats et les générations déployées. 

3. Cliquez sur **Editer l'application**. 

4. Mettez à jour la configuration que vous voulez réaliser. Assurez-vous de comprendre la façon dont les paramètres avancés modifiés vont affecter votre application avant de faire des changements.

5. Cliquez sur **Editer l'application**. 


## Génération d'applications
{: #em-builds}

Vous pouvez utiliser l'interface utilisateur d'Enclave Manager pour régénérer vos applications après avoir effectué des changements.
{: shortdesc}

1. Connectez-vous à Enclave Manager et accédez à l'onglet **Générations**.

2. Cliquez sur **Créer une génération**. 

3. Sélectionnez une application dans la liste déroulante ou ajoutez une application.

4. Entrez le nom de votre image Docker et étiquetez-la de manière spécifique. 

5. Cliquez sur **Générer**. La génération est ajoutée à la liste blanche. Vous pouvez approuver la génération dans l'onglet **Tâches**. 



## Approbation de tâches
{: #em-tasks}

Lorsqu'une application est sur liste blanche, elle est ajoutée à la liste des demandes en attente dans l'onglet **tâches** de l'interface utilisateur d'Enclave Manager. Vous pouvez utiliser l'interface utilisateur pour approuver ou refuser la demande.
{: shortdesc}

1. Connectez-vous à Enclave Manager et accédez à l'onglet **Tâches**.

2. Cliquez sur la ligne contenant la demande que vous souhaitez approuver ou refuser. Un écran s'ouvre avec des informations supplémentaires.

3. Examinez la demande et cliquez sur **Approuver** ou **Refuser**. Votre nom est ajouté à la liste des **réviseurs**.


## Affichage des journaux
{: #em-view}

Vous pouvez effectuer l'audit de votre instance Enclave Manager pour différents types d'activité.
{: shortdesc}

1. Accédez à l'onglet **Journal d'audit** de l'interface utilisateur d'Enclave Manager.
2. Filtrez les résultats de journalisation afin de limiter la recherche. Vous pouvez choisir de filtrer par délai ou par tout autre type parmi les suivants :

  * Statut d'activité : Activité concernant votre application, demandes de placement sur liste blanche ou nouvelles générations, par exemple.
  * Approbation d'utilisateur : Activité concernant l'accès d'un utilisateur, telle que l'approbation ou le refus d'utilisation du compte.
  * Attestation de noeud : Activité concernant l'attestation de noeud.
  * Autorité de certification : Activité concernant une autorité de certification.
  * Administration : Activité concernant l'aspect administratif. 

Si vous souhaitez conserver un enregistrement des journaux au-delà d'un mois, vous pouvez exporter les informations sous forme de fichier `.csv`.

