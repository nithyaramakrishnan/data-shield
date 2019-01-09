---

copyright:
  years: 2018, 2019
lastupdated: "2019-01-08"

---

{:new_window: target="_blank"}
{:shortdesc: .shortdesc}
{:tip: .tip}
{:screen: .screen}
{:codeblock: .codeblock}
{:pre: .pre}

# Uninstalling {{site.data.keyword.datashield_short}}
{: #uninstall}

If you no longer have a need to use {{site.data.keyword.datashield_full}}, you can delete the service and the TLS certificates that were created.


## Uninstalling with Helm

1. Delete the service.

  ```
  helm delete datashield -purge
  ```
  {: codeblock}

2. Delete the TLS certificates by running each of the following commands.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: codeblock}

You might also wish to delete the Certificate Manager instance and the Docker config secret if you created one.
{: tip}

</br>

## Uninstalling with the beta installer
{: #uninstall-installer}

If you installed {{site.data.keyword.datashield_short}} by using the beta installer, you can also uninstall the service with the installer.

To uninstall {{site.data.keyword.datashield_short}}, run the following command:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer
  unprovision
  ```
  {: codeblock}

</br>
</br>
