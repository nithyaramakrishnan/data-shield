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


# 이미지 배치
{: #deploying}

이미지를 변환한 후 Kubernetes 클러스터에 {{site.data.keyword.datashield_short}} 컨테이너를 배치해야 합니다.
{: shortdesc}

{{site.data.keyword.datashield_short}}를 배치할 때 컨테이너 스펙에 SGX 디바이스 및 AESM 소켓이 사용 가능한 볼륨 마운트가 있어야 합니다.

서비스를 시도할 애플리케이션이 없습니까? 없어도 문제 없습니다. 당사에서는 MariaDB 및 NGINX를 포함해 사용해 볼 수 있는 여러 샘플 앱을 제공합니다. IBM Container Registry의 모든 [{{site.data.keyword.datashield_short}} 이미지](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter)는 샘플로 사용할 수 있습니다.
{: tip}

1. [풀(pull) 시크릿](/docs/containers?topic=containers-images#other)을 구성하십시오.

2. 다음 팟(Pod) 스펙을 템플리트로 저장하십시오.

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

3. 필드 `your-app-sgx` 및 `your-registry-server`를 앱과 서버로 업데이트하십시오.

4. Kubernetes 팟(Pod)을 작성하십시오.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}

