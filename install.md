---
copyright:
  years: 2018, 2020
lastupdated: "2020-01-09"

keywords: install data shield, data in use, helm, cluster, environment variable, role binding, bare metal, tls certificates, tiller, ingress, subdomain, docker configuration, sample app, tech preivew, runtime encryption, memory, app security,

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

# Installing
{: #install}

You can install {{site.data.keyword.datashield_full}} on either a {{site.data.keyword.containershort_notm}} or a {{site.data.keyword.openshiftlong_notm}} cluster by using the provided Helm chart. 
{: shortdesc}

**Technology preview**: With {{site.data.keyword.datashield_short}} 1.5, you can preview support for {{site.data.keyword.openshiftlong_notm}} clusters. To deploy on an {{site.data.keyword.openshiftshort}} cluster, specify `--set global.OpenShiftEnabled=true`  when you [install the Helm chart](/docs/services/data-shield?topic=data-shield-install).

## Before you begin
{: #begin}

Before you can begin working with {{site.data.keyword.datashield_short}}, you must have the following prerequisites and resources.

### Prerequisites
{: #prereq}

To work with {{site.data.keyword.cloud_notm}} by using the CLI, be sure that you have the following CLIs and plug-ins downloaded. For help with downloading the CLIs and plug-ins or configuring your {{site.data.keyword.containershort_notm}} environment, check out the tutorial, [creating Kubernetes clusters](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-install-ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/){: external}
  * [Docker](https://docs.docker.com/install/){: external}
  * [Helm version 2](/docs/containers?topic=containers-helm)

  {{site.data.keyword.datashield_short}} is not configured to work with Helm v3. Be sure that you're using Helm v2.
  {: important}

* [CLI plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins):

  * {{site.data.keyword.containershort}}
  * {{site.data.keyword.registryshort_notm}}


For help with downloading the CLIs or configuring your {{site.data.keyword.containershort}} environment, check out [creating Kubernetes clusters](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1) or [creating {{site.data.keyword.openshiftshort}} clusters](/docs/openshift?topic=openshift-openshift_tutorial).
{: tip}

### Required resources
{: #resources}

Before you can work with {{site.data.keyword.datashield_short}}, you must have the following resources.

* An SGX-enabled Kubernetes or {{site.data.keyword.openshiftshort}} cluster. Depending on the type of cluster that you choose, the type of machine flavor differs. Be sure that you have the correct corresponding flavor by reviewing the following table. 

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




## Installing the Helm chart
{: #install-chart}

You can use the provided Helm chart to install {{site.data.keyword.datashield_short}} on your SGX-enabled bare metal cluster.
{: shortdesc}

The Helm chart installs the following components:

*	The supporting software for SGX, which is installed on the bare metal hosts by a privileged container.
*	The {{site.data.keyword.datashield_short}} Enclave Manager, which manages SGX enclaves in the {{site.data.keyword.datashield_short}} environment.
*	The EnclaveOS® container conversion service, which allows containerized applications to run in the {{site.data.keyword.datashield_short}} environment.


### Installing on your cluster
{: #install-cluster}

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

6. Get the information that you need to set up [backup and restore](/docs/services/data-shield?topic=data-shield-backup-restore) capabilities. 

7. Install Tiller. You might want to configure Helm to use `--tls` mode. For help with enabling TLS check out the [Helm repository](https://v2.helm.sh/docs/tiller_ssl/#using-ssl-between-helm-and-tiller){: external}. If you enable TLS, be sure to append `--tls` to every Helm command that you run.

  Both {{site.data.keyword.datashield_short}} and Tiller are not configured to work with Helm v3. Be sure that you're using Helm v2.
  {: tip}

  1. Create a service account for Tiller.
  
    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```
    {: codeblock}

  2. Create the role binding to assign Tiller admin access in the cluster.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```
    {: codeblock}

  3. Initialize Helm.

    ```
    helm init --service-account tiller --upgrade
    ```
    {: codeblock}

8. Install the chart.

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
      <td>Optional: If you are working with an {{site.data.keyword.openshiftshort}} cluster, be sure to append the {{site.data.keyword.openshiftshort}} tag to your installation command.</td>
    </tr>
    <tr>
      <td><code>--set Manager.FailOnGroupOutOfDate=true</code></td>
      <td>Optional: By default, node enrollment and the issueing of application certificates succeed. If you want the operations to fail if your platform microcode is out of date, append the flag to your install command. You are alerted in your dashboard when your service code is out of date. Note: It is not possible to change this option on existing clusters.</td>
    </tr>
    <tr>
      <td><code>--set enclaveos-chart.Ias.Mode=IAS_API_KEY</code></td>
      <td>Optional: You can use your own IAS API key. To do so, you must first obtain a linkable subscription for the Intel SGX Attestation Service. Then, generate a secret in your cluster by running the following command: <code>kubectl create secret generic ias-api-key --from-literal=env=<TEST/PROD> --from-literal=spid=<spid> --from-literal=api-key=<apikey></code>. Note: By default, IAS requests are made through a proxy service.</td>
    </tr>
  </table>

9. To monitor the startup of your components, you can run the following command.

  ```
  kubectl get pods
  ```
  {: codeblock}

