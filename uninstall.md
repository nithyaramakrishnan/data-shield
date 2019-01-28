---

copyright:
  years: 2018, 2019
lastupdated: "2019-01-21"

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

1. Log in to the {{site.data.keyword.cloud_notm}} CLI. Follow the prompts in the CLI to complete logging in.

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
      <td><code>us-south</code></td>
    </tr>
  </table>

2. Set the context for your cluster.

  1. Get the command to set the environment variable and download the Kubernetes configuration files.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copy the output and paste it into your terminal.

3. Delete the service.

  ```
  helm del --purge datashield
  ```
  {: codeblock}

4. Delete the TLS certificates by running each of the following commands.

  ```
  kubectl delete secret datashield-enclaveos-converter-tls
  kubectl delete secret datashield-enclaveos-frontend-tls
  kubectl delete secret datashield-enclaveos-manager-main-tls
  ```
  {: codeblock}

5. The uninstall process uses Helm "hooks" to run an uninstaller. You can delete the uninstaller after it runs.

  ```
  kubectl delete daemonset data-shield-uninstaller
  kubectl delete configmap data-shield-uninstall-script
  ```
  {: codeblock}

You might also wish to delete the Certificate Manager instance and the Docker config secret if you created one.
{: tip}

</br>

## Uninstalling with the beta installer
{: #uninstall-installer}

If you installed {{site.data.keyword.datashield_short}} by using the beta installer, you can also uninstall the service with the installer.

To uninstall {{site.data.keyword.datashield_short}}, log in to the `ibmcloud` CLI, target your cluster, and run the following command:

  ```
  docker run -v <CONFIG_SRC>:/usr/src/app/broker-config registry.ng.bluemix.net/datashield-core/datashield-beta-installer unprovision
  ```
  {: codeblock}

</br>
</br>
