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


# 部署映像
{: #deploy-containers}

转换映像后，必须将 {{site.data.keyword.datashield_short}} 容器重新部署到 Kubernetes 集群。
{: shortdesc}

将 {{site.data.keyword.datashield_short}} 容器部署到 Kubernetes 集群时，容器规范必须包含卷安装。卷安装允许 SGX 设备和 AESM 套接字在容器中可用。

没有要尝试服务的应用程序吗？不用担心。我们提供了多个可以尝试的样本应用程序，包括 MariaDB 和 NGINX。IBM Container Registry 中的任何 [{{site.data.keyword.datashield_short}} 映像](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)都可以用作样本。
{: tip}

1. 将以下 pod 规范另存为模板。

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

2. 将 `your-app-sgx` 和 `your-registry-server` 字段更新为您的应用程序和服务器。

3. 创建 Kubernetes pod。

   ```
   kubectl create -f template.yml
   ```
  {: pre}

