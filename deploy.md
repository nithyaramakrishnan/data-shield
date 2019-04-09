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


# Deploying images
{: #deploy-containers}

After you convert your images, you must redeploy your {{site.data.keyword.datashield_short}} containers to your Kubernetes cluster.
{: shortdesc}

When you deploy {{site.data.keyword.datashield_short}} containers to your Kubernetes cluster, the container specification must include volume mounts. The volume mounts allow the SGX devices and the AESM socket to be available in the container.

Don't have an application to try the service? No problem. We offer several sample apps that you can try, including MariaDB and NGINX. Any of the [{{site.data.keyword.datashield_short}} images](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter) in IBM Container Registry can be used as a sample.
{: tip}

1. Save the following pod specification as a template.

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

2. Update the fields `your-app-sgx` and `your-registry-server` to your app and server.

3. Create the Kubernetes pod.

   ```
   kubectl create -f template.yml
   ```
  {: pre}

