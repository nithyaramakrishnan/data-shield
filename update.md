---
copyright:
  years: 2018, 2020
lastupdated: "2020-09-21"

keywords: update data shield, install, docker config, helm, cluster, kube, container, app security, runtime encryption, memory, data in use,

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:faq: data-hd-content-type='faq'}
{:gif: data-image-type='gif'}
{:important: .important}
{:note: .note}
{:pre: .pre}
{:tip: .tip}
{:preview: .preview}
{:deprecated: .deprecated}
{:shortdesc: .shortdesc}
{:support: data-reuse='support'}
{:script: data-hd-video='script'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:video: .video}
{:step: data-tutorial-type='step'}
{:tutorial: data-hd-content-type='tutorial'}


# Updating {{site.data.keyword.datashield_short}}
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

  ```
  ibmcloud ks cluster config --cluster <cluster_name_or_ID>
  ```
  {: codeblock}

3. Optional: If you don't know the email that is associated with the administrator or the admin account ID, run the following command.

  ```
  ibmcloud account show
  ```
  {: codeblock}

4. Get the Ingress subdomain for your cluster.

  ```
  ibmcloud ks cluster get --cluster <cluster_name>
  ```
  {: codeblock}

## Updating with Helm
{: #update-helm}

To update to the newest version with the Helm chart, run the following command.

1. Delete the job for your current version of Data Shield.

  ```
  kubectl delete job $(kubectl get jobs -o custom-columns=:metadata.name | grep cockroachdb-init)
  ```
  {: codeblock}

2. Update your chart.

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
      <td>Optional: If you [configured an {{site.data.keyword.cloud_notm}} Container Registry](/docs/data-shield?topic=data-shield-convert) you must append the Docker configuration to the update command.</td>
    </tr>
    <tr>
      <td><code>--set global.OpenShiftEnabled=true</code></td>
      <td>Optional: If you're working with an OpenShift cluster, be sure to append the OpenShift tag to your installation command.</td>
    </tr>
    <tr>
      <td><code>--set Manager.FailOnGroupOutOfDate=true</code></td>
      <td>Optional: By default, node enrollment and the issuing of application certificates succeed. If you want the operations to fail if your platform microcode is out of date, append the flag to your update command. You are alerted in your dashboard when your service code is out of date. Note: It is not possible to change this option on existing clusters.</td>
    </tr>
    <tr>
      <td><code>--set enclaveos-chart.Ias.Mode=IAS_API_KEY</code></td>
      <td>Optional: You can use your own IAS API key. To do so, you must first obtain a linkable subscription for the Intel SGX Attestation Service. Then, generate a secret in your cluster by running the following command: <code>kubectl create secret generic ias-api-key --from-literal=env=<TEST/PROD> --from-literal=spid=<spid> --from-literal=api-key=<apikey></code>. Note: By default, IAS requests are made through a proxy service.</td>
    </tr>
  </table>

