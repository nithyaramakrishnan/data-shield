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

# Gerenciando o acesso
{: #access}

É possível controlar o acesso ao {{site.data.keyword.datashield_full}} Enclave Manager. Esse
controle de acesso é separado das funções típicas do Identity and Access Management (IAM) usadas quando
você está trabalhando com o {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Usando uma chave de API do IAM para efetuar login no console
{: #access-iam}

No console do Enclave Manager, é possível visualizar os nós em seu cluster e seu status de atestado. Também é possível visualizar as tarefas e os logs de auditoria de eventos de cluster.

1. Efetue login na CLI do IBM Cloud. Siga os prompts na CLI para concluir a criação de log.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

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

  2. Copie a saída que começa com `export` e cole-a em seu terminal para configurar a variável de ambiente `KUBECONFIG`.

3. Verifique se todos os seus serviços estão em execução, confirmando que todos os seus pods estão em um estado *em execução*.

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

8. No terminal, obtenha seu token do IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. Copie o token e cole-o na GUI do Enclave Manager. Você não precisa copiar a parte `Bearer` do token impresso.

9. Clique em **Conectar**.


## Configurando funções para usuários do Enclave Manager
{: #enclave-roles}

A administração do {{site.data.keyword.datashield_short}} ocorre no Enclave Manager. Como um administrador, você é designado automaticamente com a função de *gerenciador*, mas também é
possível designar funções a outros usuários.
{: shortdesc}

Lembre-se de que essas funções são diferentes das funções do IAM da plataforma que são usadas
para controlar o acesso aos serviços do {{site.data.keyword.cloud_notm}}. Para obter mais
informações sobre como configurar o acesso para o {{site.data.keyword.containerlong_notm}},
veja [Designando acesso ao cluster](/docs/containers?topic=containers-users#users).
{: tip}

Confira a tabela a seguir para saber quais funções são suportadas e algumas ações de exemplo
que podem ser tomadas por cada usuário:

<table>
  <tr>
    <th>Função</th>
    <th>Ações</th>
    <th>Por exemplo:</th>
  </tr>
  <tr>
    <td>Leitor</td>
    <td>Pode executar ações somente leitura, tais como visualizar nós, construções, informações do usuário,
apps, tarefas e logs de auditoria.</td>
    <td>Fazer download de um certificado de atestado de nó.</td>
  </tr>
  <tr>
    <td>Gravador</td>
    <td>Pode executar as ações que um Leitor pode executar e mais, incluindo a desativação e renovação
do atestado de nó, inclusão de uma construção, aprovação ou negação de qualquer ação ou tarefa.</td>
    <td>Certificar um aplicativo.</td>
  </tr>
  <tr>
    <td>Manager</td>
    <td>Pode executar as ações que um Gravador pode executar e mais, incluindo a atualização de nomes
de usuário e funções, inclusão de usuários no cluster, atualização de configurações de cluster e quaisquer
outras ações privilegiadas.</td>
    <td>Atualizar uma função de usuário.</td>
  </tr>
</table>

### Configurando funções de usuário
{: #set-roles}

É possível configurar ou atualizar as funções de usuário para seu gerenciador de console.
{: shortdesc}

1. Navegue para a [UI do Enclave Manager](/docs/services/data-shield?topic=data-shield-access#access-iam).
2. No menu suspenso, abra a tela de gerenciamento de usuários.
3. Selecione **Configurações**. É possível revisar a lista de usuários ou incluir um usuário nessa tela.
4. Para editar permissões do usuário, passe o mouse sobre um usuário até que o ícone de lápis seja exibido.
5. Clique no ícone de lápis para mudar suas permissões. Quaisquer mudanças nas permissões de um usuário são efetivadas imediatamente.
