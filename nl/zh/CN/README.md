# IBM Cloud Data Shield

通过 IBM Cloud Data Shield、Fortanix® 以及 Intel® SGX，您可以在使用 IBM Cloud 上运行的容器工作负载中的数据时保护该数据。

## 引言

谈到保护您的数据，加密是最常用、最有效的方式之一。但是，要真正保护数据安全，必须在数据生命周期的每个步骤对数据进行加密。数据在生命周期中经历三个阶段：静态数据、动态数据和使用中的数据。静态数据和动态数据通常用于在数据存储和传输时保护数据。

但是，应用程序开始运行后，CPU 和内存使用的数据易受攻击。恶意内部人员、root 用户、凭证泄露、操作系统零天和网络入侵者都会对数据构成威胁。为了使加密更进一步，您现在可以保护使用中的数据。 

有关该服务的更多信息以及保护使用中的数据的含义，您可以了解[关于服务](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about)的信息。



## chart 详细信息

此 Helm chart 将以下组件安装到启用 SGX 的 IBM Cloud Kubernetes Service 集群上：

 * SGX 的支持软件，通过特权容器安装在裸机主机上。
 * IBM Cloud Data Shield Enclave Manager，用于管理 IBM Cloud Data Shield 环境中的 SGX 封套。
 * EnclaveOS® Container Conversion Service，用于转换容器化应用程序，以便它们能够在 IBM Cloud Data Shield 环境中运行。



## 所需资源

