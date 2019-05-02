---

copyright:
  years: 2018, 2019
lastupdated: "2019-04-29"

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

# Installing the service
{: #install}

You can install {{site.data.keyword.datashield_full}} by using either the provided Helm chart or by using the provided installer. You can work with the install commands that you feel most comfortable with.
{: shortdesc}

## Before you begin
{: #begin}

Before you can begin working with {{site.data.keyword.datashield_short}}, you must have the following prerequisites. For help with downloading the CLIs and plug-ins or configuring your Kubernetes Service environment, check out the tutorial, [creating Kubernetes clusters](/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* The following CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers?topic=containers-helm#helm)

  You might want to configure Helm to use `--tls` mode. For help with enabling TLS check out the [Helm repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). If you enable TLS, be sure to append `--tls` to every Helm command that you run.
  {: tip}

* The following [{{site.data.keyword.cloud_notm}} CLI plug-ins](/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * {{site.data.keyword.containershort_notm}}
  * {{site.data.keyword.registryshort_notm}}

* An SGX-enabled Kubernetes cluster. Currently, SGX can be enabled on a bare metal cluster with node type: mb2c.4x32. If you don't have one, you can use the following steps to help ensure that you create the cluster that you need.
  1. Prepare to [create your cluster](/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Ensure that you have the [required permissions](/docs/containers?topic=containers-users#users) to create a cluster.

  3. Create the [cluster](/docs/containers?topic=containers-clusters#clusters).

* An instance of the [cert-manager](https://cert-manager.readthedocs.io/en/latest/) service version 0.5.0 or newer. To install the instance by using Helm, you can run the following command.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```
  {: pre}


## Optional: Creating a Kubernetes namespace
{: #create-namespace}

By default, {{site.data.keyword.datashield_short}} is installed into the `kube-system` namespace. Optionally, you can use an alternative namespace by creating a new one.
{: shortdesc}


1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in. If you have a federated ID, append the `--sso` option to the end of the command.

  ```
  ibmcloud login
  ```
  {: pre}

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copy the output and paste it into your terminal.

3. Create a namespace.

  ```
  kubectl create namespace <namespace_name>
  ```
  {: pre}

4. Copy any relevant secrets from the default namespace to your new namespace.

  1. List your available secrets.

    ```
    kubectl get secrets
    ```
    {: pre}

    Any secrets that start with `bluemix*` must be copied.
    {: tip}

  2. One at a time, copy the secrets.

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: pre}

  3. Verify that your secrets were copied over.

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: pre}

5. Create a service account. To see all of your customization options, check out the [RBAC page in the Helm GitHub repository](https://github.com/helm/helm/blob/master/docs/rbac.md).

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: pre}

6. Generate certificates and enable Helm with TLS by following the instructions found in the [Tiller SSL GitHub repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Be sure to specify the namespace that you created.

Excellent! Now you're ready to install {{site.data.keyword.datashield_short}} into your new namespace. From this point on, be sure to add `--tiller-namespace <namespace_name>` to any Helm command that you run.


## Installing with Helm
{: #install-chart}

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
  {: pre}

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

3. If you haven't already, add the helm chart repository.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
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

6. Set up [backup and restore](/docs/services/data-shield?topic=data-shield-backup-restore#backup-restore). 

7. Install the chart.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> <converter-registry-option>
  ```
  {: pre}

  If you [configured an {{site.data.keyword.cloud_notm}} Container Registry](/docs/services/data-shield?topic=data-shield-convert#convert) for your converter you must add `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`.
  {: note}

8. To monitor the startup of your components, you can run the following command.

  ```
  kubectl get pods
  ```
  {: pre}



## Installing with the {{site.data.keyword.datashield_short}} installer
{: #installer}

You can use the installer to quickly install {{site.data.keyword.datashield_short}} on your SGX-enabled bare metal cluster.
{: shortdesc}

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```
  {: pre}

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: pre}

  2. Copy the output and paste it into your terminal.

3. Sign in to the Container Registry CLI.

  ```
  ibmcloud cr login
  ```
  {: pre}

4. Pull the image to your local machine.

  ```
  docker pull icr.io/ibm/datashield-installer
  ```
  {: pre}

5. Install {{site.data.keyword.datashield_short}} by running the following command.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config icr.io/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  To install the most recent version of {{site.data.keyword.datashield_short}}, use `latest` for the `--version` flag.


## Updating the service
{: #update}

When {{site.data.keyword.datashield_short}} is installed on your cluster, you can update at any time.
{: shortdesc}

To update to the latest version with the Helm chart, run the following command.

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=icr.io/<your-registry>
  ```
  {: pre}


To update to the latest version with the installer, run the following command:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config icr.io/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  To install the most recent version of {{site.data.keyword.datashield_short}}, use `latest` for the `--version` flag.


