---
copyright:
  years: 2018, 2020
lastupdated: "2020-09-21"

keywords: uninstall, delete, helm, configuration, tls certificate, docker config secret, environment variable, regions, cluster, container, app security, memory encryption, data in use

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



# Uninstalling {{site.data.keyword.datashield_short}}
{: #uninstall}

If you no longer need to use {{site.data.keyword.datashield_full}}, you can delete the service, certificates, and secrets that were created.


1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: codeblock}

2. Set the context for your cluster.

  ```
  ibmcloud ks cluster config --cluster <cluster_name_or_ID>
  ```
  {: codeblock}

3. Delete the job that's attached to your instance of the service.

  ```
  kubectl delete job $(kubectl get jobs -o custom-columns=:metadata.name | grep cockroachdb-init)
  ```
  {: codeblock}

4. Delete the chart.

  * If you're using Helm v3, run the following command.

    ```
    helm uninstall <release_name>
    ```
    {: codeblock}

  * If you're using Helm v2, run the following command.

    ```
    helm delete <release-name> --purge
    ```
    {: codeblock}




## Optional: Delete the certificates and supporting software
{: #delete-components}

When you work with {{site.data.keyword.datashield_short}}, there are certificates, installers, and secrets that must also be deleted to fully remove the service from your cluster.

1. The uninstall process uses Helm "hooks" to run an uninstaller. You can delete the uninstaller after it runs.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

2. Delete your instance of `cert-manager`. 

  1. Uninstall `cert-manager`.

    * If you're using Helm v3, run the following command:

        ```
        helm uninstall cert-manager -n cert-manager
        ```
        {: codeblock}
    
    * If you're using Helm v2, run the following command:

        ```
        helm delete cert-manager --purge
        ```
        {: codeblock}

  2. Delete the namespace.
  
      ```
      kubectl delete namespace cert-manager
      ```
      {: codeblock}

  3. Delete the CRDs.

    ```
    kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/v0.10.1/deploy/manifests/00-crds.yaml
    ```
    {: codeblock}

3. Delete the TLS certificates by running each of the following commands.

  ```
  kubectl delete secret <release_name>-enclaveos-ca         
  kubectl delete secret <release_name>-enclaveos-converter-tls-v2        
  kubectl delete secret <release_name>-enclaveos-frontend-tls-v2         
  kubectl delete secret <release_name>-enclaveos-manager-admin-tls-v2    
  kubectl delete secret <release_name>-enclaveos-manager-main-tls-v2 
  kubectl delete secret <release_name>-cockroachdb-ca
  kubectl delete secret <release_name>-cockroachdb.client.root
  kubectl delete secret <release_name>-cockroachdb.node-v2
  ```
  {: codeblock}

4. Delete your converter service ID. If you delete your service ID, your Docker Config Secret no longer works and should also be deleted.

  ```
  ibmcloud iam service-id-delete <service_id>
  ```
  {: codeblock}

5. Delete your Docker config secret.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}



