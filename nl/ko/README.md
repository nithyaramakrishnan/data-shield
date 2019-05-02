# IBM Cloud Data Shield

IBM Cloud Data Shield, Fortanix® 및 Intel® SGX를 사용하면 데이터가 사용 중일 때 IBM Cloud에서 실행되는 컨테이너 워크로드의 데이터를 보호할 수 있습니다.

## 소개

데이터 보호에 관한 한 암호화는 가장 대중적이고 효과적인 방법 중 하나입니다. 하지만 데이터를 안전하게 보호하려면 라이프사이클의 각 단계에서 암호화해야 합니다. 데이터 라이프사이클의 3단계에는 저장 데이터, 이동 데이터, 사용 중인 데이터가 포함됩니다. 저장 데이터와 이동 데이터는 일반적으로 데이터를 저장하고 전송하는 경우에 이를 보호하기 위해 사용됩니다.

하지만 애플리케이션이 실행되기 시작하면 CPU 및 메모리에서 사용 중인 데이터가 공격에 취약하게 됩니다. 악의적인 내부자, 루트 사용자, 인증 정보 손상, OS 제로데이 및 네트워크 침입자는 모두 데이터에 대한 위협입니다. 암호화에서 더 나아가 이제 사용 중인 데이터를 보호할 수 있습니다. 

서비스에 대한 자세한 정보 및 사용 중인 데이터를 보호하는 의미는 [서비스 정보](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about)에서 알아볼 수 있습니다.



## 차트 세부사항

이 Helm 차트는 SGX 사용 IBM Cloud Kubernetes Service 클러스터에 다음 컴포넌트를 설치합니다.

 * SGX에 대한 지원 소프트웨어. 권한 있는 컨테이너에 의해 베어메탈 호스트에 설치됩니다.
 * IBM Cloud Data Shield 엔클레이브 관리자. IBM Cloud Data Shield 환경에서 SGX 엔클레이브를 관리합니다.
 * EnclaveOS® 컨테이너 변환 서비스. IBM Cloud Data Shield 환경에서 실행될 수 있도록 컨테이너화된 애플리케이션을 변환합니다.



## 필수 리소스

