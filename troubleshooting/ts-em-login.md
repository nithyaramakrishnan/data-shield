---
copyright:
  years: 2018, 2021
lastupdated: "2021-05-21"

keywords: enclave manager, container, convert, private registry, credentials, permissions, error, docker, support, cert manager, tokens, sgx, authentication, intel, fortanix, runtime encryption, memory protection, data in use,

subcollection: data-shield

content-type: troubleshoot
---

{:codeblock: .codeblock}
{:screen: .screen}
{:download: .download}
{:external: target="_blank" .external}
{:faq: data-hd-content-type='faq'}
{:gif: data-image-type='gif'}
{:important: .important}
{:note: .note}
{:pre: .pre}
{:tip: .tip}
{:preview: .preview}
{:deprecated: .deprecated}
{:beta: .beta}
{:term: .term}
{:shortdesc: .shortdesc}
{:script: data-hd-video='script'}
{:support: data-reuse='support'}
{:table: .aria-labeledby="caption"}
{:troubleshoot: data-hd-content-type='troubleshoot'}
{:help: data-hd-content-type='help'}
{:tsCauses: .tsCauses}
{:tsResolve: .tsResolve}
{:tsSymptoms: .tsSymptoms}
{:java: .ph data-hd-programlang='java'}
{:javascript: .ph data-hd-programlang='javascript'}
{:swift: .ph data-hd-programlang='swift'}
{:curl: .ph data-hd-programlang='curl'}
{:video: .video}
{:step: data-tutorial-type='step'}
{:tutorial: data-hd-content-type='tutorial'}


# Why can't I log in to the Enclave Manager UI?
{: #ts-log-in}
{: troubleshoot}

You encounter issues when you try to log in to the Enclave Manager UI.
{:shortdesc}

You attempt to access the Enclave Manager UI and you're unable to sign in.
{: tsSymptoms}

Sign-in might fail for the following reasons:

* You might be using an email ID that is not authorized to access the Enclave Manager cluster.
* The token that you're using might be expired.
{: tsCauses}

To resolve the issue, verify that you are using the correct email ID. If yes, verify that the email has the correct permissions to access the Enclave Manager. If you have the correct permissions, your access token might be expired. Tokens are valid for 60 minutes at a time. To obtain a new token, run `ibmcloud iam oauth-tokens`. If you have multiple {{site.data.keyword.cloud_notm}} accounts, verify that the account you are logged in to the CLI with the correct account for the Enclave Manager cluster.
{: tsResolve}
