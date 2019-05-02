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

# A propos du service
{: #about}

Avec {{site.data.keyword.datashield_full}}, Fortanix® et Intel® SGX, vous pouvez protéger les données des charges de travail de votre conteneur qui s'exécutent sur {{site.data.keyword.cloud_notm}} lorsque que vos données sont en cours d'utilisation.
{: shortdesc}

Lorsqu'il s'agit de protéger vos données, le chiffrement est l'un des contrôles les plus populaires et les plus efficaces. Mais les données doivent être chiffrées à chaque étape de leur cycle de vie pour que vos données soient réellement sécurisées. Les données passent par trois phases au cours de leur cycle de vie : les données au repos, les données en mouvement et les données en cours d'utilisation. Les données au repos et en mouvement sont habituellement utilisées pour protéger les données lorsqu'elles sont stockées et transportées. Après le démarrage d'une application, les données utilisées par l'unité centrale et la mémoire sont vulnérables à différents types d'attaques, y compris les attaques d'initiés malveillants, de superutilisateurs, de données d'identification compromises, les attaques OS zero-day et les intrusions de réseau. Pour aller plus loin dans cette protection, vous pouvez désormais chiffrer les données en cours d'utilisation. 

Avec {{site.data.data.keyword.datashield.datashield_short}}, votre code d'application et vos données s'exécutent dans des enclaves durcies par l'unité centrale, qui sont des zones de mémoire fiables sur le noeud worker qui protègent les aspects critiques de l'application. Les enclaves aident à garder le code et les données confidentiels et intacts. Si vous ou votre entreprise avez besoin de données sensibles pour des raisons liées à des politiques internes, des réglementations gouvernementales ou des exigences de conformité de l'industrie, cette solution peut vous aider à migrer vers le cloud. On peut citer à titre d'exemple les établissements financiers et de soins de santé ou les pays dont les politiques gouvernementales exigent des solutions de cloud sur site.


## Intégrations
{: #integrations}

Pour offrir un maximum de transparence, {{site.data.data.datashield.datashield_short}} est intégré à d'autres services {{site.data.keyword.cloud_notm_notm}}, à Fortanix® Runtime Encryption et à Intel SGX®.

<dl>
  <dt>Fortanix®</dt>
    <dd>Avec [Fortanix](http://fortanix.com/) vous pouvez protéger vos applications et données les plus précieuses, même lorsque l'infrastructure est compromise. Construit sur Intel SGX, Fortanix offre une nouvelle catégorie de sécurité des données appelée Runtime Encryption. De la même manière que le chiffrement fonctionne pour les données au repos et les données en mouvement, le chiffrement d'exécution protège les clés, les données et les applications des menaces externes et internes. Les menaces peuvent inclure des initiés malveillants, des fournisseurs de cloud, des pirates au niveau du système d'exploitation ou des intrus du réseau.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx) est une extension de l'architecture x86 qui vous permet d'exécuter des applications dans une enclave sécurisée complètement isolée. L'application n'est pas seulement isolée des autres applications fonctionnant sur le même système, mais aussi du système d'exploitation et éventuellement de l'hyperviseur. Cela empêche les administrateurs d'altérer l'application après son démarrage. La mémoire des enclaves sécurisées est également chiffrée pour contrecarrer les attaques physiques. La technologie prend également en charge le stockage sécurisé des données persistantes de sorte qu'elles ne peuvent être lues que par l'enclave sécurisée.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started#getting-started) propose des outils puissants en combinant les conteneurs Docker, la technologie de Kubernetes, une expérience utilisateur intuitive, ainsi qu'une sécurité et un isolement intégrés pour automatiser le déploiement, l'exploitation, la mise à l'échelle et la surveillance d'applications conteneurisées dans un cluster d'hôtes de calcul.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted#getstarted) vous permet d'authentifier les utilisateurs des services de manière sûre et de contrôler l'accès aux ressources d'une façon cohérente dans {{site.data.keyword.cloud_notm}}. Lorsqu'un utilisateur tente d'effectuer une action spécifique, le système de contrôle utilise les attributs définis dans la règle pour déterminer si l'utilisateur est autorisé à effectuer cette tâche. Les clés d'API {{site.data.keyword.cloud_notm}} sont disponibles à travers la gestion des accès et des identités (IAM) du cloud pour vous permettre de vous authentifier à l'aide de l'interface CLI ou, dans le cadre de l'automatisation, pour vous connecter avec votre identité d'utilisateur.</dd>
  <dt>{{site.data.keyword.loganalysislong}}</dt>
    <dd>Vous pouvez créer une [configuration de journalisation](/docs/containers?topic=containers-health#health) via le service {{site.data.keyword.containerlong_notm}} qui transfère vos journaux à [{{site.data.keyword.loganalysislong}}](/docs/services/CloudLogAnalysis?topic=cloudloganalysis-getting-started-with-cla#getting-started-with-cla). Vous pouvez étendre vos fonctions de collecte, de conservation et de recherche de journaux dans {{site.data.keyword.cloud_notm}}. Donnez à votre équipe DevOps des informations telles que l'agrégation des journaux d'application et d'environnement afin de faciliter la compréhension des applications ou de l'environnement, le chiffrement des journaux, la rétention des données de journaux durant toute la période requise et pour permettre une rapide détection et résolution des problèmes.</dd>
</dl>
