---

copyright:
  years: 2018, 2019
lastupdated: "2019-06-11"

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

# Assigning access
{: #access}

You can control access to the {{site.data.keyword.datashield_full}} Enclave Manager. This type of access control is separate from the typical Identity and Access Management (IAM) roles that you use when you are working with {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Assigning cluster access
{: #access-cluster}

Before you can sign in to the Enclave Manager, you must have access to the cluster that the Enclave Manager is running on.
{: shortdesc}

1. Sign in to the account that hosts the cluster that you want to sign in to.

2. Navigate to **Manage > Access (IAM) > Users**.

3. Click **Invite users**.

4. Provide the email addresses for the user's that you want to add.

5. From the **Assign access to** drop down, select **Resource**.

6. From the **Services** drop down, select **Kubernetes Service**.

7. Select a **Region**, **Cluster**, and **Namespace**.

8. Using the Kubernetes Service documentation on [assigning cluster access](/docs/containers?topic=containers-users) as a guide, assign the access that the user needs to complete their tasks.

9. Click **Save**.

## Setting roles for Enclave Manager users
{: #enclave-roles}

{{site.data.keyword.datashield_short}} administration takes place in the Enclave Manager. As an administrator, you are automatically assigned the *manager* role, but you can also assign roles to other users.
{: shortdesc}

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


### Adding a user
{: #set-roles}

By using the Enclave Manager GUI, you can give new user's access to the information.
{: shortdesc}

1. Sign in to the Enclave Manager.

2. Click **Your name > Settings**.

3. Click **Add user**.

4. Enter an email and a name for the user. Select a role from the **Role** drop down.

5. Click **Save**.



### Updating a user
{: #update-roles}

You can update the roles that are assigned to your users and their name.
{: shortdesc}

1. Sign in to the [Enclave Manager UI](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin).

2. Click **Your name > Settings**.

3. Hover over the user whose permissions you want to edit. A pencil icon displays.

4. Click the pencil icon. The edit user screen opens.

5. From the **Role** drop down, select the roles that you want to assign.

6. Update the user's name.

7. Click **Save**. Any changes to a user's permissions take immediate effect.


