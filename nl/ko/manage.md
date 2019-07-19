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

# 엔클레이브 관리자 사용
{: #enclave-manager}

엔클레이브 관리자 UI를 사용하여 {{site.data.keyword.datashield_full}}로 보호하는 애플리케이션을 관리할 수 있습니다. UI에서 앱 배치를 관리하고 액세스를 지정하며 화이트리스트 요청을 처리하고 애플리케이션을 변환할 수 있습니다.
{: shortdesc}


## 로그인
{: #em-signin}

엔클레이브 관리자 콘솔에서 클러스터의 노드 및 해당 증명 상태를 볼 수 있습니다. 또한 클러스터 이벤트의 감사 로그 및 태스크를 볼 수 있습니다. 시작하려면 로그인하십시오.
{: shortdesc}

1. [올바른 액세스 권한](/docs/services/data-shield?topic=data-shield-access)이 있는지 확인하십시오.

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

3. 모든 팟(Pod)이 *활성* 상태인지 확인하여 모든 서비스가 실행 중인지 확인하십시오.

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

7. 터미널에서 IAM 토큰을 가져오십시오.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. 토큰을 복사하여 엔클레이브 관리자 GUI에 붙여넣으십시오. 인쇄된 토큰의 `Bearer` 부분은 복사하지 않아도 됩니다.

9. **로그인**을 클릭하십시오.






## 노드 관리
{: #em-nodes}

엔클레이브 관리자 UI를 사용하여 상태를 모니터하고 클러스터에서 IBM Cloud Data Shield를 실행하는 노드의 인증서를 비활성화하거나 다운로드할 수 있습니다.
{: shortdesc}


1. 엔클레이브 관리자에 로그인하십시오.

2. **노드** 탭으로 이동하십시오.

3. 검사할 노드의 IP 주소를 클릭하십시오. 정보 화면이 열립니다.

4. 정보 화면에서 노드를 비활성화하거나 사용된 인증서를 다운로드하도록 선택할 수 있습니다.




## 애플리케이션 배치
{: #em-apps}

엔클레이브 관리자 UI를 사용하여 애플리케이션을 배치할 수 있습니다.
{: shortdesc}


### 앱 추가
{: #em-app-add}

엔클레이브 관리자 UI를 사용하여 모든 애플리케이션을 동시에 변환하고 배치하고 화이트리스트로 지정할 수 있습니다.
{: shortdesc}

1. 엔클레이브 관리자에 로그인하고 **앱** 탭으로 이동하십시오.

2. **애플리케이션 새로 추가**를 클릭하십시오.

3. 애플리케이션에 이름과 설명을 제공하십시오.

4. 이미지의 입력 및 출력 이름을 입력하십시오. 입력은 현재 애플리케이션 이름입니다. 출력은 변환된 애플리케이션을 찾을 수 있는 위치입니다.

5. **ISVPRDID** 및 **ISVSVN**을 입력하십시오.

6. 허용된 도메인을 입력하십시오.

7. 변경할 고급 설정을 편집하십시오.

8. **새 애플리케이션 작성**을 클릭하십시오. 애플리케이션이 화이트리스트에 배치되고 추가됩니다. **태스크** 탭에서 빌드 요청을 승인할 수 있습니다.




### 앱 편집
{: #em-app-edit}

목록에 애플리케이션을 추가한 후 편집할 수 있습니다.
{: shortdesc}


1. 엔클레이브 관리자에 로그인하고 **앱** 탭으로 이동하십시오.

2. 편집할 애플리케이션의 이름을 클릭하십시오. 인증서 및 배치된 빌드가 포함된 구성을 검토할 수 있는 새 화면이 열립니다.

3. **애플리케이션 편집**을 클릭하십시오.

4. 작성할 구성을 업데이트하십시오. 변경 전에 고급 설정 변경이 애플리케이션에 영향을 주는 방식을 이해해야 합니다.

5. **애플리케이션 편집**을 클릭하십시오.


## 애플리케이션 빌드
{: #em-builds}

변경 후 엔클레이브 관리자 UI를 사용하여 애플리케이션을 다시 빌드할 수 있습니다.
{: shortdesc}

1. 엔클레이브 관리자에 로그인하고 **빌드** 탭으로 이동하십시오.

2. **새 빌드 작성**을 클릭하십시오.

3. 드롭 다운 목록에서 애플리케이션을 선택하거나 애플리케이션을 추가하십시오.

4. Docker 이미지의 이름을 입력하거나 구체적으로 태그를 지정하십시오. 

5. **빌드**를 클릭하십시오. 빌드가 화이트리스트에 추가됩니다. **태스크** 탭에서 빌드를 승인할 수 있습니다.



## 태스크 승인
{: #em-tasks}

애플리케이션이 화이트리스트로 지정되면 엔클레이브 관리자 UI의 **태스크** 탭에서 보류 중인 요청 목록에 추가됩니다. UI를 사용하여 요청을 승인하거나 거부할 수 있습니다.
{: shortdesc}

1. 엔클레이브 관리자에 로그인하고 **태스크** 탭으로 이동하십시오.

2. 승인하거나 거부할 요청이 포함된 행을 클릭하십시오. 자세한 정보가 있는 화면이 열립니다.

3. 요청을 검토하고 **승인** 또는 **거부**를 클릭하십시오. 이름이 **검토자** 목록에 추가됩니다.


## 로그 보기
{: #em-view}

여러 유형의 활동에 대한 엔클레이브 관리자 인스턴스를 감사할 수 있습니다.
{: shortdesc}

1. 엔클레이브 관리자 UI의 **감사 로그** 탭으로 이동하십시오.
2. 로깅 결과를 필터링하여 검색 범위를 좁히십시오. 다음 유형 중 하나 또는 시간 범위를 기준으로 필터링하도록 선택할 수 있습니다.

  * 앱 상태: 화이트리스트 요청 및 새 빌드와 같은 애플리케이션 관련 활동입니다.
  * 사용자 승인: 계정 사용 승인 또는 거부와 같은 사용자 액세스 관련 활동입니다.
  * 노드 증명: 노드 증명 관련 활동입니다.
  * 인증 기관: 인증 기관 관련 활동입니다.
  * 관리: 관리 관련 활동입니다. 

한 달 넘게 로그 레코드를 보관하려는 경우 정보를 `.csv` 파일로 내보낼 수 있습니다.

