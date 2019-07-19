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

# Sobre o serviço
{: #about}

Com o {{site.data.keyword.datashield_full}}, a Fortanix® e as Intel® SGX, é possível
proteger os dados em suas cargas de trabalho de contêiner executadas no {{site.data.keyword.cloud_notm}} enquanto seus dados estão em uso.
{: shortdesc}

Quando se trata de proteger seus dados, a criptografia é um dos controles mais populares e efetivos. Mas, os dados devem ser criptografados em cada etapa de seu ciclo de vida para que seus dados estejam realmente seguros. Durante seu ciclo de vida, os dados têm três fases. Eles podem estar em repouso, em movimento ou em uso. Os dados em repouso e em movimento são geralmente a área de foco quando você pensa em proteger seus dados. Mas, depois que um aplicativo começa a ser executado, os dados que estão em uso pela CPU e pela memória são vulneráveis a vários ataques. Os ataques podem incluir internos maliciosos, usuários raiz, comprometimento de credencial, dia zero de S.O., intrusos de rede e outros. Levando essa proteção um
passo adiante, agora é possível criptografar os dados em uso. 

Com o {{site.data.keyword.datashield_short}}, o código e os dados do aplicativos são executados em enclaves reforçados pela CPU. Os enclaves são áreas confiáveis de memória, no nó do trabalhador, que protegem os aspectos críticos de seus aplicativos. Os enclaves ajudam a manter o código e os dados confidenciais e impedem a modificação. Se você ou sua empresa necessitar de sensibilidade de dados devido a políticas internas, regulamentações governamentais ou requisitos de conformidade do segmento de mercado, essa solução poderá ajudá-lo a mover-se para a nuvem. Os casos de uso de exemplo incluem instituições financeiras e de assistência médica ou países com políticas governamentais que requerem soluções de nuvem no local.


## Integrações
{: #integrations}

Para fornecer a experiência mais contínua para você, o {{site.data.keyword.datashield_short}} é integrado a outros serviços do {{site.data.keyword.cloud_notm}}, Fortanix® e Intel® SGX.

<dl>
  <dt>Fortanix®</dt>
    <dd>Com o [Fortanix Runtime Encryption](https://fortanix.com/){: external}, é possível manter seus aplicativos e dados mais valiosos protegidos, mesmo quando a infraestrutura está comprometida. Usando como base as Intel SGX, a Fortanix
fornece uma nova categoria de segurança de dados chamada Runtime Encryption. Semelhante à maneira como a criptografia funciona para dados em repouso e dados durante a movimentação, a criptografia de tempo de execução mantém chaves, dados e aplicativos que são protegidos contra ameaças externas e internas. As ameaças
podem incluir usuários internos maliciosos, provedores em nuvem, hacks no nível do S.O. ou invasores de rede.</dd>
  <dt>Intel® SGX</dt>
    <dd>O [Intel SGX](https://software.intel.com/en-us/sgx){: external} é uma extensão da arquitetura
x86 que permite que você execute aplicativos em um enclave seguro e completamente isolado. O aplicativo não é isolado apenas de outros aplicativos que são executados no mesmo sistema, mas também do sistema operacional e possível hypervisor. O isolamento também evita que os administradores violem o aplicativo após ele ser iniciado. A memória de enclaves seguros também é criptografada para impedir ataques físicos. A tecnologia também suporta o armazenamento de dados persistentes de forma segura para que eles possam ser lidos apenas pelo enclave seguro.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>O [{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) fornece ferramentas poderosas combinando contêineres do Docker, a tecnologia Kubernetes, uma experiência de usuário intuitiva e a segurança e o isolamento integrados para automatizar o trabalho com aplicativos conteinerizados.</dd>
  <dt>{{site.data.keyword.cloud_notm}}  Gerenciamento de Identidade e Acesso (IAM)</dt>
    <dd>O [IAM](/docs/iam?topic=iam-getstarted) permite autenticar usuários
com segurança para serviços e controlar o acesso a recursos de maneira consistente no {{site.data.keyword.cloud_notm}}. Quando um usuário tenta concluir uma ação específica, o sistema de controle usa os atributos que são definidos na política para determinar se o usuário tem permissão para executar essa tarefa. As chaves de API do {{site.data.keyword.cloud_notm}} estão disponíveis por meio do Tivoli Information Archive Manager que você pode usar para a autenticação por meio da CLI ou como parte da automação para efetuar login como a sua identidade do usuário.</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>É possível expandir suas capacidades de coleção de logs, de retenção e de procura criando uma [configuração de criação de log](/docs/containers?topic=containers-health) por meio do {{site.data.keyword.containerlong_notm}} que encaminha os logs para o [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started).
    Com o serviço, também é possível aproveitar os insights centralizados, a criptografia de log e a retenção de dados do log pelo tempo que for necessário.</dd>
</dl>
