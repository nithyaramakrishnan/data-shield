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

# Tutorial Introdução
{: #getting-started}

Com o {{site.data.keyword.datashield_full}}, desenvolvido com a Fortanix®, é possível
proteger os dados em suas cargas de trabalho do contêiner executadas no {{site.data.keyword.cloud_notm}} enquanto os dados estão em uso.
{: shortdesc}

Para obter mais informações sobre o {{site.data.keyword.datashield_short}} e o que ele
significa para proteger seus dados em uso, é possível aprender [sobre o serviço](/docs/services/data-shield?topic=data-shield-about#about).

## Antes de começar
{: #gs-begin}

Antes de poder começar a trabalhar com o {{site.data.keyword.datashield_short}}, deve-se ter os pré-requisitos a seguir. Para obter ajuda com o download das CLIs e plug-ins ou com a configuração do ambiente
do Kubernetes Service, confira o tutorial [Criando clusters
Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* As CLIs a seguir:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  Você pode desejar configurar o Helm para usar o modo `--tls`. Para obter ajuda
com a ativação do TLS, confira o [Repositório do Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Se você ativar o TLS, certifique-se de anexar `--tls` a cada comando
do Helm executado.
  {: tip}

* Os [plug-ins da CLI do {{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) a seguir:

  * Serviço Kubernetes
  * Registro de contêiner

* Um cluster Kubernetes compatível com as SGX. Atualmente, as SGX podem ser ativadas em um cluster
bare metal com o tipo de nó mb2c.4x32. Se você não tiver um, poderá usar as etapas a seguir para
ajudar a assegurar a criação do cluster necessário.
  1. Prepare-se para [criar seu cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Assegure-se de ter as [permissões necessárias](/docs/containers?topic=containers-users#users) para criar um cluster.

  3. Crie o [cluster](/docs/containers?topic=containers-clusters#clusters).

* Uma instância do serviço [cert-manager](https://cert-manager.readthedocs.io/en/latest/) versão 0.5.0 ou mais recente. A instalação padrão usa <code>cert-manager</code> para configurar os [certificados TLS](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates) para comunicação interna entre os serviços do {{site.data.keyword.datashield_short}}. Para instalar uma instância usando o Helm, é possível executar o comando a seguir.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Instalando com um gráfico do Helm
{: #gs-install-chart}

É possível usar o gráfico do Helm fornecido para instalar o {{site.data.keyword.datashield_short}} em seu cluster bare metal compatível com as SGX.
{: shortdesc}

O gráfico do Helm instala os componentes a seguir:

*	O software de suporte para as SGX, que é instalado nos hosts bare metal por um contêiner privilegiado.
*	O {{site.data.keyword.datashield_short}} Enclave Manager, que gerencia os enclaves SGX no ambiente do {{site.data.keyword.datashield_short}}.
*	O serviço de conversão de contêiner do EnclaveOS®, que permite que aplicativos conteinerizados
sejam executados no ambiente do {{site.data.keyword.datashield_short}}.

Ao instalar um gráfico do Helm, você tem várias opções e parâmetros para customizar sua instalação. O tutorial a seguir o guia pela instalação padrão mais básica do gráfico. Para obter mais informações sobre
suas opções, veja [Instalando o {{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-deploying).
{: tip}

Para instalar o {{site.data.keyword.datashield_short}} em seu cluster:

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

  <table>
    <tr>
      <th>Region</th>
      <th>Terminal do IBM Cloud</th>
      <th>Região do Kubernetes Service</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code> us-south </code></td>
      <td>SUL dos EUA</td>
    </tr>
    <tr>
      <td>Frankfurt</td>
      <td><code>eu-de</code></td>
      <td>União Europeia Central</td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
      <td>AP Sul</td>
    </tr>
    <tr>
      <td>Londres</td>
      <td><code>eu-gb</code></td>
      <td>Sul do Reino Unido</td>
    </tr>
    <tr>
      <td>Tóquio</td>
      <td><code>jp-tok</code></td>
      <td>AP Norte</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>Leste dos EUA</td>
    </tr>
  </table>

2. Configure o contexto para seu cluster.

  1. Obtenha o comando para configurar a variável de ambiente e fazer download dos arquivos de configuração do Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copie a saída que começa com `export` e cole-a em seu terminal para configurar a variável de ambiente `KUBECONFIG`.

3. Se você ainda não tiver feito isso, inclua o repositório `ibm`.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. Opcional: se você não souber o e-mail que está associado ao administrador nem o ID da conta do administrador, execute o comando a seguir.

  ```
  ibmcloud account show
  ```
  {: pre}

5. Obtenha o subdomínio do Ingress para seu cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. Instale o gráfico.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  Se você [configurou um {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) para seu conversor, é possível incluir
a opção a seguir: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. Para monitorar a inicialização de seus componentes, é possível executar o comando a seguir.

  ```
  kubectl get pods
  ```
  {: pre}


## Etapas Seguintes
{: #gs-next}

Ótimo trabalho! Agora que o serviço está instalado em seu cluster, é possível executar seus
apps no ambiente do {{site.data.keyword.datashield_short}}. 

Para executar seus apps em um ambiente do {{site.data.keyword.datashield_short}}, deve-se [converter](/docs/services/data-shield?topic=data-shield-convert#convert) sua imagem de contêiner, [incluí-la na lista de desbloqueio](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist) e, em seguida, [implementá-la](/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers).

Se você não tiver sua própria imagem para implementar, tente implementar uma das imagens do {{site.data.keyword.datashield_short}} predefinidas:

* [Repositório do GitHub de exemplos do {{site.data.keyword.datashield_short}}](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* MariaDB ou NGINX no {{site.data.keyword.cloud_notm}} Container Registry
