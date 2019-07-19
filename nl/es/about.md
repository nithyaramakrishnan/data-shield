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

# Acerca del servicio
{: #about}

Con {{site.data.keyword.datashield_full}}, Fortanix® e Intel® SGX, puede proteger los datos de sus cargas de trabajo de contenedor que se
ejecutan en {{site.data.keyword.cloud_notm}} mientras los datos están en uso.
{: shortdesc}

Cuando se trata de proteger sus datos, el cifrado es uno de los controles más populares y efectivos. Sin embargo, los datos se tienen que cifrar en cada paso de su ciclo de vida para que realmente estén protegidos. Durante su ciclo de vida, los datos tienen tres fases. Pueden estar en reposo, en movimiento o en uso. Los datos en reposo y en movimiento son, por lo general, el área de enfoque cuando se piensa en proteger los datos. No obstante, después de que una aplicación empiece a ejecutarse, los datos que utiliza la CPU y la memoria son vulnerables a posibles ataques. Los ataques pueden incluir atacantes internos, usuarios root, credenciales que se hayan visto comprometidas, SO en día cero e intrusos de la red, entre otros. Llevando dicha protección un paso más allá, ahora puede cifrar los datos en uso. 

Con {{site.data.keyword.datashield_short}}, los datos y el código de la app se ejecutan en enclaves reforzados por CPU. Los enclaves son áreas de confianza de la memoria, en el nodo trabajador, que protegen los aspectos críticos de sus apps. Los enclaves sirven de ayuda para que el código y los datos sigan siendo confidenciales y permanezcan intactos. Si usted o su empresa requieren confidencialidad de datos debido a políticas internas, normativas gubernamentales o requisitos de conformidad del sector, esta solución podría ayudarle en la transición a la nube. Los casos de uso de ejemplo incluyen instituciones financieras y de atención sanitaria o países con políticas gubernamentales que requieren soluciones de nube local.


## Integraciones
{: #integrations}

Para proporcionarle una experiencia lo más transparente posible, {{site.data.keyword.datashield_short}} se integra con otros servicios de
{{site.data.keyword.cloud_notm}}, Fortanix® e Intel SGX®.

<dl>
  <dt>Fortanix®</dt>
    <dd>Con el [cifrado en tiempo de ejecución de Fortanix](https://fortanix.com/){: external} puede conservar las apps y los datos protegidos más valiosos, incluso cuando la infraestructura esté comprometida. Construido sobre Intel SGX, Fortanix proporciona una nueva categoría de seguridad de datos llamada Cifrado en tiempo de ejecución. De forma similar a la manera en que funciona el cifrado para los datos en reposo y los datos en movimiento, el cifrado en tiempo de ejecución mantiene las claves, los datos y las aplicaciones protegidos frente a amenazas tanto externas como internas. Las amenazas pueden incluir personas maliciosas con información privilegiada, proveedores de nube, piratería a nivel del sistema operativo o intrusos de la red.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} es una extensión de la arquitectura x86 que le permite ejecutar aplicaciones en un enclave seguro y aislado. La aplicación no solo se aísla de otras aplicaciones que se ejecutan en el mismo sistema, sino también del sistema operativo y de un posible hipervisor. El aislamiento impide que los administradores puedan alterar la aplicación después de que se haya iniciado. La memoria de los enclaves seguros también se cifra para frustrar ataques físicos. La tecnología también admite el almacenamiento de datos persistentes de forma segura, de manera que solo los pueda leer el enclave seguro.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) proporciona herramientas potentes combinando contenedores de Docker, la tecnología Kubernetes, una experiencia de usuario intuitiva y la seguridad y el aislamiento incorporados para automatizar el trabajo con apps contenerizadas.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) le permite autenticar usuarios de forma segura en los servicios y controlar el acceso a los recursos de forma coherente en {{site.data.keyword.cloud_notm}}. Cuando un usuario intenta completar una acción específica, el sistema de control utiliza los atributos definidos en la política para determinar si el usuario tiene permiso para realizar esa tarea. Las claves de API de {{site.data.keyword.cloud_notm}} están disponibles a través de Tivoli Information Archive Manager, que puede utilizar para autenticarse a través de la CLI o como parte de la automatización para iniciar la sesión con su identidad de usuario.</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>Puede ampliar la recopilación de registros, la retención y las prestaciones de búsqueda mediante la creación de una [configuración de registro](/docs/containers?topic=containers-health) a través del {{site.data.keyword.containerlong_notm}} que reenvíe sus registros a
[{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started).
    Con el servicio, también puede aprovechar conocimientos centralizados, cifrado de registro y retención de datos de registro durante el tiempo que necesite.</dd>
</dl>
