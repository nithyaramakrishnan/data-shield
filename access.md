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

# Assigning access
{: #access}

You can control access to the {{site.data.keyword.datashield_full}} Enclave Manager. This type of access control is separate from the typical Identity and Access Management (IAM) roles that you use when you are working with {{site.data.keyword.cloud_notm}}.
{: shortdesc}

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

## Setting roles for Enclave Manager users
{: #enclave-roles}

{{site.data.keyword.datashield_short}} administration takes place in the Enclave Manager. As an administrator, you are automatically assigned the *manager* role, but you can also assign roles to other users.
{: shortdesc}

Keep in mind that these roles are different from the platform IAM roles that are used to control access to {{site.data.keyword.cloud_notm}} services. For more information about configuring access for the {{site.data.keyword.containerlong_notm}}, see [assigning cluster access](/docs/containers?topic=containers-users#users).
{: tip}

Check out the following table to see which roles are supported and some example actions that can be taken by each user:

<table>
  <tr>
    <th>Role</th>
    <th>Actions</th>
    <th>Example</th>
  </tr>
  <tr>
    <td>Reader</td>
    <td>Can perform read-only actions such as viewing nodes, builds, user information, apps, tasks, and audit logs.</td>
    <td>Downloading a node attestation certificate.</td>
  </tr>
  <tr>
    <td>Writer</td>
    <td>Can perform the actions that a Reader can perform and more including deactivating and renewing node attestation, adding a build, approving or denying any action or tasks.</td>
    <td>Certifying an application.</td>
  </tr>
  <tr>
    <td>Manager</td>
    <td>Can perform the actions that a Writer can perform and more including updating user names and roles, adding users to the cluster, updating cluster settings, and any other privileged actions.</td>
    <td>Updating a user role.</td>
  </tr>
</table>

### Setting user roles
{: #set-roles}

You can set or update the user roles for your console manager.
{: shortdesc}

1. Sign in to the [Enclave Manager UI](/docs/services/data-shield?topic=data-shield-managing#managing).
2. From the drop-down menu, open the user management screen.
3. Select **Settings**. You can review the list of users or add a user from this screen.
4. To edit user permissions, hover over a user until the pencil icon is displayed.
5. Click the pencil icon to change their permissions. Any changes to a user's permissions take immediate effect.
