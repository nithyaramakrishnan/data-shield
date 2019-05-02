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


# 이미지 배치
{: #deploy-containers}

이미지를 변환한 후 Kubernetes 클러스터에 {{site.data.keyword.datashield_short}} 컨테이너를 재배치해야 합니다.
{: shortdesc}

Kubernetes 클러스터에 {{site.data.keyword.datashield_short}} 컨테이너를 배치할 때 컨테이너 스펙에 볼륨 마운트가 포함되어야 합니다. 볼륨 마운트의 경우 SGX 디바이스와 AESM 소켓을 컨테이너에서 사용할 수 있습니다.

서비스를 시도할 애플리케이션이 없습니까? 없어도 문제 없습니다. 당사에서는 MariaDB 및 NGINX를 포함해 사용해 볼 수 있는 여러 샘플 앱을 제공합니다. IBM Container Registry의 모든 [{{site.data.keyword.datashield_short}} 이미지](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter)는 샘플로 사용할 수 있습니다.
{: tip}

1. 다음 팟(Pod) 스펙을 템플리트로 저장하십시오.

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

2. 필드 `your-app-sgx` 및 `your-registry-server`를 앱과 서버로 업데이트하십시오.

3. Kubernetes 팟(Pod)을 작성하십시오.

   ```
   kubectl create -f template.yml
   ```
  {: pre}

