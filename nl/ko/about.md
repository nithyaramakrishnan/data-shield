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

# 서비스 정보
{: #about}

{{site.data.keyword.datashield_full}}, Fortanix® 및 Intel® SGX를 사용하면 데이터가 사용 중일 때 {{site.data.keyword.cloud_notm}}에서 실행되는 컨테이너 워크로드의 데이터를 보호할 수 있습니다.
{: shortdesc}

데이터 보호에 관한 한 암호화는 가장 대중적이고 효과적인 제어 중 하나입니다. 하지만 데이터를 안전하게 보호하려면 라이프사이클의 각 단계에서 암호화해야 합니다. 데이터는 라이프사이클 동안 3단계를 거칩니다(저장 데이터, 이동 데이터, 사용 중인 데이터). 저장 데이터와 이동 데이터는 일반적으로 데이터를 저장하고 전송하는 경우에 이를 보호하기 위해 사용됩니다. 애플리케이션이 실행되기 시작하면, CPU 및 메모리에서 사용되는 데이터는 악의적 내부자, 루트 사용자, 인증 정보 비교, OS 제로데이, 네트워크 침입자 등을 포함한 다양한 공격에 취약하게 됩니다. 이러한 보호에서 더 나아가 이제 사용 중인 데이터를 암호화할 수 있습니다. 

{{site.data.keyword.datashield_short}}를 사용하면 앱 코드와 데이터가 CPU 강화 엔클레이브에서 실행되며 이 엔클레이브는 앱의 중요한 측면을 보호하는 작업자 노드의 신뢰할 수 있는 메모리 영역입니다. 엔클레이브를 사용하면 코드 및 데이터를 수정하지 않은 상태로 기밀로 유지할 수 있습니다. 내부 정책, 정부 규제 또는 업계의 정부 규제 준수로 인해 사용자나 사용자 회사에서 데이터 민감도가 필요한 경우, 이 솔루션은 클라우드로 이동하는 데 도움이 될 수 있습니다. 예제 유스 케이스에는 온프레미스 클라우드 솔루션이 필요한 금융 및 의료 기관 또는 국가 정책을 사용하는 국가가 포함됩니다.


## 통합
{: #integrations}

사용자에게 완벽한 경험을 제공하기 위해 {{site.data.keyword.datashield_short}}는 기타 {{site.data.keyword.cloud_notm}} 서비스, Fortanix® Runtime Encryption 및 Intel SGX®와 통합되었습니다.

<dl>
  <dt>Fortanix®</dt>
    <dd>[Fortanix](http://fortanix.com/)를 사용하면 인프라가 손상된 경우에도 가장 중요한 앱과 데이터를 계속 보호할 수 있습니다. Intel SGX를 기반으로 한 Fortanix는 Runtime Encryption이라는 새로운 카테고리의 데이터 보안을 제공합니다. 저장 데이터와 이동 중인 데이터에 대해 암호화가 작동하는 방식과 유사하게 런타임 암호화는 키, 데이터, 애플리케이션을 외부 및 내부 위협으로부터 완전히 보호합니다. 위협에는 악의적인 내부자, 클라우드 제공자, OS 레벨 해킹 또는 네트워크 침입자가 포함될 수 있습니다.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx)는 완전히 격리된 보안 엔클레이브에서 애플리케이션을 실행할 수 있도록 하는 x86 아키텍처에 대한 확장입니다. 애플리케이션은 동일한 시스템에서 실행 중인 다른 애플리케이션뿐만 아니라 운영 체제 및 가능한 하이퍼바이저에서도 격리됩니다. 이렇게 하면 관리자는 애플리케이션이 시작된 후에 애플리케이션을 변조할 수 없습니다. 보안 엔클레이브의 메모리도 물리적 공격을 막기 위해 암호화됩니다. 이 기술은 또한 보안 엔클레이브에서만 읽을 수 있도록 지속적 데이터의 안전한 저장을 지원합니다.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started)는 Docker 컨테이너, Kubernetes 기술, 직관적 사용자 경험 및 기본 제공 보안과 격리를 결합하여 컴퓨팅 호스트의 클러스터에서 컨테이너화된 앱의 배치, 조작, 스케일링 및 모니터링을 자동화하는 강력한 도구를 제공합니다.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management(IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted)을 사용하면 서비스에 대해 사용자를 안전하게 인증하고 {{site.data.keyword.cloud_notm}}에서 일관되게 리소스에 대한 액세스를 제어할 수 있습니다. 사용자가 특정 조치를 완료하려고 하면 제어 시스템은 정책에 정의된 속성을 사용하여 사용자에게 이 태스크를 수행할 권한이 있는지 여부를 판별합니다. CLI를 사용하여 또는 사용자 ID로서 로그인하는 자동화의 일부로 인증하기 위해 Cloud IAM을 통해 {{site.data.keyword.cloud_notm}} API 키를 사용할 수 있습니다.</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>[{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla)에 로그를 전달하는 {{site.data.keyword.containerlong_notm}}를 통해 [로깅 구성](/docs/containers?topic=containers-health#health)을 작성할 수 있습니다. {{site.data.keyword.cloud_notm}}에서 로그 콜렉션, 로그 보유 및 로그 검색 기능을 확장할 수 있습니다. DevOps 팀에게 통합된 애플리케이션 또는 환경 인사이트에 대한 애플리케이션과 환경 로그의 집계, 로그 암호화, 로그 데이터의 보존(필요한 경우) 및 문제의 빠른 발견과 해결 등의 기능을 제공합니다.</dd>
</dl>
