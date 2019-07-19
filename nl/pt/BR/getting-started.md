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

# Tutorial de introdução
{: #getting-started}

Com o {{site.data.keyword.datashield_full}}, desenvolvido com a Fortanix®, é possível
proteger os dados em suas cargas de trabalho do contêiner executadas no {{site.data.keyword.cloud_notm}} enquanto os dados estão em uso.
{: shortdesc}

Para obter mais informações sobre o {{site.data.keyword.datashield_short}} e o que ele
significa para proteger seus dados em uso, é possível aprender [sobre o serviço](/docs/services/data-shield?topic=data-shield-about).

## Antes de começar
{: #gs-begin}

Antes de poder começar a trabalhar com o {{site.data.keyword.datashield_short}}, deve-se ter os pré-requisitos a seguir.

Para obter ajuda com o download das CLIs ou a configuração de seu ambiente do {{site.data.keyword.containershort}}, consulte o tutorial [Criando clusters Kubernetes](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).
{: tip}

* As CLIs a seguir:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm](/docs/containers?topic=containers-helm)

* Os [plug-ins CLI](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins)a seguir:

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}

* Um cluster Kubernetes compatível com as SGX. Atualmente, as SGX podem ser ativadas em um cluster
bare metal com o tipo de nó mb2c.4x32. Se você não tiver um, poderá usar as etapas a seguir para
ajudar a assegurar a criação do cluster necessário.
  1. Prepare-se para [criar seu cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Assegure-se de ter as [permissões necessárias](/docs/containers?topic=containers-users) para criar um cluster.

  3. Crie o [cluster](/docs/containers?topic=containers-clusters).

* Uma instância do serviço [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} versão 0.5.0 ou mais recente. A instalação padrão usa <code>cert-manager</code> para configurar os [certificados TLS](/docs/services/data-shield?topic=data-shield-tls-certificates) para comunicação interna entre os serviços do {{site.data.keyword.datashield_short}}. Para instalar uma instância usando o Helm, é possível executar o comando a seguir.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Deseja ver as informações de criação de log para o Data Shield? Configure uma instância do {{site.data.keyword.la_full_notm}} para o seu cluster.
{: tip}

## Instalando o Serviço
{: #gs-install}

É possível usar o gráfico do Helm fornecido para instalar o {{site.data.keyword.datashield_short}} em seu cluster bare metal compatível com as SGX.
{: shortdesc}

O gráfico do Helm instala os componentes a seguir:

*	O software de suporte para as SGX, que é instalado nos hosts bare metal por um contêiner privilegiado.
*	O {{site.data.keyword.datashield_short}} Enclave Manager, que gerencia os enclaves SGX no ambiente do {{site.data.keyword.datashield_short}}.
*	O serviço de conversão de contêiner do EnclaveOS®, que permite que aplicativos conteinerizados
sejam executados no ambiente do {{site.data.keyword.datashield_short}}.


Para instalar o {{site.data.keyword.datashield_short}} em seu cluster, conclua as etapas a seguir.

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log. Se você tiver um ID federado, anexe a opção `--sso` no final do comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Configure o contexto para seu cluster.

  1. Obtenha o comando para configurar a variável de ambiente e fazer download dos arquivos de configuração do Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copie a saída que começa com `export` e cole-a em seu console para configurar a variável de ambiente `KUBECONFIG`.

3. Se você ainda não tiver feito isso, inclua o repositório `iks-charts`.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. Opcional: se você não souber o e-mail que está associado ao administrador nem o ID da conta do administrador, execute o comando a seguir.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. Obtenha o subdomínio do Ingress para seu cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

6. Inicialize o Helm criando uma política de ligação de função para o Tiller. 

  1. Crie uma conta de serviço para o Tiller.
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. Crie a ligação de função para designar o acesso de administrador do Tiller no cluster.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Inicialize o Helm.

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

  Você pode desejar configurar o Helm para usar o modo `--tls`. Para obter ajuda
com a ativação do TLS, confira o [Repositório do Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md){: external}. Se você ativar o TLS, certifique-se de anexar `--tls` a cada comando
do Helm executado. Para obter mais informações sobre como usar o Helm com o IBM Cloud Kubernetes Service, consulte [Incluindo serviços usando os gráficos do Helm](/docs/containers?topic=containers-helm#public_helm_install).
  {: tip}

7. Instale o gráfico.

  ```
  helm install ibm/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  Se você [configurou um {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) para seu conversor, deve-se incluir `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. Para monitorar a inicialização de seus componentes, é possível executar o comando a seguir.

  ```
  kubectl get pods
  ```
  {: codeblock}

## Etapas Seguintes
{: #gs-next}

Agora que o serviço está instalado em seu cluster, é possível começar a proteger seus dados! Em seguida, é possível experimentar [converter](/docs/services/data-shield?topic=data-shield-convert), [implementar](/docs/services/data-shield?topic=data-shield-deploying) seus aplicativos. 

Se você não tiver sua própria imagem para implementar, tente implementar uma das imagens do {{site.data.keyword.datashield_short}} predefinidas:

* [Exemplos de repositório GitHub](https://github.com/fortanix/data-shield-examples/tree/master/ewallet){: external}
* Registro de contêiner: [imagem do Barbican](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter), [imagem do MariaDB](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter), [imagem do NGINX](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter) ou [imagem da área segura](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter).


