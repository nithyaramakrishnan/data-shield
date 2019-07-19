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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# Traitement des incidents
{: #troubleshooting}

Si vous rencontrez des problèmes lorsque vous utilisez {{site.data.keyword.datashield_full}}, les techniques suivantes peuvent vous aider à les résoudre et à obtenir de l'aide.
{: shortdesc}

## Aide et support
{: #gettinghelp}

Pour obtenir de l'aide, vous pouvez rechercher des informations dans la documentation ou poser des questions sur un forum. Vous pouvez aussi ouvrir un ticket de demande de service. Lorsque vous posez une question sur un forum, identifiez votre question pour qu'elle soit vue par l'équipe de développement d'{{site.data.keyword.cloud_notm}}.
  * Si vous avez des questions techniques au sujet d'{{site.data.keyword.datashield_short}}, postez vos questions sur <a href="https://stackoverflow.com" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="Icône de lien externe"></a> et identifiez votre question avec "ibm-data-shield".
  * Posez toute question relative au service et aux instructions de mise en route sur le forum <a href="https://developer.ibm.com/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="Icône de lien externe"></a>. Identifiez votre question avec `data-shield`.

Pour plus d'informations sur l'obtention de support, voir [Comment obtenir le support dont j'ai besoin ?](/docs/get-support?topic=get-support-getting-customer-support)


## Obtention des fichiers journaux
{: #ts-logs}

Lorsque vous ouvrez un ticket de demande de service pour IBM Cloud Data Shield, mettre à disposition vos journaux peut aider à accélérer le processus de traitement des incidents. Vous pouvez utiliser la procédure suivante pour vous procurer vos journaux puis les copier et coller dans l'incident que vous créez. 

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

3. Exécutez la commande suivante pour obtenir vos journaux.

  ```
  kubectl logs --all-containers=true --selector release=$(helm list | grep 'data-shield' | awk {'print $1'}) > logs
  ```
  {: codeblock}


## Je ne parviens pas à me connecter à l'interface utilisateur d'Enclave Manager
{: #ts-log-in}

{: tsSymptoms}
Vous essayez d'accéder à l'interface utilisateur d'Enclave Manager et vous ne parvenez pas à vous connecter.

{: tsCauses}
La connexion peut échouer pour les raisons suivantes :

* Vous utilisez peut-être un ID de messagerie électronique qui n'est pas autorisé à accéder au cluster d'Enclave Manager.
* Le jeton que vous utilisez a peut-être expiré.

{: tsResolve}
Pour résoudre le problème, vérifiez que vous utilisez l'ID de messagerie électronique correct. Si oui, vérifiez que le courrier électronique possède les autorisations correctes pour accéder à Enclave Manager. Si vous avez les autorisations correctes, votre jeton d'accès a peut-être expiré. Les jetons sont valides pendant une durée de 60 minutes. Pour obtenir un nouveau jeton, exécutez `ibmcloud iam oauth-tokens`. Si vous possédez plusieurs comptes IBM Cloud, vérifiez que celui avec lequel vous êtes connecté à l'interface CLI est le bon compte pour le cluster Enclave Manager.


## L'API du convertisseur de conteneur renvoie l'erreur "Interdit"
{: #ts-converter-forbidden-error}

{: tsSymptoms}
Vous essayez d'exécuter le convertisseur de conteneur et recevez l'erreur `Interdit`.

{: tsCauses}
Il est possible que vous ne puissiez pas accéder au convertisseur si votre jeton Bearer ou IAM est manquant ou a expiré.

{: tsResolve}
Pour résoudre le problème, vérifiez que vous utilisez un jeton IAM OAuth IBM ou un jeton d'authentification pour Enclave Manager dans l'en-tête de votre demande. Les jetons ont la forme suivante :

* IAM : `Authentification : Basic <IBM IAM Token>`
* Enclave Manager : `Authentification : Bearer <E.M. Token>`

Si votre jeton est présent, vérifiez qu'il est encore valide et exécutez à nouveau la demande.


## Le convertisseur de conteneur ne parvient pas à se connecter à un registre Docker privé
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
Vous essayez d'exécuter le convertisseur de conteneur sur une image à partir d'un registre Docker privé et le convertisseur ne parvient pas à se connecter.

{: tsCauses}
Les données d'identification de votre registre privé ne sont peut-être pas configurées correctement. 

{: tsResolve}
Pour résoudre ce problème, procédez comme suit :

1. Vérifiez que les données d'identification dans votre registre privé ont été préalablement configurées. Si ce n'est pas le cas, configurez-lez maintenant.
2. Exécutez la commande suivante pour vider les données d'identification de votre registre Docker. Si nécessaire, vous pouvez changer le nom secret.

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: codeblock}

3. Utilisez le décodeur Base64 pour décoder le contenu secret de `.dockerconfigjson` et vérifiez qu'il est correct.


## Impossible de monter le socket AESM ou les dispositifs SGX
{: #ts-problem-mounting-device}

{: tsSymptoms}
Vous rencontrez des problèmes lorsque vous essayez de monter des conteneurs {{site.data.keyword.datashield_short}} sur des volumes `/var/run/aesmd/aesm.socket` ou `/dev/isgx`.

{: tsCauses}
Le montage peut échouer en raison de problèmes de configuration de l'hôte.

{: tsResolve}
Pour résoudre ce problème, vérifiez :

* que l'hôte ne contient pas de répertoire `/var/run/aesmd/aesm.socket`. Si ce répertoire existe sur l'hôte, supprimez le fichier, désinstallez le logiciel {{site.data.keyword.datashield_short}} puis effectuez à nouveau les étapes d'installation. 
* que SGX est activé dans le système BIOS des machines hôte. S'il n'est pas activé, contactez le support IBM.


## Erreur : Conversion de conteneurs
{: #ts-container-convert-fails}

{: tsSymptoms}
Vous rencontrez l'erreur suivante lorsque vous essayez de convertir votre conteneur.

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: codeblock}

{: tsCauses}
Sous macOS, si la chaîne de certificats OS X Keychain est utilisée dans votre fichier `config.json`, le convertisseur de conteneur échoue. 

{: tsResolve}
Pour résoudre ce problème, procédez comme suit :

1. Désactivez la chaîne de certificats OS X sur votre système local. Accédez à **Préférences Système > iCloud** et décochez la case **Trousseau**.

2. Supprimez le secret que vous avez créé. Vérifiez que vous êtes connecté à IBM Cloud et avez bien ciblé votre cluster avant d'exécuter la commande suivante.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}

3. Dans votre fichier `$HOME/.docker/config.json`, supprimez la ligne `"credsStore": "osxkeychain"`.

4. Connectez-vous à votre registre.

5. Créez un secret.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

6. Répertoriez vos pods et notez le nom du pod contenant la mention `enclaveos-converter`.

  ```
  kubectl get pods
  ```
  {: codeblock}

7. Supprimez le pod.

  ```
  kubectl delete pod <nom du pod>
  ```
  {: codeblock}

8. Convertissez votre image.
