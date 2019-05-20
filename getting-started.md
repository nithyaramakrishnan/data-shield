---

copyright:
  years: 2018, 2019
lastupdated: "2019-05-15"

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

# Getting started tutorial
{: #getting-started}

With {{site.data.keyword.datashield_full}} (Beta), powered by Fortanix®, you can protect the data in your container workloads that run on {{site.data.keyword.cloud_notm}} while your data is in use.
{: shortdesc}

For more information about {{site.data.keyword.datashield_short}}, and what it means to protect your data in use you can learn [about the service](/docs/services/data-shield?topic=data-shield-about#about).

## Before you begin
{: #gs-begin}

Before you can begin working with {{site.data.keyword.datashield_short}}, you must have the following prerequisites. For help with downloading the CLIs and plug-ins or configuring your {{site.data.keyword.containershort}} environment, check out the tutorial [creating Kubernetes clusters](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* The following CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-helm#helm)

  You might want to configure Helm to use `--tls` mode. For help with enabling TLS check out the [Helm repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). If you enable TLS, be sure to append `--tls` to every Helm command that you run.
  {: tip}

* The following [CLI plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}

* An SGX-enabled Kubernetes cluster. Currently, SGX can be enabled on a bare metal cluster with node type: mb2c.4x32. If you don't have one, you can use the following steps to help ensure that you create the cluster that you need.
  1. Prepare to [create your cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Ensure that you have the [required permissions](/docs/containers?topic=containers-users#users) to create a cluster.

  3. Create the [cluster](/docs/containers?topic=containers-clusters#clusters).

* An instance of the [cert-manager](https://cert-manager.readthedocs.io/en/latest/) service version 0.5.0 or newer. The default installation uses <code>cert-manager</code> to set up [TLS certificates](/docs/services/data-shield?topic=data-shield-tls-certificates#tls-certificates) for internal communication between {{site.data.keyword.datashield_short}} services. To install an instance by using Helm, you can run the following command.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Want to see logging information for Data Shield? Set up a {{site.data.keyword.la_full_notm}} instance for your cluster.
{: tip}

## Installing the service
{: #gs-install}

You can use the provided Helm chart to install {{site.data.keyword.datashield_short}} on your SGX-enabled bare metal cluster.
{: shortdesc}

The Helm chart installs the following components:

*	The supporting software for SGX, which is installed on the bare metal hosts by a privileged container.
*	The {{site.data.keyword.datashield_short}} Enclave Manager, which manages SGX enclaves in the {{site.data.keyword.datashield_short}} environment.
*	The EnclaveOS® container conversion service, which allows containerized applications to run in the {{site.data.keyword.datashield_short}} environment.


To install {{site.data.keyword.datashield_short}} onto your cluster:

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

6. Install the chart.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: codeblock}

  If you [configured an {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) for your converter you must add `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

7. To monitor the startup of your components, you can run the following command.

  ```
  kubectl get pods
  ```
  {: codeblock}

## Next steps
{: #gs-next}

Now that you have the service installed on your cluster, you can start protecting your data! Next, you can try [converting](/docs/services/data-shield?topic=data-shield-convert#convert), [deploying](/docs/services/data-shield?topic=data-shield-deploying#deploying) your applications. 

If you don't have your own image to deploy, try deploying one of the prepackaged {{site.data.keyword.datashield_short}} images:

* [Examples GitHub repo](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* Container Registry: [Barbican image](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter), [MariaDB image](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter), [NGINX image](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter),[Vault image](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


