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


# Images bereitstellen
{: #deploy-containers}

Nachdem Sie Ihre Bilder konvertiert haben, müssen Sie Ihre {{site.data.keyword.datashield_short}}-Container erneut in Ihren Kubernetes-Cluster implementieren.
{: shortdesc}

Wenn Sie {{site.data.keyword.datashield_short}}-Container in Ihrem Kubernetes-Cluster implementieren, muss die Containerspezifikation Datenträgermounts enthalten. Die Datenträgermounts ermöglichen es, dass die SGX-Einheiten und der AESM-Socket im Container verfügbar sind.

Sie haben keine Anwendung, um den Service zu testen? Kein Problem. Wir bieten verschiedene Beispielapps an, die Sie ausprobieren können, einschließlich MariaDB und NGINX. Jedes der [{{site.data.keyword.datashield_short}}-Images](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter) in IBM Container Registry kann als Beispiel verwendet werden.
{: tip}

1. Speichern Sie die folgende Pod-Spezifikation als Vorlage.

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

2. Aktualisieren Sie die Felder `your-app-sgx` und `your-registry-server` entsprechend Ihrer App und Ihrem Server.

3. Erstellen Sie das Kubernetes-Pod.

   ```
   kubectl create -f template.yml
   ```
  {: pre}

