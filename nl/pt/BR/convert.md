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

# Convertendo imagens
{: #convert}

É possível converter suas imagens para execução em um ambiente do EnclaveOS® usando o {{site.data.keyword.datashield_short}} Container Converter. Depois que suas imagens forem
convertidas, você poderá implementar em seu cluster Kubernetes compatível com as SGX.
{: shortdesc}


## Configurando credenciais de registro
{: #configure-credentials}

É possível permitir que todos os usuários do conversor obtenham imagens de entrada e enviem imagens
de saída para os registros privados configurados, configurando o conversor com credenciais de registro.
{: shortdesc}

### Configurando suas credenciais do {{site.data.keyword.cloud_notm}} Container Registry
{: #configure-ibm-registry}

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. 

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

2. Obtenha um token de autenticação para seu {{site.data.keyword.cloud_notm}} Container Registry.

  ```
  ibmcloud cr token-add --non-expiring --readwrite --description 'EnclaveOS Container Converter'
  ```
  {: pre}

3. Crie um arquivo de configuração JSON usando o token que você criou. Substitua a variável `<token>` e, em seguida, execute o comando a seguir. Se você não tiver o `openssl`, será possível usar qualquer codificador base64 da linha de comandos com
as opções apropriadas. Certifique-se de que não haja novas linhas no meio ou no término da sequência codificada.

  ```
  (echo -n '{"auths":{"registry.ng.bluemix.net":{"auth":"'; echo -n 'token:<token>' | openssl base64 -A;  echo '"}}}') | kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=/dev/stdin
  ```
  {: pre}

### Configurando credenciais para outro registro
{: #configure-other-registry}

Se você já tiver um arquivo `~/.docker/config.json` autenticado no registro
que deseja usar, será possível usar esse arquivo.

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Execute o comando a seguir.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: pre}



## Convertendo suas imagens
{: #converting-images}

É possível usar a API do Enclave Manager para se conectar ao conversor.
{: shortdesc}

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Obtenha e exporte um token do IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```
  {: pre}

3. Converta sua imagem. Certifique-se de substituir as variáveis pelas informações do seu aplicativo.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```
  {: pre}



## Solicitando um certificado de aplicativo
{: #request-cert}

Um aplicativo convertido poderá solicitar um certificado do Enclave Manager quando seu aplicativo for iniciado. Os certificados são assinados pela Autoridade de Certificação do Enclave Manager e incluem o relatório de atestado remoto da Intel para o enclave SGX de seu app.
{: shortdesc}

Confira o exemplo a seguir para ver como configurar uma solicitação para gerar uma chave privada RSA e gerar o certificado para a chave. A chave é mantida na raiz do contêiner de aplicativo. Se
você não quiser uma chave/certificado efêmero, poderá customizar o `keyPath` e o `certPath` para seus apps e armazená-los em um volume persistente.

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
 {: pre}


## Incluindo seus aplicativos na lista de desbloqueio 
{: #convert-whitelist}

Quando uma imagem do Docker é convertida para execução dentro das Intel® SGX, ela pode ser
incluída na lista de desbloqueio. Ao incluir sua imagem na lista de desbloqueio, você
está designando privilégios de administrador que permitem que o aplicativo seja executado no cluster
no qual o {{site.data.keyword.datashield_short}} está instalado.
{: shortdesc}

1. Obtenha um token de acesso do Enclave Manager que esteja utilizando o token de autenticação do IAM usando
a solicitação de curl a seguir:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```
  {: pre}

2. Faça uma solicitação de lista de desbloqueio para o Enclave Manager. Certifique-se de inserir suas informações quando executar o comando a seguir.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json'
  ```
  {: pre}

3. Use a GUI do Enclave Manager para aprovar ou negar solicitações de lista de desbloqueio. É possível controlar e gerenciar construções incluídas na lista de desbloqueio na seção **Construções** da GUI.
