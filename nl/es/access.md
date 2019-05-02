---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

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

# Gestión del acceso
{: #access}

Puede controlar el acceso a Enclave Manager de {{site.data.keyword.datashield_full}}. Este control de acceso es independiente a los roles típicos de Identity and Access Management (IAM) que se utilizan al trabajar con {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Utilización de una clave de API de IAM para iniciar sesión en la consola
{: #access-iam}

En la consola de Enclave Manager, puede ver los nodos del clúster y su estado de testificación. También puede ver tareas y registros de auditoría de los sucesos del clúster.

1. Inicie sesión en la CLI de IBM Cloud. Siga las indicaciones de la CLI para completar el inicio de sesión.

  ```
  ibmcloud login -a cloud.ibm.com -r <region>
  ```

  <table>
    <tr>
      <th>Región</th>
      <th>Punto final de IBM Cloud</th>
      <th>Región del servicio Kubernetes</th>
    </tr>
    <tr>
      <td>Dallas</td>
      <td><code>us-south</code></td>
      <td>EE.UU. sur</td>
    </tr>
    <tr>
      <td>Frankfurt</td>
      <td><code>eu-de</code></td>
      <td>UE central</td>
    </tr>
    <tr>
      <td>Sídney</td>
      <td><code>au-syd</code></td>
      <td>AP sur</td>
    </tr>
    <tr>
      <td>Londres</td>
      <td><code>eu-gb</code></td>
      <td>RU sur</td>
    </tr>
    <tr>
      <td>Tokio</td>
      <td><code>jp-tok</code></td>
      <td>AP norte</td>
    </tr>
    <tr>
      <td>Washington DC</td>
      <td><code>us-east</code></td>
      <td>EE.UU. este</td>
    </tr>
  </table>

2. Establezca el contexto del clúster.

  1. Obtenga el mandato para establecer la variable de entorno y descargar los archivos de configuración de Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```

  2. Copie la salida a partir de `export` y péguela en el terminal para establecer la variable de entorno
`KUBECONFIG`.

3. Compruebe si todos los servicios están en ejecución confirmando que todos los pods están en el estado *en ejecución*.

  ```
  kubectl get pods
  ```
  {: codeblock}

4. Busque el URL de programa de usuario de Enclave Manager ejecutando el mandato siguiente.

  ```
  kubectl get svc datashield-enclaveos-frontend
  ```
  {: codeblock}

5. Obtenga el subdominio Ingress.

  ```
  ibmcloud ks cluster-get <your-cluster-name>
  ```
  {: codeblock}

6. En un navegador, especifique el subdominio Ingress donde esté disponible Enclave Manager.

  ```
  enclave-manager.<cluster-ingress-subdomain>
  ```
  {: codeblock}

8. En el terminal, obtenga la señal de IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

7. Copie la señal y péguela en la GUI de Enclave Manager. No es necesario que copie la parte de `Bearer` de la señal impresa.

9. Pulse **Iniciar sesión**.


## Establecimiento de roles para usuarios de Enclave Manager
{: #enclave-roles}

La administración de {{site.data.keyword.datashield_short}} se lleva a cabo en Enclave Manager. Como administrador, se le asignará automáticamente el rol *manager* (gestor), pero también podrá asignar roles a otros usuarios.
{: shortdesc}

Tenga en cuenta que estos roles son distintos a los roles de IAM que se utilizan para controlar el acceso a los servicios de
{{site.data.keyword.cloud_notm}}. Para obtener más información sobre la configuración del acceso para
{{site.data.keyword.containerlong_notm}}, consulte [Asignación del acceso al clúster](/docs/containers?topic=containers-users#users).
{: tip}

Consulte la tabla siguiente para ver qué roles se admiten y algunas acciones de ejemplo que puede llevar a cabo cada usuario:

<table>
  <tr>
    <th>Rol</th>
    <th>Acciones</th>
    <th>Ejemplo</th>
  </tr>
  <tr>
    <td>Lector</td>
    <td>Puede realizar acciones de solo lectura como ver nodos, compilaciones, información de usuario, apps, tareas y registros de auditoría.</td>
    <td>Descarga de un certificado de testificación de nodo.</td>
  </tr>
  <tr>
    <td>Escritor</td>
    <td>Puede realizar las acciones que puede realizar un Lector y algunas más, incluyendo la desactivación y renovación de la testificación de nodo, la adición de una compilación, la aprobación o denegación de cualquier acción o tarea.</td>
    <td>Certificación de una aplicación.</td>
  </tr>
  <tr>
    <td>Gestor</td>
    <td>Puede realizar las acciones que puede realizar un Escritor y algunas más, incluyendo la actualización de nombres de usuario y roles, la adición de usuarios a un clúster, la actualización de valores del clúster y otras acciones con privilegios.</td>
    <td>Actualización de un rol de usuario.</td>
  </tr>
</table>

### Establecimiento de roles de usuario
{: #set-roles}

Puede establecer o actualizar los roles de usuario para el gestor de la consola.
{: shortdesc}

1. Acceda a la [interfaz de usuario de Enclave Manager](/docs/services/data-shield?topic=data-shield-access#access-iam).
2. En el menú desplegable, abra la pantalla de gestión de usuarios.
3. Seleccione **Valores**. Puede revisar la lista de usuarios o añadir un usuario en esta pantalla.
4. Para editar permisos de usuario, pase el puntero del ratón sobre un usuario hasta que aparezca el icono de lápiz.
5. Pulse el icono de lápiz para cambiar los permisos. Los cambios en los permisos de un usuario entrarán en vigor de inmediato.
