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


# Images bereitstellen
{: #deploying}

Nachdem Sie Ihre Images konvertiert haben, müssen Sie Ihre {{site.data.keyword.datashield_short}}-Container in Ihrem Kubernetes-Cluster bereitstellen.
{: shortdesc}

Bei der Bereitstellung von {{site.data.keyword.datashield_short}} muss die Containerspezifikation die Datenträgermounts beinhalten, die es ermöglichen, dass die SGX-Einheiten und der AESM-Socket verfügbar sind.

Sie haben keine Anwendung, um den Service zu testen? Kein Problem. Wir bieten verschiedene Beispielapps an, die Sie ausprobieren können, einschließlich MariaDB und NGINX. Jedes der [{{site.data.keyword.datashield_short}}-Images](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter) in IBM Container Registry kann als Beispiel verwendet werden.
{: tip}

1. Konfigurieren Sie [geheime Schlüssel für Pull-Operationen](/docs/containers?topic=containers-images#other).

2. Speichern Sie die folgende Pod-Spezifikation als Vorlage.

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

3. Aktualisieren Sie die Felder `your-app-sgx` und `your-registry-server` entsprechend Ihrer App und Ihrem Server.

4. Erstellen Sie das Kubernetes-Pod.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}

