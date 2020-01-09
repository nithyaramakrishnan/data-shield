---
copyright:
  years: 2018, 2019
lastupdated: "2019-11-15"

keywords: update data shield, install, docker config, helm, cluster, kube, container, app security, runtime encryption, memory, data in use,

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

# Updating
{: #update}

After {{site.data.keyword.datashield_short}} is installed on your cluster, you can update at any time.
{: shortdesc}

## Setting cluster context
{: #update-context}

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

  2. Copy the output and paste it into your console.

3. If you haven't already, add the `iks-charts` repository.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. Optional: If you don't know the email that is associated with the administrator or the admin account ID, run the following command.

  ```
  ibmcloud account show
  ```
  {: codeblock}

5. Get the Ingress subdomain for your cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

## Updating with Helm
{: #update-helm}

To update to the newest version with the Helm chart, run the following command.

  {{site.data.keyword.datashield_short}} is not configured to work with Helm v3. Be sure that you're using Helm v2.
  {: tip}

  ```
  helm upgrade <chart-name> iks-charts/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> 
  ```
  {: codeblock}

  <table>
    <caption>Table 1. Update options</caption>
    <tr>
      <th>Command</th>
      <th>Description</th>
    </tr>
    <tr>
      <td><code>--set converter-chart.Converter.DockerConfigSecret=converter-docker-config</code></td>
      <td>Optional: If you [configured an {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) you must append the Docker configuration to the update command.</td>
    </tr>
    <tr>
      <td><code>--set global.OpenShiftEnabled=true</code></td>
      <td>Optional: If you're working with an OpenShift cluster, be sure to append the OpenShift tag to your installation command.</td>
    </tr>
    <tr>
      <td><code>--set Manager.FailOnGroupOutOfDate=true</code></td>
      <td>Optional: By default, node enrollment and the issueing of application certificates succeed. If you want the operations to fail if your platform microcode is out of date, append the flag to your update command. You are alerted in your dashboard when your service code is out of date. Note: It is not possible to change this option on existing clusters.</td>
    </tr>
  </table>

