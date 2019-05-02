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


# イメージのデプロイ
{: #deploy-containers}

イメージを変換したら、{{site.data.keyword.datashield_short}} コンテナーを Kubernetes クラスターに再デプロイする必要があります。
{: shortdesc}

{{site.data.keyword.datashield_short}} コンテナーを Kubernetes クラスターにデプロイする際、コンテナーの仕様にはボリューム・マウントが含まれている必要があります。ボリューム・マウントを使用することによって、コンテナーで SGX デバイスと AESM ソケットを使用できるようになります。

このサービスを試用するためのアプリケーションをお持ちではないですか? 問題ありません。MariaDB や NGINX など、試用できるサンプル・アプリがいくつも用意されています。IBM Container Registry にある [{{site.data.keyword.datashield_short}} イメージ](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)をサンプルとして自由に使用できます。
{: tip}

1. 次のポッド仕様をテンプレートとして保存します。

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

2. `your-app-sgx` および `your-registry-server` の各フィールドをご使用のアプリとサーバーに合わせて更新します。

3. Kubernetes ポッドを作成します。

   ```
   kubectl create -f template.yml
   ```
  {: pre}

