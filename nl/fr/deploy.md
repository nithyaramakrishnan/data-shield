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


# Déploiement d'images
{: #deploy-containers}

Après avoir converti vos images, vous devez redéployer vos conteneurs {{site.data.data.keyword.datashield_short}} sur votre cluster Kubernetes.
{: shortdesc}

Lorsque vous déployez des conteneurs {{site.data.data.keyword.datashield_short}} sur votre cluster Kubernetes, la spécification du conteneur doit inclure des montages de volumes. Les montages de volumes permettent aux dispositifs SGX et au socket AESM d'être disponibles dans le conteneur. 

Vous n'avez pas d'application pour tester le service ? Pas de problème. Nous offrons plusieurs exemples d'applications que vous pouvez tester, notamment MariaDB et NGINX. N'importe quelle [image {{site.data.keyword.datashield_short}}](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter) dans IBM Container Registry peut être utilisée comme exemple.
{: tip}

1. Enregistrez la spécification de pod suivante en tant que modèle.

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
    {: screen}

2. Modifiez les zones `your-app-sgx` et `your-registry-server` en spécifiant votre application et votre serveur.

3. Créez le pod Kubernetes.

   ```
   kubectl create -f template.yml
   ```
  {: pre}

