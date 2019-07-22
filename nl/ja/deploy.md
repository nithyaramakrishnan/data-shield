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


# イメージのデプロイ
{: #deploying}

イメージを変換したら、{{site.data.keyword.datashield_short}} コンテナーを Kubernetes クラスターにデプロイする必要があります。
{: shortdesc}

{{site.data.keyword.datashield_short}} をデプロイする際、SGX デバイスと AESM ソケットを使用できるように、コンテナーの仕様にボリューム・マウントが指定されていなければなりません。

このサービスを試用するためのアプリケーションをお持ちではないですか? 問題ありません。 MariaDB や NGINX など、試用できるサンプル・アプリがいくつも用意されています。 IBM Container Registry にある [{{site.data.keyword.datashield_short}} イメージ](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter)をサンプルとして自由に使用できます。
{: tip}

1. [プル・シークレット](/docs/containers?topic=containers-images#other)を構成します。

2. 次のポッド仕様をテンプレートとして保存します。

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

3. `your-app-sgx` および `your-registry-server` の各フィールドをご使用のアプリとサーバーに合わせて更新します。

4. Kubernetes ポッドを作成します。

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}

