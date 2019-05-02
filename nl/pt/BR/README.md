# IBM Cloud Data Shield

Com o IBM Cloud Data Shield, a Fortanix® e as Intel® SGX, é possível proteger os dados em suas
cargas de trabalho de contêiner executadas no IBM Cloud enquanto os dados estão em uso.

## Introdução

Quando se trata de proteger seus dados, a criptografia é uma das formas mais populares e efetivas. Mas os dados devem ser criptografados em cada etapa de seu ciclo de vida para que eles realmente fiquem protegidos. As três fases do ciclo de vida de dados incluem dados em repouso, dados em movimento e dados em uso. Os dados em repouso e em movimento são comumente usados para proteger dados quando eles são armazenados e quando eles são transportados.

No entanto, depois que um aplicativo começa a ser executado, os dados em uso pela CPU e pela
memória ficam vulneráveis a ataques. Usuários internos maliciosos, usuários raiz, comprometimento de credenciais, dia zero do S.O. e invasores de rede são ameaças aos dados. Levando a criptografia um passo adiante, agora é possível proteger os dados em uso. 

Para obter mais informações sobre o serviço e o que significa proteger seus dados em uso, saiba mais [sobre o serviço](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about).



## Detalhes do gráfico

Esse gráfico do Helm instala os componentes a seguir em seu cluster do IBM Cloud Kubernetes Service compatível com as SGX:

 * O software de suporte para as SGX, que é instalado nos hosts bare metal por um contêiner privilegiado.
 * O IBM Cloud Data Shield Enclave Manager, que gerencia os enclaves SGX no ambiente do IBM Cloud Data Shield.
 * O EnclaveOS® Container Conversion Service, que converte aplicativos conteinerizados para que
eles possam ser executados no ambiente do IBM Cloud Data Shield.



## Recursos necessários

