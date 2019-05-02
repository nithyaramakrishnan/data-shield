# IBM Cloud Data Shield

Avec IBM Cloud Data Shield, Fortanix® et Intel® SGX, vous pouvez protéger les données des charges de travail de vos conteneurs qui s'exécutent sur IBM Cloud lorsque vos données se trouvent en cours d'utilisation.

## Introduction

Lorsqu'il s'agit de protéger vos données, le chiffrement est l'un des moyens les plus populaires et les plus efficaces. Cependant, pour être réellement sécurisées, les données doivent être chiffrées à chaque étape de leur cycle de vie. Les trois phases du cycle de vie des données comprennent les données au repos, les données en mouvement et les données en cours d'utilisation. Les données au repos et en mouvement sont habituellement utilisées pour protéger les données lorsqu'elles sont stockées et transportées.

Cependant, après le démarrage d'une application, les données utilisées par l'unité centrale et la mémoire sont vulnérables aux attaques. Les initiés malveillants, superutilisateurs, données d'identification compromises, attaques OS zero-day et intrus de réseau sont autant de menaces pour les données. Pour aller plus loin dans le chiffrement, vous pouvez désormais protéger les données en cours d'utilisation. 

Pour en savoir plus sur les services et sur ce que cela signifie de protéger vos données en cours d'utilisation, consultez [A propos du service](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about).



## Détails de la charte

Cette charte Helm installe les composants suivants sur votre cluster IBM Cloud Kubernetes Service compatible SGX :

 * Le logiciel de prise en charge de SGX, qui est installé sur les hôtes bare metal par un conteneur privilégié.
 * La console Enclave Manager d'IBM Cloud Data Shield, qui gère les enclaves SGX dans l'environnement IBM Cloud Data Shield.
 * Le service de conversion des conteneurs EnclaveOS®, qui convertit les applications conteneurisées pour qu'elles puissent s'exécuter dans l'environnement IBM Cloud Data Shield.



## Ressources obligatoires

