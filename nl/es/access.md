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

# Asignación de acceso
{: #access}

Puede controlar el acceso a Enclave Manager de {{site.data.keyword.datashield_full}}. Este tipo de control de acceso es independiente a los roles típicos de Identity and Access Management (IAM) que se utilizan al trabajar con {{site.data.keyword.cloud_notm}}.
{: shortdesc}


## Asignación de acceso al clúster
{: #access-cluster}

Para poder iniciar una sesión en Enclave Manager, debe tener acceso al clúster en el que se ejecuta Enclave Manager.
{: shortdesc}

1. Inicie una sesión en la cuenta que aloja el clúster en el que desea iniciar la sesión.

2. Vaya a **Gestionar > Acceso (IAM) > Usuarios**.

3. Pulse **Invitar a usuarios**.

4. Especifique las direcciones de correo electrónico de los usuarios que desea añadir.

5. En el menú desplegable **Asignar acceso a**, seleccione **Recurso**.

6. En el menú desplegable **Servicios**, seleccione **Servicio de Kubernetes**.

7. Seleccione una **Región**, un **Clúster** y un **Espacio de nombres**.

8. Utilizando como guía la documentación del servicio Kubernetes sobre [asignación de acceso a un clúster](/docs/containers?topic=containers-users), asigne el acceso que necesita el usuario para llevar a cabo sus tareas.

9. Pulse **Guardar**.

## Establecimiento de roles para usuarios de Enclave Manager
{: #enclave-roles}

La administración de {{site.data.keyword.datashield_short}} se lleva a cabo en Enclave Manager. Como administrador, se le asignará automáticamente el rol *manager* (gestor), pero también podrá asignar roles a otros usuarios.
{: shortdesc}

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
    <td>Puede realizar las acciones que puede realizar un Lector y algunas más, que incluyen la desactivación y renovación de la certificación de nodo, la adición de una compilación y la aprobación o denegación de cualquier acción o tarea.</td>
    <td>Certificación de una aplicación.</td>
  </tr>
  <tr>
    <td>Gestor</td>
    <td>Puede realizar las acciones que puede realizar un Escritor y algunas más, que incluyen la actualización de nombres de usuario y roles, la adición de usuarios a un clúster, la actualización de valores del clúster y otras acciones con privilegios.</td>
    <td>Actualización de un rol de usuario.</td>
  </tr>
</table>


### Adición de un usuario
{: #set-roles}

Mediante la GUI de Enclave Manager, puede otorgar a un nuevo usuario acceso a la información.
{: shortdesc}

1. Inicie una sesión en Enclave Manager.

2. Pulse **Su nombre > Valores**.

3. Pulse **Añadir usuario**.

4. Especifique un correo electrónico y un nombre para el usuario. Seleccione un rol en el menú desplegable **Rol**.

5. Pulse **Guardar**.



### Actualización de un usuario
{: #update-roles}

Puede actualizar los roles que se asignan a los usuarios y su nombre.
{: shortdesc}

1. Inicie una sesión en la [IU de Enclave Manager](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin).

2. Pulse **Su nombre > Valores**.

3. Mueva el puntero del ratón sobre el usuario cuyos permisos desea editar. Se visualiza un icono de lápiz.

4. Pulse el icono de lápiz. Se abre una pantalla para editar usuarios.

5. En el menú desplegable **Rol**, seleccione los roles que desea asignar.

6. Actualice el nombre del usuario.

7. Pulse **Guardar**. Los cambios en los permisos de un usuario entrarán en vigor de inmediato.


