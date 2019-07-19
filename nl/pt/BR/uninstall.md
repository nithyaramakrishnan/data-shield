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

# Desinstalando
{: #uninstall}

Se você não precisar mais usar o {{site.data.keyword.datashield_full}}, será possível excluir o serviço e os certificados TLS que foram criados.


## Desinstalando com o Helm
{: #uninstall-helm}

1. Efetue login na CLI do {{site.data.keyword.cloud_notm}}. Siga os prompts na CLI para concluir a criação de log. Se você tiver um ID federado, anexe a opção `--sso` no final do comando.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Região</th>
      <th>Terminal do {{site.data.keyword.cloud_notm}}</th>
      <th>Região do {{site.data.keyword.containershort_notm}}</th>
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
    {: codeblock}

  2. Copie a saída e cole-a em seu console.

3. Exclua o serviço.

  ```
  helm delete <chart-name> --purge
  ```
  {: codeblock}

4. Exclua os certificados TLS executando cada um dos comandos a seguir.

  ```
  kubectl delete secret <chart-name>-enclaveos-converter-tls
  kubectl delete secret <chart-name>-enclaveos-frontend-tls
  kubectl delete secret <chart-name>-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. O processo de desinstalação usa "hooks" do Helm para executar um desinstalador. É possível excluir o desinstalador após ele ser executado.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

Você também pode desejar excluir a instância `cert-manager` e o segredo da configuração do Docker caso você tenha criado um.
{: tip}


## Desinstalando com o instalador
{: #uninstall-installer}

Se você instalou o {{site.data.keyword.datashield_short}} usando o instalador, também será possível desinstalar o serviço com o instalador.

Para desinstalar o {{site.data.keyword.datashield_short}}, efetue login na CLI `ibmcloud`, tenha como destino o cluster e execute o comando a seguir:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config <region>.icr.io/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

