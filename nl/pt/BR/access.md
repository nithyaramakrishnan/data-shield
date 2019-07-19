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

# Atribuindo acesso
{: #access}

É possível controlar o acesso ao {{site.data.keyword.datashield_full}} Enclave Manager. Esse tipo de controle de acesso é separado das funções típicas do Identity and Access Management (IAM) que você usa quando está trabalhando com o {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Designando acesso ao cluster
{: #access-cluster}

Antes de poder se conectar ao Enclave Manager, deve-se ter acesso ao cluster no qual o Enclave Manager está em execução.
{: shortdesc}

1. Conecte-se à conta que hospeda o cluster ao qual você deseja se conectar.

2. Acesse **Gerenciar > Acesso (IAM) > Usuários**.

3. Clique em  ** Convidar usuários **.

4. Forneça os endereços de e-mail para o usuário que você deseja incluir.

5. Na lista suspensa **Designar acesso a**, selecione **Recurso**.

6. Na lista suspensa **Serviços**, selecione **Serviço do Kubernetes**.

7. Selecione uma **Região**, **Cluster** e **Namespace**.

8. Usando como guia a documentação do serviço do Kubernetes sobre a [designação de acesso ao cluster](/docs/containers?topic=containers-users), designe o acesso que o usuário precisa para concluir suas tarefas.

9. Clique em **Salvar**.

## Configurando funções para usuários do Enclave Manager
{: #enclave-roles}

A administração do {{site.data.keyword.datashield_short}} ocorre no Enclave Manager. Como um administrador, você é designado automaticamente com a função de *gerenciador*, mas também é
possível designar funções a outros usuários.
{: shortdesc}

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
    <td>Pode executar as ações que um Leitor pode executar e mais, incluindo a desativação e a renovação do atestado de nó, uma construção e a aprovando ou negação de qualquer ação ou tarefa.</td>
    <td>Certificar um aplicativo.</td>
  </tr>
  <tr>
    <td>Manager</td>
    <td>Pode executar as ações que um Gravador pode executar e mais, incluindo a atualização de nomes de usuários e funções, a inclusão de usuários no cluster, a atualização das configurações de cluster e qualquer outra ação privilegiada.</td>
    <td>Atualizar uma função de usuário.</td>
  </tr>
</table>


### Incluindo um usuário
{: #set-roles}

Usando a GUI do Enclave Manager, é possível fornecer ao novo usuário acesso às informações.
{: shortdesc}

1. Conecte-se ao Enclave Manager.

2. Clique em **Seu nome > Configurações**.

3. Clique em **Incluir usuário**.

4. Insira um e-mail e um nome para o usuário. Selecione uma função na lista suspensa **Função**.

5. Clique em **Salvar**.



### Atualizando um Usuário
{: #update-roles}

É possível atualizar as funções que estão designadas aos usuários e seus nomes.
{: shortdesc}

1. Conecte-se à [IU do Enclave Manager](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin).

2. Clique em **Seu nome > Configurações**.

3. Passe o mouse sobre o usuário cujas permissões você deseja editar. Um ícone de lápis é exibido.

4. Clique no ícone de lápis. A tela de edição do usuário se abre.

5. Na lista suspensa **Função**, selecione as funções que você deseja designar.

6. Atualize o nome do usuário.

7. Clique em **Salvar**. Quaisquer mudanças nas permissões de um usuário são efetivadas imediatamente.


