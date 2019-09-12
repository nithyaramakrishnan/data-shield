---

copyright:
  years: 2018, 2019
lastupdated: "2019-09-12"

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

# Application's Performance in an Enclave Environment
{: #em-performance}

The {{site.data.keyword.datashield_full}} environment is designed with the goal of protecting any application. Performance of a code executing in an Intel® SGX enclave is similar to performance of the same code executed outside of enclave context. However, there are some overheads associated with enclave execution. Different applications can be more or less sensitive to these overheads and can be more or less performant in the enclave environment. This document attempts to explain some of the factors affecting enclave performance, and to set some performance expectations for applications run in the IBM Cloud Data Shield environment. This information may be useful in planning a migration or in the design of new services.
{: shortdesc}

## Considerations
{: #em-considerations}

### Enclave Memory and Paging
{: #em-memoryandpaging}

Most SGX-capable processors available today have 128 MB of enclave page cache (“EPC”). The EPC holds pages that are actively available for use by an enclave. In a 128 MB EPC, 93.5 MB of memory is available for applications. The remainder of EPC holds integrity metadata. Enclaves can access larger amounts of memory through a demand-paging mechanism, but there is a performance penalty associated with paging. Applications will perform best in the IBM Cloud Data Shield environment if their working set is smaller than 90 MB. This memory limitation is a property of SGX. If more memory is available to SGX enclaves in the future, IBM Cloud Data Shield will be able to use the additional memory.
{: shortdesc}

### Enclave Entry/Exit Overhead
{: #em-entryexit}

Entering or exiting an SGX enclave incurs a substantial time delay. Additionally, an entry/exit flushes certain CPU caches, which can have a performance impact due to subsequent cache misses. An enclave exit and re-entry can occur for the following reasons:
  * To allow the enclave to interact with external resources (for example, sending data from the enclave over the network)
  * To switch to a different thread of execution in the enclave application
  * To service CPU interrupts

The IBM Cloud Data Shield environment employs various strategies to reduce the number of enclave exit/entry events, and additional optimizations will be implemented over time. However, the general issue of I/O overhead across the security boundary will remain.
{: shortdesc}

## Guidance
{: #em-guidance}

The best-performing applications for the enclave environment will exhibit modest memory working set size and infrequent I/O operations relative to the amount of computation performed. In some situations, performance may be less important than security characteristics, and in these cases,  it is also advisable to consider running the application in the IBM Cloud Data Shield environment.
Since every application is different, the best way to evaluate the performance of an application in the IBM Cloud Data Shield environment is through empirical measurement. However, answering the following questions may help to evaluate whether an application is a good candidate:
  * What request rate (queries per second) is expected for the application? If the request rate is on the order of 1000 QPS or less, the application may be a good fit. If the request rate is 10k QPS or more, that suggests the application may be I/O limited in IBM Cloud Data Shield.
  * What kind of processing does the application do for each request? Applications that perform relatively simple data processing tasks (for example, a compatibility service that rewrites requests from a stable external API format to an unstable backend API format) are unlikely to do enough computation to offset the cost of transferring data in or out of the enclave.
  * What kind of internal data structures does the application use in handling the request? Applications that are already dominated by a relatively long latency (for example, a database where the request pattern is expected to go to disk most of the time) may be a good fit. Conversely, applications that make random accesses to an in-memory data structure that does not fit in EPC (for example, an in-memory key-value store) will exhibit degraded performance in the IBM Cloud Data Shield environment.
{: shortdesc}

## Sample Applications
{: #em-sampleapps}

### Timestamp Server (Python)
{: #em-timestampserver}

This application is a custom RFC3161-compliant (mostly) timestamp server written in Python, using the Flask, ctypescrypto, and rfc3161ng packages.
{: shortdesc}

<table>
  <caption>Table 1. Timestamp Server</caption>
  <tr>
    <th>Native Performance/th>
    <th>Enclave Performance</th>
    <th>Ratio Enclave: Native</th>
  </tr>
  <tr>
    <td>106 QPS</td>
    <td>74 QPS</td>
    <td>0.70</td>
  </tr>
  </table>

### AcmeAir Airline Booking (Java)
{: #em-acmeairbooking}

This is a sample Java web application, available at https://github.com/blueperf/acmeair-monolithic-java. The application uses a MongoDB database. For this benchmark, the MongoDB database was not running in an enclave.
{: shortdesc}

<table>
  <caption>Table 2. AcmeAir Airline Booking (Java)</caption>
  <tr>
    <th>Native Performance/th>
    <th>Enclave Performance</th>
    <th>Ratio Enclave: Native</th>
  </tr>
  <tr>
    <td>89 QPS</td>
    <td>70 QPS</td>
    <td>0.79</td>
  </tr>
</table>

### CSV Processor (C)
{: #em-csvprocessor}

This application reads a CSV file, parses it, and performs asymmetric encryption/decryption of data in the CSV file.
{: shortdesc}

<table>
  <caption>Table 3. CSV Processor (C)</caption>
  <tr>
    <th>Native Performance/th>
    <th>Enclave Performance</th>
    <th>Ratio Enclave: Native</th>
  </tr>
  <tr>
    <td>3.33236 s</td>
    <td>3.424258</td>
    <td>0.97</td>
  </tr>
</table>
