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


# Déploiement d'images
{: #deploying}

Après avoir converti vos images, vous devez déployer vos conteneurs {{site.data.keyword.datashield_short}} sur votre cluster Kubernetes.
{: shortdesc}

Lorsque vous déployez {{site.data.keyword.datashield_short}}, la spécification de conteneur doit inclure les montages de volume qui aux unités SGX et au socket AESM d'être disponibles. 

Vous n'avez pas d'application pour tester le service ? Pas de problème. Nous offrons plusieurs exemples d'applications que vous pouvez tester, notamment MariaDB et NGINX. Toute [image {{site.data.keyword.datashield_short}}](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter) dans IBM Container Registry peut être utilisée en tant qu'exemple.
{: tip}

1. Configurez des [secrets d'extraction](/docs/containers?topic=containers-images#other).

2. Enregistrez la spécification de pod suivante en tant que modèle.

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

3. Modifiez les zones `your-app-sgx` et `your-registry-server` en spécifiant votre application et votre serveur.

4. Créez le pod Kubernetes.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}

