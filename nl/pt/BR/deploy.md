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


# Implementando imagens
{: #deploy-containers}

Depois de converter suas imagens, deve-se reimplementar seus contêineres do {{site.data.keyword.datashield_short}} em seu cluster Kubernetes.
{: shortdesc}

Quando você implementa contêineres do {{site.data.keyword.datashield_short}} em seu
cluster Kubernetes, a especificação do contêiner deve incluir montagens de volume. As montagens de
volume permitem que os dispositivos SGX e o soquete AESM estejam disponíveis no contêiner.

Não tem um aplicativo para experimentar o serviço? Sem problema. Oferecemos vários apps de amostra
que você pode experimentar, incluindo o MariaDB e o NGINX. Qualquer uma das [imagens do {{site.data.keyword.datashield_short}}](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter) no IBM Container Registry pode ser usada
como uma amostra.
{: tip}

1. Salve a especificação de pod a seguir como um modelo.

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

2. Atualize os campos `your-app-sgx` e `your-registry-server`
para seu app e seu servidor.

3. Crie o pod do Kubernetes.

   ```
   kubectl create -f template.yml
   ```
  {: pre}

