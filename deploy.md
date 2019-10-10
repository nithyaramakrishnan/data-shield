---

copyright:
  years: 2018, 2019
lastupdated: "2019-07-08"

keywords: Data protection, data in use, runtime encryption, runtime memory encryption, encrypted memory, Intel SGX, software guard extensions, Fortanix runtime encryption

subcollection: data-shield

---

{:external: target="_blank" .external}
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


# Deploying images
{: #deploying}

After you convert your images, you must deploy your {{site.data.keyword.datashield_short}} containers to your Kubernetes cluster.
{: shortdesc}

When you deploy {{site.data.keyword.datashield_short}}, the container specification must include volume mounts that allow the SGX devices and the AESM socket to be available.

Don't have an application to try the service? No problem. We offer several sample apps that you can try, including MariaDB and NGINX. Any of the [{{site.data.keyword.datashield_short}} images](/docs/services/Registry?topic=RegistryImages-datashield-mariadb_starter) in IBM Container Registry can be used as a sample.
{: tip}

1. Configure [pull secrets](/docs/containers?topic=containers-images#other).

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


3. Update the fields `your-app-sgx` and `your-registry-server` to your app and server.

4. Create the Kubernetes pod.

   ```
   kubectl create -f template.yml
   ```
  {: codeblock}

## Deploying images on IBM Cloud OpenShift clusters

Data Shield 1.5.xx includes a technology preview of support for IBM Cloud OpenShift clusters.

To deploy on an OpenShift cluster, specify `--set global.OpenShiftEnabled=true`  when installing the helm chart.

Be aware of the following limitations when using {{site.data.keyword.datashield_full}} on OpenShift:

* Currently, application containers must be run as privileged containers so that they may access the host's SGX devices. This requirement will be eliminated in a future release. To make containers privileged, add the following to the pod specification for each container that needs to access the SGX devices:
```
securityContext:
  privileged: true
```
OpenShift security policies may restrict creation of privileged containers. Cluster admin users have permission to create privileged containers when creating pods directly. When pods are created by a Kubernetes controller (replica set, daemon set), that controller must be associated with a service account that has permission to create privileged containers.

* Installing {{site.data.keyword.datashield_full}} on a cluster puts SELinux in permissive mode. SELinux compatibility will be addressed in an upcoming release.