* SGX 사용 Kubernetes 클러스터입니다. 현재 노드 유형이 mb2c.4x32인 베어메탈 클러스터에서 SGX를 사용할 수 있습니다. 없는 경우 다음 단계를 사용하여 필요한 클러스터를 작성할 수 있습니다.
  1. [클러스터 작성](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare)을 준비하십시오.

  2. 클러스터 작성에 [필요한 권한](https://cloud.ibm.com/docs/containers?topic=containers-users#users)이 있는지 확인하십시오.

  3. [클러스터](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters)를 작성하십시오.

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 서비스 버전 0.5.0 이상의 인스턴스입니다. Helm을 사용하여 인스턴스를 설치하기 위해 다음 명령을 실행할 수 있습니다.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## 전제조건

IBM Cloud Data Shield 사용을 시작하려면 먼저 다음 전제조건을 충족해야 합니다. CLI 및 플러그인 다운로드와 Kubernetes Service 환경 구성에 대한 도움을 받으려면 튜토리얼 [Kubernetes 클러스터 작성](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)을 참조하십시오.

* CLI는 다음과 같습니다.

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  `--tls` 모드를 사용하도록 Helm을 구성할 수 있습니다. TLS 사용에 대한 도움을 받으려면 [Helm 저장소](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)를 참조하십시오. TLS를 사용으로 설정하는 경우, 실행하는 모든 Helm 명령에 `--tls`를 추가하십시오.
  {: tip}

* [{{site.data.keyword.cloud_notm}} CLI 플러그인](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)은 다음과 같습니다.

  * Kubernetes Service
  * Container Registry



## 차트 설치

Helm 차트를 설치하는 경우 설치를 사용자 정의하는 데 사용할 수 있는 여러 옵션과 매개변수가 있습니다. 다음 지시사항에서는 가장 기본적인 차트 기본 설치에 대해 설명합니다. 옵션에 대한 자세한 정보는 [IBM Cloud Data Shield 문서](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started)를 참조하십시오.

팁: 개인용 레지스트리에 이미지가 저장되어 있습니까? EnclaveOS 컨테이너 변환기를 사용하여 IBM Cloud Data Shield에서 작동하도록 이미지를 구성할 수 있습니다. 필요한 구성 정보를 가지려면 차트를 배치하기 전에 이미지를 변환하십시오. 이미지 변환에 대한 자세한 정보는 [문서](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)를 참조하십시오.


**IBM Cloud Data Shield를 클러스터에 설치하려면 다음을 수행하십시오.**

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

3. 아직 없는 경우 `ibm` 저장소를 추가하십시오.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. 선택사항: 관리자 또는 관리 계정 ID와 연관된 이메일을 모르는 경우 다음 명령을 실행하십시오.

  ```
  ibmcloud account show
  ```

5. 클러스터의 Ingress 하위 도메인을 가져오십시오.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. 차트를 설치하십시오.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  참고: 변환기에 대해 [IBM Cloud Container Registry를 구성](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)한 경우 다음 옵션을 추가하십시오. `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. 컴포넌트 시작을 모니터하기 위해 다음 명령을 실행할 수 있습니다.

  ```
  kubectl get pods
  ```

## IBM Cloud Data Shield 환경에서 앱 실행

IBM Cloud Data Shield 환경에서 애플리케이션을 실행하려면 컨테이너 이미지를 변환하고 화이트리스트로 지정한 다음 배치해야 합니다.

### 이미지 변환
{: #converting-images}

엔클레이브 관리자 API를 사용하여 변환기에 연결할 수 있습니다.
{: shortdesc}

1. IBM Cloud CLI에 로그인하십시오. CLI에서 프롬프트에 따라 로그인을 완료하십시오.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. IAM 토큰을 확보하여 내보내십시오.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. 이미지를 변환하십시오. 변수를 애플리케이션의 정보로 바꾸십시오.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### 애플리케이션 화이트리스트 지정
{: #convert-whitelist}

Docker 이미지가 Intel SGX의 내부에서 실행되도록 변환되면 화이트리스트로 지정될 수 있습니다. 사용자 이미지를 화이트리스트로 지정하여 애플리케이션이 IBM Cloud Data Shield가 설치된 클러스터에서 실행되도록 하는 관리 권한을 지정합니다.
{: shortdesc}

1. 다음 curl 요청을 사용하여 IAM 인증 토큰을 사용하는 엔클레이브 관리자 액세스 토큰을 확보하십시오.

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. 인클레이브 관리자에 대한 화이트리스트 요청을 작성하십시오. 다음 명령을 실행할 때 사용자 정보를 입력하십시오.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. 엔클레이브 관리자 GUI를 사용하여 화이트리스트 요청을 승인하거나 거부하십시오. GUI의 **빌드** 섹션에서 화이트리스트로 지정된 빌드를 추적하고 관리할 수 있습니다.



### IBM Cloud Data Shield 컨테이너 배치

이미지를 변환한 후 Kubernetes 클러스터에 IBM Cloud Data Shield 컨테이너를 재배치해야 합니다.
{: shortdesc}

Kubernetes 클러스터에 IBM Cloud Data Shield 컨테이너를 배치할 때 컨테이너 스펙에 볼륨 마운트가 포함되어야 합니다. 볼륨의 경우 SGX 디바이스와 AESM 소켓을 컨테이너에서 사용할 수 있습니다.

1. 다음 팟(Pod) 스펙을 템플리트로 저장하십시오.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. 필드 `your-app-sgx` 및 `your-registry-server`를 앱과 서버로 업데이트하십시오.

3. Kubernetes 팟(Pod)을 작성하십시오.

   ```
   kubectl create -f template.yml
   ```

서비스를 시도할 애플리케이션이 없습니까? 없어도 문제 없습니다. 당사에서는 MariaDB 및 NGINX를 포함해 사용해 볼 수 있는 여러 샘플 앱을 제공합니다. IBM Container Registry의 모든 ["datashield" 이미지](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)는 샘플로 사용할 수 있습니다.




## 엔클레이브 관리자 GUI에 액세스

엔클레이브 관리자 GUI를 사용하여 IBM Cloud Data Shield 환경에서 실행되는 모든 애플리케이션의 개요를 확인할 수 있습니다. 엔클레이브 관리자 콘솔에서 클러스터의 노드, 증명 상태, 태스크 및 클러스터 이벤트의 감사 로그를 볼 수 있습니다. 화이트리스트 요청을 승인하고 거부할 수도 있습니다.

GUI를 사용하려면 다음을 수행하십시오.

1. IBM Cloud에 로그인하여 클러스터의 컨텍스트를 설정하십시오.

2. 모든 팟(Pod)이 *실행 중* 상태인지 확인하여 서비스가 실행 중인지 확인하십시오.

  ```
  kubectl get pods
  ```

3. 다음 명령을 실행하여 엔클레이브 관리자의 프론트 엔드 URL을 검색하십시오.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Ingress 하위 도메인을 얻으십시오.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. 브라우저에서 엔클레이브 관리자가 사용 가능한 Ingress 하위 도메인을 입력하십시오.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. 터미널에서 IAM 토큰을 가져오십시오.

  ```
  ibmcloud iam oauth-tokens
  ```

7. 토큰을 복사하여 엔클레이브 관리자 GUI에 붙여넣으십시오. 인쇄된 토큰의 `Bearer` 부분은 복사하지 않아도 됩니다.

8. **로그인**을 클릭하십시오.

사용자가 여러 조치를 수행하는 데 필요한 역할에 대한 정보는 [엔클레이브 관리자 사용자의 역할 설정](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles)을 참조하십시오.

## 사전 패키지된 보호된 이미지 사용

IBM Cloud Data Shield 팀은 IBM Cloud Data Shield 환경에서 실행할 수 있는 서로 다른 4개의 프로덕션 준비 이미지를 모읍니다. 다음 이미지 중 하나를 사용해 볼 수 있습니다.

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## 설치 제거 및 문제점 해결

IBM Cloud Data Shield 관련 작업을 수행하는 동안 문제가 발생하면 문서의 [문제점 해결](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting) 또는 [자주 묻는 질문](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq) 절을 참조하십시오. 질문 또는 문제에 대한 솔루션을 확인하지 못한 경우 [IBM 지원 센터](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support)에 문의하십시오.

IBM Cloud Data Shield를 더 이상 사용할 필요가 없는 경우 [작성된 TLS 인증서 및 서비스를 삭제](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall)할 수 있습니다.

