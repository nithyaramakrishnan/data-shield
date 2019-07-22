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

# アクセス権限の割り当て
{: #access}

{{site.data.keyword.datashield_full}} Enclave Manager へのアクセスを制御することができます。 このタイプのアクセス制御は、{{site.data.keyword.cloud_notm}} で作業する際に使用する典型的な Identity and Access Management (IAM) の役割とは別のものです。
{: shortdesc}


## クラスター・アクセス権限の割り当て
{: #access-cluster}

Enclave Manager にサインインするには、その前に Enclave Manager が稼働しているクラスターへのアクセス権限がなければなりません。
{: shortdesc}

1. サインインするクラスターをホストしているアカウントにサインインします。

2. **「管理」>「アクセス (IAM)」>「ユーザー」**に移動します。

3. **「ユーザーの招待」**をクリックします。

4. 追加するユーザーの E メール・アドレスを入力します。

5. **「アクセス権限の割り当て」**ドロップダウンから**「リソース」**を選択します。

6. **「サービス」**ドロップダウンから**「Kubernetes サービス (Kubernetes Service)」**を選択します。

7. **「地域」**、**「クラスター」**、**「名前空間」**を選択します。

8. [クラスター・アクセス権限の割り当て](/docs/containers?topic=containers-users)にある Kubernetes Service の資料をガイドとして使用して、ユーザーがタスクを実行するのに必要なアクセス権限を割り当てます。

9. **「保存」**をクリックします。

## Enclave Manager ユーザーの役割の設定
{: #enclave-roles}

{{site.data.keyword.datashield_short}} は Enclave Manager で管理されます。 管理者は、自動的に*管理者* 役割が割り当てられますが、他のユーザーに役割を割り当てることもできます。
{: shortdesc}

以下の表は、サポート対象の役割と、各ユーザーが実行できるアクションの例を示しています。

<table>
  <tr>
    <th>役割</th>
    <th>アクション</th>
    <th>例</th>
  </tr>
  <tr>
    <td>リーダー</td>
    <td>ノード、ビルド、ユーザー情報、アプリ、タスク、および監査ログの表示など、読み取り専用のアクションを実行できます。</td>
    <td>ノード認証の証明書のダウンロード。</td>
  </tr>
  <tr>
    <td>ライター</td>
    <td>リーダーが実行できるアクションに加え、ノード認証の非アクティブ化と更新、ビルドの追加、アクションとタスクの承認と拒否などのアクションを実行できます。</td>
    <td>アプリケーションの認証。</td>
  </tr>
  <tr>
    <td>管理者</td>
    <td>ライターが実行できるアクションに加え、ユーザー名と役割の更新、クラスターへのユーザーの追加、クラスター設定の更新などの特権アクションを実行できます。</td>
    <td>ユーザー役割の更新。</td>
  </tr>
</table>


### ユーザーの追加
{: #set-roles}

Enclave Manager GUI を使用して、情報に対する新しいユーザーのアクセス権限を付与できます。
{: shortdesc}

1. Enclave Manager にサインインします。

2. **「(自分の名前)」>「設定」**をクリックします。

3. **「ユーザーの追加」**をクリックします。

4. ユーザーの E メールと名前を入力します。**「役割」**ドロップダウンから役割を選択します。

5. **「保存」**をクリックします。



### ユーザーの更新
{: #update-roles}

ユーザーに割り当てられている役割とユーザー名を更新できます。
{: shortdesc}

1. [Enclave Manager UI](/docs/services/data-shield?topic=data-shield-enclave-manager#em-signin) にサインインします。

2. **「(自分の名前)」>「設定」**をクリックします。

3. 権限を編集するユーザーをマウスオーバーします。鉛筆アイコンが表示されます。

4. 鉛筆アイコンをクリックします。ユーザーの編集画面が開きます。

5. **「役割」**ドロップダウンから、割り当てる役割を選択します。

6. ユーザーの名前を更新します。

7. **「保存」**をクリックします。ユーザー許可に加えた変更は、すぐに反映されます。


