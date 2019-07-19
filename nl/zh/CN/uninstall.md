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

# 卸载 
{: #uninstall}

如果您不再需要使用 {{site.data.keyword.datashield_full}}，那么可以删除已创建的服务和 TLS 证书。


## 使用 Helm 卸载
{: #uninstall-helm}

1. 登录到 {{site.data.keyword.cloud_notm}} CLI。遵循 CLI 中的提示完成登录。如果您具有联合标识，请将 `--sso` 选项附加到命令末尾。

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>区域</th>
      <th>{{site.data.keyword.cloud_notm}} 端点</th>
      <th>{{site.data.keyword.containershort_notm}} 区域</th>
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
    {: codeblock}

  2. 复制输出并将其粘贴到控制台中。

3. 删除服务。

  ```
  helm delete <chart-name> --purge
  ```
  {: codeblock}

4. 通过运行以下每个命令来删除 TLS 证书。

  ```
  kubectl delete secret <chart-name>-enclaveos-converter-tls
  kubectl delete secret <chart-name>-enclaveos-frontend-tls
  kubectl delete secret <chart-name>-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. 卸载过程使用 Helm“挂钩”运行卸载程序。您可以在卸载程序运行后删除卸载程序。

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

您可能还希望删除 `cert-manager` 实例和 Docker 配置私钥（如果已创建）。
{: tip}


## 使用安装程序进行卸载
{: #uninstall-installer}

如果通过使用安装程序安装了 {{site.data.keyword.datashield_short}}，那么还可以使用安装程序来卸载该服务。

要卸载 {{site.data.keyword.datashield_short}}，请登录到 `ibmcloud` CLI，将您的集群设置为目标，然后运行以下命令：

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

