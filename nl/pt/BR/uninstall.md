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

# Desinstalando
{: #uninstall}

Se você não precisar mais usar o {{site.data.keyword.datashield_full}}, será possível excluir o serviço e os certificados TLS que foram criados.


## Desinstalando com o Helm

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log.

  ```
  ibmcloud login -a https://api. < region> .bluemix.net
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

2. Configure o contexto para seu cluster.

  1. Obtenha o comando para configurar a variável de ambiente e fazer download dos arquivos de configuração do Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copie a saída e cole-a em seu terminal.

3. Exclua o serviço.

  ```
  helm delete datashield --purge
  ```
  {: pre}

4. Exclua os certificados TLS executando cada um dos comandos a seguir.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: pre}

5. O processo de desinstalação usa "hooks" do Helm para executar um desinstalador. É possível excluir o desinstalador após ele ser executado.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: pre}

Você também pode desejar excluir a instância `cert-manager` e o segredo da configuração do Docker caso você tenha criado um.
{: tip}



## Desinstalando com o instalador beta
{: #uninstall-installer}

Se você instalou o {{site.data.keyword.datashield_short}} usando o instalador beta, também é possível desinstalar o serviço com o instalador.

Para desinstalar o {{site.data.keyword.datashield_short}}, efetue login na CLI `ibmcloud`, tenha como destino o cluster e execute o comando a seguir:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: pre}
