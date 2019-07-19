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


# Fazendo Backup e Restaurando
{: #backup-restore}

É possível fazer backup e restaurar a instância do Enclave Manager.
{: shortdesc}


## Fazendo backup de sua instância do Enclave Manager
{: #backup}

É possível configurar o {{site.data.keyword.datashield_full}} para fazer backup periodicamente do banco de dados do Enclave Manager no {{site.data.keyword.cos_full_notm}}.
{: shortdesc}

Considere inscrever os hosts em mais de um local físico para minimizar o risco de perda de dados. É possível restaurar o Enclave Manager no hardware que foi inscrito anteriormente no cluster do Enclave Manager apenas.
{: tip}


1. Crie um [ID de serviço](/docs/services/cloud-object-storage?topic=cloud-object-storage-service-credentials) usando as instruções na documentação do {{site.data.keyword.cos_short}} e selecionando a opção para incluir as credenciais do HMAC. A tarefa de backup usa as credenciais do HMAC para a autenticação no {{site.data.keyword.cos_short}}.

2. Crie um segredo do Kubernetes com as credenciais para a autenticação no {{site.data.keyword.cos_short}}.
    
    ```
    kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
    ```
    {: codeblock}

3. Inclua as opções a seguir no comando `helm install` quando instalar o Data Shield ou no comando `helm upgrade` quando fizer upgrade de uma instância existente do {{site.data.keyword.datashield_full}}. Modifique os valores a seguir para seu ambiente. `enclaveos-chart.Backup.CronSchedule` é seu planejamento de backup, que é especificado na sintaxe do cron. Por exemplo, `0 0 * * *` executa um backup diariamente à meia-noite, pela Hora Universal Coordenada. `global.S3.Endpoint` corresponde ao local do depósito do {{site.data.keyword.cos_short}} que você criou, que pode ser consultado na [tabela de terminais](/docs/services/cloud-object-storage?topic=cloud-object-storage-endpoints).
    
    ```
    --set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
    --set global.S3.Endpoint=<endpoint>
    --set global.S3.Bucket=<orgname>-enclave-manager-backups
    --set global.S3.HmacSecretName=enclave-manager-backup-credentials
    ```
    {: codeblock}

    Opcionalmente, também é possível configurar `enclaveos-chart.Backup.S3Prefix` em um caminho dentro do depósito do {{site.data.keyword.cos_short}} no qual você deseja armazenar o backup. Por padrão, os backups são armazenados na raiz do depósito.
    {: tip}



## Restaurando o Enclave Manager
{: #restore}

Se você configurou o seu gráfico do Helm para criar um backup do Enclave Manager antes de implementá-lo, será possível restaurá-lo se você encontrar algum problema.

1. Certifique-se de que esteja executando em um nó que esteve em execução no Enclave Manager anteriormente. Os dados do Enclave Manager são criptografados usando chaves seladoras SGX e podem ser decriptografados apenas no mesmo hardware.

2. Implemente o Enclave Manager com 0 instâncias do servidor de back-end configurando o valor do Helm a seguir.

    ```
    --set enclaveos-chart.Manager.ReplicaCount=0
    ```
    {: codeblock}

3. Depois que o Enclave Manager tiver sido implementado, copie o backup para o contêiner de banco de dados.

    ```
    kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
    ```
    {: codeblock}

4. Crie um shell no contêiner de banco de dados.

    ```
    kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
    ```
    {: codeblock}

5. Prepare o banco de dados para a restauração do seu backup.

    1. Crie um shell SQL.

        ```
        ./cockroach sql --insecure
        ```
        {: codeblock}
    
    2. Quando solicitado pelo SQL, execute os comandos a seguir.

        ```
        drop database malbork cascade;
        create database malbork;
        ```
        {: codeblock}
    
    3. Saia e execute o comando a seguir.

        ```
        ./cockroach sql --insecure -d malbork < <your backup>.sql
        ```
        {: codeblock}

6. Aumente a capacidade de implementação do Enclave Manager executando `helm upgrade` sem configurar o valor `enclaveos-chart.Manager.ReplicaCount`.

