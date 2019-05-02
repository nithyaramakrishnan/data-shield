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

# 이미지 변환
{: #convert}

{{site.data.keyword.datashield_short}} 컨테이너 변환기를 사용하여 EnclaveOS® 환경에서 실행되도록 이미지를 변환할 수 있습니다. 이미지를 변환한 후 SGX에서 사용 가능한 Kubernetes 클러스터에 배치할 수 있습니다.
{: shortdesc}


## 레지스트리 인증 정보 구성
{: #configure-credentials}

레지스트리 인증 정보로 변환기를 구성하여 변환기의 모든 사용자가 입력 이미지를 확보하고 출력 이미지를 구성된 개인용 레지스트리에 푸시할 수 있도록 허용할 수 있습니다.
{: shortdesc}

### {{site.data.keyword.cloud_notm}} Container Registry 인증 정보 구성
{: #configure-ibm-registry}

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오.

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

2. {{site.data.keyword.cloud_notm}} Container Registry의 인증 토큰을 확보하십시오.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. 작성한 토큰을 사용하여 JSON 구성 파일을 작성하십시오. `<token>` 변수를 바꾼 후 다음 명령을 실행하십시오. `openssl`이 없는 경우 적절한 옵션을 사용하여 명령행 base64 인코더를 사용할 수 있습니다. 인코딩된 문자열의 중간 또는 끝에 줄 바꾸기가 없는지 확인하십시오.

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### 다른 레지스트리의 인증 정보 구성
{: #configure-other-registry}

사용할 레지스트리를 인증하는 `~/.docker/config.json` 파일이 이미 있는 경우 이 파일을 사용할 수 있습니다.

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. 다음 명령을 실행하십시오.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## 이미지 변환
{: #converting-images}

엔클레이브 관리자 API를 사용하여 변환기에 연결할 수 있습니다.
{: shortdesc}

1. {{site.data.keyword.cloud_notm}} CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. IAM 토큰을 확보하여 내보내십시오.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. 이미지를 변환하십시오. 변수를 애플리케이션의 정보로 바꾸십시오.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## 애플리케이션 인증서 요청
{: #request-cert}

변환된 애플리케이션은 애플리케이션이 시작될 때 엔클레이브 관리자에서 인증서를 요청할 수 있습니다. 인증서는 엔클레이브 관리자 인증 기관에서 서명되며 앱의 SGX 엔클레이브에 대한 Intel의 원격 증명 보고서를 포함합니다.
{: shortdesc}

다음 예를 참조하여 RSA 개인 키 및 이 키의 인증서를 생성하도록 요청을 구성하는 방법을 확인하십시오. 키는 애플리케이션 컨테이너의 루트에 보관됩니다. 임시 키/인증서를 원하지 않는 경우 앱에 맞게 `keyPath` 및 `certPath`를 사용자 정의하고 지속적 볼륨에 저장할 수 있습니다.

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
 {: pre}


## 애플리케이션 화이트리스트 지정
{: #convert-whitelist}

Docker 이미지가 Intel® SGX의 내부에서 실행되도록 변환되면 화이트리스트로 지정될 수 있습니다. 사용자 이미지를 화이트리스트로 지정하여 애플리케이션이 {{site.data.keyword.datashield_short}}가 설치된 클러스터에서 실행되도록 하는 관리 권한을 지정합니다.
{: shortdesc}

1. 다음 curl 요청을 사용하여 IAM 인증 토큰을 사용하는 엔클레이브 관리자 액세스 토큰을 확보하십시오.

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. 인클레이브 관리자에 대한 화이트리스트 요청을 작성하십시오. 다음 명령을 실행할 때 사용자 정보를 입력하십시오.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. 엔클레이브 관리자 GUI를 사용하여 화이트리스트 요청을 승인하거나 거부하십시오. GUI의 **빌드** 섹션에서 화이트리스트로 지정된 빌드를 추적하고 관리할 수 있습니다.
