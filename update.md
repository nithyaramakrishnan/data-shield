---

copyright:
  years: 2018, 2019
lastupdated: "2019-04-30"

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

# Updating
{: #update}

After {{site.data.keyword.datashield_short}} is installed on your cluster, you can update at any time.
{: shortdesc}

## Updating with Helm
{: #update-helm}

To update to the latest version with the Helm chart, run the following command.

  ```
  helm repo update && helm install ibm/ibmcloud-data-shield --name datashield --set enclaveos-chart.Manager.AdminEmail=<>  --set enclaveos-chart.Manager.AdminIBMAccountId=<hex account ID> --set global.Registry=icr.io/<your-registry>
  ```
  {: pre}

## Updating with the installer
{: #update-installer}

To update to the latest version with the installer, run the following command:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config icr.io/ibm/datashield-installer upgrade
  [ --adminEmail <ADMIN_EMAIL> ] [ --accountId <ACCOUNT_ID> ] [ --ingressSubdomain <INGRESS_SUBDOMAIN> ]
  [ --version <VERSION>] [ --registry <REGISTRY> ] [ --converterSecret <CONVERTER_SECRET> ] [ --namespace <NAMESPACE> ]
  ```
  {: pre}

  To install the most recent version of {{site.data.keyword.datashield_short}}, use `latest` for the `--version` flag.


