---

copyright:
  years: 2018, 2019
lastupdated: "2019-02-19"

---

{:new_window: target="_blank"}
{:shortdesc: .shortdesc}
{:tip: .tip}
{:screen: .screen}
{:codeblock: .codeblock}
{:pre: .pre}

# Managing access
{: #access}

You can control access to the {{site.data.keyword.datashield_full}} Enclave Manager. This access control is separate from the typical Identity and Access Management (IAM) roles that you use when working with {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Using an IAM API key to log in to the console
{: #access-iam}

In the Enclave Manager console, you can view the nodes in your cluster and their attestation status. You can also view tasks and an audit logs of cluster events.

1. Log in to the {{site.data.keyword.cloud_notm}} CLI.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>IBM Cloud Endpoint</th>
      <th>Kubernetes Service region</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>US South</td>
    </tr>
    <tr>
      <td>Frankfurt</td>
      <td><code>eu-de</code></td>
      <td>EU Central</td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
      <td>AP South</td>
    </tr>
    <tr>
      <td>London</td>
      <td><code>eu-gb</code></td>
      <td>UK South</td>
    </tr>
    <tr>
      <td>Tokyo</td>
      <td><code>jp-tok</code></td>
      <td>AP North</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>US East</td>
    </tr>
  </table>

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output and paste it into your terminal.

3. Check to see that all your service is running by confirming that all of your pods are in a *running* state.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Look up the frontend URL for your Enclave Manager by running the following command.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Obtain your Ingress subdomain.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. In a browser enter the Ingress subdomain where your Enclave Manager is available.

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


## Setting roles for Enclave Manager users
{: #enclave-roles}

{{site.data.keyword.datashield_short}} administration takes place in the Enclave Manager. As an administrator, you are automatically assigned the *manager* role, but you can also assign roles to other users.
{: shortdesc}

Keep in mind that these roles are different from the platform IAM roles that are used to control access to {{site.data.keyword.cloud_notm}} services. For more information about configuring access for the {{site.data.keyword.containerlong_notm}}, see [Assigning cluster access](/docs/containers/cs_users.html#users).
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

1. Navigate to the [Enclave Manager UI](/docs/services/data-shield/access.html#access-iam).
2. From the dropdown menu, open the user management screen.
3. Select **Settings**. Review the list of users or add a new user from this screen.
4. To edit a users permissions, hover over a user until the pencil icon displays.
5. Click the pencil icon to change their permissions. Any changes to a users permissions take immediate effect.