* Un cluster Kubernetes compatible SGX. Actuellement, SGX peut être activé sur un cluster bare metal avec le type de noeud mb2c.4x32. Si vous n'en avez pas, vous pouvez utiliser la procédure suivante pour être sûr de créer le cluster dont vous avez besoin.
  1. Préparez-vous pour la [création de votre cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Vérifiez que vous disposez des [droits requis](https://cloud.ibm.com/docs/containers?topic=containers-users#users) pour créer un cluster.

  3. Créez le [cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters).

* Une instance du service [cert-manager](https://cert-manager.readthedocs.io/en/latest/) de version 0.5.0 ou plus récente. Pour installer l'instance à l'aide d'une charte Helm, exécutez la commande suivante.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## Conditions requises

Avant de commencer à utiliser IBM Cloud Data Shield, vérifiez que vous possédez les composants requis répertoriés ci-dessous. Pour obtenir de l'aide lors du téléchargement des interfaces de ligne de commande et des plug-ins ou lors de la configuration de votre environnement Kubernetes Service, consultez le tutoriel [Création de clusters Kubernetes](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* Les interfaces de ligne de commande suivantes :

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  Si vous le souhaitez, vous pouvez configurer Helm pour utiliser le mode `--tls`. Pour obtenir de l'aide pour activer TLS, consultez le [référentiel Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Si vous activez TLS, assurez-vous d'ajouter `--tls` à chaque commande Helm que vous exécutez.
  {: tip}

* Les [plug-ins d'interface de ligne de commande {{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) suivants :

  * Service Kubernetes
  * Container Registry



## Installation de la charte

Lorsque vous installez une charte Helm, vous disposez de plusieurs options et paramètres pour personnaliser votre installation. Les instructions suivantes vous guident à travers l'installation de base de la charte, qui est configurée par défaut. Pour en savoir plus sur vos options, voir [la documentation d'IBM Cloud Data Shield](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started).

Astuce : vos images sont-elles stockées dans un registre privé ? Vous pouvez utiliser le convertisseur de conteneur EnclaveOS pour configurer les images pour utiliser IBM Cloud Data Shield. Veillez à convertir vos images avant de déployer la charte afin de disposer des informations de configuration nécessaires. Pour en savoir plus sur la conversion des images, voir [les documentations](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert).


**Pour installer IBM Cloud Data Shield sur votre cluster :**

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

3. Si vous ne l'avez pas déjà fait, ajoutez le référentiel `ibm`.

  ```
  helm repo add ibm  https://registry.bluemix.net/helm/ibm
  ```

4. Facultatif : si vous ne connaissez pas l'e-mail qui est associé à l'administrateur ou l'ID de compte administrateur, exécutez la commande suivante.

  ```
  ibmcloud account show
  ```

5. Obtenez le sous-domaine Ingress correspondant à votre cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. Installez la charte.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  Remarque : si vous avez [configuré un registre IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert) pour votre convertisseur, ajoutez l'option suivante : `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. Pour surveiller le démarrage de vos composants, exécutez la commande suivante.

  ```
  kubectl get pods
  ```

## Exécution de vos applications dans l'environnement IBM Cloud Data Shield

Pour exécuter vos applications dans l'environnement IBM Cloud Data Shield, vous devez convertir, mettre sur liste blanche puis déployer votre image de conteneur.

### Conversion de vos images
{: #converting-images}

Vous pouvez utiliser l'API Enclave Manager pour vous connecter au convertisseur.
{: shortdesc}

1. Connectez-vous à l'interface de ligne de commande d'IBM Cloud. Suivez les invites dans l'interface de ligne de commande pour finaliser la connexion.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. Obtenez et exportez un jeton IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. Convertissez votre image. Veillez à remplacer les variables par les informations relatives à votre application.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### Mise sur liste blanche de votre application
{: #convert-whitelist}

Lorsqu'une image Docker est convertie pour s'exécuter à l'intérieur d'Intel SGX, elle peut être mise sur liste blanche. En mettant votre image sur liste blanche, vous affectez des privilèges d'administrateur qui permettent à l'application de s'exécuter sur le cluster sur lequel IBM Cloud Data Shield est installé.
{: shortdesc}

1. Obtenez un jeton d'accès d'Enclave Manager à l'aide du jeton d'authentification IAM avec la demande curl suivante :

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. Effectuez une demande de mise sur liste blanche dans Enclave Manager. Assurez-vous d'entrer vos informations lorsque vous exécutez la commande suivante.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. Utilisez l'interface utilisateur d'Enclave Manager pour approuver ou refuser les demandes de mise sur liste blanche. Vous pouvez suivre et gérer les générations mises sur liste blanche dans la section **Générations** de l'interface utilisateur.



### Déploiement des conteneurs IBM Cloud Data Shield

Après avoir converti vos images, vous devez redéployer vos conteneurs IBM Cloud Data Shield dans votre cluster Kubernetes.
{: shortdesc}

Lorsque vous déployez des conteneurs IBM Cloud Data Shield dans votre cluster Kubernetes, la spécification du conteneur doit inclure les montages de volumes. Les volumes permettent aux appareils SGX et aux sockets AESM d'être disponibles dans le conteneur.

1. Sauvegardez la spécification de pod suivante en tant que modèle.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. Modifiez les zones `your-app-sgx` et `your-registry-server` en spécifiant votre application et votre serveur.

3. Créez le pod Kubernetes.

   ```
   kubectl create -f template.yml
   ```

Vous n'avez pas d'application pour tester le service ? Pas de problème. Nous offrons plusieurs exemples d'applications que vous pouvez tester, notamment MariaDB et NGINX. Toutes les [images "datashield" ](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter) contenues dans le registre IBM Container Registry peuvent être utilisées en tant qu'exemple.



## Accès à l'interface utilisateur d'Enclave Manager

Vous trouverez un aperçu de toutes vos applications qui s'exécutent dans un environnement IBM Cloud Data Shield dans l'interface utilisateur d'Enclave Manager. Dans la console Enclave Manager, vous pouvez afficher les noeuds présents dans votre cluster, leur statut d'attestation, les tâches, et un journal d'audit des événements du cluster. Vous pouvez également autoriser ou rejeter les demandes de mise sur liste blanche.

Pour accéder à l'interface utilisateur :

1. Connectez-vous à IBM Cloud et définissez le contexte pour votre cluster.

2. Vérifiez que le service est en cours d'exécution en confirmant que tous vos pods se trouvent à l'état *en cours d'exécution*.

  ```
  kubectl get pods
  ```

3. Recherchez l'URL frontale de votre console Enclave Manager en exécutant la commande suivante.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Obtenez votre sous-domaine Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. Dans un navigateur, entrez le sous-domaine Ingress dans lequel se trouve votre console Enclave Manager.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. Dans le terminal, obtenez votre jeton IAM.

  ```
  ibmcloud iam oauth-tokens
  ```

7. Copiez le jeton et collez-le dans l'interface utilisateur de la console Enclave Manager. Vous n'avez pas besoin de copier la portion `Bearer` du jeton imprimé.

8. Cliquez sur **Se connecter**.

Pour obtenir des informations sur les rôles dont un utilisateur a besoin pour effectuer les différentes actions, voir [Définition des rôles pour les utilisateurs de la console Enclave Manager](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles).

## Utilisation des images prépackagées dotées d'une protection maximale

L'équipe d'IBM Cloud Data Shield a conçu quatre images différentes prêtes à la production qui peuvent être exécutées dans des environnements IBM Cloud Data Shield. Vous pouvez essayer l'une des images suivantes :

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## Désinstallation et traitement des incidents

Si vous rencontrez un problème lorsque vous travaillez avec IBM Cloud Data Shield, essayez de parcourir les sections [Traitement des incidents](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting) ou [Questions fréquentes](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq) de la documentation. Si vous ne voyez pas votre question ou une solution à votre problème, contactez [le support IBM](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).

Si vous n'avez plus besoin d'IBM Cloud Data Shield, vous pouvez [supprimer le service et les certificats TLS créés](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall).

