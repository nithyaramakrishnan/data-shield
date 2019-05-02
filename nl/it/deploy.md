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


# Distribuzione di immagini
{: #deploy-containers}

Dopo che hai convertito le tue immagini, devi distribuire nuovamente i tuoi contenitori {{site.data.keyword.datashield_short}} al tuo cluster Kubernetes.
{: shortdesc}

Quando distribuisci i contenitori {{site.data.keyword.datashield_short}} al tuo cluster Kubernetes, la specifica del contenitore deve includere i montaggi di volume. I montaggi di volume consentono ai dispositivi SGX e al socket AESM di essere disponibile nel contenitore.

Non hai un'applicazione per provare il servizio? Nessun problema. Offriamo diverse applicazioni di esempio che puoi provare, tra cui MariaDB e NGINX. Come un esempio, puoi utilizzare qualsiasi [{{site.data.keyword.datashield_short}} immagine](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter) in IBM Container Registry.
{: tip}

1. Salva la seguente specifica del pod come template.

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

2. Aggiorna i campi `your-app-sgx` e `your-registry-server` alla tua applicazione e al tuo server.

3. Crea il pod Kubernetes.

   ```
   kubectl create -f template.yml
   ```
  {: pre}

