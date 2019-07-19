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


# Implementando imagens
{: #deploying}

Depois de converter suas imagens, deve-se implementar seus contêineres do {{site.data.keyword.datashield_short}} em seu cluster Kubernetes.
{: shortdesc}

Ao implementar o {{site.data.keyword.datashield_short}}, a especificação de contêiner deve incluir montagens do volume que permitem aos dispositivos SGX e ao soquete AESM estarem disponíveis.

Não tem um aplicativo para experimentar o serviço? Sem problema. Oferecemos vários apps de amostra
que você pode experimentar, incluindo o MariaDB e o NGINX. Qualquer uma das [{{site.data.keyword.datashield_short}} imagens](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter) no IBM Container Registry pode ser usada como uma amostra.
{: tip}

1. Configure os [segredos de pull](/docs/containers?topic=containers-images#other).

2. Salve a especificação de pod a seguir como um modelo.

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

3. Atualize os campos `your-app-sgx` e `your-registry-server`
para seu app e seu servidor.

4. Crie o pod do Kubernetes.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}

