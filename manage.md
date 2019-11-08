---

copyright:
  years: 2018, 2019
lastupdated: "2019-10-18"

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

# Deploying apps with the Enclave Manager
{: #enclave-manager}

You can use the Enclave Manager UI to manage the applications that you protect with {{site.data.keyword.datashield_full}}. From the UI you can manage your app deployment, assign access, handle whitelist requests, and convert your applications.
{: shortdesc}


## Signing in
{: #em-signin}

In the Enclave Manager console, you can view the nodes in your cluster and their attestation status. You can also view tasks and an audit logs of cluster events. To get started, sign in.
{: shortdesc}

1. Be sure that you have the [correct access](/docs/services/data-shield?topic=data-shield-access).

2. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: codeblock}

3. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

4. Check to see that all your service is running by confirming that all of your pods are in an *active* state.

  ```
  kubectl get pods
  ```
  {: codeblock}

5. Get your Ingress subdomain.

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

8. Copy the just the alpha-numeric portion of the token and paste it into the Enclave Manager GUI. You do not need to copy the word `Bearer`.

9. Click **Sign in**.



## Managing nodes
{: #em-nodes}

You can use the Enclave Manager UI to monitor the status, deactivate, or download the certificates for nodes that run IBM Cloud Data Shield in your cluster.
{: shortdesc}


1. [Sign in](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) to the Enclave Manager.

2. Go to the **Nodes** tab.

3. Click the IP address of the node that you want to investigate. An information screen opens.

4. On the information screen, you can choose to remove the node from your whitelist by clicking **Delist node** or you can download the certificate that is used for attestation.



## Adding an app
{: #em-app-add}

You can convert, deploy, and whitelist your application all at the same time by using the Enclave Manager UI.
{: shortdesc}

1. [Sign in](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) to the Enclave Manager and go to the **Apps** tab.

2. Click **Add new application**.

3. Give your application a name and description.

4. Enter the input and output name for your images. The input is the name of your registry and image without the tag. The output is the name of the registry and image where you want to send the converted application.

5. Enter an **ISVPRDID**. It is a numeric product identifier that you assign to the enclave. You can choose a unique value in range 0 - 65,535.

6. Enter an **ISVSVN**. It is a numeric security version that you assign to the enclave. When you make a change that affects your application security, be sure to incrementally increase the value.

7. Provide a memory size for your Enclave. If your application uses a large amount of memory, you can use a large enclave. However, the size of your enclave can affect your performance. Be sure that your memory allocation is set to a power of 2. For example: `2048 MB`.

8. Enter a number of threads for your enclave that is large enough to accommodate the maximum number of processes that run in your app.

6. Enter any allowed domains.

7. Edit any advanced settings that you might want to change.

8. Click **Add**. The application added to your list of available applications. To deploy your app, create a build and then approve the build request in the **tasks** tab.




## Editing an app
{: #em-app-edit}

You can edit an application after you add it to your list.
{: shortdesc}


1. [Sign in](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) to the Enclave Manager and go to the **Apps** tab.

2. Click the name of the application that you want to edit. A new screen opens where you can review the configuration including certificates and deployed builds.

3. Click **Edit application**.

4. Update the configuration. Be sure that you understand the way that changing the advanced settings affects your application before you make any changes.

5. Click **Update application**.




## Building applications
{: #em-builds}

You can use the Enclave Manager UI to rebuild your applications after you make changes.
{: shortdesc}

1. [Sign in](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) to the Enclave Manager and go to the **Builds** tab.

2. Click **Create new build**.

3. Select an application from the drop-down list or click **[add an application](/docs/services/data-shield?topic=data-shield-enclave-manager#em-app-add)** to go to the app tab.

4. Enter the name of your Docker image and tag it with a label.

5. Click **Create**. The build is added to your whitelist. You can approve the build in the **Tasks** tab.



## Approving tasks
{: #em-tasks}

When an application is whitelisted, it is added to the list of pending requests in the **Tasks** tab of the Enclave Manager UI. You can use the UI to approve or deny the request.
{: shortdesc}

1. [Sign in](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) to the Enclave Manager and navigate to the **Tasks** tab.

2. Click the row of the request that you want to approve or deny. A screen with more information opens.

3. Review the request and click **Approve** or **Deny**. Your name is added to the list of **Reviewers**.


## Viewing logs
{: #em-view}

You can audit your Enclave manager instance for several different types of activity.
{: shortdesc}

1. Navigate to the **Audit log** tab of the Enclave Manager UI.
2. Filter the logging results to narrow your search. You can choose to filter by timeframe or by any of the following types.

  * App status: Activity that pertains to your application such as whitelist requests and new builds.
  * User approval: Activity that pertains to a user's access such as their approval or denial to use the account.
  * Node attestation: Activity that pertains to node attestation.
  * Certificate authority: Activity that pertains to a certificate authority.
  * Administration: Activity that pertains to administration.

If you want to keep a record of the logs beyond 1 month, you can export the information as a `.csv` file.
{: tip}

## Configure Certificate
{: #em-certificate}

Add a certificate using the Certificate configuration section in the **Add application** page of {{site.data.keyword.datashield_short}}. A converted application can request a certificate from  {{site.data.keyword.datashield_short}} when your application is started. The certificates are signed by the IBM Cloud Data Shield Certificate Authority, which issues certificates only to enclaves presenting a valid attestation. Following are the **Certificate Configuration** fields:
* Key path – Enter the key path that will be accessible by the application. For example: `/etc/nginx/nginx-key.pem`
* Certificate path – Enter the certificate path that will be accessible by the application. For example: `/etc/nginx/nginx-cert.pem`
* CA Cert path (optional) – Enter the path to store the Data Shield CA certificate.For example: `/etc/cacert.pem`
* Chain path (optional) – Enter the chain path for the complete certificate chain.
* Subject – Enter the subject which is same as the value in the Allowed domain(s) list.

As an optional step, the user can install the CA certificate in the system trust store where all the certificates are stored. Following are the three options:
*	**Yes, install and continue build conversion even if the installation fails** – select this option if you want to convert the build even after the CA Certificate installation fails.
*	**Yes, install and fail build conversion if the installation fails** – select this option if you want to stop build conversion after the CA Certificate installation fails.
*	**No, do not install** – select this option if you do not want to install the CA Certificate.
