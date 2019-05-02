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

# Gestion des accès
{: #access}

Vous pouvez contrôler l'accès à la console Enclave Manager d'{{site.data.keyword.datashield_full}}. Ce contrôle d'accès est séparé des rôles IAM (Identity and Access Management) que vous utilisez lorsque vous travaillez avec {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Utilisation d'une clé d'API IAM pour la connexion à la console
{: #access-iam}

Dans la console Enclave Manager, vous pouvez afficher les noeuds de votre cluster ainsi que leur statut d'attestation. Vous pouvez également afficher les tâches et les journaux d'audit des événements du cluster.

1. Connectez-vous à l'interface de ligne de commande d'IBM Cloud. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

  2. Copiez la sortie commençant par `export` et collez-la dans votre terminal pour définir la variable d'environnement `KUBECONFIG`.

3. Vérifiez que l'ensemble de votre service est exécuté en confirmant que tous vos pods se trouvent à l'état *en cours d'exécution*.

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

8. Dans le terminal, obtenez votre jeton IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. Copiez le jeton et collez-le dans l'interface utilisateur de la console Enclave Manager. Vous n'avez pas besoin de copier la portion `Bearer` du jeton imprimé.

9. Cliquez sur **Se connecter**.


## Définition des rôles pour les utilisateurs de la console Enclave Manager
{: #enclave-roles}

L'administration d'{{site.data.keyword.datashield_short}} a lieu dans la console Enclave Manager. En tant qu'administrateur, vous obtenez automatiquement le rôle de *gestionnaire* mais vous pouvez également affecter des rôles à d'autres utilisateurs.
{: shortdesc}

Gardez à l'esprit que ces rôles sont différents des rôles IAM de la plateforme qui sont utilisés pour contrôler l'accès aux services {{site.data.keyword.cloud_notm}}. Pour en savoir plus sur la configuration de l'accès pour {{site.data.keyword.containerlong_notm}}, voir [Assignation d'accès au cluster](/docs/containers?topic=containers-users#users).
{: tip}

Consultez le tableau suivant pour voir quels rôles sont pris en charge et des exemples de mesures qui peuvent être prises par chaque utilisateur :

<table>
  <tr>
    <th>Rôle</th>
    <th>Actions</th>
    <th>Exemple</th>
  </tr>
  <tr>
    <td>Lecteur</td>
    <td>Peut effectuer des actions de lecture seule comme visualiser les noeuds, les générations, des informations utilisateur, les applications, les tâches et les journaux d'audit.</td>
    <td>Téléchargement d'un certificat d'attestation de noeud.</td>
  </tr>
  <tr>
    <td>Editeur</td>
    <td>Peut effectuer les actions d'un lecteur et plus, y compris désactiver et renouveler l'attestation de noeud, ajouter une génération, approuver ou refuser des actions ou des tâches.</td>
    <td>Certification d'une application.</td>
  </tr>
  <tr>
    <td>Gestionnaire</td>
    <td>Peut effectuer les actions d'un éditeur et plus, y compris mettre à jour les noms d'utilisateur et les rôles, ajouter des utilisateurs au cluster, mettre à jour les paramètres du cluster, et toute autre action privilégiée.</td>
    <td>Mise à jour d'un rôle d'utilisateur.</td>
  </tr>
</table>

### Configuration des rôles d'utilisateur
{: #set-roles}

Vous pouvez définir ou mettre à jour les rôles d'utilisateur pour votre gestionnaire de console.
{: shortdesc}

1. Accédez à l'[interface utilisateur de la console Enclave Manager](/docs/services/data-shield?topic=data-shield-access#access-iam).
2. Dans le menu déroulant, ouvrez l'écran de gestion des utilisateurs.
3. Sélectionnez **Paramètres**. Vous pouvez vérifier la liste des utilisateurs ou ajouter un utilisateur dans cet écran.
4. Pour éditer les droits d'utilisateur, survolez un utilisateur jusqu'à ce que l'icône du crayon s'affiche.
5. Cliquez sur l'icône du crayon pour changer ses droits. Les modifications apportées aux droits d'utilisateur prennent immédiatement effet.
