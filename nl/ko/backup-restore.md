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


# 백업 및 복원
{: #backup-restore}

엔클레이브 관리자 인스턴스를 백업하고 복원할 수 있습니다.
{: shortdesc}


## 엔클레이브 관리자 인스턴스 백업
{: #backup}

{{site.data.keyword.cos_full_notm}}에 엔클레이브 관리자 데이터베이스를 주기적으로 백업하도록 {{site.data.keyword.datashield_full}}를 구성할 수 있습니다.
{: shortdesc}

데이터 유실 위험을 최소화하려면 둘 이상의 실제 위치에 호스트 등록을 고려하십시오. 이전에 엔클레이브 관리자 클러스터에만 등록된 하드웨어에 엔클레이브 관리자를 복원할 수 있습니다.
{: tip}


1. {{site.data.keyword.cos_short}} 문서의 지시사항을 사용하고 HMAC 인증 정보를 포함하는 옵션을 선택하여 [서비스 ID](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials)를 작성하십시오. 백업 작업에서는 HMAC 인증 정보를 사용하여 {{site.data.keyword.cos_short}}를 인증합니다.

2. {{site.data.keyword.cos_short}} 인증을 위해 인증 정보로 Kubernetes 시크릿을 작성하십시오.
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. Data Shield를 설치하는 경우 `helm install` 명령에, 기존 {{site.data.keyword.datashield_full}} 인스턴스를 업그레이드하는 경우에는 `helm upgrade` 명령에 다음 옵션을 추가하십시오. 사용자 환경에 맞게 다음 값을 수정하십시오. `enclaveos-chart.Backup.CronSchedule`은 cron 구문에 지정된 백업 스케줄입니다. 예를 들어, `0 0 * * *`는 협정 세계시(UTC)로 매일 자정에 백업을 수행합니다. `global.S3.Endpoint`는 작성된 {{site.data.keyword.cos_short}} 버킷의 위치에 해당하며, 이는 [엔드포인트 테이블](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints)에서 찾을 수 있습니다.
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    선택적으로 `enclaveos-chart.Backup.S3Prefix`를 백업을 저장할 {{site.data.keyword.cos_short}} 버킷 내 경로로 설정할 수 있습니다. 기본적으로 백업은 버킷 루트에 저장됩니다.
    {: tip}



## 엔클레이브 관리자 복원
{: #restore}

배치 전에 엔클레이브 관리자의 백업을 작성하도록 Helm 차트를 구성한 경우 문제가 발생하면 이를 복원할 수 있습니다.

1. 이전에 엔클레이브 관리자에서 실행된 노드에서 실행 중인지 확인하십시오. 엔클레이브 관리자 데이터가 SGX 봉인 키를 사용하여 암호화되고, 동일한 하드웨어에서만 복호화될 수 있습니다.

2. 다음 Helm 값을 설정하여 백엔드 서버의 0 인스턴스로 엔클레이브 관리자를 배치하십시오.

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. 엔클레이브 관리자가 배치되면 데이터베이스 컨테이너에 백업을 복사하십시오.

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. 데이터베이스 컨테이너에서 쉘을 작성하십시오.

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. 백업에서 복원할 데이터베이스를 준비하십시오.

    1. SQL 쉘을 작성하십시오.

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. SQL에서 프롬프트가 표시되면 다음 명령을 실행하십시오.

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. 종료하고 다음 명령을 실행하십시오.

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. `enclaveos-chart.Manager.ReplicaCount` 값을 설정하지 않고 `helm upgrade`를 실행하여 엔클레이브 관리자 배치를 확장하십시오.

