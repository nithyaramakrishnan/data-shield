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

# Conversion d'images
{: #convert}

Vous pouvez convertir vos images pour qu'elles s'exécutent dans un environnement EnclaveOS® à l'aide du convertisseur de conteneur d'{{site.data.keyword.datashield_short}}. Une fois vos images converties, vous pouvez les déployer sur votre cluster Kubernetes compatible SGX.
{: shortdesc}

Vous pouvez convertir vos applications sans modifier votre code. En effectuant la conversion, vous préparez votre application à s'exécuter dans un environnement EnclaveOS. Il est important de noter que le processus de conversion ne chiffre pas votre application. Seules les données générées lors de l'exécution - après le démarrage de l'application au sein d'une enclave SGX Enclave - sont protégées par IBM Cloud Data Shield. 

Le processus de conversion ne chiffre pas votre application.
{: important}


## Avant de commencer
{: #convert-before}

Avant de convertir vos applications, vous devez vous assurer de bien comprendre les considérations suivantes.
{: shortdesc}

* Pour des raisons de sécurité, les secrets doit être fourni lors de l'exécution, et non placés dans l'image de conteneur que vous souhaitez convertir. Lorsque l'application est convertie et en cours d'exécution, vous pouvez vérifier via une attestation que l'application s'exécute dans une enclave avant de fournir un secret.

* L'invité du conteneur doit s'exécuter en tant que superutilisateur (root) du conteneur.

* Exécution d'un test des conteneurs inclus basés sur Debian, Ubuntu et Java, avec différents résultats. D'autres environnements peuvent être utilisés, mais n'ont pas été testés.


## Configuration des données d'identification de registre
{: #configure-credentials}

Vous pouvez autoriser tous les utilisateurs du convertisseur de conteneur {{site.data.keyword.datashield_short}} à obtenir des images d'entrée depuis et à envoyer par commande push des images de sortie vers des registres privés configurés via la configuration avec des données d'identification de registre. Si vous avez utilisé Container Registry avant le 4 octobre 2018, vous voudrez peut-être [activer l'application de la politique d'accès IAM pour votre registre](/docs/services/Registry?topic=registry-user#existing_users).
{: shortdesc}

### Configuration de vos données d'identification dans {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion. Si vous disposez d'un ID fédéré, ajoutez l'option `--sso` à la fin de la commande.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Créez un ID service et une clé d'API d'ID service pour le convertisseur de conteneur {{site.data.keyword.datashield_short}}.

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. Accordez les droits à l'ID service d'accéder au registre de conteneurs.

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. Créez un fichier de configuration JSON à l'aide de la clé d'API que vous avez créée. Remplacez la variable `<api key>` puis exécutez la commande suivante. Si vous n'avez pas `openssl`, vous pouvez utiliser n'importe quel codeur base64 de la ligne de commande avec les options appropriées. Assurez-vous qu'il n'existe aucune nouvelle ligne au milieu ou à la fin de la chaîne codée.

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### Configuration des données d'identification pour un autre registre
{: #configure-other-registry}

Si vous avez déjà un fichier `~/.docker/config.json` qui s'authentifie au registre et que vous souhaitez utiliser, vous pouvez utiliser ce fichier. Les fichiers sous OS X ne sont actuellement pas pris en charge.

1. Configurez des [secrets d'extraction](/docs/containers?topic=containers-images#other).

2. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion. Si vous disposez d'un ID fédéré, ajoutez l'option `--sso` à la fin de la commande.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. Exécutez la commande suivante.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## Conversion de vos images
{: #converting-images}

Vous pouvez utiliser l'API Enclave Manager pour vous connecter au convertisseur.
{: shortdesc}

Vous pouvez également convertir vos conteneurs lorsque vous générez vos applications via l'[interface utilisateur d'Enclave Manager](/docs/services/data-shield?topic=enclave-manager#em-apps).
{: tip}

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion. Si vous disposez d'un ID fédéré, ajoutez l'option `--sso` à la fin de la commande.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Obtenez et exportez un jeton IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. Convertissez votre image. N'oubliez pas de remplacer les variables par les informations relatives à votre application.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Conversion d'applications Java
{: #convert-java}

Lorsque vous convertissez des applications Java, il existe quelques exigences et limitations supplémentaires. Quand vos convertissez des applications Java via l'interface utilisateur d'Enclave Manager, vous pouvez sélectionner `Java-Mode`. Pour convertir des applications Java via l'API, gardez à l'esprit les limitations et options suivantes.

**Limitations**

* La taille d'enclave maximale recommandée pour les applications Java est de 4 Go. Les enclaves de plus grande taille peuvent fonctionner mais vos risquez d'avoir des performances dégradées. 
* La taille de segment de mémoire recommandée est inférieure à la taille d'enclave. Il est recommandé de retirer toute option `-Xmx` afin de réduire la taille de segment de mémoire.
* Les bibliothèques Java suivantes ont été testées :
  - MySQL Java Connector
  - Crypto (`JCA`)
  - Messaging (`JMS`)
  - Hibernate (`JPA`)

  Si vous utilisez une autre bibliothèque, contactez notre équipe via les forums ou en cliquant sur le bouton de commentaire sur cette page. Veillez à inclure vos informations de contact ainsi que la bibliothèque que vous souhaitez utiliser.


**Options**

Pour utiliser la conversion `Java-Mode`, modifiez le fichier Docker afin de fournir les options suivantes. Pour que la conversion Java fonctionne, vous devez définir toutes les variables telles qu'elles sont définies dans cette section. 


* Définissez la variable d'environnement MALLOC_ARENA_MAX comme égale à 1.

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* Si vous utilisez `OpenJDK JVM`, définissez les options suivantes.

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* Si vous utilisez la machine virtuelle Java `OpenJ9 JVM`, définissez les options suivantes.

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## Demande d'un certificat d'application
{: #request-cert}

Une application convertie peut demander un certificat d'Enclave Manager lorsque votre application est démarrée. Les certificats sont signés par l'autorité de certification d'Enclave Manager et incluent un rapport d'attestation à distance d'Intel pour l'enclave SGX de votre application.
{: shortdesc}

Vérifiez l'exemple suivant pour voir comment configurer une demande pour générer une clé privée RSA et générer le certificat pour la clé. La clé est conservée sur la racine du conteneur d'application. Si vous ne souhaitez pas utiliser de clé ou certificat temporaire, vous pouvez personnaliser `keyPath` et `certPath` pour vos applications et les stocker sur un volume persistant.

1. Sauvegardez le modèle suivant en tant que `app.json` et effectuez les modifications requises pour répondre aux besoins de certificat de votre application.

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. Entrez vos variables et exécutez la commande suivante pour exécuter à nouveau le convertisseur avec vos informations de certificat.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## Placement sur liste blanche d'applications
{: #convert-whitelist}

Lorsqu'une image Docker est convertie pour s'exécuter à l'intérieur d'Intel® SGX, elle peut être mise sur liste blanche. En mettant votre image sur liste blanche, vous affectez des privilèges d'administrateur qui permettent à l'application de s'exécuter sur le cluster sur lequel {{site.data.keyword.datashield_short}} est installé.
{: shortdesc}


1. Obtenez un jeton d'accès à Enclave Manager en utilisant le jeton d'authentification IAM :

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. Effectuez une demande de placement sur liste blanche dans Enclave Manager. Assurez-vous d'entrer vos informations lorsque vous exécutez la commande suivante.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. Utilisez l'interface utilisateur d'Enclave Manager pour approuver ou refuser les demandes de mise sur liste blanche. Vous pouvez suivre et gérer les générations placées sur liste blanche dans la section **Tâches** de l'interface utilisateur.

