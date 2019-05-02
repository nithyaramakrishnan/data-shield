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

# 시작하기 튜토리얼
{: #getting-started}

Fortanix® 기반 {{site.data.keyword.datashield_full}}를 사용하면 데이터가 사용 중일 때 {{site.data.keyword.cloud_notm}}에서 실행되는 컨테이너 워크로드의 데이터를 보호할 수 있습니다.
{: shortdesc}

{{site.data.keyword.datashield_short}}에 대한 자세한 정보 및 사용 중인 데이터를 보호하는 의미는 [서비스 정보](/docs/services/data-shield?topic=data-shield-about#about)에서 알아볼 수 있습니다.

## 시작하기 전에
{: #gs-begin}

{{site.data.keyword.datashield_short}}에 대한 작업을 시작하려면 먼저 다음 전제조건을 충족해야 합니다. CLI 및 플러그인 다운로드 또는 Kubernetes Service 환경 구성에 대한 도움을 받으려면 튜토리얼 [Kubernetes 클러스터 작성](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)을 참조하십시오.

* CLI는 다음과 같습니다.

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  `--tls` 모드를 사용하도록 Helm을 구성할 수 있습니다. TLS 사용에 대한 도움을 받으려면 [Helm 저장소](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)를 참조하십시오. TLS를 사용으로 설정하는 경우, 실행하는 모든 Helm 명령에 `--tls`를 추가하십시오.
  {: tip}

* [{{site.data.keyword.cloud_notm}} CLI 플러그인](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)은 다음과 같습니다.

  * Kubernetes Service
  * Container Registry

* SGX 사용 Kubernetes 클러스터입니다. 현재 노드 유형이 mb2c.4x32인 베어메탈 클러스터에서 SGX를 사용할 수 있습니다. 없는 경우 다음 단계를 사용하여 필요한 클러스터를 작성할 수 있습니다.
  1. [클러스터 작성](/docs/containers?topic=containers-clusters#cluster_prepare)을 준비하십시오.

  2. 클러스터 작성에 [필요한 권한](/docs/containers?topic=containers-users#users)이 있는지 확인하십시오.

  3. [클러스터](/docs/containers?topic=containers-clusters#clusters)를 작성하십시오.

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 서비스 버전 0.5.0 이상의 인스턴스입니다. 기본 설치는 <code>cert-manager</code>를 사용하여 {{site.data.keyword.datashield_short}} 서비스 간 내부 통신을 위한 [TLS 인증서](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates)를 설정합니다. Helm을 사용하여 인스턴스를 설치하기 위해 다음 명령을 실행할 수 있습니다.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Helm 차트를 사용한 설치
{: #gs-install-chart}

제공된 Helm 차트를 사용하여 SGX 사용 베어메탈 클러스터에 {{site.data.keyword.datashield_short}}를 설치할 수 있습니다.
{: shortdesc}

Helm 차트는 다음 컴포넌트를 설치합니다.

*	SGX에 대한 지원 소프트웨어. 권한 있는 컨테이너에 의해 베어메탈 호스트에 설치됩니다.
*	{{site.data.keyword.datashield_short}} 엔클레이브 관리자. {{site.data.keyword.datashield_short}} 환경에서 SGX 엔클레이브를 관리합니다.
*	EnclaveOS® 컨테이너 변환 서비스. 컨테이너화된 애플리케이션이 {{site.data.keyword.datashield_short}} 환경에서 실행될 수 있게 합니다.

Helm 차트를 설치하는 경우 설치를 사용자 정의하기 위한 여러 옵션과 매개변수가 있습니다. 다음 튜토리얼에서는 가장 기본적인 차트 기본 설치에 대해 설명합니다. 옵션에 대한 자세한 정보는 [{{site.data.keyword.datashield_short}} 설치](/docs/services/data-shield?topic=data-shield-deploying)를 참조하십시오.
{: tip}

클러스터에 {{site.data.keyword.datashield_short}}를 설치하려면 다음을 수행하십시오.

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>지역</th>
      <th>IBM Cloud 엔드포인트</th>
      <th>Kubernetes Service 지역</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>미국 남부</td>
    </tr>
    <tr>
      <td>프랑크푸르트</td>
      <td><code>eu-de</code></td>
      <td>유럽 연합 중앙</td>
    </tr>
    <tr>
      <td>시드니</td>
      <td><code>au-syd</code></td>
      <td>AP 남부</td>
    </tr>
    <tr>
      <td>런던</td>
      <td><code>eu-gb</code></td>
      <td>영국 남부</td>
    </tr>
    <tr>
      <td>도쿄</td>
      <td><code>jp-tok</code></td>
      <td>AP 북부</td>
    </tr>
    <tr>
      <td>워싱턴 DC</td>
      <td><code>us-east</code></td>
      <td>미국 동부</td>
    </tr>
  </table>

2. 클러스터의 컨텍스트를 설정하십시오.

  1. 명령을 사용하여 환경 변수를 설정하고 Kubernetes 구성 파일을 다운로드하십시오.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. `export`로 시작하는 출력을 복사하고 터미널에 붙여넣어 `KUBECONFIG` 환경 변수를 설정하십시오.

3. 아직 없는 경우 `ibm` 저장소를 추가하십시오.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. 선택사항: 관리자 또는 관리 계정 ID와 연관된 이메일을 모르는 경우 다음 명령을 실행하십시오.

  ```
  ibmcloud account show
  ```
  {: pre}

5. 클러스터의 Ingress 하위 도메인을 가져오십시오.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. 차트를 설치하십시오.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  변환기에 대해 [{{site.data.keyword.cloud_notm}} Container Registry를 구성](/docs/services/data-shield?topic=data-shield-convert#convert)한 경우 다음 옵션을 추가할 수 있습니다. `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. 컴포넌트 시작을 모니터하기 위해 다음 명령을 실행할 수 있습니다.

  ```
  kubectl get pods
  ```
  {: pre}


## 다음 단계
{: #gs-next}

잘하셨습니다. 이제 클러스터에 서비스가 설치되었으므로 {{site.data.keyword.datashield_short}} 환경에서 앱을 실행할 수 있습니다. 

{{site.data.keyword.datashield_short}} 환경에서 앱을 실행하려면 컨테이너 이미지를 [변환](/docs/services/data-shield?topic=data-shield-convert#convert)하고, [화이트리스트로 지정](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist)한 다음 [배치](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers)해야 합니다.

배치할 고유 이미지가 없는 경우 사전 패키지된 {{site.data.keyword.datashield_short}} 이미지 중 하나를 배치하십시오.

* [{{site.data.keyword.datashield_short}} Examples GitHub repo](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* {{site.data.keyword.cloud_notm}} Container Registry의 MariaDB 또는 NGINX
