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

# 指派存取權
{: #access}

您可以控制 {{site.data.keyword.datashield_full}} Enclave Manager 的存取權。此存取控制類型與您用於 {{site.data.keyword.cloud_notm}} 的典型 Identity and Access Management (IAM) 角色是分開的。
{: shortdesc}


## 指派叢集存取權
{: #access-cluster}

登入到 Enclave Manager 之前，您必須存取執行 Enclave Manager 的叢集。
{: shortdesc}

1. 登入到管理您想要登入的叢集的帳戶。

2. 移至**管理 > 存取權 (IAM) > 使用者**。

3. 按一下**邀請使用者**。

4. 提供您想要新增的使用者的電子郵件位址。

5. 從**指派下列項目的存取權**下拉清單中，選取**資源**。

6. 從**服務**下拉清單中，選取 **Kubernetes Service**。

7. 選取**地區**、**叢集**和**名稱空間**。

8. 使用有關[指派叢集存取權](/docs/containers?topic=containers-users)的 Kubernetes Service 文件作為手冊，指派使用者完成作業時需要的存取權。

9. 按一下**儲存**。

## 設定「區域管理程式」使用者的角色
{: #enclave-roles}

{{site.data.keyword.datashield_short}} 管理在「區域管理程式」中進行。您作為管理者，*管理員* 角色會自動指派給您，但您也可以將角色指派給其他使用者。
{: shortdesc}

參閱下列表格，以查看哪些是支援的角色，以及每個使用者可以採取的部分範例動作：

<table>
  <tr>
    <th>角色</th>
    <th>動作</th>
    <th>範例</th>
  </tr>
  <tr>
    <td>讀者</td>
    <td>可以執行唯讀動作，例如檢視節點、建置、使用者資訊、應用程式、作業及審核日誌。</td>
    <td>下載節點認證憑證。</td>
  </tr>
  <tr>
    <td>撰寫者</td>
    <td>可以執行「讀者」可以執行的動作以及其他動作，包括停用及更新節點認證、新增建置，以及核准或拒絕任何動作或作業。</td>
    <td>認證應用程式</td>
  </tr>
  <tr>
    <td>管理員</td>
    <td>可以執行「撰寫者」可以執行的動作以及其他動作，包括更新使用者名稱和角色、將使用者新增至叢集、更新叢集設定，以及任何其他特許動作。</td>
    <td>更新使用者角色</td>
  </tr>
</table>


### 新增使用者
{: #set-roles}

藉由使用 Enclave Manager GUI，您可以為新使用者提供對資訊的存取權。
{: shortdesc}

1. 登入 Enclave Manager。

2. 按一下**您的名稱 > 設定**。

3. 按一下**新增使用者**。

4. 輸入使用者的電子郵件和姓名。從**角色**下拉清單中選取角色。

5. 按一下**儲存**。



### 更新使用者
{: #update-roles}

您可以更新指派給使用者的角色及其姓名。
{: shortdesc}

1. 登入至 [Enclave Manager 使用者介面](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin)。

2. 按一下**您的名稱 > 設定**。

3. 將鼠標懸停在您想要編輯其許可權的使用者上。此時將顯示「鉛筆」圖示。

4. 按一下「鉛筆」圖示。此時將開啟「編輯使用者」畫面。

5. 從**角色**下拉清單中，選取您想要指派的角色。

6. 更新使用者的姓名。

7. 按一下**儲存**。對使用者許可權所做的任何變更都會立即生效。


