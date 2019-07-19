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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# 문제점 해결
{: #troubleshooting}

{{site.data.keyword.datashield_full}} 관련 작업을 수행하는 동안 문제점이 발생하면 문제점을 해결하고 지원을 받기 위한 방법을 고려하십시오.
{: shortdesc}

## 도움 및 지원 받기
{: #gettinghelp}

도움말은 문서에서 또는 포럼을 통해 질문하여 정보를 검색할 수 있습니다. 또한 지원 티켓을 열 수도 있습니다. 포럼을 사용하여 질문하는 경우 {{site.data.keyword.cloud_notm}} 개발 팀에서 볼 수 있도록 질문에 태그를 지정하십시오.
  * {{site.data.keyword.datashield_short}}에 대한 기술적 질문이 있는 경우, <a href="https://stackoverflow.com" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="외부 링크 아이콘"></a>에 질문을 게시하고 질문에 "ibm-data-shield"로 태그를 지정하십시오.
  * 서비스에 대한 질문과 시작하기 지시사항은 <a href="https://developer.ibm.com/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="외부 링크 아이콘"></a> 포럼을 사용하십시오. `data-shield` 태그를 포함하십시오.

지원 받기에 대한 자세한 정보는 [필요한 지원을 받는 방법](/docs/get-support?topic=get-support-getting-customer-support)을 참조하십시오.


## 로그 확보
{: #ts-logs}

IBM Cloud Data Shield에 대한 지원 티켓을 여는 경우 로그를 제공하면 문제점 해결 프로세스를 가속화할 수 있습니다. 다음 단계를 사용하여 로그를 확보한 다음 작성 시 문제에 붙여넣을 수 있습니다.

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

3. 다음 명령을 실행하여 로그를 확보하십시오.

  ```
  kubectl logs --all-containers=true --selector release=$(helm list | grep 'data-shield' | awk {'print $1'}) > logs
  ```
  {: codeblock}


## 엔클레이브 관리자 UI에 로그인할 수 없음
{: #ts-log-in}

{: tsSymptoms}
엔클레이브 관리자 UI에 액세스하려고 시도하지만 로그인할 수 없습니다.

{: tsCauses}
다음 이유로 로그인에 실패할 수 있습니다.

* 엔클레이브 관리자 클러스터에 액세스할 수 있는 권한이 없는 이메일 ID를 사용하고 있습니다.
* 사용 중인 토큰이 만료되었습니다.

{: tsResolve}
문제를 해결하려면 올바른 이메일 ID를 사용 중인지 확인하십시오. 예인 경우 이메일에 엔클레이브 관리자에게 액세스할 수 있는 올바른 권한이 있는지 확인하십시오. 올바른 권한이 있는 경우에는 액세스 토큰이 만료되었을 수 있습니다. 토큰은 한 번에 60분 동안 유효합니다. 토큰을 새로 얻으려면 `ibmcloud iam oauth-tokens`를 실행하십시오. 여러 IBM Cloud 계정이 있는 경우 엔클레이브 관리자 클러스터의 올바른 계정으로 CLI에 로그인된 계정을 확인하십시오.


## 컨테이너 변환기 API가 금지됨 오류를 리턴함
{: #ts-converter-forbidden-error}

{: tsSymptoms}
컨테이너 변환기를 실행하려는 중에 다음 오류가 발생합니다. `Forbidden`.

{: tsCauses}
IAM 또는 Bearer 토큰이 누락되었거나 만료된 경우에는 변환기에 액세스할 수 없습니다.

{: tsResolve}
문제를 해결하려면 요청의 헤더에서 IBM IAM OAuth 토큰 또는 엔클레이브 관리자 인증 토큰을 사용하고 있는지 확인하십시오. 토큰은 다음 양식을 사용합니다.

* IAM: `Authentication: Basic <IBM IAM Token>`
* 엔클레이브 관리자: `Authentication: Bearer <E.M. Token>`

토큰이 있는 경우 여전히 유효한지 확인하고 요청을 다시 실행하십시오.


## 컨테이너 변환기를 개인용 Docker 레지스트리에 연결할 수 없음
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
개인용 Docker 레지스트리에서 이미지에 대해 컨테이너 변환기를 실행하려고 하는데 변환기를 연결할 수 없습니다.

{: tsCauses}
개인용 레지스트리 인증 정보를 올바르게 구성할 수 없습니다. 

{: tsResolve}
문제를 해결하기 위해 다음 단계를 수행할 수 있습니다.

1. 개인용 레지스트리 인증 정보가 이전에 구성되었는지 확인하십시오. 구성되지 않은 경우 지금 구성하십시오.
2. 다음 명령을 실행하여 Docker 레지스트리 인증 정보를 덤프하십시오. 필요한 경우 시크릿 이름을 변경할 수 있습니다.

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: codeblock}

3. Base64 디코더를 사용하여 `.dockerconfigjson`의 시크릿 컨텐츠를 디코딩하고 이 컨텐츠가 올바른지 확인하십시오.


## AESM 소켓 또는 SGX 디바이스를 마운트할 수 없음
{: #ts-problem-mounting-device}

{: tsSymptoms}
볼륨 `/var/run/aesmd/aesm.socket` 또는 `/dev/isgx`에서 {{site.data.keyword.datashield_short}} 컨테이너를 마운트하려는 중에 문제가 발생합니다.

{: tsCauses}
호스트 구성 문제로 인해 마운트에 실패할 수 있습니다.

{: tsResolve}
문제를 해결하려면 다음을 모두 확인하십시오.

* `/var/run/aesmd/aesm.socket`이 호스트의 디렉토리가 아닙니다. 디렉토리라면 파일을 삭제하고 {{site.data.keyword.datashield_short}} 소프트웨어를 설치 제거한 후 설치 단계를 다시 수행하십시오. 
* SGX는 호스트 시스템의 BIOS에서 사용 가능합니다. 사용할 수 없는 경우 IBM 지원 센터에 문의하십시오.


## 오류: 컨테이너 변환
{: #ts-container-convert-fails}

{: tsSymptoms}
컨테이너를 변환하려는 경우 다음 오류가 발생합니다.

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: codeblock}

{: tsCauses}
macOS에서 OS X 키 체인이 `config.json` 파일에 사용되는 경우 컨테이너 변환기에 오류가 발생합니다. 

{: tsResolve}
문제를 해결하려면 다음 단계를 사용할 수 있습니다.

1. 로컬 시스템에서 OS X 키 체인을 사용 안함으로 설정하십시오. **시스템 환경 설정 > iCloud**로 이동하여 **키 체인**에 대한 상자를 선택 취소하십시오.

2. 작성한 시크릿을 삭제하십시오. 다음 명령을 실행하기 전에 IBM Cloud에 로그인하고 클러스터를 대상으로 지정했는지 확인하십시오.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}

3. `$HOME/.docker/config.json` 파일에서 `"credsStore": "osxkeychain"` 행을 삭제하십시오.

4. 레지스트리에 로그인하십시오.

5. 시크릿을 작성하십시오.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

6. 팟(Pod)을 나열하고 이름에 `enclaveos-converter`가 있는 팟(Pod)을 기록하십시오.

  ```
  kubectl get pods
  ```
  {: codeblock}

7. 팟(Pod)을 삭제하십시오.

  ```
  kubectl delete pod <pod name>
  ```
  {: codeblock}

8. 이미지를 변환하십시오.
