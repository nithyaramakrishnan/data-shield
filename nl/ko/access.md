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

# 액세스 관리
{: #access}

{{site.data.keyword.datashield_full}} 엔클레이브 관리자에 대한 액세스를 제어할 수 있습니다. 이 액세스 제어는 {{site.data.keyword.cloud_notm}}에서 작업할 때 사용하는 일반적 Identity and Access Management(IAM) 역할과 구분됩니다.
{: shortdesc}


## IAM API 키를 사용하여 콘솔에 로그인
{: #access-iam}

엔클레이브 관리자 콘솔에서 클러스터의 노드 및 해당 증명 상태를 볼 수 있습니다. 또한 클러스터 이벤트의 감사 로그 및 태스크를 볼 수 있습니다.

1. IBM Cloud CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

  2. `export`로 시작하는 출력을 복사하고 터미널에 붙여넣어 `KUBECONFIG` 환경 변수를 설정하십시오.

3. 모든 팟(Pod)이 *실행 중* 상태인지 확인하여 모든 서비스가 실행 중인지 확인하십시오.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. 다음 명령을 실행하여 엔클레이브 관리자의 프론트 엔드 URL을 검색하십시오.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Ingress 하위 도메인을 얻으십시오.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. 브라우저에서 엔클레이브 관리자가 사용 가능한 Ingress 하위 도메인을 입력하십시오.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

8. 터미널에서 IAM 토큰을 가져오십시오.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. 토큰을 복사하여 엔클레이브 관리자 GUI에 붙여넣으십시오. 인쇄된 토큰의 `Bearer` 부분은 복사하지 않아도 됩니다.

9. **로그인**을 클릭하십시오.


## 엔클레이브 관리자 사용자의 역할 설정
{: #enclave-roles}

{{site.data.keyword.datashield_short}} 관리는 엔클레이브 관리자에서 이루어집니다. 관리자에게는 자동으로 *관리자* 역할이 지정되지만 이 관리자가 다른 사용자에게 역할을 지정할 수도 있습니다.
{: shortdesc}

이러한 역할은 {{site.data.keyword.cloud_notm}} 서비스에 대한 액세스를 제어하는 데 사용되는 플랫폼 IAM 역할과 다르다는 점에 유의하십시오. {{site.data.keyword.containerlong_notm}}의 액세스 구성에 대한 자세한 정보는 [클러스터 액세스 지정](/docs/containers?topic=containers-users#users)을 참조하십시오.
{: tip}

다음 표를 참조하여 지원되는 역할 및 각 사용자가 수행할 수 있는 몇 가지 조치 예를 확인하십시오.

<table>
  <tr>
    <th>역할</th>
    <th>조치</th>
    <th>예</th>
  </tr>
  <tr>
    <td>독자</td>
    <td>노드, 빌드, 사용자 정보, 앱, 태스크 및 감사 로그 보기와 같은 읽기 전용 조치를 수행할 수 있습니다.</td>
    <td>노드 증명 인증서를 다운로드합니다.</td>
  </tr>
  <tr>
    <td>작성자</td>
    <td>독자가 수행할 수 있는 조치 및 노드 증명 비활성화와 갱신, 빌드 추가, 조치나 태스크 승인 또는 거부 등의 조치를 수행할 수 있습니다.</td>
    <td>애플리케이션을 인증합니다.</td>
  </tr>
  <tr>
    <td>관리자</td>
    <td>작성자가 수행할 수 있는 조치 및 사용자 이름과 역할 업데이트, 클러스터에 사용자 추가, 클러스터 설정 업데이트 및 기타 권한 있는 조치를 수행할 수 있습니다.</td>
    <td>사용자 역할을 업데이트합니다.</td>
  </tr>
</table>

### 사용자 역할 설정
{: #set-roles}

콘솔 관리자의 사용자 역할을 설정하거나 업데이트할 수 있습니다.
{: shortdesc}

1. [엔클레이브 관리자 UI](/docs/services/data-shield?topic=data-shield-access#access-iam)로 이동하십시오.
2. 드롭 다운 메뉴에서 사용자 관리 화면을 여십시오.
3. **설정**을 선택하십시오. 사용자 목록을 검토하거나 이 화면에서 사용자를 추가할 수 있습니다.
4. 사용자 권한을 편집하려면 연필 아이콘이 표시될 때까지 사용자 위로 마우스 포인터를 이동하십시오.
5. 연필 아이콘을 클릭하여 해당 권한을 변경하십시오. 사용자 권한에 대한 모든 변경사항이 즉시 적용됩니다.
