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

# Perguntas mais frequentes (FAQ)
{: #faq}

Esta Pergunta mais frequente fornece respostas às perguntas comuns sobre o serviço {{site.data.keyword.datashield_full}}.
{: shortdesc}


## O que é atestado de enclave? Quando e por que ele é requerido?
{: #enclave-attestation}
{: faq}

Os enclaves são instanciados nas plataformas por código não confiável. Portanto, antes que os enclaves
sejam provisionados com informações confidenciais do aplicativo, é essencial ser capaz de confirmar que o
enclave foi instanciado corretamente em uma plataforma que é protegida pelas Intel® SGX. Isso é feito por um processo de atestado remoto. O atestado remoto consiste em usar as instruções das Intel SGX e o software de plataforma para gerar uma “cotação”. A cotação combina a compilação do enclave com uma compilação de dados de enclave relevantes e uma chave assimétrica exclusiva de plataforma em uma estrutura de dados que é enviada
para um servidor remoto por meio de um canal autenticado. Se o servidor remoto concluir que o enclave foi instanciado conforme desejado e estiver em execução em um processador compatível com Intel SGX genuínas, ele provisionará o enclave conforme necessário.


##	Quais idiomas são suportados atualmente no {{site.data.keyword.datashield_short}}?
{: #language-support}
{: faq}

O serviço estende o suporte à linguagem das SGX de C e C++ para Python e Java. Ele também fornece aplicativos SGX pré-convertidos para MariaDB, NGINX e Vault, com pouca ou nenhuma mudança de código.


##	Como saber se as Intel SGX estão ativadas no nó do trabalhador?
{: #sgx-enabled}
{: faq}

O software {{site.data.keyword.datashield_short}} verifica a disponibilidade das SGX no nó do trabalhador durante o processo de instalação. Se a instalação for bem-sucedida, as informações detalhadas
do nó e o relatório de atestado das SGX poderão ser visualizados na IU do Enclave Manager.


##	Como eu sei que meu aplicativo está em execução no enclave SGX?
{: #running-app}
{: faq}

[Efetue login](/docs/services/data-shield?topic=data-shield-access#access-iam) em sua conta do Enclave Manager e navegue para a guia **Apps**. Na guia **Apps**, é possível ver informações sobre o atestado das Intel SGX para seus aplicativos na forma de um certificado. O enclave de aplicativos pode ser verificado a qualquer momento, usando o Intel Remote Attestation Service (IAS) para verificar se o aplicativo está em execução em um enclave verificado.



## Qual é o impacto no desempenho da execução do aplicativo no {{site.data.keyword.datashield_short}}?
{: #impact}
{: faq}


O desempenho de seu aplicativo depende da natureza de sua carga de trabalho. Se você tiver uma carga de trabalho intensiva de CPU, o efeito que o {{site.data.keyword.datashield_short}} tem em seu app será mínimo. Mas, se você tiver aplicativos intensivos de memória ou E/S, poderá notar um efeito devido à troca de paginação e de contexto. O tamanho da área de cobertura da memória de seu app em relação ao cache da página de enclave SGX é geralmente como é possível determinar o impacto do {{site.data.keyword.datashield_short}}.
