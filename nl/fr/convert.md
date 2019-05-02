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

# Conversion d'images
{: #convert}

Vous pouvez convertir vos images pour qu'elles s'exécutent dans un environnement EnclaveOS® à l'aide du convertisseur de conteneur d'{{site.data.keyword.datashield_short}}. Une fois que vos images sont converties, vous pouvez les déployer sur votre cluster Kubernetes compatible SGX.
{: shortdesc}


## Configuration des données d'identification de registre
{: #configure-credentials}

Vous pouvez autoriser tous les utilisateurs du convertisseur à obtenir des images d'entrée et à ajouter des images de sortie dans les registres privés configurés en configurant le convertisseur avec les données d'identification de registre.
{: shortdesc}

### Configuration de vos données d'identification dans {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}.

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

2. Obtenez un jeton d'authentification pour votre registre {{site.data.keyword.cloud_notm}} Container Registry.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. Créez un fichier de configuration JSON à l'aide du jeton que vous avez créé. Remplacez la variable `<token>` puis exécutez la commande suivante. Si vous n'avez pas `openssl`, vous pouvez utiliser n'importe quel codeur base64 de la ligne de commande avec les options appropriées. Assurez-vous qu'il n'y a pas de nouvelle ligne au milieu ou à la fin de la chaîne codée.

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### Configuration des données d'identification pour un autre registre
{: #configure-other-registry}

Si vous avez déjà un fichier `~/.docker/config.json` qui s'authentifie au registre et que vous souhaitez utiliser, vous pouvez utiliser ce fichier.

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Exécutez la commande suivante.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## Conversion de vos images
{: #converting-images}

Vous pouvez utiliser l'API Enclave Manager pour vous connecter au convertisseur.
{: shortdesc}

1. Connectez-vous à l'interface de ligne de commande d'{{site.data.keyword.cloud_notm}}. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Obtenez et exportez un jeton IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. Convertissez votre image. N'oubliez pas de remplacer les variables par les informations relatives à votre application.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## Demande d'un certificat d'application 
{: #request-cert}

Une application convertie peut demander un certificat d'Enclave Manager lorsque votre application est démarrée. Les certificats sont signés par l'autorité de certification d'Enclave Manager et incluent un rapport d'attestation à distance d'Intel pour l'enclave SGX de votre application.
{: shortdesc}

Vérifiez l'exemple suivant pour voir comment configurer une demande pour générer une clé privée RSA et générer le certificat pour la clé. La clé est conservée sur la racine du conteneur d'application. Si vous ne souhaitez pas utiliser une clé temporaire ou un certificat, vous pouvez personnaliser `keyPath` et `certPath` pour vos applications et les stocker sur un volume persistant.

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
 {: pre}


## Mise sur liste blanche de vos applications
{: #convert-whitelist}

Lorsqu'une image Docker est convertie pour s'exécuter à l'intérieur d'Intel® SGX, elle peut être mise sur liste blanche. En mettant votre image sur liste blanche, vous affectez des privilèges d'administrateur qui permettent à l'application de s'exécuter sur le cluster sur lequel {{site.data.keyword.datashield_short}} est installé.
{: shortdesc}

1. Obtenez un jeton d'accès d'Enclave Manager à l'aide du jeton d'authentification IAM avec la demande curl suivante :

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. Effectuez une demande de mise sur liste blanche dans Enclave Manager. Assurez-vous d'entrer vos informations lorsque vous exécutez la commande suivante.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. Utilisez l'interface utilisateur d'Enclave Manager pour approuver ou refuser les demandes de mise sur liste blanche. Vous pouvez suivre et gérer les générations mises sur liste blanche dans la section **Générations** de l'interface utilisateur.
