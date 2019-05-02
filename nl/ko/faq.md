---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

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
{:faq: data-hd-content-type='faq'}

# 자주 묻는 질문(FAQ) 
{: #faq}

이 FAQ에서는 {{site.data.keyword.datashield_full}} 서비스에 대한 일반적인 질문의 답을 제공합니다.
{: shortdesc}


## 엔클레이브 증명은 무엇입니까? 필요한 시기와 이유는 무엇입니까?
{: #enclave-attestation}
{: faq}

엔클레이브는 신뢰할 수 없는 코드로 플랫폼에서 인스턴스화됩니다. 따라서 엔클레이브에 애플리케이션 기밀 정보가 프로비저닝되기 전에, 엔클레이브가 Intel® SGX에 의해 보호되는 플랫폼에서 올바르게 인스턴스화되었는지 확인할 수 있어야 합니다. 이는 원격 증명 프로세스에 의해 수행됩니다. 원격 증명에는 Intel SGX 지시사항 및 플랫폼 소프트웨어를 사용하여 “견적”을 생성하는 일이 포함됩니다. 견적에서는 플랫폼 고유 비대칭 키와 관련 엔클레이브 데이터의 요약을 포함한 엔클레이브 요약을 인증된 채널을 통해 원격 서버로 보내는 데이터 구조와 결합합니다. 원격 서버가 엔클레이브가 의도대로 인스턴스화되었으며 진정한 Intel SGX에서 사용 가능한 프로세서에서 실행되고 있다고 결론을 내린 경우 필요에 따라 엔클레이브를 프로비저닝합니다.


##	현재 {{site.data.keyword.datashield_short}}에서 지원되는 언어는 무엇입니까?
{: #language-support}
{: faq}

서비스는 SGX 언어 지원을 C 및 C++에서 Python 및 Java까지 확장합니다. 또한 MariaDB, NGINX 및 Vault에 대한 사전 변환된 SGX 애플리케이션을 제공하며, 이 경우 코드가 거의 변경되지 않은 상태입니다.


##	내 작업자 노드에서 Intel SGX가 사용 가능한지 여부를 어떻게 알 수 있습니까?
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} 소프트웨어는 설치 프로세스 중에 작업자 노드에서 SGX 가용성을 확인합니다. 설치에 성공하면 엔클레이브 관리자 UI에서 노드의 자세한 정보 및 SGX 증명 보고서를 볼 수 있습니다.


##	SGX 엔클레이브에서 내 애플리케이션이 실행 중인지 어떻게 알 수 있습니까?
{: #running-app}
{: faq}

엔클레이브 관리자 계정에 [로그인](/docs/services/data-shield?topic=data-shield-access#access-iam)하고 **앱** 탭으로 이동하십시오. **앱** 탭에서 애플리케이션의 Intel SGX 증명에 대한 정보를 인증서 양식으로 볼 수 있습니다. 
애플리케이션이 검증된 엔클레이브에서 실행 중인지 확인하려면 언제든 Intel Remote Attestation Service(IAS)를 사용하여 애플리케이션 엔클레이브를 검증할 수 있습니다.



## {{site.data.keyword.datashield_short}}에서 애플리케이션을 실행하는 경우 성능에 미치는 영향은 무엇입니까?
{: #impact}
{: faq}


애플리케이션의 성능은 워크로드의 네이처에 따라 다릅니다. CPU 집약적 워크로드가 있는 경우 {{site.data.keyword.datashield_short}}가 앱에 미치는 영향이 최소화됩니다. 하지만 메모리나 IO 집약적 애플리케이션이 있는 경우에는 페이징 및 컨텍스트 전환으로 인한 영향을 확인할 수 있습니다. SGX 엔클레이브 페이지 캐시와 관련된 앱의 메모리 풋프린트 크기는 일반적으로 {{site.data.keyword.datashield_short}}의 영향을 판별하는 방법입니다.
