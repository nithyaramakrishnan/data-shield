# Data Shield

With IBM Cloud™ Data Shield, powered by Fortanix®, you can protect the data in your container workloads that run on Kubernetes Service or OpenShift clusters while your data is in use.
For more information about how you are charged for using Data Shield, see the [catalog](https://cloud.ibm.com/catalog/services/data-shield).

## Introduction

When it comes to protecting your data, encryption is one of the most popular and effective ways. But, the data must be encrypted at each step of its lifecycle for it to really be secure. Data at rest and in motion are commonly used to protect data when it is stored and when it is transported. However, after an application starts to run, data in use by CPU and memory is vulnerable to attacks. Malicious insiders, compromised credentials, and network intruders are all threats to data. Taking encryption one step further, you can now protect data in use. For more information about Data Shield, and what it means to protect your data in use, see [the docs](https://cloud.ibm.com/docs/data-shield?topic=data-shield-about#about).

## Resources required

To work with Data Shield, you must have an SGX enabled cluster. Depending on whether you're working with Kubernetes or OpenShift, the machine type differs. Be sure that you have the correct machine type:

  * If you're working with Kubernetes Service, you can use machine types `mb2c.4x32` or `ms2c.4x32.1.9tb.ssd`. Note: To see the options, you must filter the page to see the Ubuntu 16 operating system options.

  * If you're working with OpenShift, you can use machine types `mb3c.4x32` and `ms3c.4x32.1.9tb.ssd`.

**Important**: Your cluster must be using Kubernetes version 1.15 or earlier to install the service.

## Prerequisites

Before you can begin working with Data Shield, you must install the required prerequisites as listed in the [getting started tutorial](https://cloud.ibm.com/docs/data-shield?topic=data-shield-getting-started).

## Installing the chart

After you have all of the prerequisites, you can install Data Shield to your cluster by running the following command.

```
helm install iks-charts/ibmcloud-data-shield --set enclaveos-chart.Manager.AdminEmail=<admin email> --set enclaveos-chart.Manager.AdminName=<admin name> --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.IngressDomain=<your cluster's ingress domain> --set converter-chart.Converter.DockerConfigSecret=converter-docker-config
```

Note: If you're working with an OpenShift cluster, be sure to append the following tag to your installation command: `--set global.OpenShiftEnabled=true`.

## Next steps

With the [Enclave Manager GUI](https://cloud.ibm.com/docs/data-shield?topic=data-shield-enclave-manager), you can manage nodes, deploy and build apps, and approve tasks for all of the applications that run in your Data Shield environment. You can also build, deploy, and allow list applications by [using the API](https://cloud.ibm.com/docs/data-shield?topic=data-shield-convert) if that is your preference.

## Using prepackaged shielded images

Want to try out Data Shield, but don't have an image ready to go? No problem, you can use one of the provided production-ready images that are able to be run in Data Shield environments.

* [Barbican](https://cloud.ibm.com/docs/Registry?topic=RegistryImages-datashield-barbican_starter#datashield-barbican_starter)
* [MYSQL](https://cloud.ibm.com/docs/Registry?topic=RegistryImages-datashield-mysql_starter#datashield-mysql_starter)
* [NGINX](https://cloud.ibm.com/docs/Registry?topic=RegistryImages-datashield-nginx_starter#datashield-nginx_starter)
* [Vault](https://cloud.ibm.com/docs/Registry?topic=RegistryImages-datashield-vault_starter#datashield-vault_starter)

## Uninstalling and troubleshooting

If you encounter an issue while working with Data Shield, try looking through the [troubleshooting](https://cloud.ibm.com/docs/data-shield?topic=data-shield-troubleshooting#troubleshooting) or [frequently asked questions](https://cloud.ibm.com/docs/data-shield?topic=data-shield-faq#faq) sections of the documentation. If you don't see your question or a solution to your issue, contact [IBM support](https://cloud.ibm.com/docs/get-support?topic=get-support-using-avatar).

If you no longer need to use Data Shield, you can [uninstall the service](https://cloud.ibm.com/docs/data-shield?topic=data-shield-uninstall#uninstall).

