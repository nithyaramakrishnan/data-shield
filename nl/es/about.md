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

# Acerca del servicio
{: #about}

Con {{site.data.keyword.datashield_full}}, Fortanix® e Intel® SGX, puede proteger los datos de sus cargas de trabajo de contenedor que se
ejecutan en {{site.data.keyword.cloud_notm}} mientras los datos están en uso.
{: shortdesc}

Cuando se trata de proteger sus datos, el cifrado es uno de los controles más populares y efectivos. Sin embargo, los datos se tienen que cifrar en cada paso de su ciclo de vida para que realmente estén protegidos. Los datos atraviesan tres fases durante su ciclo de vida: datos en reposo, datos en movimiento y datos en uso. Los datos en reposo y en movimiento se utilizan habitualmente para proteger los datos cuando se almacenan y cuando se transportan. Después de que comience a ejecutarse una aplicación, los datos en uso por la CPU o la memoria son vulnerables a diversos ataques, incluyendo personas maliciosas con información privilegiada, usuarios root, credenciales que se hayan visto comprometidas, SO en día cero, intrusos de red, etc. Llevando dicha protección un paso más allá, ahora puede cifrar los datos en uso. 

Con {{site.data.keyword.datashield_short}}, los datos y el código de la app se ejecutan en enclaves reforzados por CPU, que son áreas de confianza de la memoria en el nodo trabajador que protegen aspectos críticos de la app. Los enclaves sirven de ayuda para que el código y los datos sigan siendo confidenciales y permanezcan intactos. Si usted o su empresa requieren confidencialidad de datos debido a políticas internas, normativas gubernamentales o requisitos de conformidad del sector, esta solución podría ayudarle a trasladarse a la nube. Los casos de uso de ejemplo incluyen instituciones financieras y de atención sanitaria o países con políticas gubernamentales que requieren soluciones de nube local.


## Integraciones
{: #integrations}

Para proporcionarle una experiencia lo más transparente posible, {{site.data.keyword.datashield_short}} se integra con otros servicios de
{{site.data.keyword.cloud_notm}}, el cifrado en tiempo de ejecución de Fortanix® e Intel SGX®.

<dl>
  <dt>Fortanix®</dt>
    <dd>Con [Fortanix](http://fortanix.com/), puede mantener protegidos los datos y las apps más valiosas, incluso aunque la infraestructura se vea comprometida. Construido sobre Intel SGX, Fortanix proporciona una nueva categoría de seguridad de datos llamada Cifrado en tiempo de ejecución. Similar a la manera en que funciona el cifrado para los datos en reposo y los datos en movimiento, el cifrado en tiempo de ejecución mantiene las claves, los datos y las aplicaciones protegidos de amenazas tanto externas como internas. Las amenazas pueden incluir personas maliciosas con información privilegiada, proveedores de nube, piratería a nivel del sistema operativo o intrusos de la red.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx) es una extensión de la arquitectura x86 que le permite ejecutar aplicaciones en un enclave seguro y completamente aislado. La aplicación no solo se aísla de otras aplicaciones que se ejecutan en el mismo sistema, sino también del sistema operativo y de posibles hipervisores. Esto impide que los administradores puedan alterar la aplicación después de que se haya iniciado. La memoria de los enclaves seguros también se cifra para frustrar ataques físicos. La tecnología también admite el almacenamiento de datos persistentes de forma segura, de manera que solo los pueda leer el enclave seguro.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started) combina contenedores Docker, la tecnología Kubernetes y una experiencia de usuario intuitiva para ofrecer herramientas potentes y funciones integradas de seguridad e identificación para automatizar el despliegue, operación, escalado y supervisión de apps contenerizadas sobre un clúster de hosts de cálculo.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted) le permite autenticar usuarios de forma segura en los servicios y controlar el acceso a los recursos de forma coherente en {{site.data.keyword.cloud_notm}}. Cuando un usuario intenta completar una acción específica, el sistema de control utiliza los atributos definidos en la política para determinar si el usuario tiene permiso para realizar esa tarea. Hay claves de API de {{site.data.keyword.cloud_notm}} disponibles a través de Cloud IAM, que puede utilizar para realizar la autenticación mediante la CLI o como parte de la automatización para iniciar sesión con su identidad de usuario.</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>Puede crear una [configuración de registro](/docs/containers?topic=containers-health#health) a través del
{{site.data.keyword.containerlong_notm}} que reenvía sus registros a
[{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla). Puede ampliar las posibilidades de recopilación de registros, retención de registros y búsqueda de registros de {{site.data.keyword.cloud_notm}}. Ofrezca a su equipo de DevOps características como la agregación de registros de aplicación y del entorno para obtener un conocimiento consolidado de la aplicación o el entorno, cifrado de registros, retención de datos de registro durante el tiempo que sea necesario, y una rápida detección y resolución de los problemas.</dd>
</dl>
