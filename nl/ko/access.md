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

# 액세스 지정
{: #access}

{{site.data.keyword.datashield_full}} 엔클레이브 관리자에 대한 액세스를 제어할 수 있습니다. 이 유형의 액세스 제어는 {{site.data.keyword.cloud_notm}}에서 작업할 때 사용하는 일반적 Identity and Access Management(IAM) 역할과 구분됩니다.
{: shortdesc}


## 클러스터 액세스 지정
{: #access-cluster}

엔클레이브 관리자에 로그인하려면 엔클레이브 관리자가 실행 중인 클러스터에 대한 액세스 권한이 있어야 합니다.
{: shortdesc}

1. 로그인할 클러스터를 호스팅하는 계정에 로그인하십시오.

2. **관리 > 액세스(IAM) > 사용자**로 이동하십시오.

3. **사용자 초대**를 클릭하십시오.

4. 추가할 사용자의 이메일 주소를 제공하십시오.

5. **액세스 지정** 드롭 다운에서 **리소스**를 선택하십시오.

6. **서비스** 드롭 다운에서 **Kubernetes Service**를 선택하십시오.

7. **지역**, **클러스터** 및 **네임스페이스**를 선택하십시오.

8. [클러스터 액세스 지정](/docs/containers?topic=containers-users)의 Kubernetes Service 문서를 안내서로 사용하여 사용자가 태스크를 완료하는 데 필요한 액세스를 지정하십시오.

9. **저장**을 클릭하십시오.

## 엔클레이브 관리자 사용자의 역할 설정
{: #enclave-roles}

{{site.data.keyword.datashield_short}} 관리는 엔클레이브 관리자에서 이루어집니다. 관리자에게는 자동으로 *관리자* 역할이 지정되지만 이 관리자가 다른 사용자에게 역할을 지정할 수도 있습니다.
{: shortdesc}

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


### 사용자 추가
{: #set-roles}

엔클레이브 관리자 GUI를 사용하여 정보에 대한 새 사용자 액세스를 제공할 수 있습니다.
{: shortdesc}

1. 엔클레이브 관리자에 로그인하십시오.

2. **이름 > 설정**을 클릭하십시오.

3. **사용자 추가**를 클릭하십시오.

4. 사용자의 이메일 및 이름을 입력하십시오. **역할** 드롭 다운에서 역할을 선택하십시오.

5. **저장**을 클릭하십시오.



### 사용자 업데이트
{: #update-roles}

사용자 및 해당 이름에 지정된 역할을 업데이트할 수 있습니다.
{: shortdesc}

1. [엔클레이브 관리자 UI](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin)에 로그인하십시오.

2. **이름 > 설정**을 클릭하십시오.

3. 편집하려는 권한을 가진 사용자 위에 마우스 포인터를 올리십시오. 연필 아이콘이 표시됩니다.

4. 연필 아이콘을 클릭하십시오. 사용자 편집 화면이 열립니다.

5. **역할** 드롭 다운에서 지정할 역할을 선택하십시오.

6. 사용자 이름을 업데이트하십시오.

7. **저장**을 클릭하십시오. 사용자 권한에 대한 모든 변경사항이 즉시 적용됩니다.


