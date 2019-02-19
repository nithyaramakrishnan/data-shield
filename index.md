---

copyright:
  years: 2018, 2019
lastupdated: "2019-02-19"

---

{:new_window: target="_blank"}
{:shortdesc: .shortdesc}
{:screen: .screen}
{:codeblock: .codeblock}
{:pre: .pre}
{:tip: .tip}
{:important: .important}
{:note: .note}

# Getting started tutorial
{: #gettingstarted}

With {{site.data.keyword.datashield_full}}, powered by Fortanix®, you can protect the data in your container workloads that run on {{site.data.keyword.cloud_notm}} while your data is in use.
{: shortdesc}

For more information about the service and what it means to protect your data in use, you can learn [about the service](/docs/services/data-shield?topic=data-shield-about#about).

## Before you begin
{: #gs-begin}

Before you can begin using {{site.data.keyword.datashield_short}}, you must have the following prerequisites. For help getting the CLIs and plug-ins downloaded and your Kubernetes Service environment configured, check out the tutorial [creating Kubernetes clusters](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* The following CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli#install_use)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-integrations#helm)

  You might want to configure Helm to use `--tls` mode. For help enabling TLS check out the [Helm repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). If you enable TLS, be sure to append `--tls` to every Helm command that you run.
  {: tip}

* The following [{{site.data.keyword.cloud_notm}} CLI plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes Service
  * Container Registry

* An SGX-enabled Kubernetes cluster. Currently, SGX can be enabled on a bare metal cluster with node type: mb2c.4x32. If you don't have one, you can use the following steps to help ensure that you create the cluster that you need.
  1. Prepare to [create your cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Ensure that you have the [required permissions](/docs/containers?topic=containers-users) to create a cluster.

  3. Create the [cluster](/docs/containers?topic=containers-clusters).

* An instance of the Certificate Manager service version 0.5.0. To install the instance by using Helm, you can run the following command.

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

</br>

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in.

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
    {: pre}

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

3. Add the `ibm` repository.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: pre}

4. Optional: If you don't know the email associated with the administrator or the admin account ID, run the following command.

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
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress subdomain>
  ```
  {: pre}

  If you [configured a {{site.data.keyword.cloud_notm}} Container Registry for your converter](convert.html) you can add the following option: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

7. To monitor the startup of your components you can run the following command.

  ```
  kubectl get pods
  ```
  {: pre}


## Getting to the Enclave Manager console
{: #gs-console}

In the Enclave Manager console, you can view the nodes in your cluster and the nodes’ attestation status. You can also view tasks and an audit log of cluster events.

1. Log in to the {{site.data.keyword.cloud_notm}} CLI.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: pre}

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

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
  {: pre}

6. In a browser enter the Ingress subdomain where your Enclave Manager is available.

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



## Next steps
{: #gs-next}

Great job! Now that {{site.data.keyword.datashield_short}} is installed, try walking through some sample apps:

* [{{site.data.keyword.datashield_short}} Examples GitHub repo](https://github.com/fortanix/data-shield-examples/tree/master/ewallet)
* MariaDB or NGINX in {{site.data.keyword.cloud_notm}} Container Registry
