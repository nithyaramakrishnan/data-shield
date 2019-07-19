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


# Despliegue de imágenes
{: #deploying}

Tras convertir las imágenes, debe desplegar sus contenedores de
{{site.data.keyword.datashield_short}} en el clúster de Kubernetes.
{: shortdesc}

Cuando despliegue {{site.data.keyword.datashield_short}}, la especificación del contenedor debe incluir montajes de volúmenes que permitan que los dispositivos SGX y el socket AESM estén disponibles.

¿No tiene ninguna aplicación con la que probar el servicio? No pasa nada. Ofrecemos varias apps de ejemplo que puede probar, incluyendo MariaDB y NGINX. Como ejemplo se puede utilizar cualquiera de las [imágenes de {{site.data.keyword.datashield_short}}](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter) de IBM Container Registry.
{: tip}

1. Configure [secretos de extracción](/docs/containers?topic=containers-images#other).

2. Guarde la especificación de pod siguiente como plantilla.

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

3. Actualice los campos `your-app-sgx` y `your-registry-server` para su app y servidor.

4. Cree el pod de Kubernetes.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}

