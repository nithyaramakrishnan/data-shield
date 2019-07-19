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

# 이미지 변환
{: #convert}

{{site.data.keyword.datashield_short}} 컨테이너 변환기를 사용하여 EnclaveOS® 환경에서 실행되도록 이미지를 변환할 수 있습니다. 이미지를 변환한 후 SGX에서 사용 가능한 Kubernetes 클러스터에 배치할 수 있습니다.
{: shortdesc}

코드를 변경하지 않고 애플리케이션을 변환할 수 있습니다. 변환을 수행하여 EnclaveOS 환경에서 실행되도록 애플리케이션을 준비합니다. 변환 프로세스가 애플리케이션을 암호화하지 않아야 합니다. 런타임 시 생성된 데이터만(SGX 엔클레이브 내에서 애플리케이션이 시작된 후) IBM Cloud Data Shield에서 보호됩니다. 

변환 프로세스가 애플리케이션을 암호화하지 않습니다.
{: important}


## 시작하기 전에
{: #convert-before}

애플리케이션을 변환하기 전에 다음 고려사항을 완전히 이해하고 있어야 합니다.
{: shortdesc}

* 보안을 이유로 런타임 시 시크릿을 제공해야 하며 변환할 컨테이너 이미지에 배치하면 안됩니다. 앱이 변환되고 실행 중인 경우 시크릿을 제공하기 전에 엔클레이브에서 애플리케이션이 실행 중이라는 증명을 통해 확인할 수 있습니다.

* 컨테이너 게스트는 컨테이너의 루트 사용자로서 실행되어야 합니다.

* 테스트에는 Debian, Ubuntu 및 Java를 기반으로 한 컨테이너가 포함되어 여러 가지 결과를 가져왔습니다. 기타 환경이 작동될 수도 있지만 테스트되지는 않습니다.


## 레지스트리 인증 정보 구성
{: #configure-credentials}

레지스트리 인증 정보로 변환기를 구성하여 {{site.data.keyword.datashield_short}} 컨테이너 변환기의 모든 사용자가 입력 이미지를 확보하고 출력 이미지를 구성된 개인용 레지스트리에 푸시할 수 있도록 허용할 수 있습니다. 2018년 10월 4일 전에 컨테이너 레지스트리를 사용한 경우 [레지스트리에 IAM 액세스 정책 시행을 사용](/docs/services/Registry?topic=registry-user#existing_users)할 수 있습니다.
{: shortdesc}

### {{site.data.keyword.cloud_notm}} Container Registry 인증 정보 구성
{: #configure-ibm-registry}

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오. 연합 ID가 있는 경우 명령 끝에 `--sso` 옵션을 추가하십시오.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. {{site.data.keyword.datashield_short}} 컨테이너 변환기의 서비스 ID 및 서비스 ID API 키를 작성하십시오.

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. 컨테이너 레지스트리에 액세스할 수 있는 서비스 ID 권한을 부여하십시오.

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. 작성한 API 키를 사용하여 JSON 구성 파일을 작성하십시오. `<api key>` 변수를 바꾼 후 다음 명령을 실행하십시오. `openssl`이 없는 경우 적절한 옵션을 사용하여 명령행 base64 인코더를 사용할 수 있습니다. 인코딩된 문자열의 중간 또는 끝에 줄 바꾸기가 없는지 확인하십시오.

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### 다른 레지스트리의 인증 정보 구성
{: #configure-other-registry}

사용할 레지스트리를 인증하는 `~/.docker/config.json` 파일이 이미 있는 경우 이 파일을 사용할 수 있습니다. OS X의 파일이 현재 지원되지 않습니다.

1. [풀(pull) 시크릿](/docs/containers?topic=containers-images#other)을 구성하십시오.

2. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오. 연합 ID가 있는 경우 명령 끝에 `--sso` 옵션을 추가하십시오.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. 다음 명령을 실행하십시오.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## 이미지 변환
{: #converting-images}

엔클레이브 관리자 API를 사용하여 변환기에 연결할 수 있습니다.
{: shortdesc}

[엔클레이브 관리자 UI](/docs/services/data-shield?topic=enclave-manager#em-apps)를 통해 앱을 빌드할 때 컨테이너를 변환할 수도 있습니다.
{: tip}

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오. 연합 ID가 있는 경우 명령 끝에 `--sso` 옵션을 추가하십시오.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. IAM 토큰을 확보하여 내보내십시오.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. 이미지를 변환하십시오. 변수를 애플리케이션의 정보로 바꾸십시오.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Java 애플리케이션 변환
{: #convert-java}

Java 기반 애플리케이션을 변환하는 경우 추가 요구사항 및 제한사항이 몇 가지 있습니다. 엔클레이브 관리자 UI를 사용하여 Java 애플리케이션을 변환하는 경우 `Java-Mode`를 선택할 수 있습니다. API를 사용하여 Java 앱을 변환하려면 다음 제한사항 및 옵션을 유념하십시오.

**제한사항**

* Java 앱의 권장 최대 엔클레이브 크기는 4GB입니다. 더 큰 엔클레이브가 작동될 수도 있지만 성능이 저하될 수 있습니다.
* 권장 힙 크기는 엔클레이브 크기보다 작습니다. `-Xmx` 옵션 제거는 힙 크기를 줄이는 방법으로 권장됩니다.
* 다음 Java 라이브러리가 테스트되었습니다.
  - MySQL Java 커넥터
  - Crypto(`JCA`)
  - 메시징(`JMS`)
  - Hibernate(`JPA`)

  다른 라이브러리에 대한 작업을 수행하는 경우 포럼을 사용하거나 이 페이지의 피드백 단추를 클릭하여 저희 팀에 문의하십시오. 연락처 정보 및 작업할 라이브러리를 포함해야 합니다.


**옵션**

`Java-Mode` 변환을 사용하려면 다음 옵션을 제공하도록 Docker 파일을 수정하십시오. Java 변환이 작동하게 하려면 이 절에 정의된 모든 변수를 설정해야 합니다. 


* 환경 변수 MALLOC_ARENA_MAX를 1로 설정하십시오.

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* `OpenJDK JVM`을 사용하는 경우 다음 옵션을 설정하십시오.

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* `OpenJ9 JVM`을 사용하는 경우 다음 옵션을 설정하십시오.

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## 애플리케이션 인증서 요청
{: #request-cert}

변환된 애플리케이션은 애플리케이션이 시작될 때 엔클레이브 관리자에서 인증서를 요청할 수 있습니다. 인증서는 엔클레이브 관리자 인증 기관에서 서명되며 앱의 SGX 엔클레이브에 대한 Intel의 원격 증명 보고서를 포함합니다.
{: shortdesc}

다음 예를 참조하여 RSA 개인 키 및 이 키의 인증서를 생성하도록 요청을 구성하는 방법을 확인하십시오. 키는 애플리케이션 컨테이너의 루트에 보관됩니다. 임시 키 또는 인증서를 원하지 않는 경우 앱에 맞게 `keyPath` 및 `certPath`를 사용자 정의하고 지속적 볼륨에 저장할 수 있습니다.

1. 다음 템플리트를 `app.json`으로 저장하고 애플리케이션의 인증서 요구사항에 맞게 변경하십시오.

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. 변수를 입력하고 다음 명령을 실행하여 인증서 정보로 변환기를 다시 실행하십시오.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## 애플리케이션을 화이트리스트로 지정
{: #convert-whitelist}

Docker 이미지가 Intel® SGX의 내부에서 실행되도록 변환되면 화이트리스트로 지정될 수 있습니다. 사용자 이미지를 화이트리스트로 지정하여 애플리케이션이 {{site.data.keyword.datashield_short}}가 설치된 클러스터에서 실행되도록 하는 관리 권한을 지정합니다.
{: shortdesc}


1. IAM 인증 토큰을 사용하여 엔클레이브 관리자 액세스 토큰을 확보하십시오.

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. 엔클레이브 관리자에 대한 화이트리스트 요청을 작성하십시오. 다음 명령을 실행할 때 사용자 정보를 입력하십시오.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. 엔클레이브 관리자 GUI를 사용하여 화이트리스트 요청을 승인하거나 거부하십시오. GUI의 **태스크** 섹션에서 화이트리스트로 지정된 빌드를 추적하고 관리할 수 있습니다.

