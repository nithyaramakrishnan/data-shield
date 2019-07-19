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

# A propos du service
{: #about}

Avec {{site.data.keyword.datashield_full}}, Fortanix® et Intel® SGX, vous pouvez protéger les données des charges de travail de votre conteneur qui s'exécutent sur {{site.data.keyword.cloud_notm}} lorsque que vos données sont en cours d'utilisation.
{: shortdesc}

Lorsqu'il s'agit de protéger vos données, le chiffrement est l'un des contrôles les plus populaires et les plus efficaces. Néanmoins, les données doivent être chiffrées à chaque étape de leur cycle de vie pour que vos données soient réellement sécurisées. Le cycle de vie des données comporte trois phases. Elles peuvent être au repos, en transit ou en cours d'utilisation. Les données au repos et en transit constituent généralement la zone d'intérêt en termes de sécurisation de vos données. Toutefois, après le démarrage d'une application, les données utilisées par l'unité centrale et la mémoire sont vulnérables à diverses attaques. Ces attaques peuvent inclure, notamment, les initiés malveillants, les superutilisateurs, les données d'identification compromises, les attaques OS zero-day, les intrusions de réseau, et autres. Pour aller plus loin dans cette protection, vous pouvez désormais chiffrer les données en cours d'utilisation. 

Avec {{site.data.keyword.datashield_short}}, votre code d'application et vos données s'exécutent dans des enclaves renforcées de l'UC. Les enclaves sont des zones de mémoire sécurisées, sur le noeud worker, qui protègent les aspects critiques de vos applications. Les enclaves aident à garder le code et les données confidentiels et à prévenir toute modification. Si vous ou votre entreprise avez besoin de données sensibles pour des raisons liées à des politiques internes, des réglementations gouvernementales ou des exigences de conformité de l'industrie, cette solution peut vous aider à migrer vers le cloud. On peut citer à titre d'exemple les établissements financiers et de soins de santé ou les pays dont les politiques gouvernementales exigent des solutions de cloud sur site.


## Intégrations
{: #integrations}

Pour offrir un maximum de transparence, {{site.data.keyword.datashield_short}} est intégré à d'autres services {{site.data.keyword.cloud_notm}}, à Fortanix® et à Intel® SGX. 

<dl>
  <dt>Fortanix®</dt>
    <dd>Avec [Fortanix Runtime Encryption](https://fortanix.com/){: external}, vous pouvez protéger vos applications et données les plus précieuses, même lorsque l'infrastructure est compromise. Construit sur Intel SGX, Fortanix offre une nouvelle catégorie de sécurité des données appelée Runtime Encryption. De la même manière que le chiffrement fonctionne pour les données au repos et les données en mouvement, le chiffrement d'exécution protège les clés, les données et les applications des menaces externes et internes. Les menaces peuvent inclure des initiés malveillants, des fournisseurs de cloud, des pirates au niveau du système d'exploitation ou des intrus du réseau.</dd>
  <dt>Intel® SGX</dt>
    <dd>[Intel SGX](https://software.intel.com/en-us/sgx){: external} est une extension de l'architecture x86 qui permet d'exécuter des applications dans une enclave sécurisée entièrement isolée. L'application n'est pas seulement isolée des autres applications qui s'exécutent sur le même système, mais aussi du système d'exploitation et éventuellement de l'hyperviseur. L'isolement empêche également les administrateurs d'altérer l'application après son démarrage. La mémoire des enclaves sécurisées est également chiffrée pour contrecarrer les attaques physiques. La technologie prend également en charge le stockage sécurisé des données persistantes de sorte qu'elles peuvent être lues uniquement par l'enclave sécurisée.</dd>
  <dt>{{site.data.keyword.containerlong_notm}}</dt>
    <dd>[{{site.data.keyword.containerlong_notm}}](/docs/containers?topic=containers-getting-started) propose des outils puissants en combinant les conteneurs Docker, la technologie de Kubernetes, une expérience utilisateur intuitive, ainsi qu'une sécurité et un isolement intégrés afin d'automatiser la gestion d'applications conteneurisées.</dd>
  <dt>{{site.data.keyword.cloud_notm}} Identity and Access Management (IAM)</dt>
    <dd>[IAM](/docs/iam?topic=iam-getstarted) vous permet d'authentifier les utilisateurs des services de manière sûre et de contrôler l'accès aux ressources d'une façon cohérente dans {{site.data.keyword.cloud_notm}}. Lorsqu'un utilisateur tente d'effectuer une action spécifique, le système de contrôle utilise les attributs définis dans la règle pour déterminer si l'utilisateur est autorisé à effectuer cette tâche. Les clés d'API {{site.data.keyword.cloud_notm}} sont disponibles via Tivoli Information Archive Manager pour vous permettre de vous authentifier via l'interface CLI ou dans le cadre de l'automatisation de la connexion en tant qu'identité de l'utilisateur.</dd>
  <dt>{{site.data.keyword.la_full_notm}}</dt>
    <dd>Vous pouvez étendre vos fonctions de collecte, de conservation et de recherche de journaux en créant une [configuration de journalisation](/docs/containers?topic=containers-health) via le service {{site.data.keyword.containerlong_notm}} qui transmet vos journaux à [{{site.data.keyword.la_full_notm}}](/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started).
    Ce service vous permet également de tirer parti des connaissances centralisées, du chiffrement de journal et de la conservation des données de journal, ce, aussi longtemps que vous en avez besoin.</dd>
</dl>
