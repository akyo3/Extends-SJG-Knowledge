# MacOSでのVirtualBoxのセットアップ

#### 環境

- MacBook Pro (13-inch, 2019, Two Thunderbolt 3 ports)
- Monterey 12.5

#### ダウンロード/インストール
- Ubuntu Desktop 20.04.4 LTS
- VirtualBox-6.1.36

---

## 1- Ubuntuイメージファイルのダウンロード

1-1. 以下のリンク先からISOイメージファイルをダウンロードします。

  - [Ubuntuを入手する](https://releases.ubuntu.com/20.04.4/?_ga=2.145106481.424434523.1659109603-1752942665.1659109603)
※ ダウンロード完了まで少しかかるのでしばらくお待ちください

| ファイル名 | ubuntu-20.04.4-desktop-amd64.iso |
:---|:---

![UbuntuInstall-1](https://user-images.githubusercontent.com/80967103/181872638-1f240138-2fc6-4158-9963-1d84d95e3c54.png)

---

## 2- VirtualBoxのダウンロード/インストール

2-1. 以下のリンク先からVirtualBoxをインストールします。

  - [VirtualBoxを入手する](https://www.virtualbox.org/wiki/Downloads)


| ファイル名 | VirtualBox-6.1.36-152435-OSX.dmg |
:---|:---

![VirtualBoxInstall-1](https://user-images.githubusercontent.com/80967103/181872823-0ac6192a-2bdb-42cf-830c-8c407b31f609.png)

---

2-2. ダウンロードしたファイルをクリックし、インストールウィザードに従ってインストールします。
完了したら「閉じる」をクリックして終了します。


> macOS BigSur 以降では、インストールしたカーネル拡張をロードできるようにするために再起動が必要です。

![VirtualBoxInstall-2](https://user-images.githubusercontent.com/80967103/158053289-ab1efca1-f989-4025-96e4-d79e56e49b1b.png)

---

## 3- VirtualBoxで仮想マシンを作成
> VirtualBoxのアイコンをクリックし、起動します。

3-1. VirtualBoxが起動したら「新規」をクリックします。

![UbuntuVMCreate-1](https://user-images.githubusercontent.com/80967103/158601180-168b2c80-54fc-4ea7-b7a3-c795822b9cc0.png)

---

3-2. 以下の項目を設定し、「続き」をクリックします。
> ※ 名前はお好みで入力してください。

| 名前 | Air-Gap-Machine |
:---|:---
| マシンフォルダー | デフォルトでOK |
| タイプ | Linux |
| バージョン | Ubuntu（64-bit） |

![UbuntuVMCreate-2](https://user-images.githubusercontent.com/80967103/158602639-d642c913-9c3a-4e76-ad95-7e639f03fd6e.png)

  ---

3-3. 仮想マシンに割当てるメモリサイズは「`4096`MB」とし、「続き」をクリックします。

![UbuntuVMCreate-3](https://user-images.githubusercontent.com/80967103/159216570-ab997522-b8ea-42d6-a47a-86f5729c641d.png)

---

3-4. 「仮想ハードディスクを作成する」にチェックを入れ、「作成」をクリックします。

![UbuntuVMCreate-4](https://user-images.githubusercontent.com/80967103/158603719-0c8488a9-27e0-4d2a-9324-4c37b4d6ded2.png)

---

3-5. 「VDI（VirtualBox Disk Image）」にチェックを入れ、「続き」をクリックします。

![UbuntuVMCreate-5](https://user-images.githubusercontent.com/80967103/158604211-49605724-3e9f-4ed4-b728-974a0a39ffe0.png)

---

3-6. 「固定サイズ」にチェックを入れ、「続き」をクリックします。

![UbuntuVMCreate-6](https://user-images.githubusercontent.com/80967103/158604563-9f0d291d-9596-4d04-a3ac-723d8cdf5504.png)

---

3-7. 仮想HDDファイルは「`50`GB」を入力し、「作成」をクリックします。

![UbuntuVMCreate-7](https://user-images.githubusercontent.com/80967103/158605301-1aed9543-40ae-43ef-9ec0-d58904a689d4.png)

---

## 4- 仮想マシンの仕様設定

> 「OK」をクリックしたら「Oracle VM VirtualBox マネージャー」画面に遷移するので設定毎に「設定」をクリックしてください。

## 一般

4-1. 歯車マークの「設定」をクリックします。

![UbuntuSpecSettings-1](https://user-images.githubusercontent.com/80967103/159109074-94571ed6-ec42-4c64-9fab-14eb8f1c72ba.png)

---

4-2. 「高度」タブから、以下の設定を「双方向」にし、「OK」をクリックします。

![UbuntuSpecSettings-2](https://user-images.githubusercontent.com/80967103/159109569-30d3557b-047f-4bfb-ac49-5ef66d7534c7.png)

---

## システム

4-3. 「マザーボード」タブと「プロセッサー」タブを以下の設定にし、「OK」をクリックします。

| マザーボード |  |
:---|:---
| 起動順序 | 「フロッピー」のチェックマークを外す |
| チップセット | ICH9 |
| ポインティングデバイス | PS/2マウス |

| プロセッサー |  |
:---|:---
| プロセッサー数 | 4 |

![UbuntuSpecSettings-3](https://user-images.githubusercontent.com/80967103/159111094-fbe3b0f6-b6ea-4d30-8c91-d86c1fb28791.png)

---

## ディスプレイ

4-4. 「スクリーン」タブから以下の設定にし、「OK」をクリックします。

| ビデオメモリー | 128MB |
:---|:---
| 表示倍率 | 200% |
| グラフィックスコントローラー | VMSVGA |
| アクセラレーション | 「3Dアクセラレーションを有効化」にチェック |

![UbuntuSpecSettings-4](https://user-images.githubusercontent.com/80967103/159127356-0a509093-8739-479d-ab24-7c711e43a599.png)

---

## ストレージ

> イメージファイルはダウンロードフォルダにあると思いますので、そちらを選択するかお好きなフォルダに移動させてください。

4-5. 「ストレージデバイス」の「空」にUbuntuのイメージを指定し、「OK」をクリックします。

![UbuntuSpecSettings-5](https://user-images.githubusercontent.com/80967103/159216844-a5ceddfe-e04e-4338-be5d-d12d61f66c27.png)

---

## 共有フォルダー

4-6. ホスト側で共有させたいフォルダを事前に作成しておきます。
- 例）「AirGap」フォルダを作成後、配下に「share」フォルダを作成。

`Mac Terminal`
```console
mkdir -p $HOME/AirGap/share
```

---

4-7. 共有フォルダを指定します。

![UbuntuSpecSettings-6](https://user-images.githubusercontent.com/80967103/159114384-1ec0efb2-69a3-4c87-85d4-aa33ae3c550c.png)

---

## 5- 仮想マシンにUbuntuをインストール

5-1. 仮想マシンを起動します。

![BootVirtualMachine-1](https://user-images.githubusercontent.com/80967103/159123352-9d054193-2ba6-4717-ac2a-1978c2d1ffc4.png)

> PCから権限許可を求められたら「セキュリティとプライバシー」にて必要な権限を許可し、VirtualBoxを再起動します。

---

5-2. 読み込み終了後、言語は「日本語」にし、「Install Ubuntu」をクリックします。

![BootVirtualMachine-2](https://user-images.githubusercontent.com/80967103/159124610-ae485412-085c-42e2-94e2-f75b9f556066.png)

---

5-3. キーボード設定では、日本語キーボードの方は、両方とも「Japanese」を選択し、設定が完了したら「続ける」をクリックします。
> USキーボードの方は「キーボードレイアウト」→「キーボードレイアウトの検出」をクリックして設定してください。
※ 画面が見切れていた場合の対処法：Alt＋F7で移動できます)

---

5-4. 「アップデートと他のソフトウェア」の設定では、以下のように設定し、「続ける」をクリックします。

![BootVirtualMachine-3](https://user-images.githubusercontent.com/80967103/159128238-53def4ff-7699-45c0-85e4-c5e1115c87cb.png)

---

5-5. 「インストールの種類」の設定では「ディスクを削除してUbuntuをインストール」を選択し、「インストール」をクリックします。

![BootVirtualMachine-4](https://user-images.githubusercontent.com/80967103/159128589-0b0373ac-a342-45d6-b22c-0f14122a5f3d.png)

---

5-6. 「ディスクに変更を書き込みますか?」の設定では「続ける」をクリックします。

![BootVirtualMachine-5](https://user-images.githubusercontent.com/80967103/159128650-7cbc6a86-5fce-465b-b980-95d3f17f7e3e.png)

---

5-7. タイムゾーンの設定は、「Tokyo」を選択し、「続ける」をクリックします。

![BootVirtualMachine-6](https://user-images.githubusercontent.com/80967103/159128953-10f8e1d9-cd04-401e-905c-3b27cbdf89e6.png)

---

5-8. 必要な情報を入力し、「続ける」をクリックします。
> ※ 画像は一例ですのでお好みで設定してください。

![BootVirtualMachine-7](https://user-images.githubusercontent.com/80967103/159129148-b99c85e4-4747-427a-b4e0-9c1842716682.png)

---

5-9. インストール開始。

![BootVirtualMachine-8](https://user-images.githubusercontent.com/80967103/159129325-84554dfb-4062-4c90-ab26-baa3422c2fd5.png)

---

5-10. インストール完了後、再起動を求められるので「今すぐ再起動する」をクリックし、Enterキーを押下します。

![BootVirtualMachine-9](https://user-images.githubusercontent.com/80967103/159130124-bf8953ae-bde1-4b4e-8d52-e34c026b59cc.png)

---

5-11. 再起動後、ユーザー名をクリックし、パスワードを入力してログインします。

---

5-12. 「オンラインアカウントへの接続」の設定では右上の「スキップ」をクリックします。

![BootVirtualMachine-10](https://user-images.githubusercontent.com/80967103/159129733-65cc86f5-1e84-4bdd-a8be-d425f1d609d9.png)

---

5-13. 「Livepatch」の設定では右上の「次へ」をクリックします。

![BootVirtualMachine-11](https://user-images.githubusercontent.com/80967103/159129954-9a75c0d4-1c99-4eb7-b7c4-0fa0f44654c8.png)

---

5-14. 「Ubuntuの改善を支援する」の設定では、「いいえ、送信しません」を選択後、右上の「次へ」をクリックします。

![BootVirtualMachine-12](https://user-images.githubusercontent.com/80967103/159130038-77933811-e25d-4a48-84e7-0d77eb261aef.png)

---

5-15. 「プライバシー」の設定では右上の「次へ」をクリックします。

![BootVirtualMachine-13](https://user-images.githubusercontent.com/80967103/159130272-c25ae943-20bc-41b0-a32d-a1bd63644181.png)

---

5-16. 「準備完了」と表示されたら右上の「完了」をクリックします。

![BootVirtualMachine-14](https://user-images.githubusercontent.com/80967103/159130355-84b05b70-2269-4569-8793-9967a53642ba.png)

---

## 6- Guest Additionsのインストール
6-1. ターミナルを開いて以下を実行します。
> Guest Additionsがインストールされていない状態なのでホストからゲストにコピーアンドペーストできません。タイプミスに留意してください。
```console
sudo apt install gcc make perl -y
```

---

6-2. ホストメイン画面上部の「Devices」タブから「Insert Guest Additions CD image...」→「OK」をクリックします。

---

6-3. 以下のメッセージが表示されたら「実行」をクリックした後、パスワードを入力します。

![BootVirtualMachine-15](https://user-images.githubusercontent.com/80967103/159217595-93ffe2a5-ed89-4924-a3da-ece4791fbe25.png)

---

6-4. 処理完了のメッセージが表示されたらEnterキーを押下します。

![BootVirtualMachine-16](https://user-images.githubusercontent.com/80967103/159153823-eb6c79b5-a6d8-46e8-9ae9-a392ed33de8e.png)

---

6-5. ユーザーを`vboxsf`グループに追加して再起動します。
```console
sudo adduser $USER vboxsf
sudo reboot
```

---

6-6. 「View」→「Auto-resize　Guest　Display」にチェックが入っている事を確認します。  
> 確認後、右クリック→「取り出す」をクリックします。

![BootVirtualMachine-18](https://user-images.githubusercontent.com/80967103/159217747-5601d4d0-2c97-4464-b270-a5ae61ef29ee.png)

---

6-7. テストファイル作成  
ターミナルを開いて以下を実行します。
> 共有フォルダにテストファイルを作成してホスト側で確認できたら成功です。

```console
touch /media/sf_share/test
```

---

## 補足

### GUI操作でGuest Additionsがインストールできなかった場合
Virtualbox guest addition packagesをインストールします。
> ターミナルを開いて以下のコマンドを実行してください。  
> Guest Additionsがインストールされていない状態なのでホストからゲストにコピーアンドペーストできません。タイプミスに留意してください。  
> 成功していれば再起動後、コピーアンドペーストできます。
```console
sudo add-apt-repository multiverse
sudo apt install virtualbox-guest-dkms virtualbox-guest-x11 -y
```

ユーザーを`vboxsf`グループに追加して再起動します。
```console
sudo adduser $USER vboxsf
sudo reboot
```

共有フォルダが追加されているか確認
```console
df
```
> `share`          488245288 203122832 285122456  42% `/media/sf_share`

共有フォルダのグループを確認
```console
ls -l /media
```
> drwxrwx--- 1 root `vboxsf` 96  x月 xx xx:xx sf_share

テストファイル作成  
> 共有フォルダにテストファイルを作成してホスト側で確認できたら成功です。

```console
touch /media/sf_share/test
```

---

### Swapファイルの設定時のエラーについて

- 「テキストファイルがビジー状態です」と表示されたら以下を実行します。
```console
sudo swapoff /swapfile
rm /swapfile
```

- [Swap領域設定](https://docs.spojapanguild.net/setup/1-ubuntu-setup/#1-7swap)

---

### 本番運用で使用する際の注意点

- 本番運用で使用される場合は必ず「ネットワークアダプターを有効化」のチェックを外してください。

![BootVirtualMachine-21](https://user-images.githubusercontent.com/80967103/159157103-500edf69-5ed1-48c9-aa67-bea37647c395.png)
