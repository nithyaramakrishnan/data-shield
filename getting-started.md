---
copyright:
  years: 2018, 2020
lastupdated: "2020-01-09"

keywords: data protection, data in use, helm chart, cluster, container, role binding, bare metal, kube security, image, tiller, sample app, runtime encryption, tech preview, cpu, memory,

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
{:preview: .preview}

# Getting started tutorial
{: #getting-started}

With {{site.data.keyword.datashield_full}}, powered by Fortanix®, you can protect the data in your container workloads that run on {{site.data.keyword.containershort_notm}} while your data is in use.
{: shortdesc}

When it comes to protecting your data, encryption is one of the most popular and effective ways. But, the data must be encrypted at each step of its lifecycle for it to really be secure. The three phases of the data lifecycle include data at rest, data in motion, and data in use. Data at rest and in motion are commonly used to protect data when it is stored and when it is transported.

However, after an application starts to run, data in use by CPU and memory is vulnerable to attacks. Malicious insiders, root users, credential compromise, OS zero-day, and network intruders are all threats to data. Taking encryption one step further, you can now protect data in use. For more information about {{site.data.keyword.datashield_short}}, and what it means to protect your data in use, see [about the service](/docs/services/data-shield?topic=data-shield-about).


**Technology preview**: With {{site.data.keyword.datashield_short}} 1.5, you can preview support for {{site.data.keyword.openshiftlong_notm}} clusters. To deploy on an {{site.data.keyword.openshiftshort}} cluster, specify `--set global.OpenShiftEnabled=true` when you [install the Helm chart](/docs/services/data-shield?topic=data-shield-install).




## Before you begin
{: #gs-begin}

Before you can begin working with {{site.data.keyword.datashield_short}}, you must have the following prerequisites and resources.

### Prerequisites
{: #gs-prereq}

To work with {{site.data.keyword.cloud_notm}} by using the CLI, be sure that you have the following CLIs and plug-ins downloaded. For help with downloading the CLIs and plug-ins or configuring your {{site.data.keyword.containershort_notm}} environment, check out [creating Kubernetes clusters](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1) or [creating OpenShift clusters](/docs/openshift?topic=openshift-openshift_tutorial).


* [{{site.data.keyword.cloud_notm}} CLI](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
* [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
* [Docker](https://docs.docker.com/install/){: external}
* [{{site.data.keyword.containershort}} and {{site.data.keyword.registryshort_notm}} plugins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins)
* [Helm version 2](/docs/containers?topic=containers-helm): Be sure to follow the instructions for setting up Helm in a cluster with public access.

You might want to configure Helm to use `--tls` mode. For help with enabling TLS check out the [Helm repository](https://v2.helm.sh/docs/tiller_ssl/#using-ssl-between-helm-and-tiller){: external}. If you enable TLS, be sure to append `--tls` to every Helm command that you run.
{: tip}



### Required resources
{: #gs-resources}

Before you can work with {{site.data.keyword.datashield_short}}, you must have the following resources.

* An SGX-enabled Kubernetes or OpenShift cluster. Depending on the type of cluster that you choose, the type of machine flavor differs. Be sure that you have the correct corresponding flavor by reviewing the following table. 

  <table>
    <tr>
      <th>Type of cluster</th>
      <th>Available machine types</th>
    </tr>
    <tr>
      <td>{{site.data.keyword.containershort}}</td>
      <td><code>mb2c.4x32</code> and <code>ms2c.4x32.1.9tb.ssd</code></br>To see the options, you must check the <b>Ubuntu 16</b> operating system.</td>
    </tr>
    <tr>
      <td>{{site.data.keyword.openshiftshort}}</td>
      <td><code>mb3c.4x32</code> and <code>ms3c.4x32.1.9tb.ssd</code></td>
    </tr>
  </table>

  If you need help with creating your cluster, check out the following resources: 

  1. Prepare to [create your cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Ensure that you have the [required permissions](/docs/containers?topic=containers-users) to create a cluster.

  3. Create the [cluster](/docs/containers?topic=containers-clusters).

* An instance of the [cert-manager](https://cert-manager.readthedocs.io/en/latest/){: external} service version 0.5.0 or newer. The default installation uses <code>cert-manager</code> to set up [TLS certificates](/docs/services/data-shield?topic=data-shield-tls-certificates) for internal communication between {{site.data.keyword.datashield_short}} services. To install an instance by using Helm, you can run the following command.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: codeblock}

Want to see logging information for {{site.data.keyword.datashield_short}}? Set up [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started).
{: tip}


## Installing the service
{: #gs-install}

You can use the provided Helm chart to install {{site.data.keyword.datashield_short}} on your SGX-enabled bare metal cluster. The following instructions walk you through the most basic, default installation of the Helm chart. For more information about your options, see [Installing {{site.data.keyword.datashield_short}}](/docs/services/data-shield?topic=data-shield-install).
{: shortdesc}

The Helm chart installs the following components:

*	The supporting software for SGX, which is installed on the bare metal hosts by a privileged container.
*	The {{site.data.keyword.datashield_short}} Enclave Manager, which manages SGX enclaves in the {{site.data.keyword.datashield_short}} environment.
*	The {{site.data.keyword.datashield_short}} Container Conversion Service, which allows containerized applications to run in the {{site.data.keyword.datashield_short}} environment.

### Installing on your cluster
{: #gs-install-cluster}

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

  2. Copy the output beginning with `export` and paste it into your console to set the `KUBECONFIG` environment variable.

3. If you haven't already, add the `iks-charts` repository.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```
  {: codeblock}

4. If you don't know the email that is associated with the administrator or the admin account ID, run the following command.

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
  helm install iks-charts/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain>
  ```
  {: codeblock}

  <table>
    <caption>Table 1. Installation options</caption>
    <tr>
      <th>Command</th>
      <th>Description</th>
    </tr>
    <tr>
      <td><code>--set converter-chart.Converter.DockerConfigSecret=converter-docker-config</code></td>
      <td>Optional: If you [configured an {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert) you must append the Docker configuration to the installation command.</td>
    </tr>
    <tr>
      <td><code>--set global.OpenShiftEnabled=true</code></td>
      <td>Optional: If you are working with an OpenShift cluster, be sure to append the OpenShift tag to your installation command.</td>
    </tr>
  </table>

7. To monitor the startup of your components, you can run the following command.

  ```
  kubectl get pods
  ```
  {: codeblock}

## Next steps
{: #gs-next}

Now that the service is installed on your cluster, you can start protecting your data! Next, you can try [converting](/docs/services/data-shield?topic=data-shield-convert) and [deploying](/docs/services/data-shield?topic=data-shield-deploying) your applications. 

If you don't have your own image to deploy, try deploying one of the prepackaged {{site.data.keyword.datashield_short}} images:

* [Examples GitHub repo](https://github.com/fortanix/data-shield-examples/tree/master/ewallet){: external}
* Container Registry: [Barbican image](/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter), [MariaDB image](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter#datashield-mariadb_starter), [NGINX image](/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter), or [Vault image](/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter).


