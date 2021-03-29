---
copyright:
  years: 2018, 2021
lastupdated: "2021-03-29"

keywords: release notes, data shield version, data shield updates, new in data shield, what's new

subcollection: data-shield
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




# Release notes
{: #release-notes}

The following features and changes to the {{site.data.keyword.datashield_full}} service are now available.


## Current version: 1.26.1148
{: #v1.26.1148}

**Released: 15 March 2021**

- Enclave Manager:
  - Added support to prevent creation of duplicate builds - multiple builds for the same `mrenclave` value.
  - Upgraded Golang to version `1.16` to fix `CVE-2021-3114/CVE-2021-3115`.
  - Updated Docker to version `20.10.3` to fix `CVE-2021-21284/CVE-2021-21285/CVE-2020-27534`.

- EnclaveOS
  - Updated `glibc` to version `2.33`.
  - Implemented several additional nodes in the `/sys filesystem`.
  - Fixed an issue with incorrect return value from `access() system` call for some files.
  - Fixed `lseek()` on directories.
  - Implemented `timer_create`, `timer_settime`, `timer_gettime`, `timer_getoverrun`, `timer_delete`.
  - Fixed problems that can happen when applications terminate with certain signals.

## 2021 updates
{: #2021-updates}

The following features and changes to the {{site.data.keyword.datashield_short}} service are available as of 2021.

### Version 1.25.1090
{: #v1.25.1090}

#### Released: 22 January 2021
{: #2020-01-22}

- Enclave Manager:

  - Added support to enable and disable application heartbeats and configure heartbeat interval to resolve performance issues.
  - Added support for installation on version 1.18 Kubernetes Service clusters.

    If you are installing {{site.data.keyword.datashield_short}} on a cluster that was created after 1 December 2020, append the following tag to your installation command: `--set global.UsingCustomIBMIngressImage=false`. For more information, see [Installing {{site.data.keyword.datashield_short}}](/docs/data-shield?topic=data-shield-getting-started#gs-install).
    {: note}

  - Fixed the vulnerability CVE-2020-28362/66/67 by upgrading Go to 1.15.5.
  - Fixed the vulnerability CVE-2020-8277 by upgrading Node.js to 14.15.1.

- EnclaveOS:

  - Fixed defects.

## 2020 updates
{: #2020-updates}

The following features and changes to the {{site.data.keyword.datashield_short}} service are available as of 2020.

### Version 1.24.1010
{: #v1.24.1010}

#### Released: 19 November 2020
{: #2020-11-19}

- EnclaveOS: 
  - Fixed a performance issue by disabling application heartbeats.


### Version 1.23.965
{: #v1.23.965}

#### Released: 30 October 2020
{: #2020-10-30}

- Enclave Manager:

  - Added Ubuntu 18.04 support for {{site.data.keyword.datashield_short}}. For more information about upgrading from Ubuntu 16.04 to Ubuntu 18.04, see [Updating {{site.data.keyword.datashield_short}} for Ubuntu 18.04](/docs/data-shield?topic=data-shield-update#upgrade-ubuntu-18.04).
  - Added support for editing `ISVPRODID` for an application.
  - Fixed the vulnerability CVE-2020-8201/8251/8252 by updating Node.js to 14.13.1.
  - Fixed the vulnerability CVE-2020-26160 for `jwt-go`.
  - Fixed an issue with editing automatically created applications.
  - Fixed a `CockroachDB` cleanup issue that was causing uninstall to fail.

- EnclaveOS:

  - Fixed an issue causing Java applications to hang when run with an enclave larger than 4 GB.
  - Fixed an issue to effectively reduce index node number collisions, causing various issues with files.


### Version 1.22.925
{: #v1.22.925}

#### Released: 24 September 2020
{: #2020-09-24}

- Enclave Manager:

  - Deleted `Undefined` from the pop-up that is seen when deleting builds.
  - Fixed CVE-2020-24553 by upgrading to Golang version `1.15.2`.
  - Updated to use `cloud.ibm.com` URLs.

- EnclaveOS:

  - Fixed defects.


### Version 1.21.889
{: #v1.21.889}

#### Released: 30 August 2020
{: #2020-08-30}

- Enclave Manager:

  - Removed `You can provide a different tag number for the new builds.` from the create new builds page.
  - Trimmed white-space in input fields in the container conversion tool.
  - Fixed text bug that occurred when deleting builds.
  - Removed public JavaScript source maps.
  - Fixed the vulnerabilities CVE-2020-14039, CVE-2020-15586 and CVE-2020-16845 by updating Go to version 1.14.7.
  - Fixed the vulnerability CVE-2019-20907 by updating Python.
  - Fixed the vulnerability CVE-2020-15709 by updating Ubuntu software-properties package.

- EnclaveOS:

  - Fixed defects.


### Version 1.20.858
{: #v1.20.858}

#### Released: 07 August 2020
{: #2020-08-07}

- Enclave Manager:

  - Added support for installation on version 1.16 Kubernetes Service clusters.

    If you have {{site.data.keyword.datashield_short}} running in a Kubernetes cluster that is version 1.15 and you attempt to upgrade your cluster to version 1.16, this upgrade is not supported. First, update your cluster version and then install {{site.data.keyword.datashield_short}}.
    {: note}

  - Fixed vulnerabilities CVE-2020-8172, CVE-2020-8174, and CVE-2020-11080 by updating Node.js to version 14.6

- EnclaveOS:

  - Added support for the container converter in air-tight or fire-walled environments
  - Fixed vulnerability CVE-2020-1752 by updating the `glibc` to version 2.31.


### Version 1.19.794
{: #v1.19.794}

#### Released: 22 June 2020
{: #2020-06-22}

- Enclave Manager:

  - Updated the image path to be configurable. Set `global.Images.Kubectl`, `global.Images.Docker`, `global.Images.Ubuntu`, `global.Images.Busybox` when installing to pull `kubectl`, Docker, Ubuntu, and BusyBox images from a private Docker registry. By default, they're pulled from a public repository.
  - Fixed multiple pods of same StatefulSets being scheduled on the same node.
  - Enforced TLS 1.2 across the board.
  - Made the username field non-editable in the UI.
  - Removed 1024 but RSA Encryption key size option from certificate config of an app.

- EnclaveOS:

  - Set all reserved and undesired bits in `SGX ATTRIBUTEMASK` to 1 to avoid running enclaves with unexpected features enabled.
  - Updated the way that FPU and Vector register state is now saved and restored when signals are delivered and returned.
  - Updated the version of `glibc` to 2.28 to permit the conversion of containers based on Debian 10.
  - The in-enclave `glibc` now uses the Linux `clone()` system call.


### Version 1.18.731
{: #v1.18.731}

#### Released: 27 April 2020
{: #2020-04-27}

- Enclave Manager:

  - Added information to the UI for certification and chain path requirements.
  - Added the ability to delete non-admin users.
  - Replaced `sgx_perm_daemon` with a device plug-in pod which mounts `gsgx`, `isgx`, and `aesmd` on requesting containers.

If the manager pods fail to come up after upgrading, delete them one-by-one to fix the issue.
{: note}


### Version 1.17.694
{: #v1.17.694}

#### Released: 6 April 2020
{: #2020-04-06}

- Enclave Manager:

  - Remove the experimental encrypted directories feature from the Enclave Manager UI. The feature is still available for use through the API.
  - Added support for Helm 3.
  - Updated SGX PSW to version 2.9.100.2.

- EnclaveOS:

  - Addressed `Glibc` Vulnerability CVE-2020-10029.

### Version 1.16.654
{: #v1.16.654}

#### Released: 20 March 2020
{: #2020-03-20}

- Enclave Manager:

  - Moved the CA Certificate configuration into the Advanced Settings section in the Application template.

- EnclaveOS:

  - Fixed a resource leak that had the potential to prevent applications with multiple forks from running.


### Version 1.15.625
{: #v1.15.625}

#### Released: 02 March 2020
{: #2020-03-02}

- Enclave Manager:

  - Upgraded Node.js to version 13.x.
  - Changed the Edit App form to make the App Name field read-only in the UI.

- EnclaveOS:

  - Fixed bugs.

### Version 1.14.596
{: #v1.14.596}

#### Released: 13 February 2020
{: #2020-02-13}

- Enclave Manager:

  - Fix for configuring the enclave size of an application.
  - The UI now reports whether enclaves are running in debug mode. The memory of debug enclaves is not protected from inspection by the host. In production deployments, it is not recommended that enclaves run in debug mode.

- EnclaveOS:

  - Fixed bugs.


### Version 1.12.575
{: #v1.12.575}

#### Released: 06 February 2020
{: #2020-02-06}

- Enclave Manager:

  - Added support to delete builds in the UI.
  - The Enclave Manager replica count now applies to the database, as well as the backend application.
  - Fixed bugs

- EnclaveOS:

  - Fixed bugs.


### Version 1.11.534
{: #v1.11.534}

#### Released: 21 January 2020
{: #2020-01-21}

- Enclave Manager:

  - Updated the authentication token mechanism that handles authentication between the node agent and the Enclave Manager.
  - Upgraded to Intel SGX PSW version 2.7.


## 2019 updates
{: #2019-updates}

The following features and changes to the {{site.data.keyword.datashield_short}} service are available as of 2019.

### Version 1.10.448
{: #v1.10.448}

#### Released: 20 December 2019
{: #2019-12-20}

- Enclave Manager:

  - Heartbeat improvements.

- EnclaveOS:

  - Heartbeat improvements.
  - Each build now by default has `/run` and `/tmp` mounted as encrypted directories if they or any of their children are not marked as read/write or encrypted file system.



### Version 1.9.424
{: #v1.9.424}

#### Released: 06 December 2019
{: #2019-12-06}

- Enclave Manager:

  - Added support for billing labels in Kubernetes and OpenShift.
  - Fixed cockroach Docker image vulnerability.
  - Node enrollment and app certificate issuance now succeeds by default on platforms that are running out-of-date microcode. It is not possible to change this option on existing clusters. You must reinstall the Enclave Manager to take advantage of this feature.

- EnclaveOS:

  - Improved logging errors.


### Version 1.8.396
{: #v1.8.396}

#### Released: 22 November 2019
{: #2019-11-22}

- Enclave Manager:

  - Added billing support with the addition of the node label.



### Version 1.7.373
{: #v1.7.373}

#### Released: 11 November 2019
{: #2019-11-11}

- Enclave Manager:

  - Updated the endpoint names of the Docker images to `icr.io`.
  - Updated the {{site.data.keyword.datashield_short}} uninstaller to work with OpenShift.
  - Fixed an issue when a different `Ias.Mode(IAS_API_KEY, IAS_CREDENTIALS)` is used for deployment.
  - Upgraded cockroach DB to `v2.1.9` to address vulnerability scan results.

- EnclaveOS:

  - The Enclave Manager CA certificate is now installed in the system truststore of converted containers, even if a file system path for the CA certificate is not specified.


### Version 1.6.342
{: #v1.6.342}

#### Released: 25 October 2019
{: #2019-10-25}

- Enclave Manager:

  - Updated Golang with security fixes to version `1.12.10` for `CVE-2019-16276`.

- EnclaveOS:

  - Fixed an issue that occurred when running `glibc-2.28-based` containers in EnclaveOS that resulted in the following message: `/lib/x86_64-linux-gnu/libnss_files.so.2: symbol __libc_readline_unlocked version GLIBC_PRIVATE not defined in file libc.so.6`. It is not recommended to use `glibc 2.28`.
  - Reduced default Java heap sizes to address intermittent failures that occurred when allocating non-heap memory.
  - Fixed CA certificate installation in `python-client` container.
  - Update readme file to mention OpenShift.




### Version 1.5.317
{: #v1.5.317}

#### Released: 12 October 2019
{: #2019-10-12}

- Enclave Manager:

  - Added support for OpenShift.
  - Fixed CA certificates issue.

- EnclaveOS:

  - Added support for OpenShift.


### Version 1.4.282
{: #v1.4.282}

#### Released: 20 September 2019
{: #2019-09-20}

- Enclave Manager:

  - Updated the Enclave Manager conversion UI to include an option to select a file system location where the Enclave Manager CA certificate is made available.
  -Update protocol buffer library for `CVE-2019-15544`.

- EnclaveOS:

  - Conversion now also installs the Enclave Manager's root certificate in the system truststore for supported guest container types when a file system location is specified. Tested with: Debian, Ubuntu, and CentOS-based containers.
  - Update packages installed in container images to address `CVE-2019-12972`.

- General

  - {{site.data.keyword.datashield_short}} now creates a `datashield-admin` service account upon installation.
  - Updated Python with September 2019 security fixes to address several CVEs.


Releases before 1.2 cannot be upgraded to this release.
{: note}



### Version 1.3.270
{: #v1.3.270}

#### Released: 13 September 2019
{: #2019-09-13}

- EnclaveOS:

  - Fix an error converting certain images in `OPENJ9` mode.


Releases before 1.2 cannot be upgraded to this release.
{: note}



### Version 1.3.262
{: #v1.3.262}

#### Released: 06 September 2019
{: #2019-09-06}


- Enclave Manager:

  - Update Golang version to address HTTP/2 DoS attack.

- EnclaveOS:

  - Fix a security vulnerability.
  - For Java containers converted with 'OPENJ9' option, the `-Xmx` value is chosen dynamically based on enclave size.
  - Set the default number of `malloc arenas` to 2, for better performance for most applications.


Releases before 1.2 cannot be upgraded to this release.
{: note}


### Version 1.2.245
{: #v1.2.245}

#### Released: 23 August 2019
{: #2019-08-23}


- Enclave Manager:

  - Added maintainer information to the Helm chart.
  - Updated the Helm chart readme file.
  - Fixed an issue with service startup.

Releases before 1.2 cannot be upgraded to this release.
{: note}


### Version 1.2.238
{: #v1.2.238}

#### Released: 13 August 2019
{: #2019-08-13}


- Enclave Manager:

  - Added support for configuring IAS credentials directly.
  - Fixed bugs and improved stability.
  - Added production signed enclaves.

- EnclaveOS:

  - Added support for running as a non-root user.
  - Turned off environment variable and command-line restrictions for containers.
  - Turned off read-only file systems.
  - Added more performance monitoring.
  - Improved performance.

Releases before 1.2 cannot be upgraded to this release.
{: note}


### Version 1.1.227
{: #v1.1.227}

#### Released: 25 July 2019
{: #2019-07-25}


- Enclave Manager:

  - Added SSL support for communication between the Enclave Manager backend and Cockroach DB.
  - Fixed bugs with software upgrades.


### Version 1.0.212
{: #v1.0.212}

#### Released: 03 July 2019
{: #2019-07-03}

- Enclave Manager:

  - Added more locale support: English, German, French, Korean, Spanish, Italian, Japanese, Brazilian Portuguese, and Chinese (simplified and traditional).
  - Added support for high availability of {{site.data.keyword.datashield_short}} services.
  - Fixed bugs and improved stability.

- EnclaveOS:

  - Broadened support for Java applications.
  - Fixed bugs and improved stability.
  - For security reasons, environment variables set in the host environment at run time are no longer passed to the guest.
  - Added fixes for security vulnerabilities.
  - Added curated application support.


### Version 0.5.181
{: #v0.5.181}

#### Released: 14 May 2019
{: #2019-05-14}

- Installer:

  - Fixed an issue installing on clusters that run IBM Kubernetes Service v1.12+.


### Version 0.5.180
{: #v0.5.180}

#### Released: 13 May 2019
{: #2019-05-13}

- Enclave Manager:

  - Node selection for the Enclave Manager backend server and its database is now constrained by the Kubernetes Node labels `fortanix.com/enclave-manager-backend` and `fortanix.com/enclave-manager-db`. On a new install, the labels are assigned to an arbitrary node. To assign specific nodes, then you can assign the labels manually before you install.

- EnclaveOS

  - EnclaveOS application file systems are now mounted read-only by default to prevent inadvertent disclosure of sensitive data. If your application needs to write data to a file system, consider mounting an encrypted file system by supplying the `Encrypted Directories` option at conversion time.



### Version 0.5.174
{: #v0.5.174}

#### Released: 03 May 2019
{: #2019-05-03}


- User Interface:

  - Changed the default enclave size and thread count.
  - Fixed bugs for build page crash.
  - Improved {{site.data.keyword.datashield_short}} naming.

- Enclave Manager:

  - Changed zone sealing strategy to prepare for HA support.



### Version 0.4.169
{: #v0.4.169}

#### Released: 26 April 2019
{: #2019-04-26}


- User Interface:

  - Edit application to change when 400 error displays.
  - Fixed audit log display.
  - Added a flag to show when configuration is needed.

- Enclave Manager:

  - Updated Docker image packages with security fixes.


### Version 0.4.121
{: #v0.4.121}

#### Released: 29 March 2019
{: #2019-03-29}

- Enclave Manager:

  - Added domain allow-listing support in the Enclave Manager UI.
  - Updated packages in Docker images with security fix released by Ubuntu. The vulnerabilities are not exploitable in the {{site.data.keyword.datashield_short}} environment.
  - Updated the converter to send heartbeats to the Enclave Manager by default.
  - Changed curated Docker images to have the same version as the {{site.data.keyword.datashield_short}} Helm chart and Docker images.



### Version 0.4.88
{: #v0.4.88}

#### Released: 19 March 2019
{: #2019-03-19}

- Enclave Manager:

  - Added IASv3 support.
  - Attested heartbeat from app to manager.



### Version 0.4.74
{: #v0.4.74}

#### Released: 12 February 2019
{: #2019-02-12}

- Enclave Manager:

  - Secured TLS communication.
  - Updated TLS cert secret name.
  - Added UI for EnclaveOS conversion.


### Version 0.4.69
{: #v0.4.69}

#### Released: 23 January 2019
{: #2019-01-23}

- Enclave Manager:

  - Added notes.txt to the Helm chart.
  - Update security for apt.
  - Fixed an error that occasionally prevented login through the web UI.
  - Fixed an error with issuing application certificates.


### Version 0.4.65
{: #v0.4.65}

#### Released: 18 January 2019
{: #2019-01-18}

- Enclave Manager:

  - Fixed the high severity issues that were identified by pen testing.
  - Updated Helm chart to set an uninstall hook that moves the Enclave Manager database image and creates the associated build.
  - Added APIs to the backend to automate the process of converting a container image and creating the associated build.
  - Updated authentication to enforce that the IAM tokens are used to log in are issued under the correct account.

- EnclaveOS:

  - Added support for obtaining the enclave signature from the EnclaveOS_SIGNATURE environment variable.
  - Fixed an out of memory error from bash that appeared with certain applications.
  - Fixed bugs.



### Version 0.4.59
{: #v0.4.59}

#### Released: 10 January 2019
{: #2019-01-10}

- Enclave Manager:

  - Fixed issue with logging in to the web UI.


### Version 0.4.57
{: #v0.4.57}

#### Released: 04 January 2019
{: #2019-01-04}

- General:

  - Update to Intel SGX Platform Software 2.4.



## 2018 updates
{: #2018-updates}

The following features and changes to the {{site.data.keyword.datashield_short}} service are available as of 2018.


### Version 0.4.48
{: #v0.4.48}

#### Released: 13 December 2018
{: #2018-12-13}

- Product release.

