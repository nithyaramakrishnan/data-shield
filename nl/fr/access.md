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

# Affectation d'un accès
{: #access}

Vous pouvez contrôler l'accès à la console Enclave Manager d'{{site.data.keyword.datashield_full}}. Ce type de contrôle d'accès est séparé des rôles IAM (Identity and Access Management) que vous utilisez lorsque vous travaillez avec {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Affectation d'accès au cluster
{: #access-cluster}

Avant de vous connecter à Enclave Manager, vous devez disposer d'un accès au cluster sur lequel Enclave Manager s'exécute.
{: shortdesc}

1. Connectez-vous au compte qui héberge le cluster auquel vous voulez vous connecter.

2. Accédez à **Gérer > Accès (IAM) > Utilisateurs**.

3. Cliquez sur **Inviter des utilisateurs**.

4. Indiquez les adresses électroniques de l'utilisateur que vous souhaitez ajouter.

5. Dans la liste déroulante **Affecter l'accès à**, sélectionnez **Ressource**.

6. Dans la liste déroulante **Services**, sélectionnez **Service Kubernetes**.

7. Sélectionnez une **Région**, un **Cluster** et un **Espace de nom**.

8. En vous guidant avec la documentation Kubernetes Service relative à l'[affectation d'accès au cluster](/docs/containers?topic=containers-users), affectez l'accès dont l'utilisateur a besoin pour exécuter ses tâches.

9. Cliquez sur **Sauvegarder**.

## Définition des rôles pour les utilisateurs de la console Enclave Manager
{: #enclave-roles}

L'administration d'{{site.data.keyword.datashield_short}} a lieu dans la console Enclave Manager. En tant qu'administrateur, vous obtenez automatiquement le rôle de *gestionnaire* mais vous pouvez également affecter des rôles à d'autres utilisateurs.
{: shortdesc}

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
    <td>Peut effectuer les actions d'un lecteur et plus, y compris désactiver et renouveler l'attestation de noeud, ajouter une génération, et approuver ou refuser des actions ou des tâches.</td>
    <td>Certification d'une application.</td>
  </tr>
  <tr>
    <td>Gestionnaire</td>
    <td>Peut effectuer les actions d'un éditeur et plus, y compris mettre à jour les noms d'utilisateur et les rôles, ajouter des utilisateurs au cluster, mettre à jour les paramètres du cluster, et toute autre action privilégiée.</td>
    <td>Mise à jour d'un rôle d'utilisateur.</td>
  </tr>
</table>


### Ajout d'un utilisateur
{: #set-roles}

En utilisant l'interface graphique d'Enclave Manager, vous pouvez donner aux nouveaux utilisateurs l'accès aux informations.
{: shortdesc}

1. Connectez-vous à Enclave Manager.

2. Cliquez sur **Votre nom > Paramètres**.

3. Cliquez sur **Ajouter un utilisateur**.

4. Entrez une adresse électronique et un nom pour l'utilisateur. Sélectionnez un rôle dans la liste déroulante **Rôle** .

5. Cliquez sur **Sauvegarder**.



### Mise à jour d'un utilisateur
{: #update-roles}

Vous pouvez mettre à jour les rôles affectés aux utilisateurs, ainsi que les noms.
{: shortdesc}

1. Connectez-vous à l'[interface utilisateur d'Enclave Manager](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin).

2. Cliquez sur **Votre nom > Paramètres**.

3. Survolez l'utilisateur dont vous souhaitez éditer les droits. Une icône de crayon s'affiche.

4. Cliquez sur l'icône de crayon. L'écran d'édition de l'utilisateur s'affiche.

5. Dans la liste déroulante **Rôle**, sélectionnez les rôles que vous souhaitez affecter.

6. Mettez à jour le nom de l'utilisateur. 

7. Cliquez sur **Sauvegarder**. Les modifications apportées aux droits d'utilisateur prennent immédiatement effet.


