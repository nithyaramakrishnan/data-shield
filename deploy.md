---

copyright:
  years: 2018, 2021
lastupdated: "2021-04-21"

keywords: clusters, deploy apps, pod specification, security policies, containers, encryption, helm, sample apps, volumes, memory, data in use,

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
{:beta: .beta}
{:term: .term}
{:shortdesc: .shortdesc}
{:script: data-hd-video='script'}
{:support: data-reuse='support'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:java: .ph data-hd-programlang='java'}
{:javascript: .ph data-hd-programlang='javascript'}
{:swift: .ph data-hd-programlang='swift'}
{:curl: .ph data-hd-programlang='curl'}
{:video: .video}
{:step: data-tutorial-type='step'}
{:tutorial: data-hd-content-type='tutorial'}


# Deploying images
{: #deploying}

After you convert your images, you must deploy your {{site.data.keyword.datashield_full}} containers to your Kubernetes cluster.
{: shortdesc}

When you deploy Data Shield, the container specification must include volume mounts that allow the SGX devices and the AESM socket to be available.

Don't have an application to try the service? No problem. We offer several sample apps that you can try, including MariaDB and NGINX. Any of the [Data Shield images](/docs/Registry?topic=RegistryImages-datashield-mariadb_starter) in IBM Container Registry can be used as a sample.
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
        env:
        - name: NODE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: NODE_AGENT_BASE_URL
          value: http://$(NODE_IP):9092/v1
      resources:
        limits:
          fortanix.com/isgx: 1
          fortanix.com/gsgx: 1
    ```
    {: screen}

3. Update the fields `your-app-sgx` and `your-registry-server` to your app and server.

4. Create the Kubernetes pod.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}



## Deploying images on {{site.data.keyword.openshiftshort}} clusters
{: #deploy-openshift}

With Data Shield 1.5, you can preview support for {{site.data.keyword.openshiftlong_notm}} clusters.

To deploy on an {{site.data.keyword.openshiftshort}} cluster, specify `--set global.OpenShiftEnabled=true` when you [install the Helm chart](/docs/data-shield?topic=data-shield-getting-started).
{: tip}

Because Data Shield is being previewed, there are a few limitations that you should be aware of:

* Application containers must run as privileged containers, which allows them to access the host's SGX devices. To make a container privileged, add the following code snippet to your pod specification for each container that needs to access the SGX devices.

  ```
  securityContext:
    privileged: true
  ```
  {: screen}

  {{site.data.keyword.openshiftshort}} security policies might restrict the creation of privileged containers. Cluster administrators have permission to create them when they create pods. If the pods are created by a Kubernetes controller, such as a replica or daemon set, the controller must be associated with a service account that has permission to create privileged containers.
  {: note}

* SELinux is placed in permissive mode during the installation. 


