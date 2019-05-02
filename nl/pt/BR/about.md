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

# Sobre o serviço
{: #about}

Com o {{site.data.keyword.datashield_full}}, a Fortanix® e as Intel® SGX, é possível
proteger os dados em suas cargas de trabalho de contêiner executadas no {{site.data.keyword.cloud_notm}} enquanto seus dados estão em uso.
{: shortdesc}

Quando se trata de proteger seus dados, a criptografia é um dos controles mais populares e efetivos. Mas os dados devem ser criptografados em cada etapa de seu ciclo de vida para que eles realmente fiquem protegidos. Os dados passam por três fases durante seu ciclo de vida: dados em repouso, dados em movimento e dados em uso. Os dados em repouso e em movimento são comumente usados para proteger dados quando eles são armazenados e quando eles são transportados. Depois que um aplicativo começa a ser executado, os dados em uso pela CPU e pela memória
ficam vulneráveis a uma variedade de ataques, incluindo usuários internos maliciosos, usuários raiz,
comprometimento de credenciais, dia zero do S.O., invasores de rede e outros. Levando essa proteção um
passo adiante, agora é possível criptografar os dados em uso. 

Com o {{site.data.keyword.datashield_short}}, o código do app e os dados são executados em
enclaves protegidos por CPU, que são áreas confiáveis de memória no nó do trabalhador que protegem os
aspectos críticos do app. Os enclaves ajudam a manter o código e os dados confidenciais e não modificados. Se
você ou sua empresa precisarem de sensibilidade de dados devido a políticas internas, regulamentações do
governo ou requisitos de conformidade do segmento de mercado, essa solução poderá ajudá-lo a ir para
a nuvem. Os casos de uso de exemplo incluem instituições financeiras e de assistência médica ou países com políticas governamentais que requerem soluções de nuvem no local.


## Integrações
{: #integrations}

Para fornecer o máximo da experiência contínua para você, o {{site.data.keyword.datashield_short}} é integrado a outros serviços {{site.data.keyword.cloud_notm}}, ao Fortanix® Runtime Encryption e às Intel SGX®.

<dl>
  <dt>Fortanix®</dt>
    <dd>Com a [Fortanix](http://fortanix.com/), é possível manter seus apps e dados
mais valiosos protegidos, mesmo quando a infraestrutura está comprometida. Usando como base as Intel SGX, a Fortanix
fornece uma nova categoria de segurança de dados chamada Runtime Encryption. Semelhante à maneira como a criptografia funciona para dados em repouso e dados durante movimento, a criptografia de tempo de execução
mantém chaves, dados e aplicativos completamente protegidos contra ameaças externas e internas. As ameaças
podem incluir usuários internos maliciosos, provedores em nuvem, hacks no nível do S.O. ou invasores de rede.</dd>
  <dt>Intel® SGX</dt>
    <dd>As [Intel SGX](https://software.intel.com/en-us/sgx) são extensões da arquitetura
x86 que permitem que você execute aplicativos em um enclave seguro completamente isolado. O aplicativo não é isolado
somente de outros aplicativos em execução no mesmo sistema, mas também do sistema operacional e do possível hypervisor. Isso evita que os administradores violem o aplicativo após ele ser iniciado. A memória de enclaves seguros também é criptografada para impedir ataques físicos. A tecnologia também suporta o armazenamento
seguro de dados persistentes, de modo que eles possam ser lidos somente pelo enclave seguro.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>O [{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started) entrega ferramentas poderosas, combinando contêineres do Docker, a tecnologia do Kubernetes, uma experiência do usuário intuitiva e segurança e isolamento integrados para automatizar a implementação, a operação, o ajuste de escala e o monitoramento de apps conteinerizados em um cluster de hosts de cálculo.</dd>
  <dt>{{site.data.keyword.cloud_notm}}  Gerenciamento de Identidade e Acesso (IAM)</dt>
    <dd>O [IAM](/docs/iam?topic=iam-getstarted#getstarted) permite autenticar usuários
com segurança para serviços e controlar o acesso a recursos de maneira consistente no {{site.data.keyword.cloud_notm}}. Quando um usuário tenta concluir uma ação específica, o sistema de controle usa os atributos que são definidos na política para determinar se o usuário tem permissão para executar essa tarefa. As chaves de API do {{site.data.keyword.cloud_notm}} estão disponíveis por meio do Cloud IAM para que você use para autenticar usando a CLI ou como parte da automação para efetuar login como
sua identidade do usuário.</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>É possível criar uma [configuração de criação de log](/docs/containers?topic=containers-health#health) por meio do {{site.data.keyword.containerlong_notm}} que encaminha seus logs para o [{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla). É possível expandir suas capacidades de coleção de logs, de retenção de logs e de procura de logs no {{site.data.keyword.cloud_notm}}. Forneça à sua equipe do DevOps recursos como agregação de logs de aplicativos e ambiente para insights consolidados de ambiente ou aplicativos, criptografia de logs, retenção de dados de log pelo tempo que for necessário e detecção e resolução
rápidas de problemas.</dd>
</dl>
