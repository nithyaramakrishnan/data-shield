---

copyright:
  years: 2018, 2019
lastupdated: "2019-03-13"

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
{:faq: data-hd-content-type='faq'}

# Preguntas más frecuentes (FAQ)
{: #faq}

Estas preguntas más frecuentes proporcionan respuestas a preguntas comunes sobre el servicio {{site.data.keyword.datashield_full}}.
{: shortdesc}


## ¿Qué es una testificación de enclave? ¿Cuándo y por qué es necesaria?
{: #enclave-attestation}
{: faq}

En las plataformas, se crean instancias de enclaves mediante código que no es confianza. Por lo tanto, para que a los enclaves se les pueda proporcionar información confidencial de aplicaciones, es esencial que se pueda confirmar que la instancia del enclave se ha creado correctamente en una plataforma que está protegida por Intel® SGX. Esto se lleva a cabo mediante un proceso de testificación remota. La testificación remota consiste en utilizar el software de la plataforma e instrucciones de Intel SGX para generar un "presupuesto". El presupuesto combina el resumen de enclave con un resumen de los datos de enclave relevantes y una clave asimétrica exclusiva de la plataforma en una estructura de datos que se envía a un servidor remoto a través de un canal autenticado. Si el servidor remoto concluye que la instancia del enclave se ha creado según lo esperado y está en ejecución en un procesador con capacidad real para Intel SGX, se suministrará el enclave según sea necesario.


##	¿Qué lenguajes admite actualmente {{site.data.keyword.datashield_short}}?
{: #language-support}
{: faq}

El servicio amplía el soporte del lenguaje SGX de C y C++ a Python y Java. También proporciona aplicaciones SGX convertidas previamente para MariaDB, NGINX y Vault, con un cambio mínimo (o inexistente) del código.


##	¿Cómo puedo saber si Intel SGX está habilitado en mi nodo trabajador?
{: #sgx-enabled}
{: faq}

El software de {{site.data.keyword.datashield_short}} comprueba la disponibilidad de SGX en el nodo trabajador durante el proceso de instalación. Si la instalación se realiza correctamente, la información detallada del nodo y el informe de testificación de SGX se pueden visualizar en interfaz de usuario de Enclave Manager.


##	¿Cómo puedo saber si mi aplicación se está ejecutando en un enclave de SGX?
{: #running-app}
{: faq}

[Inicie sesión](/docs/services/data-shield?topic=data-shield-access#access-iam) en su cuenta de Enclave Manager y vaya al separador **Apps**. En el separador **Apps**, puede ver información acerca de la testificación de Intel SGX para sus aplicaciones en forma de certificado. El enclave de aplicaciones se puede verificar en cualquier momento utilizando el servicio de testificación remota de Intel (IAS) para verificar que la aplicación está en ejecución en un enclave verificado.



## ¿Cuál es el impacto en el rendimiento de la ejecución de la aplicación en {{site.data.keyword.datashield_short}}?
{: #impact}
{: faq}


El rendimiento de la aplicación depende de la naturaleza de la carga de trabajo. Si tiene una carga de trabajo de uso intensivo de la CPU, el efecto que tiene {{site.data.keyword.datashield_short}} sobre su app es mínimo. Sin embargo, si tiene aplicaciones con uso intensivo de memoria o E/S, es posible que se observe un efecto debido a la paginación y al cambio de contexto. Normalmente, la relación entre el tamaño de la ocupación de memoria de la app y la memoria caché de páginas de enclave de SGX es la manera en que se puede determinar el impacto de
{{site.data.keyword.datashield_short}}.
