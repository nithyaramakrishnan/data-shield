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

# 설치
{: #install}

제공된 Helm 차트를 사용하거나 제공된 설치 프로그램을 사용하여 {{site.data.keyword.datashield_full}}를 설치할 수 있습니다. 가장 편한 설치 명령을 사용하여 작업할 수 있습니다.
{: shortdesc}

## 시작하기 전에
{: #begin}

{{site.data.keyword.datashield_short}}에 대한 작업을 시작하려면 먼저 다음 전제조건을 충족해야 합니다. CLI 및 플러그인 다운로드 또는 Kubernetes Service 환경 구성에 대한 도움을 받으려면 튜토리얼 [Kubernetes 클러스터 작성](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)을 참조하십시오.

* CLI는 다음과 같습니다.

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* [{{site.data.keyword.cloud_notm}} CLI 플러그인](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)은 다음과 같습니다.

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* SGX 사용 Kubernetes 클러스터입니다. 현재 노드 유형이 mb2c.4x32인 베어메탈 클러스터에서 SGX를 사용할 수 있습니다. 없는 경우 다음 단계를 사용하여 필요한 클러스터를 작성할 수 있습니다.
  1. [클러스터 작성](/docs/containers?topic=containers-clusters#cluster_prepare)을 준비하십시오.

  2. 클러스터 작성에 [필요한 권한](/docs/containers?topic=containers-users)이 있는지 확인하십시오.

  3. [클러스터](/docs/containers?topic=containers-clusters)를 작성하십시오.

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} 서비스 버전 0.5.0 이상의 인스턴스입니다. Helm을 사용하여 인스턴스를 설치하기 위해 다음 명령을 실행할 수 있습니다.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Data Shield에 대한 로깅 정보를 보려고 합니까? 클러스터의 {{site.data.keyword.la_full_notm}} 인스턴스를 설정하십시오.
{: tip}


## Helm을 사용한 설치
{: #install-chart}

제공된 Helm 차트를 사용하여 SGX 사용 베어메탈 클러스터에 {{site.data.keyword.datashield_short}}를 설치할 수 있습니다.
{: shortdesc}

Helm 차트는 다음 컴포넌트를 설치합니다.

*	SGX에 대한 지원 소프트웨어. 권한 있는 컨테이너에 의해 베어메탈 호스트에 설치됩니다.
*	{{site.data.keyword.datashield_short}} 엔클레이브 관리자. {{site.data.keyword.datashield_short}} 환경에서 SGX 엔클레이브를 관리합니다.
*	EnclaveOS® 컨테이너 변환 서비스. 컨테이너화된 애플리케이션이 {{site.data.keyword.datashield_short}} 환경에서 실행될 수 있게 합니다.


클러스터에 {{site.data.keyword.datashield_short}}를 설치하려면 다음을 수행하십시오.

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

  2. `export`로 시작하는 출력을 복사하고 터미널에 붙여넣어 `KUBECONFIG` 환경 변수를 설정하십시오.

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

6. [백업 및 복원](/docs/services/data-shield?topic=data-shield-backup-restore) 기능 설정에 필요한 정보를 가져오십시오. 

7. Tiller에 대한 역할 바인딩 정책을 작성하여 Helm을 초기화하십시오. 

  1. Tiller에 대한 서비스 계정을 생성하십시오.
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. 역할 바인딩을 작성하여 클러스터에 Tiller 관리자 액세스를 지정하십시오.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Helm을 초기화하십시오.

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  `--tls` 모드를 사용하도록 Helm을 구성할 수 있습니다. TLS 사용에 대한 도움을 받으려면 [Helm 저장소](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}를 참조하십시오. TLS를 사용으로 설정하는 경우, 실행하는 모든 Helm 명령에 `--tls`를 추가하십시오. IBM Cloud Kubernetes Service에서 Helm 사용에 대한 자세한 정보는 [Helm 차트를 사용하여 서비스 추가](/docs/containers?topic=containers-helm#public_helm_install)를 참조하십시오.
  {: tip}

8. 차트를 설치하십시오.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  변환기에 대해 [{{site.data.keyword.cloud_notm}} Container Registry를 구성](/docs/services/data-shield?topic=data-shield-convert)한 경우 `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`를 추가해야 합니다.
  {: note}

9. 컴포넌트 시작을 모니터하기 위해 다음 명령을 실행할 수 있습니다.

  ```
  kubectl get pods
  ```
  {: codeblock}



## 설치 프로그램을 사용한 설치
{: #installer}

설치 프로그램을 사용하여 SGX 사용 베어메탈 클러스터에 {{site.data.keyword.datashield_short}}를 신속하게 설치할 수 있습니다.
{: shortdesc}

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. 클러스터의 컨텍스트를 설정하십시오.

  1. 명령을 사용하여 환경 변수를 설정하고 Kubernetes 구성 파일을 다운로드하십시오.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. 출력을 복사하여 콘솔에 붙여넣으십시오.

3. Container Registry CLI에 로그인하십시오.

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. 로컬 시스템으로 이미지를 가져오십시오.

  ```
  docker pull <region>.icr.io/ibm/datashield-installer
  ```
  {: codeblock}

5. 다음 명령을 실행하여 {{site.data.keyword.datashield_short}}를 설치하십시오.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  최신 버전의 {{site.data.keyword.datashield_short}}를 설치하려면 `--version` 플래그에 `latest`를 사용하십시오.

