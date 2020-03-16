---

copyright:
  years: 2018, 2020
lastupdated: "2020-03-16"

keywords: clusters, deploy apps, pod specification, security policies, containers, encryption, helm, sample apps, volumes, memory, data in use,

subcollection: data-shield
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:new_window: target="_blank"}
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
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}


# Deploying images
{: #deploying}

After you convert your images, you must deploy your {{site.data.keyword.datashield_short}} containers to your Kubernetes cluster.
{: shortdesc}

When you deploy {{site.data.keyword.datashield_short}}, the container specification must include volume mounts that allow the SGX devices and the AESM socket to be available.

Don't have an application to try the service? No problem. We offer several sample apps that you can try, including MariaDB and NGINX. Any of the [{{site.data.keyword.datashield_short}} images](/docs/Registry?topic=RegistryImages-datashield-mariadb_starter) in IBM Container Registry can be used as a sample.
{: tip}

1. Configure [pull secrets](/docs/containers?topic=containers-registry#other).

2. Save the following pod specification as a template.

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: your-app-sgx
      labels:
        app: your-app-sgx
    spec:
      containers:
      - name: your-app-sgx
        image: your-registry-server/your-app-sgx
        volumeMounts:
        - mountPath: /dev/isgx
          name: isgx
        - mountPath: /dev/gsgx
          name: gsgx
        - mountPath: /var/run/aesmd/aesm.socket
          name: aesm-socket
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      volumes:
      - name: isgx
        hostPath:
          path: /dev/isgx
          type: CharDevice
      - name: gsgx
        hostPath:
          path: /dev/gsgx
          type: CharDevice
      - name: aesm-socket
        hostPath:
          path: /var/run/aesmd/aesm.socket
          type: Socket
    ```
    {: screen}

    The line `type: CharDevice` prevents Kubernetes from creating an empty directory if the underlying device files don't exist.
    {: Tip}

3. Update the fields `your-app-sgx` and `your-registry-server` to your app and server.

4. Create the Kubernetes pod.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}



## Deploying images on IBM Cloud OpenShift clusters
{: #deploy-openshift}

With {{site.data.keyword.datashield_short}} 1.5, you can preview support for {{site.data.keyword.openshiftlong_notm}} clusters.

To deploy on an OpenShift cluster, specify `--set global.OpenShiftEnabled=true` when you [install the Helm chart](/docs/data-shield?topic=data-shield-getting-started).
{: tip}

Because {{site.data.keyword.datashield_short}} is being previewed, there are a few limitations that you should be aware of:

* Application containers must run as privileged containers, which allows them to access the host's SGX devices. To make a container privileged, add the following code snippet to your pod specification for each container that needs to access the SGX devices.

  ```
  securityContext:
    privileged: true
  ```
  {: screen}

  OpenShift security policies might restrict the creation of privileged containers. Cluster administrators have permission to create them when they create pods. If the pods are created by a Kubernetes controller, such as a replica or daemon set, the controller must be associated with a service account that has permission to create privileged containers.
  {: note}

* SELinux is placed in permissive mode during the installation. 


