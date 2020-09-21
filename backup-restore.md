---

copyright:
  years: 2018, 2020
lastupdated: "2020-09-21"

keywords: backup, restore, enclave manager, app security, memory encryption, database, container, kube security, nodes, hmac credentials, helm, keys

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:faq: data-hd-content-type='faq'}
{:gif: data-image-type='gif'}
{:important: .important}
{:note: .note}
{:pre: .pre}
{:tip: .tip}
{:preview: .preview}
{:deprecated: .deprecated}
{:shortdesc: .shortdesc}
{:support: data-reuse='support'}
{:script: data-hd-video='script'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:video: .video}
{:step: data-tutorial-type='step'}



# Backing up and restoring
{: #backup-restore}

You can back up and restore your Enclave Manager instance.
{: shortdesc}


## Backing up your Enclave Manager instance
{: #backup}

You can configure {{site.data.keyword.datashield_full}} to periodically back up the Enclave Manager database to {{site.data.keyword.cos_full_notm}}.
{: shortdesc}

Consider enrolling hosts in more than one physical location to minimize the risk of data loss. You can restore the Enclave Manager on hardware that was previously enrolled in the Enclave Manager cluster only.
{: tip}


1. Create a [service ID](/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials) by using the instructions in the {{site.data.keyword.cos_short}} documentation, and selecting the option to include HMAC credentials. The backup job uses the HMAC credentials to authenticate to {{site.data.keyword.cos_short}}.

2. Create a Kubernetes secret with the credentials to authenticate to {{site.data.keyword.cos_short}}.
		
	```
	kubectl create secret generic enclave-manager-backup-credentials --from-literal=AWS_ACCESS_KEY_ID=<key id> --from-literal=AWS_SECRET_ACCESS_KEY=<secret>
	```
	{: codeblock}

3. Add the following options to your `helm install` command when you install Data Shield, or to your `helm upgrade` command when you upgrade an existing {{site.data.keyword.datashield_full}} instance. Modify the following values for your environment.
		
	```
	--set enclaveos-chart.Backup.CronSchedule="<backup schedule>"
	--set global.S3.Endpoint=<endpoint>
	--set global.S3.Bucket=<orgname>-enclave-manager-backups
	--set global.S3.HmacSecretName=enclave-manager-backup-credentials
	```
	{: codeblock}

	<table>
		<caption>Table 1. Backup installation options</caption>
		<tr>
			<th>Option</th>
			<th>Description</th>
		</tr>
		<tr>
			<td><code>enclaveos-chart.Backup.CronSchedule</code></td>
			<td>The schedule on which you want to back up your environment. The schedule is set in cron syntax. For example: <code>0 0 * * *</code> performs a backup every night at midnight Coordinated Universal Time.</td>
		</tr>
		<tr>
			<td><code>global.S3.Endpoint</code></td>
			<td>The location of the {{site.data.keyword.cos_short}} bucket that you created. You can find the endpoint in the <a href="/docs/cloud-object-storage?topic=cloud-object-storage-endpoints">{{site.data.keyword.cos_short}} endpoint documentation</a>.</td>
		</tr>
		<tr>
			<td>Optional: <code>enclaveos-chart.Backup.S3Prefix</code></td>
			<td>A path within the bucket where you want to store the backup. By default, backups are stored at the bucket root.</td>
		</tr>
	</table>



## Restoring Enclave Manager
{: #restore}

If you configured your Helm chart to create a backup of the Enclave Manager before you deployed, you can restore it if you encounter any issues.

1. Ensure that you're running on a node that was previously running in the Enclave Manager. The Enclave Manager data is encrypted by using SGX sealing keys, and can be decrypted only on the same hardware.

2. Deploy the Enclave Manager with 0 instances of the backend server by setting the following Helm value.

	```
	--set enclaveos-chart.Manager.ReplicaCount=0
	```
	{: codeblock}

3. After the Enclave Manager is deployed, copy the backup to the database container.

	```
	kubectl cp <local path to backup> <release>-enclaveos-cockroachdb-0:/cockroach
	```
	{: codeblock}

4. Create a shell in the database container.

	```
	kubectl exec -it <release>-enclaveos-cockroachdb-0 bash
	```
	{: codeblock}

5. Prepare the database to restore from your backup.

   1. Create an SQL shell.

		```
		./cockroach sql --insecure
		```
		{: codeblock}

   1. When prompted by SQL run the following commands.

		```
		drop database malbork cascade;
		create database malbork;
		```
		{: codeblock}

   1. Exit and run the following command.

		```
		./cockroach sql --insecure -d malbork < <your backup>.sql
		```
		{: codeblock}

6. Scale the Enclave Manager deployment up by running `helm upgrade` without setting the `enclaveos-chart.Manager.ReplicaCount` value.

