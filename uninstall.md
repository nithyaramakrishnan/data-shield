---
copyright:
  years: 2018, 2020
lastupdated: "2020-03-16"

keywords: uninstall, delete, helm, configuration, tls certificate, docker config secret, environment variable, regions, cluster, container, app security, memory encryption, data in use

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:new_window: target="_blank"}
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
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}



# Uninstalling {{site.data.keyword.datashield_short}}
{: #uninstall}

If you no longer need to use {{site.data.keyword.datashield_full}}, you can delete the service and the TLS certificates that were created.


1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>{{site.data.keyword.cloud_notm}} Endpoint</th>
      <th>{{site.data.keyword.containershort_notm}} region</th>
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

  2. Copy the output and paste it into your console.

3. Delete the service.

  ```
  helm delete <release-name> --purge
  ```
  {: codeblock}

4. Delete the TLS certificates by running each of the following commands.

  ```
  kubectl delete secret <release name>-enclaveos-ca         
  kubectl delete secret <release name>-enclaveos-converter-tls-v2        
  kubectl delete secret <release name>-enclaveos-frontend-tls-v2         
  kubectl delete secret <release name>-enclaveos-manager-admin-tls-v2    
  kubectl delete secret <release name>-enclaveos-manager-main-tls-v2 
  kubectl delete secret <release name>-cockroachdb-ca
  kubectl delete secret <release name>-cockroachdb.client.root
  kubectl delete secret <release name>-cockroachdb.node
  ```
  {: codeblock}

5. The uninstall process uses Helm "hooks" to run an uninstaller. You can delete the uninstaller after it runs.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

6. Optional: Delete your instance of `cert-manager`. If you delete your instance, be sure that you also delete the following CRDs.

  ```
  kubectl delete crd certificates.certmanager.k8s.io
  kubectl delete crd clusterissuers.certmanager.k8s.io 
  kubectl delete crd issuers.certmanager.k8s.io
  ```
  {: codeblock}

7. Optional: Delete your converter service ID. Note: if you choose to delete your service ID, your Docker config secret will no longer work. 

  ```
  ibmcloud iam service-id-delete <service_id>
  ```
  {: codeblock}

8. Optional: Delete your Docker config secret.



