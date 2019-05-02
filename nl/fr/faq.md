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

# Foire aux questions
{: #faq}

Cette foire aux questions fournit des réponses aux questions courantes sur le service {{site.data.keyword.datashield_full}}.
{: shortdesc}


## Qu'est-ce que l'attestation d'enclave ? Quand et pourquoi est-elle nécessaire ?
{: #enclave-attestation}
{: faq}

Les enclaves sont instanciées sur les plates-formes par un code non fiable. Ainsi, avant de fournir aux enclaves des informations confidentielles sur les applications, il est essentiel de pouvoir confirmer que l'enclave a été correctement instanciée sur une plate-forme protégée par Intel® SGX. Cela se fait par un processus d'attestation à distance. L'attestation à distance consiste à utiliser les instructions Intel SGX et le logiciel de la plate-forme pour générer une "soumission". La soumission combine le résumé de l'enclave avec un résumé des données pertinentes de l'enclave et une clé asymétrique unique à la plate-forme dans une structure de données qui est envoyée à un serveur distant via un canal authentifié. Si le serveur distant conclut que l'enclave a été instanciée comme prévu et fonctionne sur un processeur Intel SGX authentique, il fournira l'enclave comme demandé.


##	Quels langages sont actuellement pris en charge dans {{site.data.keyword.datashield_short}} ?
{: #language-support}
{: faq}

Le service étend la prise en charge de langage de SGX de C et C+++ à Python et Java. Il fournit également des applications SGX préconverties pour MariaDB, NGINX et Vault, avec peu ou pas de changement de code.


##	Comment savoir si Intel SGX est activé sur mon noeud worker ?
{: #sgx-enabled}
{: faq}

{{site.data.keyword.datashield_short}} vérifie la disponibilité de SGX sur le noeud worker pendant le processus d'installation. Si l'installation réussit, les détails du noeud ainsi que le rapport d'attestation SGX peuvent être consultés sur l'interface utilisateur d'Enclave Manager.


##	Comment savoir si mon application fonctionne dans une enclave SGX ?
{: #running-app}
{: faq}

[Connectez-vous](/docs/services/data-shield?topic=data-shield-access#access-iam) à votre compte Enclave Manager et naviguez jusqu'à l'onglet **Applications**. Sur l'onglet **Applications**, vous pouvez voir des informations sur l'attestation Intel SGX de vos applications sous forme de certificat. L'enclave des applications peut être vérifiée à tout moment en utilisant le service IAS (Intel Remote Attestation Service) pour vérifier que l'application fonctionne dans une enclave vérifiée.



## Quel impact a l'exécution de l'application sur {{site.data.keyword.datashield_short}} sur les performances ?
{: #impact}
{: faq}


La performance de votre application dépend de la nature de votre charge de travail. Si vous avez une charge de travail qui sollicite beaucoup l'unité centrale, l'effet que {{site.data.data.keyword.datashield_short}} a sur votre application est minimal. Mais si vos applications consomment beaucoup de mémoire ou d'E/S, vous pourriez remarquer un impact dû à la pagination et au changement de contexte. La taille de l'empreinte mémoire de votre application par rapport au cache de page de l'enclave SGX permet généralement de déterminer l'impact de {{site.data.keyword.datashield_short}}.
