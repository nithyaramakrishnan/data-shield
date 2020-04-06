# IBM Cloud Data Shield

With IBM Cloud Data Shield, Fortanix®, and Intel® SGX, you can protect the data in your container workloads that run on IBM Cloud while the data is in use.

For more information about how you are charged for using IBM Cloud Data Shield, see the [catalog](https://cloud.ibm.com/catalog/services/data-shield).

## Introduction

When it comes to protecting your data, encryption is one of the most popular and effective ways. But, the data must be encrypted at each step of its lifecycle for it to really be secure. The three phases of the data lifecycle include data at rest, data in motion, and data in use. Data at rest and in motion are commonly used to protect data when it is stored and when it is transported.

However, after an application starts to run, data in use by CPU and memory is vulnerable to attacks. Malicious insiders, root users, credential compromise, OS zero-day, and network intruders are all threats to data. Taking encryption one step further, you can now protect data in use. For more information about the service, and what it means to protect your data in use, see [about the service](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-about#about).

**Technical preview**: With IBM Cloud Data Shield 1.5, you can preview support for Red Hat OpenShift on IBM Cloud clusters. To deploy on an OpenShift cluster, you just need to specify a tag when you [install the Helm chart](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-install) and in your [pod specifications](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-deploying).


## Chart details

This Helm chart installs the following components onto your SGX-enabled cluster:

 * The supporting software for SGX, which is installed on the bare metal hosts by a privileged container.
 * The IBM Cloud Data Shield Enclave Manager, which manages the SGX enclaves in the IBM Cloud Data Shield environment.
 * The IBM Cloud Data Shield Container Conversion Service, which converts containerized applications so that they are able to run in the IBM Cloud Data Shield environment.



## Resources required

* An SGX-enabled Kubernetes or OpenShift cluster. Depending on the type of cluster that you choose, the type of machine flavor differs. Be sure that you have the correct corresponding flavor.

  * Kubernetes Service available machine types: `mb2c.4x32` and `ms2c.4x32.1.9tb.ssd`. To see the options, you must check the **Ubuntu 16** operating system checkbox.

  * OpenShift available machine types: `mb3c.4x32` and `ms3c.4x32.1.9tb.ssd`.

  If you need help with creating your cluster, check out the following resources:

  1. Prepare to [create your cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#cluster_prepare).

  2. Ensure that you have the [required permissions](https://cloud.ibm.com/docs/containers?topic=containers-users#users) to create a cluster.

  3. Create the [cluster](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters).

* An instance of the [cert-manager](https://cert-manager.readthedocs.io/en/latest/) service version 0.5.0 or newer. To install the instance by using Helm, you can run the following command.

  ```
  helm repo update && helm install --version 0.5.0 stable/cert-manager
  ```



## Prerequisites

Before you can begin working with IBM Cloud Data Shield, you must have the following prerequisites. For help with getting the CLIs and plug-ins downloaded and your Kubernetes Service environment configured, check out the tutorial [creating Kubernetes clusters](https://cloud.ibm.com/docs/containers?topic=containers-cs_cluster_tutorial#cs_cluster_tutorial_lesson1).

* The following CLIs:

  * [IBM Cloud](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-ibmcloud-cli#ibmcloud-cli)
  * [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  * [Docker](https://docs.docker.com/install/)
  * [Helm](https://cloud.ibm.com/docs/containers?topic=containers-integrations#helm)

* The following [IBM Cloud CLI plug-ins](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-plug-ins#plug-ins):

  * Kubernetes Service
  * Container Registry


## Installing the chart

When you install a Helm chart, you have several options and parameters that you can use to customize your installation. The following instructions walk you through the most basic, default installation of the chart. For more information about your options, see [the IBM Cloud Data Shield documentation](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-getting-started#getting-started).

**Tip**: Are your images stored in a private registry? You can use the Container Converter to configure the images to work with IBM Cloud Data Shield. Be sure to convert your images before you deploy the chart so that you have the necessary configuration information. For more information, see [Converting images](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert).


**To install IBM Cloud Data Shield to your cluster:**

1. Log in to the IBM Cloud CLI. Follow the prompts in the CLI to complete logging in.

  ```
  ibmcloud login
  ```

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```

  2. Copy the output beginning with `export` and paste it into your terminal to set the `KUBECONFIG` environment variable.

3. If you haven't already, add the `iks-charts` repository.

  ```
  helm repo add iks-charts https://icr.io/helm/iks-charts
  ```

4. If you don't know the email that is associated with the administrator or the admin account ID, run the following command.

  ```
  ibmcloud account show
  ```

5. Get the Ingress subdomain for your cluster.

  ```
  ibmcloud ks cluster-get <cluster_name>
  ```

6. Initialize Helm by creating a role binding policy for Tiller.

  1. Create a service account for Tiller.

    ```
    kubectl --namespace kube-system create serviceaccount tiller
    ```

  2. Create the role binding to assign Tiller admin access in the cluster.

    ```
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    ```

  3. Initialize Helm.

    ```
    helm init --service-account tiller --upgrade
    ```

  You might want to configure Helm to use `--tls` mode. For help with enabling TLS check out the [Helm repository](https://github.com/helm/helm/blob/master/docs/tiller_ssl.md). If you enable TLS, be sure to append `--tls` to every Helm command that you run. For more information about using Helm with IBM Cloud Kubernetes Service, see [Adding services by using Helm Charts](https://cloud.ibm.com/docs/containers?topic=containers-helm#public_helm_install).

7. Install the chart.

  ```
  helm install iks-charts/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain>
  ```

  * If you [configured an IBM Cloud Container Registry](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert#convert) for your converter, add the following option: `--set converter-chart.Converter.DockerConfigSecret=converter-docker-config`
  * If you're working with an OpenShift cluster, be sure to append the following tag to your installation command: `--set global.OpenShiftEnabled=true`.

8. To monitor the startup of your components, you can run the following command.

  ```
  kubectl get pods
  ```

## Running your apps in the IBM Cloud Data Shield environment

With the [Enclave Manager GUI](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-enclave-manager), you can manage nodes, deploy and build apps, and approve tasks for all of the applications that run in your IBM Cloud Data Shield environment. You can also build, deploy, and whitelist applications by [using the API](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-convert) if that is your preference.



### Accessing the Enclave Manager GUI

1. Sign in to IBM Cloud and set the context for your cluster.

2. Check to see that the service is running by confirming that all of your pods are in a *running* state.

  ```
  kubectl get pods
  ```

3. Look up the front-end URL for your Enclave Manager by running the following command.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```

4. Get your Ingress subdomain.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```

5. In a browser, enter the Ingress subdomain where your Enclave Manager is available.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```

6. In terminal, get your IAM token.

  ```
  ibmcloud iam oauth-tokens
  ```

7. Copy the token and paste it into the Enclave Manager GUI. You do not need to copy the `Bearer` portion of the printed token.

8. Click **Sign in**.

For more information about the roles that a user needs to take different actions, see [Setting roles for Enclave Manager users](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-access#enclave-roles).

## Using prepackaged shielded images

Want to try out IBM Cloud Data Shield, but don't have an image ready to go? No problem, you can use one of the provided production-ready images that are able to be run in IBM Cloud Data Shield environments.

* [Barbican](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/services/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)


## Uninstalling and troubleshooting

If you encounter an issue while working with IBM Cloud Data Shield, try looking through the [troubleshooting](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-troubleshooting#troubleshooting) or [frequently asked questions](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-faq#faq) sections of the documentation. If you don't see your question or a solution to your issue, contact [IBM support](https://cloud.ibm.com/docs/get-support?topic=get-support-getting-customer-support#getting-customer-support).

If you no longer need to use IBM Cloud Data Shield, you can [delete the service and the TLS certificates that were created](https://cloud.ibm.com/docs/services/data-shield?topic=data-shield-uninstall#uninstall).