* Um cluster Kubernetes compatível com as SGX. Atualmente, as SGX podem ser ativadas em um cluster
bare metal com o tipo de nó mb2c.4x32. Se você não tiver um, poderá usar as etapas a seguir para
ajudar a assegurar a criação do cluster necessário.
  1. Prepare-se para [criar seu cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Assegure-se de ter as [permissões necessárias](https://cloud.ibm.com/docs/containers?topic=containers-users#users) para criar um cluster.

  3. Crie o [cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters).

* Uma instância do serviço [cert-manager](https://cert-manager.readthedocs.io/en/latest/) versão 0.5.0 ou mais recente. Para instalar a instância usando o Helm, é possível executar o comando a seguir.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## Pré-requisito

Antes de poder começar a usar o IBM Cloud Data Shield, deve-se ter os pré-requisitos a seguir. Para
obter ajuda para fazer download das CLIs e dos plug-ins e configurar o ambiente do serviço do Kubernetes, confira o tutorial [Criando clusters Kubernetes](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* As CLIs a seguir:

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  Você pode desejar configurar o Helm para usar o modo `--tls`. Para obter ajuda
para ativar o TLS, confira o [Repositório
do Helm](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Se você ativar o TLS, certifique-se de anexar --tls a cada comando
do Helm executado.
  {: tip}

* Os [plug-ins
da CLI do {{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins) a seguir:

  * Serviço Kubernetes
  * Registro de contêiner



## Instalando o gráfico

Ao instalar um gráfico do Helm, você tem vários parâmetros e opções que podem ser usados para customizar sua instalação. As instruções a seguir descrevem a instalação padrão mais básica do gráfico. Para obter mais informações sobre suas opções, veja [a documentação do IBM Cloud Data Shield](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started).

Dica: as suas imagens são armazenadas em um registro privado? É possível usar o EnclaveOS Container Converter para configurar as imagens para que elas funcionem com o IBM Cloud Data Shield. Certifique-se de converter
suas imagens antes de implementar o gráfico para que você tenha as informações de configuração necessárias. Para obter mais informações sobre como converter imagens, veja [os docs](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert).


**Para instalar o IBM Cloud Data Shield em seu cluster:**

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

3. Se você ainda não tiver feito isso, inclua o repositório `ibm`.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. Opcional: se você não souber o e-mail que está associado ao administrador nem o ID da conta do administrador, execute o comando a seguir.

  ```
  ibmcloud account show
  ```

5. Obtenha o subdomínio do Ingress para seu cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. Instale o gráfico.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  Nota: se você [configurou um IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert) para seu conversor, inclua a opção a seguir: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. Para monitorar a inicialização de seus componentes, é possível executar o comando a seguir.

  ```
  kubectl get pods
  ```

## Executando seus apps no ambiente do IBM Cloud Data Shield

Para executar seus aplicativos no ambiente do IBM Cloud Data Shield, deve-se converter sua imagem de contêiner, incluí-la
na lista de desbloqueio e, em seguida, implementá-la.

### Convertendo suas imagens
{: #converting-images}

É possível usar a API do Enclave Manager para se conectar ao conversor.
{: shortdesc}

1. Efetue login na CLI do IBM Cloud. Siga os prompts na CLI para concluir a criação de log.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. Obtenha e exporte um token do IAM.

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. Converta sua imagem. Certifique-se de substituir as variáveis pelas informações do seu aplicativo.

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### Incluindo seu aplicativo na lista de desbloqueio 
{: #convert-whitelist}

Quando uma imagem do Docker é convertida para execução dentro das Intel SGX, ela pode ser incluída na lista de desbloqueio. Ao incluir sua imagem na lista de desbloqueio, você está designando
privilégios de administrador que permitem que o aplicativo seja executado no cluster no qual o IBM Cloud
Data Shield está instalado.
{: shortdesc}

1. Obtenha um token de acesso do Enclave Manager que esteja utilizando o token de autenticação do IAM usando a solicitação de curl a seguir:

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. Faça uma solicitação de lista de desbloqueio para o Enclave Manager. Certifique-se de inserir suas informações ao executar o comando a seguir.

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. Use a GUI do Enclave Manager para aprovar ou negar solicitações de lista de desbloqueio. É possível controlar e gerenciar construções incluídas na lista de desbloqueio na seção **Construções** da GUI.



### Implementando contêineres do IBM Cloud Data Shield

Depois de converter suas imagens, deve-se reimplementar os contêineres do IBM Cloud Data Shield em seu cluster Kubernetes.
{: shortdesc}

Ao implementar os contêineres do IBM Cloud Data Shield em seu cluster do Kubernetes, a especificação do contêiner deve incluir montagens de volume. Os volumes permitem que os dispositivos SGX e o soquete AESM estejam disponíveis no contêiner.

1. Salve a especificação de pod a seguir como um modelo.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```

2. Atualize os campos `your-app-sgx` e `your-registry-server`
para seu app e seu servidor.

3. Crie o pod do Kubernetes.

   ```
   kubectl create -f template.yml
   ```

Não tem um aplicativo para experimentar o serviço? Sem problema. Oferecemos vários apps de amostra
que você pode experimentar, incluindo o MariaDB e o NGINX. Qualquer uma das [imagens "datashield"](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter) no IBM Container Registry pode ser usada como uma amostra.



## Acessando a GUI do Enclave Manager

É possível ter uma visão geral de todos os aplicativos que são executados em um ambiente do
IBM Cloud Data Shield usando a GUI do Enclave Manager. No console do Enclave Manager, é possível visualizar
os nós em seu cluster, seu status de atestado, as tarefas e um log de auditoria de eventos de cluster. Também é possível aprovar e negar solicitações de lista de desbloqueio.

Para acessar a GUI:

1. Conecte-se ao IBM Cloud e configure o contexto para seu cluster.

2. Verifique se o serviço está em execução confirmando se todos os seus pods estão em
um estado *em execução*.

  ```
  kubectl get pods
  ```

3. Consulte a URL de front-end para seu Enclave Manager executando o comando a seguir.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Obtenha seu subdomínio do Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. Em um navegador, insira o subdomínio do Ingress no qual o seu Enclave Manager está disponível.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. No terminal, obtenha seu token do IAM.

  ```
  ibmcloud iam oauth-tokens
  ```

7. Copie o token e cole-o na GUI do Enclave Manager. Você não precisa copiar a parte `Bearer` do token impresso.

8. Clique em **Conectar**.

Para obter informações sobre as funções que um usuário precisa para executar ações diferentes,
veja [Configurando funções para usuários do Enclave Manager](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles).

## Usando imagens blindadas predefinidas

A equipe do IBM Cloud Data Shield colocou quatro imagens prontas para produção diferentes que
podem ser executadas em ambientes do IBM Cloud Data Shield. É possível experimentar qualquer uma das imagens a seguir:

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Cofre](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## Desinstalando e solucionando problemas

Se você encontrar um problema ao trabalhar com o IBM Cloud Data Shield, tente consultar as seções [Resolução de problemas](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting) ou [Perguntas mais frequentes](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq) da documentação. Se você não vir sua pergunta ou uma solução para seu problema,
entre em contato com o [suporte IBM](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).

Se você não precisar mais usar o IBM Cloud Data Shield, será possível [excluir o serviço e os certificados TLS que foram criados](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall).

