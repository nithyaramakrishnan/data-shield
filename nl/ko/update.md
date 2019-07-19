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

# 업데이트
{: #update}

클러스터에 {{site.data.keyword.datashield_short}}가 설치되면 언제든 업데이트할 수 있습니다.
{: shortdesc}

## 클러스터 컨텍스트 설정
{: #update-context}

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오. 연합 ID가 있는 경우 명령 끝에 `--sso` 옵션을 추가하십시오.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. 클러스터의 컨텍스트를 설정하십시오.

  1. 명령을 사용하여 환경 변수를 설정하고 Kubernetes 구성 파일을 다운로드하십시오.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. 출력을 복사하여 콘솔에 붙여넣으십시오.

3. 아직 없는 경우 `iks-charts` 저장소를 추가하십시오.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. 선택사항: 관리자 또는 관리 계정 ID와 연관된 이메일을 모르는 경우 다음 명령을 실행하십시오.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. 클러스터의 Ingress 하위 도메인을 가져오십시오.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

## Helm을 사용한 업데이트
{: #update-helm}

Helm 차트를 사용하여 최신 버전으로 업데이트하려면 다음 명령을 실행하십시오.

  ```
  helm upgrade <chart-name> ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

## 설치 프로그램을 사용하여 업데이트
{: #update-installer}

설치 프로그램을 사용하여 최신 버전으로 업데이트하려면 다음 명령을 실행하십시오.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer upgrade [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ] [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  최신 버전의 {{site.data.keyword.datashield_short}}를 설치하려면 `--version` 플래그에 `latest`를 사용하십시오.


