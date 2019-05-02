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


# 部署映像檔
{: #deploy-containers}

轉換映像檔之後，您必須將 {{site.data.keyword.datashield_short}} 容器重新部署至 Kubernet 叢集。
{: shortdesc}

將 {{site.data.keyword.datashield_short}} 容器部署至 Kubernetes 叢集時，容器規格必須包括磁區裝載。磁區裝載能夠在容器中提供使用 SGX 裝置和 AESM Socket。

沒有應用程式可嘗試服務嗎？沒問題。我們提供數個您可以嘗試的範例應用程式，包括 MariaDB 及 NGINX。IBM Container Registry 中的任何 [{{site.data.keyword.datashield_short}} 映像檔](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)都可用來作為範例。
{: tip}

1. 將下列 Pod 規格儲存為範本。

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

2. 將 `your-app-sgx` 和 `your-registry-server` 欄位更新為您的應用程式和伺服器。

3. 建立 Kubernetes Pod。

   ```
   kubectl create -f template.yml
   ```
  {: pre}

