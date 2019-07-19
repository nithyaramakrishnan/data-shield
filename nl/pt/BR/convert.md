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

# Convertendo imagens
{: #convert}

É possível converter suas imagens para execução em um ambiente do EnclaveOS® usando o {{site.data.keyword.datashield_short}} Container Converter. Depois que suas imagens forem convertidas, será possível implementá-las em seu cluster Kubernetes compatível com SGX.
{: shortdesc}

É possível converter seus aplicativos sem mudar o código. Ao executar a conversão, você está preparando seu aplicativo para ser executado em um ambiente EnclaveOS. É importante observar que o processo de conversão não criptografa o seu aplicativo. Somente dados que são gerados no tempo de execução, depois que o aplicativo é iniciado dentro de um Enclave SGX, são protegidos pelo IBM Cloud Data Shield. 

O processo de conversão não criptografa o seu aplicativo.
{: important}


## Antes de começar
{: #convert-before}

Antes de converter seus aplicativos, é necessário assegurar-se de que você entenda completamente as considerações a seguir.
{: shortdesc}

* Por motivos de segurança, os segredos devem ser fornecidos no tempo de execução e não colocados na imagem de contêiner que você deseja converter. Quando o aplicativo é convertido e está em execução, é possível verificar por meio do atestado se o aplicativo está em execução em um enclave antes de fornecer qualquer segredo.

* O guest do contêiner deve ser executado como o usuário raiz do contêiner.

* O teste incluiu contêineres baseados em Debian, Ubuntu e Java com resultados variados. Outros ambientes podem funcionar, mas não foram testados.


## Configurando credenciais de registro
{: #configure-credentials}

É possível permitir que todos os usuários do conversor de contêiner do {{site.data.keyword.datashield_short}} obtenham imagens de entrada e enviem por push imagens
de saída para os registros privados definidos ao configurar o conversor com as credenciais de registro. Se você usou o registro do contêiner antes de 4 de outubro de 2018, talvez você queira [ativar o cumprimento de política de acesso do IAM para o seu registro](/docs/services/Registry?topic=registry-user#existing_users).
{: shortdesc}

### Configurando suas credenciais do {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log. Se você tiver um ID federado, anexe a opção `--sso` no final do comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Crie um ID de serviço e uma chave de API do ID de serviço para o conversor de contêiner do {{site.data.keyword.datashield_short}}.

  ```
  ibmcloud iam service-id-create data-shield-container-converter -d 'Data Shield Container Converter'
  ibmcloud iam service-api-key-create 'Data Shield Container Converter' data-shield-container-converter
  ```
  {: codeblock}

3. Conceda permissão ao ID de serviço para acessar o seu registro de contêiner.

  ```
  ibmcloud iam service-policy-create data-shield-container-converter --roles Reader,Writer --service-name container-registry
  ```
  {: codeblock}

4. Crie um arquivo de configuração JSON usando a chave de API que você criou. Substitua a variável `<api key>` e, em seguida, execute o comando a seguir. Se você não tiver o `openssl`, será possível usar qualquer codificador base64 da linha de comandos com
as opções apropriadas. Certifique-se de que não haja nenhuma nova linha no meio ou no final da sequência codificada.

  ```
  (echo -n '{"auths":{"<region>.icr.io":{"auth":"'; echo -n 'iamapikey:<api key>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: codeblock}

### Configurando credenciais para outro registro
{: #configure-other-registry}

Se você já tiver um arquivo `~/.docker/config.json` autenticado no registro
que deseja usar, será possível usar esse arquivo. Os arquivos no OS X não são suportados atualmente.

1. Configure os [segredos de pull](/docs/containers?topic=containers-images#other).

2. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log. Se você tiver um ID federado, anexe a opção `--sso` no final do comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. Execute o comando a seguir.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}



## Convertendo suas imagens
{: #converting-images}

É possível usar a API do Enclave Manager para se conectar ao conversor.
{: shortdesc}

Também é possível converter seus contêineres ao construir seus aplicativos por meio da [IU do Enclave Manager](/docs/services/data-shield?topic=enclave-manager#em-apps).
{: tip}

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log. Se você tiver um ID federado, anexe a opção `--sso` no final do comando.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Obtenha e exporte um token do IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: codeblock}

3. Converta sua imagem. Certifique-se de substituir as variáveis pelas informações do seu aplicativo.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: codeblock}

### Convertendo aplicativos Java
{: #convert-java}

Quando você converte aplicativos baseados em Java, há alguns requisitos e limitações extras. Ao converter aplicativos Java usando a IU do Enclave Manager, é possível selecionar `Java-Mode`. Para converter aplicativos Java usando a API, lembre-se das limitações e opções a seguir.

** Limitações **

* O tamanho máximo recomendado do enclave para aplicativos Java é 4 GB. Os enclaves maiores podem funcionar, mas podem ter um desempenho degradado.
* O tamanho de heap recomendado é menor que o tamanho do enclave. Recomendamos a remoção de qualquer opção `-Xmx` como uma maneira de diminuir o tamanho de heap.
* As bibliotecas Java a seguir foram testadas:
  - Conector Java MySQL
  - Crypto (`JCA`)
  - Sistema de mensagens (`JMS`)
  - Hibernate (`JPA`)

  Se você estiver trabalhando com outra biblioteca, entre em contato com nossa equipe usando os fóruns ou clicando no botão de feedback nesta página. Certifique-se de incluir suas informações de contato e a biblioteca com a qual você está interessado em trabalhar.


**Opções**

Para usar a conversão `Java-Mode`, modifique seu arquivo Docker para fornecer as opções a seguir. Para que a conversão Java funcione, deve-se configurar todas as variáveis conforme elas são definidas nesta seção. 


* Configure a variável de ambiente MALLOC_ARENA_MAX igual a 1.

  ```
  MALLOC_ARENA_MAX=1
  ```
  {: codeblock}

* Se você estiver usando a `OpenJDK JVM`, configure as opções a seguir.

  ```
  -XX:CompressedClassSpaceSize=16m
  -XX:-UsePerfData 
  -XX:ReservedCodeCacheSize=16m 
  -XX:-UseCompiler 
  -XX:+UseSerialGC 
  ```
  {: codeblock}

* Se você estiver usando a `OpenJ9 JVM`, configure as opções a seguir.

  ```
  -Xnojit
  –Xnoaot
  ```
  {: codeblock}

## Solicitando um certificado de aplicativo
{: #request-cert}

Um aplicativo convertido poderá solicitar um certificado do Enclave Manager quando seu aplicativo for iniciado. Os certificados são assinados pela Autoridade de Certificação do Enclave Manager e incluem o relatório de atestado remoto da Intel para o enclave SGX de seu app.
{: shortdesc}

Confira o exemplo a seguir para ver como configurar uma solicitação para gerar uma chave privada RSA e gerar o certificado para a chave. A chave é mantida na raiz do contêiner de aplicativo. Se você não desejar uma chave efêmera ou certificado, será possível customizar o `keyPath` e o `certPath` para os seus aplicativos e armazená-los em um volume persistente.

1. Salve o modelo a seguir como `app.json` e faça a mudança necessária para ajustar os requisitos de certificado de seu aplicativo.

 ```json
 {
       "inputImageName": "your-registry-server/your-app",
       "outputImageName": "your-registry-server/your-app-sgx",
       "certificates": [
         {
           "issuer": "MANAGER_CA",
           "subject": "SGX-Application",
           "keyType": "rsa",
           "keyParam": {
             "size": 2048
           },
           "keyPath": "/appkey.pem",
           "certPath": "/appcert.pem",
           "chainPath": "none"
         }
       ]
 }
 ```
 {: screen}

2. Insira suas variáveis e execute o comando a seguir para executar o conversor novamente com suas informações de certificado.

 ```
 curl -H 'Content-Type: application/json' -d @app.json  -H "Authorization: Basic $token"  https://enclave-manager.<Ingress-subdomain>/api/v1/tools/converter/convert-app
 ```
 {: codeblock}


## Aplicativos da lista de aplicativos confiáveis
{: #convert-whitelist}

Quando uma imagem do Docker é convertida para execução dentro das Intel® SGX, ela pode ser
incluída na lista de desbloqueio. Ao incluir sua imagem na lista de desbloqueio, você
está designando privilégios de administrador que permitem que o aplicativo seja executado no cluster
no qual o {{site.data.keyword.datashield_short}} está instalado.
{: shortdesc}


1. Obtenha um token de acesso do Enclave Manager usando o token de autenticação do IAM:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: codeblock}

2. Faça uma solicitação de lista de desbloqueio para o Enclave Manager. Certifique-se de inserir suas informações quando executar o comando a seguir.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: codeblock}

3. Use a GUI do Enclave Manager para aprovar ou negar solicitações de lista de desbloqueio. É possível controlar e gerenciar as construções incluídas na lista de desbloqueio na seção **Tarefas** da GUI.

