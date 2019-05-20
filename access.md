---

copyright:
  years: 2018, 2019
lastupdated: "2019-05-13"

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
