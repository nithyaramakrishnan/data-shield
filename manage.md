---

copyright:
  years: 2018, 2019
lastupdated: "2019-05-15"

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

# Working with the Enclave Manager
{: #enclave-manager}

You can manage your instance of {{site.data.keyword.datashield_full}} through the GUI. You can manage the {{site.data.keyword.datashield_short}} service instance itself through the {{site.data.keyword.cloud_notm}} dashboard. From the dashboard, you can get to the Enclave Manager where you can view and manage cluster events.
{: shortdesc}



## Signing in to the Enclave Manager
{: #em-signin}

In the Enclave Manager console, you can view the nodes in your cluster and their attestation status. You can also view tasks and an audit logs of cluster events.

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

3. Check to see that all your service is running by confirming that all of your pods are in an *active* state.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Look up the front end URL for your Enclave Manager by running the following command.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Obtain your Ingress subdomain.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. In a browser, enter the Ingress subdomain where your Enclave Manager is available.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

7. In terminal, get your IAM token.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. Copy the token and paste it into the Enclave Manager GUI. You do not need to copy the `Bearer` portion of the printed token.

9. Click **Sign in**.



