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

# Usando o Enclave Manager
{: #enclave-manager}

É possível usar a IU do Enclave Manager para gerenciar os aplicativos que você protege com o {{site.data.keyword.datashield_full}}. Por meio da IU, é possível gerenciar a implementação do app, designar acesso, manipular solicitações de lista de desbloqueio e converter seus aplicativos.
{: shortdesc}


## Registrando-se
{: #em-signin}

No console do Enclave Manager, é possível visualizar os nós em seu cluster e seu status de atestado. Também é possível visualizar as tarefas e os logs de auditoria de eventos de cluster. Para iniciar, conecte-se.
{: shortdesc}

1. Certifique-se de que você tenha o [acesso correto](/docs/services/data-shield?topic=data-shield-access).

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

  2. Copie a saída que começa com `export` e cole-a em seu terminal para configurar a variável de ambiente `KUBECONFIG`.

3. Verifique se todo o seu serviço está em execução, confirmando que todos os seus pods estão em um estado *ativo*.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Consulte a URL de front-end para seu Enclave Manager executando o comando a seguir.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Obtenha seu subdomínio do Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. Em um navegador, insira o subdomínio do Ingress no qual o seu Enclave Manager está disponível.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

7. No terminal, obtenha seu token do IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. Copie o token e cole-o na GUI do Enclave Manager. Você não precisa copiar a parte `Bearer` do token impresso.

9. Clique em **Conectar**.






## Gerenciando Nós
{: #em-nodes}

É possível usar a IU do Enclave Manager para monitorar o status, desativar ou fazer download dos certificados para os nós que executam o IBM Cloud Data Shield em seu cluster.
{: shortdesc}


1. Conecte-se ao Enclave Manager.

2. Navegue para a guia **Nós**.

3. Clique no endereço IP do nó que você deseja investigar. Uma tela de informações é aberta.

4. Na tela de informações, é possível optar por desativar o nó ou fazer download do certificado que é usado.




## Implementando Aplicativos
{: #em-apps}

É possível usar a IU do Enclave Manager para implementar seus aplicativos.
{: shortdesc}


### Incluindo um aplicativo
{: #em-app-add}

É possível converter, implementar e colocar na lista de desbloqueio o seu aplicativo, tudo ao mesmo tempo, usando a IU do Enclave Manager.
{: shortdesc}

1. Conecte-se ao Enclave Manager e navegue para a guia **Aplicativos**.

2. Clique em **Incluir novo aplicativo**.

3. Dê um nome e uma descrição ao seu aplicativo.

4. Insira o nome de entrada e de saída para as suas imagens. A entrada é o seu nome de aplicativo atual. A saída é onde você pode localizar o aplicativo convertido.

5. Insira um **ISVPRDID** e **ISVSVN**.

6. Insira qualquer domínio permitido.

7. Edite qualquer configuração avançada que você possa desejar mudar.

8. Clique em **Criar novo aplicativo**. O aplicativo é implementado e incluído em sua lista de desbloqueio. É possível aprovar a solicitação de construção na guia **Tarefas**.




### Editando um aplicativo
{: #em-app-edit}

É possível editar um aplicativo depois de incluí-lo na lista.
{: shortdesc}


1. Conecte-se ao Enclave Manager e navegue para a guia **Aplicativos**.

2. Clique no nome do aplicativo que você deseja editar. Abre-se uma nova tela na qual é possível revisar a configuração, incluindo certificados e as construções implementadas.

3. Clique em **Editar aplicativo**.

4. Atualize a configuração que você deseja criar. Certifique-se de entender a maneira como a mudança das configurações avançadas afeta o seu aplicativo antes de fazer qualquer mudança.

5. Clique em **Editar aplicativo**.


## Construindo aplicativos
{: #em-builds}

É possível usar a UI do Enclave Manager para reconstruir seus aplicativos depois de fazer mudanças.
{: shortdesc}

1. Conecte-se ao Enclave Manager e navegue para a guia **Construções**.

2. Clique em **Criar nova construção**.

3. Selecione um aplicativo na lista suspensa ou inclua um aplicativo.

4. Insira o nome de sua imagem do Docker e identifique-o com um específico 

5. Clique em **Construir**. A construção foi incluída na lista de desbloqueio. É possível aprovar a construção na guia **Tarefas**.



## Aprovando tarefas
{: #em-tasks}

Quando um aplicativo é incluído na lista de desbloqueio, ele é incluído na lista de solicitações pendentes na guia **Tarefas** da IU do Enclave Manager. É possível usar a IU para aprovar ou negar a solicitação.
{: shortdesc}

1. Conecte-se ao Enclave Manager e navegue para a guia **Tarefas**.

2. Clique na linha que contém a solicitação que você deseja aprovar ou negar. Uma tela com mais informações é aberta.

3. Revise a solicitação e clique em **Aprovar** ou **Negar**. Seu nome é incluído na lista de **Revisores**.


## Exibindo logs
{: #em-view}

É possível auditar a instância do gerenciador do Enclave para vários tipos diferentes de atividades.
{: shortdesc}

1. Navegue para a guia **Log de auditoria** da IU do Enclave Manager.
2. Filtre os resultados de criação de log para limitar a sua procura. É possível optar por filtrar por intervalo de tempo ou por qualquer um dos tipos a seguir.

  * Status do aplicativo: atividade que pertence a seu aplicativo, como solicitações de lista de desbloqueio e novas construções.
  * Aprovação do usuário: atividade que pertence a um acesso do usuário, como a aprovação ou negação para usar a conta.
  * Atestado do nó: atividade que pertence ao atestado do nó.
  * Autoridade de certificação: atividade que pertence a uma autoridade de certificação.
  * Administração: atividade que pertence ao administrativo. 

Se você deseja manter um registro dos logs além de 1 mês, é possível exportar as informações como um arquivo `.csv`.

