---

copyright:
  years: 2018, 2019
lastupdated: "2019-06-05"

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

# Using the Enclave Manager
{: #enclave-manager}

You can use the Enclave Manager UI to manage the applications that you protect with {{site.data.keyword.datashield_full}}. From the UI you can manage your app deployment, assign access, handle whitelist requests and convert your applications.
{: shortdesc}


## Signing in
{: #em-signin}

In the Enclave Manager console, you can view the nodes in your cluster and their attestation status. You can also view tasks and an audit logs of cluster events. To get started, sign in.
{: shortdesc}

1. Be sure that you have the [correct access](/docs/services/data-shield?topic=data-shield-access).

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






## Managing nodes
{: #em-nodes}

You can use the Enclave Manager UI to monitor the status, deactivate, or download the certificates for nodes that run IBM Cloud Data Shield in your cluster.
{: shortdesc}


1. Sign in to the Enclave Manager.

2. Navigate to the **Nodes** tab.

3. Click the IP address of the node that you want to investigate. An information screen opens.

4. On the information screen, you can choose to deactivate the node or download the certificate that is used.




## Deploying applications
{: #em-apps}

You can use the Enclave Manager UI to deploy your applications.
{: shortdesc}


### Adding an app
{: #em-app-add}

You can convert, deploy, and whitelist your application all at the same time by using the Enclave Manager UI.
{: shortdesc}

1. Sign in to the Enclave Manager and navigate to the **Apps** tab.

2. Click **Add new application**.

3. Give your application a name and description.

4. Enter the input and output name for your images. The input is your current application name. The output is where you can find the converted application.

5. Enter an **ISVPRDID** and **ISVSVN**.

6. Enter any allowed domains.

7. Edit any advanced settings that you might want to change.

8. Click **Create new application**. The application is deployed and added to your whitelist. You can approve the build request in the **tasks** tab.




### Editing an app
{: #em-app-edit}

You can edit an application after you add it to your list.
{: shortdesc}


1. Sign in to the Enclave Manager and navigate to the **Apps** tab.

2. Click the name of the application that you want to edit. A new screen opens where you can review the configuration including certificates and deployed builds.

3. Click **Edit application**.

4. Update the configuration that you want to make. Be sure to that you understand the way that changing the advanced settings affects your application before making any advanced change.

5. Click **Edit application**.


## Building applications
{: #em-builds}

You can use the Enclave Manager UI to rebuild your applications after you make changes.
{: shortdesc}

1. Sign in to the Enclave Manager and navigate to the **Builds** tab.

2. Click **Create new build**.

3. Select an application from the drop-down list or add an application.

4. Enter the name of your Docker image and tag it with a specific 

5. Click **Build**. The build is added to the whitelist. You can approve the build in the **Tasks** tab.



## Approving tasks
{: #em-tasks}

When an application is whitelisted, it is added to the list of pending requests in the **tasks** tab of the Enclave Manager UI. You can use the UI to approve or deny the request.
{: shortdesc}

1. Sign in to the Enclave Manager and navigate to the **Tasks** tab.

2. Click the row that contains the request that you want to approve or deny. A screen with more information opens.

3. Review the request and click **Approve** or **Deny**. Your name is added to the list of **Reviewers**.


## Viewing logs
{: #em-view}

You can audit your Enclave manager instance for several different types of activity. 
{: shortdesc}

1. Navigate to the **Audit log** tab of the Enclave Manager UI.
2. Filter the logging results to narrow your search. You can choose to filter by time frame or by any of the following types.

  * App status: Activity that pertains to your application such as whitelist requests and new builds.
  * User approval: Activity that pertains to a user's access such as their approval or denial to use the account.
  * Node attestation: Activity that pertains to node attestation.
  * Certificate Authority: Activity that pertains to a Certificate Authority.
  * Administration: Activity that pertains to administrative. 

If you want to keep a record of the logs beyond 1 month, you can export the information as a `.csv` file.

