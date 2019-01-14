---

copyright:
  years: 2018, 2019
lastupdated: "2019-01-14"

---

{:new_window: target="_blank"}
{:shortdesc: .shortdesc}
{:screen: .screen}
{:codeblock: .codeblock}
{:pre: .pre}
{:tip: .tip}
{:important: .important}
{:note: .note}

# Installing {{site.data.keyword.datashield_short}}
{: #deploying}

You can install {{site.data.keyword.datashield_full}} by using either the provided Helm chart or by using the provided installer. There is no benefit to using one over the other, so you can work with the commands that you feel most comfortable with.
{: shortdesc}

## Before you begin
{: #begin}

Before you can begin using {{site.data.keyword.datashield_short}}, you must have the following prerequisites. For help getting the CLIs and plug-ins downloaded and your Kubernetes Service environment configured, check out the tutorial [creating Kubernetes clusters](/docs/containers/cs_tutorials.html#cs_cluster_tutorial_lesson1).

* The following CLIs:

  * [{{site.data.keyword.cloud_notm}}](/docs/cli/reference/ibmcloud/download_cli.html#install_use)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](/docs/containers/cs_integrations.html#helm)

  You might want to configure Helm to use `--tls` mode. For help enabling TLS check out the [Helm repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). If you enable TLS, be sure to append `--tls` to every Helm command that you run.
  {: tip}

* The following [{{site.data.keyword.cloud_notm}} CLI plug-ins](/docs/cli/reference/ibmcloud/extend_cli.html#plug-ins):

  * Kubernetes Service
  * Container Registry

* An SGX-enabled Kubernetes cluster. Currently, SGX can be enabled on a bare metal cluster with node type: mb2c.4x32. If you don't have a cluster, you can use the following steps to help you get started.
  1. Prepare to [create your cluster](/docs/containers/cs_clusters.html#cluster_prepare).

  2. Ensure that you have the [required permissions](/docs/containers/cs_users.html) to create a cluster.

  3. Create the [cluster](/docs/containers/cs_clusters.html).

* An instance of the Certificate Manager service version 0.4.1. To install the instance by using Helm, you can run the following command.

  ```
  helm repo update && helm install --version 0.4.1 stable/cert-manager
  ```
  {: codeblock}

</br>

## Optional: Creating a Kube namespace
{: #create-namespace}

By default, {{site.data.keyword.datashield_short}} is installed into the `kube-system` namespace. Optionally, you can use an alternative namespace by creating a new one.
{: shortdesc}


1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to finish logging in.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>Endpoint</th>
    </tr>
    <tr>
      <td>Germany</td>
      <td><code>eu-de</code></td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
    </tr>
    <tr>
      <td>United Kingdom</td>
      <td><code>eu-gb</code></td>
    </tr>
    <tr>
      <td>US South</td>
      <td><code>ng</code></td>
    </tr>
  </table>

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output and paste it into your terminal.

3. Create a new namespace.

  ```
  kubectl create namespace <namespace_name>
  ```
  {: codeblock}

4. Copy any relevant secrets from the default namespace to your new namespace.

  1. List your available secrets.

    ```
    kubectl get secrets
    ```
    {: codeblock}

    Any secrets that start with `bluemix*` must be copied.
    {: tip}

  2. One at a time, copy the secrets.

    ```
    kubectl get secret <secret_name> --namespace=default --export -o yaml |\
    kubectl apply --namespace=<namespace_name> -f -
    ```
    {: codeblock}

  3. Verify that your secrets were copied over.

    ```
    kubectl get secrets --namespace <namespace_name>
    ```
    {: codeblock}

5. Create a service account. To see all of your customization options, check out the [RBAC page in the Helm GitHub repository](https://github.com/helm/helm/blob/master/docs/rbac.md).

  ```
  kubectl create serviceaccount --namespace <namespace_name> <service_account_name>
  kubectl create clusterrolebinding <role_name> --clusterrole=cluster-admin --serviceaccount=<namespace_name>:<service_account_name>
  ```
  {: codeblock}

6. Generate certificates and enable Helm with TLS by following the instructions found in the [Tiller SSL GitHub repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). Be sure to specify the namespace that you created.

Excellent! Now you're ready to install {{site.data.keyword.datashield_short}} into your new namespace. From this point on, be sure to add `--tiller-namespace <namespace_name>` to any Helm command that you run.

</br>

## Installing with a Helm chart
{: #install-chart}

You can use the provided Helm chart to install {{site.data.keyword.datashield_short}} on your SGX-enabled bare metal cluster.
{: shortdesc}

The Helm chart installs the following components:

*	The supporting software for SGX, which is installed on the bare metal hosts by a privileged container.
*	The {{site.data.keyword.datashield_short}} Enclave Manager, which manages SGX enclaves in the {{site.data.keyword.datashield_short}} environment.
*	The container conversion service, which allows containerized applications to run in the {{site.data.keyword.datashield_short}} environment.

</br>

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete finish logging in.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>Endpoint</th>
    </tr>
    <tr>
      <td>Germany</td>
      <td><code>eu-de</code></td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
    </tr>
    <tr>
      <td>United Kingdom</td>
      <td><code>eu-gb</code></td>
    </tr>
    <tr>
      <td>US South</td>
      <td><code>ng</code></td>
    </tr>
  </table>

2. Get the name and ingress domain of your cluster.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

3. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Beginning with `export`, copy the output and paste it into your terminal to set the `KUBECONFIG` environment variable.

4. Add the `ibm` repository.

  ```
  helm repo add ibm https://registry.bluemix.net/helm/ibm
  ```
  {: codeblock}

5. Optional: If you don't know the email associated with the administrator or the admin account ID, run the following command.

  ```
  ibmcloud account show
  ```
  {: codeblock}

6. Get the ingress domain for your cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```
  {: codeblock}

7. Install the chart.

  ```
  helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<domain> <converter-registry-option>
  ```
  {: codeblock}

  If you [configured an {{site.data.keyword.cloud_notm}} Container Registry for your converter](convert.html) you can add the following option: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`

8. To monitor the startup of your components you can run the following command.

  ```
  kubectl get pods
  ```
  {: codeblock}

</br>

## Installing with the {{site.data.keyword.datashield_short}} installer
{: #installer}

You can use the installer to quickly install {{site.data.keyword.datashield_short}} on your SGX-enabled bare metal cluster.
{: shortdesc}

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete finish logging in.

  ```
  ibmcloud login -a https://api.<region>.bluemix.net
  ```
  {: codeblock}

  <table>
    <tr>
      <th>Region</th>
      <th>Endpoint</th>
    </tr>
    <tr>
      <td>Germany</td>
      <td><code>eu-de</code></td>
    </tr>
    <tr>
      <td>Sydney</td>
      <td><code>au-syd</code></td>
    </tr>
    <tr>
      <td>United Kingdom</td>
      <td><code>eu-gb</code></td>
    </tr>
    <tr>
      <td>US South</td>
      <td><code>ng</code></td>
    </tr>
  </table>

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output and paste it into your terminal.

3. Sign in to the Container Registry CLI.

  ```
  ibmcloud cr login
  ```
  {: codeblock}

4. Pull the image to your local machine.

  ```
  docker pull registry.bluemix.net/ibm/datashield-installer
  ```
  {: codeblock}

5. Install {{site.data.keyword.datashield_short}} by running the following command.

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer provision
  --adminEmail <ADMIN_EMAIL> --accountId <ACCOUNT_ID> --ingressSubdomain <INGRESS_SUBDOMAIN>
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  To install the most recent version of {{site.data.keyword.datashield_short}}, use `latest` for the `--version` flag.

</br>

## Updating the service
{: update}

After you have {{site.data.keyword.datashield_short}} installed on your cluster, you can upgrade at any time.

To upgrade to the latest version with the Helm chart, run the following command.

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=registry.ng.bluemix.net/<your-registry>
  ```
  {: codeblock}

</br>

To upgrade to the latest version with the installer, run the following command:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.bluemix.net/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: codeblock}

  To install the most recent version of {{site.data.keyword.datashield_short}}, use `latest` for the `--version` flag.

</br>
</br>
