---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

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

With {{site.data.keyword.datashield_full}}, powered by Fortanix®, you can protect the data in your container workloads that run on {{site.data.keyword.cloud_notm}} while your data is in use.
{: shortdesc}

For more information about the service and what it means to protect your data in use, you can learn [about the service](/docs/services/data-shield?topic=data-shield-about#about).

## Before you begin
{: #gs-begin}

Before you can begin using {{site.data.keyword.datashield_short}}, you must have the following prerequisites. For help getting the CLIs and plug-ins downloaded and your Kubernetes Service environment configured, check out the tutorial [creating Kubernetes clusters](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* The following CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  You might want to configure Helm to use `--tls` mode. For help enabling TLS check out the [Helm repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). If you enable TLS, be sure to append `--tls` to every Helm command that you run.
  {: tip}

* The following [{{site.data.keyword.cloud_notm}} CLI plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes Service
  * Container Registry

* An SGX-enabled Kubernetes cluster. Currently, SGX can be enabled on a bare metal cluster with node type: mb2c.4x32. If you don't have one, you can use the following steps to help ensure that you create the cluster that you need.
  1. Prepare to [create your cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Ensure that you have the [required permissions](https://cloud.ibm.com/docs/containers?topic=containers-users#users) to create a cluster.

  3. Create the [cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters).

* An instance of the [cert-manager](https://cert-manager.readthedocs.io/en/latest/) service version 0.5.0 or newer. To install the instance by using Helm, you can run the following command.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Installing with a Helm chart
{: #gs-install-chart}

You can use the provided Helm chart to install {{site.data.keyword.datashield_short}} on your SGX-enabled bare metal cluster.
{: shortdesc}

The Helm chart installs the following components:

*	The supporting software for SGX, which is installed on the bare metal hosts by a privileged container.
*	The {{site.data.keyword.datashield_short}} Enclave Manager, which manages SGX enclaves in the {{site.data.keyword.datashield_short}} environment.
*	The EnclaveOS® container conversion service, which allows containerized applications to run in the {{site.data.keyword.datashield_short}} environment.

When you install a Helm chart, there are several options and parameters that allow you to customize your installation. The following tutorial walks you through the most basic, default installation of the chart. For more information about your options, see [Installing {{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-deploying).
{: tip}

To install Data Shield onto your cluster:

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

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
    {: pre}

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

3. If you haven't already, add the `ibm` repository.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. Optional: If you don't know the email that is associated with the administrator or the admin account ID, run the following command.

  ```
  ibmcloud account show
  ```
  {: pre}

5. Get the Ingress subdomain for your cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: pre}

6. Install the chart.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  If you [configured an {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) for your converter you can add the following option: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  {: note}

7. To monitor the startup of your components you can run the following command.

  ```
  kubectl get pods
  ```
  {: pre}


## Next steps
{: #gs-next}

Great job! Now that the service is installed on your cluster you can run your apps in the {{site.data.keyword.datashield_short}} environment. 

To run your apps in a {{site.data.keyword.datashield_short}} environment, you must [convert](/docs/services/data-shield?topic=data-shield-convert#convert), [whitelist](/docs/services/data-shield?topic=data-shield-convert#convert-whitelist), and then [deploy](https://test.cloud.ibm.com/docs/services/data-shield?topic=data-shield-deploy-containers#deploy-containers) your container image.

If you don't have your own image to deploy, try using one of the sample "datashield" images:

* [{{site.data.keyword.datashield_short}} Examples GitHub repo](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* MariaDB or NGINX in {{site.data.keyword.cloud_notm}} Container Registry