* 启用 SGX 的 Kubernetes 集群。当前，节点类型为 mb2c.4x32 的裸机集群上可以启用 SGX。如果没有所需的集群，那么可以使用以下步骤来帮助确保创建该集群。
  1. 准备[创建集群](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare)。

  2. 确保您具有创建集群[所需的许可权](https://cloud.ibm.com/docs/containers?topic=containers-users#users)。

  3. 创建[集群](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters)。

* [cert-manager](https://cert-manager.readthedocs.io/en/latest/) 服务实例 V0.5.0 或更高版本。要使用 Helm 安装实例，可以运行以下命令。

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## 先决条件

在开始使用 IBM Cloud Data Shield 之前，必须满足以下先决条件。有关下载 CLI 和插件以及配置 Kubernetes Service 环境的帮助，请查看教程
[创建 Kubernetes 集群](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1)。

* 以下 CLI：

  * [{{site.data.keyword.cloud_notm}}](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

  您可能想要将 Helm 配置为使用 `--tls` 方式。有关启用 TLS 的帮助，请查看 [Helm 存储库](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md)。如果启用 TLS，请确保将 `--tls` 附加到运行的每个 Helm 命令。
  {: tip}

* 以下 [{{site.data.keyword.cloud_notm}} CLI 插件](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins)：

  * Kubernetes Service
  * Container Registry



## 安装 chart

安装 Helm chart 时，有多个选项和参数可用于定制安装。以下指示信息将指导您完成 chart 的最基本的缺省安装。有关选项的更多信息，请参阅 [IBM Cloud Data Shield 文档](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started)。

提示：映像存储在专用注册表中吗？您可以使用 EnclaveOS Container Converter 配置映像以用于 IBM Cloud Data Shield。请确保在部署 chart 之前转换映像，以便您拥有必要的配置信息。有关转换映像的更多信息，请参阅[文档](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)。


**要将 IBM Cloud Data Shield 安装到集群上：**

1. 登录到 IBM Cloud CLI。遵循 CLI 中的提示完成登录。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

  <table>
    <tr>
      <th>区域</th>
      <th>IBM Cloud 端点</th>
      <th>Kubernetes Service 区域</th>
    </tr>
    <tr>
      <td>达拉斯</td>
      <td><code>us-south</code></td>
      <td>美国南部</td>
    </tr>
    <tr>
      <td>法兰克福</td>
      <td><code>eu-de</code></td>
      <td>欧洲中部</td>
    </tr>
    <tr>
      <td>悉尼</td>
      <td><code>au-syd</code></td>
      <td>亚太地区南部</td>
    </tr>
    <tr>
      <td>伦敦</td>
      <td><code>eu-gb</code></td>
      <td>英国南部</td>
    </tr>
    <tr>
      <td>东京</td>
      <td><code>jp-tok</code></td>
      <td>亚太地区北部</td>
    </tr>
    <tr>
      <td>华盛顿</td>
      <td><code>us-east</code></td>
      <td>美国东部</td>
    </tr>
  </table>

2. 设置集群的上下文。

  1. 获取命令以设置环境变量并下载 Kubernetes 配置文件。

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```

  2. 复制以 `export` 开头的输出，并将其粘贴到终端中，以设置 `KUBECONFIG` 环境变量。

3. 如果尚未添加 `ibm` 存储库，请进行添加。

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```

4. 可选：如果您不知道与管理员或管理帐户标识关联的电子邮件，请运行以下命令。

  ```
  ibmcloud account show
  ```

5. 获取集群的 Ingress 子域。

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. 安装 chart。

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```

  注：如果您已经为转换器[配置 IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert)，请添加以下选项：`--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. 要监视组件的启动，可以运行以下命令。

  ```
  kubectl get pods
  ```

## 在 IBM Cloud Data Shield 环境中运行应用程序

要在 IBM Cloud Data Shield 环境中运行应用程序，必须对容器映像进行转换，列入白名单，然后进行部署。

### 转换映像
{: #converting-images}

您可以使用 Enclave Manager API 连接到转换器。
{: shortdesc}

1. 登录到 IBM Cloud CLI。遵循 CLI 中的提示完成登录。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

2. 获取并导出 IAM 令牌。

  ```
  export token=`ibmcloud iam oauth-tokens | awk -F"Bearer " '{print $NF}'`
  echo $token
  ```

3. 转换映像。请确保将变量替换为您的应用程序的信息。

  ```
  curl -H 'Content-Type: application/json' -d '{"inputImageName": "your-registry-server/your-app", "outputImageName": "your-registry-server/your-app-sgx"}'  -H "Authorization: Basic $token"  https://enclave-manager.<ingress-domain>/api/v1/tools/converter/convert-app
  ```



### 将应用程序列入白名单
{: #convert-whitelist}

Docker 映像转换为在 Intel® SGX 内部运行时，可以将其列入白名单。通过将映像列入白名单，您将分配管理特权，以允许应用程序在安装了 IBM Cloud Data Shield 的集群上运行。
{: shortdesc}

1. 通过以下 curl 请求，使用 IAM 认证令牌获取 Enclave Manager 访问令牌：

  ```
  export em_token=`curl -X POST https://enclave-manager.<ingress-domain>/api/v1/sys/auth/token -H "Authorization: Basic $token" | jq -r '.access_token'`
  echo $em_token
  ```

2. 向 Enclave Manager 发出白名单请求。请确保在运行以下命令时输入您的信息。

  ```
  curl -X POST https://enclave-manager.<ingress-subdomain>/api/v1/builds -d '{"docker_image_name": "your-app-sgx", "docker_version": "latest", "docker_image_sha": "<...>", "docker_image_size": <...>, "mrenclave": "<...>", "mrsigner": "<..>", "isvprodid": 0, "isvsvn": 0, "app_name": "your-app-sgx"}' -H 'Content-type: application/json' -H "Authorization: Bearer $em_token"
  ```

3. 使用 Enclave Manager GUI 核准或拒绝白名单请求。您可以在 GUI 的**构建**部分中跟踪和管理列入白名单的构建。



### 部署 IBM Cloud Data Shield 容器

转换映像后，必须将 IBM Cloud Data Shield 容器重新部署到 Kubernetes 集群。
{: shortdesc}

将 IBM Cloud Data Shield 容器部署到 Kubernetes 集群时，容器规范必须包含卷安装。这些卷允许 SGX 设备和 AESM 套接字在容器中可用。

1. 将以下 pod 规范另存为模板。

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

2. 将 `your-app-sgx` 和 `your-registry-server` 字段更新为您的应用程序和服务器。

3. 创建 Kubernetes pod。

   ```
   kubectl create -f template.yml
   ```

没有要尝试服务的应用程序吗？不用担心。我们提供了多个可以尝试的样本应用程序，包括 MariaDB 和 NGINX。IBM Container Registry 中的任何[“datashield”映像](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)都可以用作样本。



## 访问 Enclave Manager GUI

您可以使用 Enclave Manager GUI 来查看在 IBM Cloud Data Shield 环境中运行的所有应用程序的概述。在 Enclave Manager 控制台中，可以查看集群中的节点、其认证状态、任务以及集群事件的审计日志。您还可以核准和拒绝白名单请求。

要访问 GUI，请执行以下操作：

1. 登录到 IBM Cloud 并设置集群的上下文。

2. 通过确认所有 pod 都处于 *running* 状态来确定服务正在运行。

  ```
  kubectl get pods
  ```

3. 通过运行以下命令，查找 Enclave Manager 的前端 URL。

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. 获取 Ingress 子域。

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. 在浏览器中，输入您的 Enclave Manager 在其中可用的 Ingress 子域。

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. 在终端中，获取 IAM 令牌。

  ```
  ibmcloud iam oauth-tokens
  ```

7. 复制令牌，并将其粘贴到 Enclave Manager GUI。您无需复制已打印令牌的 `Bearer` 部分。

8. 单击**登录**。

有关用户执行不同操作所需的角色的信息，请参阅[设置 Enclave Manager 用户的角色](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles)。

## 使用预先打包的保护映像

IBM Cloud Data Shield 团队将能够在 IBM Cloud Data Shield 环境中运行的四个不同的生产就绪型映像组合在一起。您可以尝试使用以下任何映像：

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## 卸载和故障诊断

如果使用 IBM Cloud Data Shield 时遇到问题，请尝试查阅文档的[故障诊断](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting)或
[常见问题](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq)部分。如果未看到您的问题或问题解决方案，请联系 [IBM 支持人员](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support)。

如果不再需要使用 IBM Cloud Data Shield，那么可以[删除已创建的服务和 TLS 证书](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall)。

