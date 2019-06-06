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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# Resolução de Problemas
{: #troubleshooting}

Se você tiver problemas enquanto está trabalhando com o {{site.data.keyword.datashield_full}}, considere estas técnicas para resolução de problemas e obtenção de ajuda.
{: shortdesc}

## Obtendo ajuda e suporte
{: #gettinghelp}

Para obter ajuda, é possível procurar informações na documentação ou fazendo perguntas em um fórum. Também é possível abrir um chamado de suporte. Quando você estiver usando os fóruns para fazer uma pergunta, marque a sua pergunta para que ela seja vista pela equipe de desenvolvimento do {{site.data.keyword.Bluemix_notm}}.
  * Se você tiver perguntas técnicas sobre o {{site.data.keyword.datashield_short}}, poste sua pergunta no <a href="https://stackoverflow.com/search?q=ibm-data-shield" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="Ícone de link externo"></a> e identifique-a com "ibm-data-shield".
  * Para perguntas sobre o serviço e instruções de introdução, use o fórum <a href="https://developer.ibm.com/answers/topics/data-shield/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="Ícone de link externo"></a>. Inclua a tag `data-shield`.

Para informações adicionais sobre como obter suporte, consulte [como obtenho o suporte de que preciso](/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).


## Eu não sei quais opções posso usar com o instalador
{: #options}

Para ver todos os comandos e obter mais informações de ajuda, é possível executar o comando a seguir e revisar a saída.

```
docker run registry.bluemix.net/ibm/datashield-installer help
```
{: pre}

## Não consigo fazer login na IU do Enclave Manager
{: #ts-log-in}

{: tsSymptoms}
Você tenta acessar a IU do Enclave Manager e não consegue se conectar.

{: tsCauses}
A conexão pode falhar pelos motivos a seguir:

* Talvez você esteja usando um ID do e-mail que não está autorizado a acessar o cluster do Enclave Manager.
* O token que você está usando pode estar expirado.

{: tsResolve}
Para resolver o problema, verifique se você está usando o ID do e-mail correto. Se sim, verifique se o
e-mail tem as permissões corretas para acessar o Enclave Manager. Se você tiver as permissões corretas,
seu token de acesso poderá estar expirado. Os tokens são válidos por 60 minutos a cada vez. Para obter
um novo token, execute `ibmcloud iam oauth-tokens`.


## A API do conversor de contêiner retorna um erro proibido
{: #ts-converter-forbidden-error}

{: tsSymptoms}
Você tenta executar o conversor de contêiner e recebe um erro: `Forbidden`.

{: tsCauses}
Talvez não seja possível acessar o conversor se o seu token do IAM ou Bearer estiver ausente ou expirado.

{: tsResolve}
Para resolver o problema, é necessário verificar se você está usando um token do IBM IAM OAuth ou um
token de autenticação do Enclave Manager no cabeçalho de sua solicitação. Os tokens tomariam o formato a seguir:

* IAM: `Authentication: Basic <IBM IAM Token>`
* Enclave Manager: `Authentication: Bearer <E.M. Token>`

Se seu token estiver presente, verifique se ele ainda é válido e execute a solicitação novamente.


## O conversor de contêiner não é capaz de se conectar a um registro do Docker privado
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
Você tenta executar o conversor de contêiner em uma imagem de um registro do Docker privado e o conversor não consegue se conectar.

{: tsCauses}
As credenciais de registro privado podem não estar configuradas corretamente. 

{: tsResolve}
Para resolver o problema, é possível seguir estas etapas:

1. Verifique se suas credenciais de registro privado foram configuradas anteriormente. Se não, configure-as agora.
2. Execute o comando a seguir para fazer dump de suas credenciais de registro do Docker. Se necessário, é possível mudar o nome do segredo.

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: pre}

3. Use um decodificador Base64 para decodificar o conteúdo do secreto de `.dockerconfigjson` e verifique se ele está correto.


## Não é possível montar dispositivos de soquete AESM ou SGX
{: #ts-problem-mounting-device}

{: tsSymptoms}
Você encontra problemas ao tentar montar contêineres {{site.data.keyword.datashield_short}} em volumes `/var/run/aesmd/aesm.socket` ou `/dev/isgx`.

{: tsCauses}
A montagem pode falhar devido a problemas com a configuração do host.

{: tsResolve}
Para resolver o problema, verifique:

* Se `/var/run/aesmd/aesm.socket` não é um diretório no host. Se for, exclua
o arquivo, desinstale o software {{site.data.keyword.datashield_short}} e execute as etapas de
instalação novamente. 
* Se as SGX estão ativadas no BIOS das máquinas host. Se elas não estiverem ativadas, entre em contato
com o suporte IBM.


## Erro ao converter contêineres
{: #ts-container-convert-fails}

{: tsSymptoms}
Você encontra o erro a seguir ao tentar converter seu contêiner.

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: pre}

{: tsCauses}
No MacOS, se o keychain do OSX for usado em seu arquivo config.json, o conversor de contêiner falhará. 

{: tsResolve}
Para resolver o problema, é possível usar as etapas a seguir:

1. Desative o keychain do OSX em seu sistema local. Acesse **Preferências do sistema > iCloud** e desmarque a caixa para **Keychain**.

2. Exclua o segredo que você criou. Certifique-se de ter efetuado login no IBM Cloud e de ter direcionado seu cluster antes de executar o comando a seguir.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: pre}

3. Em seu arquivo `$HOME/.docker/config.json`, exclua a linha `"credsStore": "osxkeychain"`.

4. Efetue login em seu registro.

5. Criar um novo segredo.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}

6. Liste seus pods e anote o pod com `enclaveos-converter` no nome.

  ```
  kubectl get pods
  ```
  {: pre}

7. Exclua o pod.

  ```
  kubectl delete pod <pod name>
  ```
  {: pre}

8. Converta sua imagem.