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

# 설치 제거
{: #uninstall}

{{site.data.keyword.datashield_full}}를 더 이상 사용할 필요가 없는 경우 작성된 TLS 인증서 및 서비스를 삭제할 수 있습니다.


## Helm을 사용하여 설치 제거

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
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

  2. 출력을 복사하여 터미널에 붙여넣으십시오.

3. 서비스를 삭제하십시오.

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. 다음 명령을 각각 실행하여 TLS 인증서를 삭제하십시오.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. 설치 제거 프로세스는 Helm "후크"를 사용하여 설치 제거 프로그램을 실행합니다. 실행 후 설치 제거 프로그램을 삭제할 수 있습니다.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

`cert-manager` 인스턴스 및 Docker 구성 시크릿을 삭제할 있습니다(작성한 경우).
{: tip}



## 베타 설치 프로그램을 사용하여 설치 제거
{: #uninstall-installer}

베타 설치 프로그램을 사용하여 {{site.data.keyword.datashield_short}}를 설치한 경우 설치 프로그램을 사용하여 서비스를 설치 제거할 수도 있습니다.

{{site.data.keyword.datashield_short}}를 설치 제거하려면 `ibmcloud` CLI에 로그인하고 클러스터를 대상으로 지정하고 다음 명령을 실행하십시오.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
