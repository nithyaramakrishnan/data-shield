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

# Utilización de Enclave Manager
{: #enclave-manager}

Puede utilizar la interfaz de usuario de Enclave Manager para gestionar las aplicaciones que protege con {{site.data.keyword.datashield_full}}. Desde la interfaz de usuario puede gestionar el despliegue de la app, asignar acceso, manejar las solicitudes de lista blanca y convertir las aplicaciones.
{: shortdesc}


## Inicio de sesión
{: #em-signin}

En la consola de Enclave Manager, puede ver los nodos del clúster y su estado de certificación. También puede ver tareas y registros de auditoría de los sucesos del clúster. Para empezar, inicie una sesión.
{: shortdesc}

1. Asegúrese de que tiene el [acceso correcto](/docs/services/data-shield?topic=data-shield-access).

1. Inicie la sesión en la CLI de {{site.data.keyword.cloud_notm}}. Siga las indicaciones de la CLI para completar el inicio de sesión. Si tiene un ID federado, añada la opción `--sso` al final del mandato.

  ```
  ibmcloud login
  ```
  {: codeblock}

2. Establezca el contexto del clúster.

  1. Obtenga el mandato para establecer la variable de entorno y descargar los archivos de configuración de Kubernetes.

    ```
    ibmcloud ks cluster-config <cluster_name_or_ID>
    ```
    {: codeblock}

  2. Copie la salida a partir de `export` y péguela en el terminal para establecer la variable de entorno `KUBECONFIG`.

3. Compruebe si todos los servicios están en ejecución confirmando que todos los pods están en el estado *activo*.

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

7. En el terminal, obtenga la señal de IAM.

  ```
  ibmcloud iam oauth-tokens
  ```
  {: codeblock}

8. Copie la señal y péguela en la GUI de Enclave Manager. No es necesario que copie la parte de `Bearer` de la señal impresa.

9. Pulse **Iniciar sesión**.






## Gestión de nodos
{: #em-nodes}

Puede utilizar la interfaz de usuario de Enclave Manager para supervisar el estado, desactivar o descargar los certificados para los nodos que ejecutan IBM Cloud Data Shield en el clúster.
{: shortdesc}


1. Inicie una sesión en Enclave Manager.

2. Vaya al separador **Nodos**.

3. Pulse la dirección IP del nodo que desea investigar. Se abre una pantalla de información.

4. En la pantalla de información, puede optar por desactivar el nodo o descargar el certificado que se utiliza.




## Despliegue de aplicaciones
{: #em-apps}

Puede utilizar la interfaz de usuario de Enclave Manager para desplegar las aplicaciones.
{: shortdesc}


### Adición de una app
{: #em-app-add}

Puede convertir, desplegar y colocar en la lista blanca la aplicación, todos ello al mismo tiempo, mediante la interfaz de usuario de Enclave Manager.
{: shortdesc}

1. Inicie una sesión en Enclave Manager y vaya al separador **Apps**.

2. Pulse **Añadir nueva aplicación**.

3. Asigne un nombre y una descripción a la aplicación.

4. Especifique el nombre de entrada y de salida de las imágenes. La entrada es el nombre de la aplicación actual. La salida en donde encontrará la aplicación convertida.

5. Escriba un valor de **ISVPRDID** y de **ISVSVN**.

6. Especifique los dominios permitidos.

7. Edite los valores avanzados que desee cambiar.

8. Pulse **Crear nueva aplicación**. La aplicación se despliega y se añade a la lista blanca. Puede aprobar la solicitud de compilación en el separador **tareas**.




### Edición de una app
{: #em-app-edit}

Puede editar una aplicación después de añadirla a la lista.
{: shortdesc}


1. Inicie una sesión en Enclave Manager y vaya al separador **Apps**.

2. Pulse el nombre de la aplicación que desea editar. Se abre una nueva pantalla en la que puede revisar la configuración, incluidos los certificados y las compilaciones desplegadas.

3. Pulse **Editar aplicación**.

4. Actualice la configuración que desea realizar. Asegúrese de que comprende el modo en que el cambio de los valores avanzados afecta a la aplicación antes de realizar ningún cambio.

5. Pulse **Editar aplicación**.


## Creación de aplicaciones
{: #em-builds}

Puede utilizar la IU de Enclave Manager para volver a crear las aplicaciones después de realizar cambios.
{: shortdesc}

1. Inicie una sesión en Enclave Manager y vaya al separador **Compilaciones**.

2. Pulse **Crear nueva compilación**.

3. Seleccione una aplicación en la lista desplegable o añada una aplicación.

4. Especifique el nombre de la imagen de Docker y etiquétela 

5. Pulse **Compilación**. La compilación se añade a la lista blanca. Puede aprobar la compilación en el separador **Tareas**.



## Aprobación de tareas
{: #em-tasks}

Cuando una aplicación está en la lista blanca, se añade a la lista de solicitudes pendientes en el separador **tareas** de la interfaz de usuario de Enclave Manager. Puede utilizar la interfaz de usuario para aprobar o denegar la solicitud.
{: shortdesc}

1. Inicie una sesión en Enclave Manager y vaya al separador **Tareas**.

2. Pulse la fila que contiene la solicitud que desea aprobar o denegar. Se abre una pantalla con más información.

3. Revise la solicitud y pulse **Aprobar** o **Denegar**. Su nombre se añade a la lista de **Revisores**.


## Visualización de registros
{: #em-view}

Puede auditar la instancia de Enclave Manager para diversos tipos de actividad. 
{: shortdesc}

1. Vaya al separador **Registro de auditoría** de la interfaz de usuario de Enclave Manager.
2. Filtre los resultados del registro para acotar la búsqueda. Puede optar por filtrar por periodo de tiempo o por cualquiera de los tipos siguientes.

  * Estado de la app: actividad referente a la aplicación, como por ejemplo las solicitudes de colocación en lista blanca y de nuevas compilaciones.
  * Aprobación del usuario: actividad referente al acceso de un usuario, como su aprobación o denegación para utilizar la cuenta.
  * Certificación de nodo: actividad referente al certificado de nodo.
  * Entidad emisora de certificados: actividad referente a una entidad emisora de certificados.
  * Administración: actividad referente a la administración. 

Si desea conservar un registro de los registros de más de 1 mes, puede exportar la información como un archivo `.csv`.

