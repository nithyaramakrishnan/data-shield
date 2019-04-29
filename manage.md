---

copyright:
  years: 2018, 2019
lastupdated: "2019-04-29"

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

# Managing
{: #managing}

You can manage your instance of {{site.data.keyword.datashield_full}} through the GUI. You can manage the {{site.data.keyword.datashield_short}} service instance itself through the {{site.data.keyword.cloud_notm}} dashboard. From the dashboard, you can get to the Enclave Manager where you can view and manage cluster events.
{: shortdesc}


## Managing your service instance
{: #managing-service}

In the {{site.data.keyword.cloud_notm}} dashboard, you can update and delete your instance of the service. You can also easily get to the Enclave Manager and see a summary of the service.


Check out the following table to learn about the type of information you see in the summary. 

<table>
    <tr>
        <th colspan=2>Understanding the service summary</th>
    </tr>
    <tr>
        <td>Name</td>
        <td>The name of the cluster in which Data Shield is running.</td>
    </tr>
    <tr>
        <td>State</td>
        <td></td>
    </tr>
    <tr>
        <td>Zones</td>
        <td>Lists the zones in which you are running the service.</td>
    </tr>
    <tr>
        <td>Worker count</td>
        <td>The number of worker nodes that are running in your cluster.</td>
    </tr>
    <tr>
        <td>Created</td>
        <td>The date that your cluster was created.</td>
    </tr>
    <tr>
        <td>Kubernetes version</td>
        <td>The version of Kubernetes that your cluster is running.</td>
    </tr>
    <tr>
        <td>Data Shield version</td>
        <td>The version of Data Shield that is running in your cluster.</td>
    </tr>
</table>


To manage your service instance, navigate to the **Manage** tab of your {{site.data.keyword.datashield_short}} service dashboard. When there, you can perform the following actions:


* Click **Update** to get the newest version of the service.
* Click the trash can icon to delete your service instance.
* Click **Open Enclave Manager** to get to the Enclave Manager. A new screen opens.



## Signing in to the Enclave Manager
{: #managing-iam}

In the Enclave Manager console, you can view the nodes in your cluster and their attestation status. You can also view tasks and an audit logs of cluster events.

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: pre}

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

3. Check to see that all your service is running by confirming that all of your pods are in an *active* state.

  ```
  kubectl get pods
  ```
  {: pre}

4. Look up the frontend URL for your Enclave Manager by running the following command.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: pre}

5. Obtain your Ingress subdomain.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: pre}

6. In a browser, enter the Ingress subdomain where your Enclave Manager is available.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: pre}

7. In terminal, get your IAM token.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: pre}

8. Copy the token and paste it into the Enclave Manager GUI. You do not need to copy the `Bearer` portion of the printed token.

9. Click **Sign in**.



