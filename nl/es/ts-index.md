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
{:tsSymptoms: .tsSymptoms}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}

# Resolución de problemas
{: #troubleshooting}

Si tiene problemas mientras trabaja con {{site.data.keyword.datashield_full}}, considere estas técnicas para resolverlos y obtener ayuda.
{: shortdesc}

## Obtención de ayuda y soporte
{: #gettinghelp}

Para obtener ayuda, puede buscar información en la documentación o hacer preguntas a través de un foro. También puede abrir una incidencia de soporte. Cuando utilice los foros para formular una pregunta, etiquete la pregunta de manera que la vea el equipo de desarrollo de {{site.data.keyword.cloud_notm}}.
  * Si tiene preguntas de carácter técnico acerca de {{site.data.keyword.datashield_short}}, publique su pregunta en
<a href="https://stackoverflow.com" target="_blank">Stack Overflow <img src="../../icons/launch-glyph.svg" alt="Icono de enlace externo"></a> y etiquete su pregunta con "ibm-data-shield".
  * Para formular preguntas sobre el servicio y obtener instrucciones de iniciación, utilice el foro <a href="https://developer.ibm.com/" target="_blank">dW Answers <img src="../../icons/launch-glyph.svg" alt="Icono de enlace externo"></a>. Incluya la etiqueta `data-shield`.

Para obtener más información sobre cómo obtener ayuda, consulte [¿Cómo puedo obtener la ayuda que necesito?](/docs/get-support?topic=get-support-getting-customer-support).


## Obtención de registros
{: #ts-logs}

Cuando abre una incidencia de soporte para IBM Cloud Data Shield, puede agilizar el proceso de resolución de problemas si proporciona sus registros. Puede seguir los pasos siguientes para obtener sus registros y luego copiarlos y pegarlos en el problema cuando lo cree.

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

3. Ejecute el mandato siguiente para obtener los registros.

  ```
  kubectl logs --all-containers=true --selector release=$(helm list | grep 'data-shield' | awk {'print $1'}) > logs
  ```
  {: codeblock}


## No puedo iniciar sesión en la interfaz de usuario de Enclave Manager
{: #ts-log-in}

{: tsSymptoms}
Intenta acceder a la interfaz de usuario de Enclave Manager, pero no puede iniciar sesión.

{: tsCauses}
El inicio de sesión podría fallar por los motivos siguientes:

* Es posible que esté utilizando un ID de correo electrónico que no tenga autorización para acceder al clúster de Enclave Manager.
* Es posible que la señal que está utilizando haya caducado.

{: tsResolve}
Para resolver el problema, verifique que está utilizando el ID de correo electrónico correcto. Si es así, verifique que el correo electrónico tenga los permisos correctos para acceder a Enclave Manager. Si tiene los permisos adecuados, es posible que la señal de acceso haya caducado. Las señales son válidas durante 60 minutos cada vez. Para obtener una señal nueva, ejecute `ibmcloud iam oauth-tokens`. Si tiene varias cuentas de IBM Cloud, verifique que ha iniciado la sesión en la CLI con la cuenta correcta para el clúster de Enclave Manager.


## La API del conversor de contenedores devuelve un error Forbidden (prohibido)
{: #ts-converter-forbidden-error}

{: tsSymptoms}
Intenta ejecutar el conversor de contenedores y recibe un error: `Forbidden`.

{: tsCauses}
Es posible que no pueda acceder al conversor si falta su señal de IAM o Bearer o ya ha caducado.

{: tsResolve}
Para resolver el problema, verifique que está utilizando una señal de IBM IAM OAuth o una señal de autenticación de Enclave Manager en la cabecera de la solicitud. Las señales deben tener el formato siguiente:

* IAM: `Authentication: Basic <IBM IAM Token>`
* Enclave Manager: `Authentication: Bearer <E.M. Token>`

Si la señal está presente, verifique que sigue siendo válida y ejecute de nuevo la solicitud.


## El conversor de contenedores no se puede conectar a un registro de Docker privado
{: #ts-converter-unable-connect-registry}

{: tsSymptoms}
Intenta ejecutar el conversor de contenedores en una imagen de un registro de Docker privado y el conversor no se puede conectar.

{: tsCauses}
Es posible que las credenciales del registro privado no se hayan configurado correctamente. 

{: tsResolve}
Para resolver el problema, puede seguir los pasos siguientes:

1. Verifique que las credenciales del registro privado se han configurado con anterioridad. Si no es así, configúrelas ahora.
2. Ejecute el mandato siguiente para volcar las credenciales del registro de Docker. Si es necesario, puede cambiar el nombre secreto.

  ```
  kubectl get secret -oyaml converter-docker-config
  ```
  {: codeblock}

3. Utilice un decodificador de Base64 para decodificar el contenido secreto de
`.dockerconfigjson` y verifique que sea correcto.


## No se pueden montar los dispositivos SGX o de socket AESM
{: #ts-problem-mounting-device}

{: tsSymptoms}
Se producen problemas al intentar montar contenedores de {{site.data.keyword.datashield_short}} en los volúmenes
`/var/run/aesmd/aesm.socket` o `/dev/isgx`.

{: tsCauses}
El montaje puede fallar debido a problemas en la configuración del host.

{: tsResolve}
Para resolver el problema, verifique:

* Que `/var/run/aesmd/aesm.socket` no es un directorio del host. Si lo es, suprima el archivo, desinstale el software de
{{site.data.keyword.datashield_short}} y vuelva a realizar los pasos de la instalación. 
* Que SGX está habilitado en el BIOS de las máquinas host. Si no está habilitado, póngase en contacto con el soporte de IBM.


## Error: conversión de contenedores
{: #ts-container-convert-fails}

{: tsSymptoms}
Se produce el error siguiente al intentar convertir el contenedor.

```
{"errorType":"Processing Failure","reason":"Credentials store error: StoreError('docker-credential-osxkeychain not installed or not available in PATH',)"}
```
{: codeblock}

{: tsCauses}
En macOS, si se utiliza el sistema operativo X Keychain en el archivo `config.json`, el conversor de contenedor falla. 

{: tsResolve}
Para resolver el problema, puede utilizar los pasos siguientes:

1. Inhabilite OS X Keychain en el sistema local. Vaya a **Preferencias del sistema > iCloud** y desmarque el recuadro correspondiente a **Keychain**.

2. Suprima el secreto que ha creado. Asegúrese de haber iniciado una sesión en IBM Cloud y de haber elegido como destino el clúster antes de ejecutar el mandato siguiente.

  ```
  kubectl delete secret converter-docker-config
  ```
  {: codeblock}

3. En el archivo `$HOME/.docker/config.json`, suprima la línea `"credsStore": "osxkeychain"`.

4. Inicie sesión en el registro.

5. Cree un secreto.

  ```
  kubectl create secret generic converter-docker-config --from-file=.dockerconfigjson=$HOME/.docker/config.json
  ```
  {: codeblock}

6. Obtenga una lista de los pods y tome nota del pod que tiene `enclaveos-converter` en el nombre.

  ```
  kubectl get pods
  ```
  {: codeblock}

7. Suprima el pod.

  ```
  kubectl delete pod <pod name>
  ```
  {: codeblock}

8. Convierta la imagen.
