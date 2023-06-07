# MacOSでのVirtualBoxのセットアップ

#### 環境
- macOS Ventura 13.4

#### ダウンロード/インストール
- VirtualBox バージョン 7.0.2
- Ubuntu Desktop `22.04.2 LTS` (Jammy Jellyfish)

---

## 1- Ubuntuイメージファイルのダウンロード

1-1. 以下のリンク先からISOイメージファイルをダウンロードします。

| リンク | ファイル名 |
| --- | --- |
| [Ubuntu Desktop `22.04.2 LTS` (Jammy Jellyfish)](https://releases.ubuntu.com/jammy/) | ubuntu-`22.04.2`-desktop-amd64.iso |
> ダウンロード完了まで少しかかるのでしばらくお待ちください

![Ubuntu-22.04-Install_1](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/243997998-9ae3d178-0dfa-4149-88d4-1e6bd3a8d035.png)

---

## 2- VirtualBoxのダウンロード/インストール

2-1. 以下のリンク先からVirtualBoxをインストールします。

| リンク | ファイル名 |
| --- | --- |
| [VirtualBox-`7.0.2`](https://www.virtualbox.org/wiki/Downloads) | VirtualBox-`7.0.2`-154219-OSX.dmg |

![VirtualBoxInstall-1](https://user-images.githubusercontent.com/80967103/199987719-48886644-846b-4748-95a7-65d6d12cf08c.png)

---

2-2. ダウンロードしたファイルをクリックし、インストールウィザードに従ってインストールして、完了したら「`閉じる`」をクリックして終了します。  
> macOS BigSur 以降では、インストールしたカーネル拡張をロードできるようにするために再起動が必要です。

![VirtualBoxInstall-2](https://user-images.githubusercontent.com/80967103/200001693-d02d64e2-a17c-4a35-ab42-3239b6e85ade.png)

---

## 3- VirtualBoxで仮想マシンを作成
3-1. VirtualBoxのアイコンをクリックし、起動したら「`新規(N)`」をクリックします。

![UbuntuVMCreate-1](https://user-images.githubusercontent.com/80967103/199995540-8812988e-ae05-4f52-b40c-b1ac255cd6ef.png)

---

3-2. 以下の項目を設定し、「`次へ`」をクリックします。
1. `名前`は`お好み`で入力してください。(例) airGap  
2. `Folder`は、`デフォルトでOK`です。
3. `ISO Image`は、「`その他`」を選択し、`ダウンロードしたubuntuのISOイメージファイルを選択`します。  
4. `Skip Unattended Installation`に`チェック`します。  
> タイプ、バージョンについてはデフォルトで設定されます    

![UbuntuVMCreate-2](https://user-images.githubusercontent.com/80967103/200000228-a7333064-a9a7-43dd-bc24-91292d2af32a.png)

---

3-3. 仮想マシンに割当てる`メモリサイズ`は`4096MB`、`Processors`は`2`を選択し「`次へ`」をクリックします。

![UbuntuVMCreate-3](https://user-images.githubusercontent.com/80967103/200007711-1919c2b1-ca3a-4710-8f95-09506a444881.png)

---

3-4. `Virtual Hard disk`は`50GB`を入力し、「`次へ`」をクリックします。

![UbuntuVMCreate-7](https://user-images.githubusercontent.com/80967103/200004570-a7831dd0-971a-4a85-b442-386e9510321f.png)

---

3-5. 概要を確認して「`完了`」をクリックします。

![UbuntuVMCreate-7](https://user-images.githubusercontent.com/80967103/200163806-ebee3d0f-5caa-4b54-b07c-6569e9b8059f.png)

---

## 4- 仮想マシンの仕様設定
「`完了`」をクリック後、`Oracle VM VirtualBox マネージャー`画面に遷移しますので、「`設定`」をクリックしてください。

## 一般

4-1. 「`設定`」→「`一般`」→「`高度`」タブから、以下の設定を`双方向`にし、「`OK`」をクリックします。

![UbuntuSpecSettings-2](https://user-images.githubusercontent.com/80967103/200102482-958c0ece-9c96-40e7-854c-84eeb172fe39.png)

---

## システム

4-2. 「`マザーボード`」タブを選択後、項目を以下のように設定し、「`OK`」をクリックします。

| タブ | 起動順序 | チップセット | ポインティングデバイス |
| --- | --- | --- | --- |
| マザーボード | `フロッピー`、`ネットワーク`の`チェックマークを外す` | `ICH9` | `PS/2マウス` |

![UbuntuSpecSettings-3](https://user-images.githubusercontent.com/80967103/200104121-58558676-f637-494d-897c-f5c6f7e2f905.png)

---

## ディスプレイ

4-3. 「`スクリーン`」タブを選択後、項目を以下のように設定し、「`OK`」をクリックします。

| タブ | ビデオメモリー | 表示倍率 | グラフィックスコントローラー |
| --- | --- | --- | --- |
| スクリーン | `128MB` | `200%` | `VMSVGA` |

![UbuntuSpecSettings-4](https://user-images.githubusercontent.com/80967103/200104321-b1805130-d1b9-4e7e-9883-ef9ca583b41c.png)

---

## 共有フォルダー

4-4. ホスト側で共有させたいフォルダを事前に作成しておきます。
> (例） `airGap`フォルダの配下に`share`フォルダを作成

`Mac Terminal`
```console
mkdir -p $HOME/airGap/share
```

---

4-5. 共有フォルダを指定します。  
![UbuntuSpecSettings-6](https://user-images.githubusercontent.com/80967103/200105091-1ab57c12-26b9-4f1e-92fd-e989ae76a3e1.png)

---

## 5- 仮想マシンにUbuntuをインストール

5-1. 仮想マシンを起動します。

![BootVirtualMachine-1](https://user-images.githubusercontent.com/80967103/200105774-017a584c-24ca-471b-8ce3-2c6bce299301.png)

> PCから権限許可を求められたら「セキュリティとプライバシー」にて必要な権限を許可し、VirtualBoxを再起動します。

---

5-2. 読み込み終了後、言語は「`日本語`」を選択し、「`Install Ubuntu`」をクリックします。

![BootVirtualMachine-2](https://user-images.githubusercontent.com/80967103/200107225-fab3855e-ffe1-4291-9337-2d2dd908ba18.png)

---

5-3. お使いのキーボードによって設定する内容は変わります。設定が完了したら「`続ける`」をクリックします。  
- 日本語キーボードの方は、両方とも「`Japanese`」を選択。  
- USキーボードの方は「`キーボードレイアウト`」→「`キーボードレイアウトの検出`」を選択。  
> `画面が見切れていた場合の対処法`：`Alt＋F7`で移動できます

---

5-4. `アップデートと他のソフトウェア`の設定では、以下のように設定し、「`続ける`」をクリックします。

![BootVirtualMachine-3](https://user-images.githubusercontent.com/80967103/203983361-de583135-1f98-4578-819e-98ceef0ba661.png)

---

5-5. `インストールの種類`の設定では「`ディスクを削除してUbuntuをインストール`」を選択し、「`インストール`」をクリックします。

![BootVirtualMachine-4](https://user-images.githubusercontent.com/80967103/159128589-0b0373ac-a342-45d6-b22c-0f14122a5f3d.png)

---

5-6. `ディスクに変更を書き込みますか?`の設定では「`続ける`」をクリックします。

![BootVirtualMachine-5](https://user-images.githubusercontent.com/80967103/159128650-7cbc6a86-5fce-465b-b980-95d3f17f7e3e.png)

---

5-7. `タイムゾーンの設定`は、「`Tokyo`」を選択し、「`続ける`」をクリックします。

![BootVirtualMachine-6](https://user-images.githubusercontent.com/80967103/159128953-10f8e1d9-cd04-401e-905c-3b27cbdf89e6.png)

---

5-8. 必要な情報を入力し、「`続ける`」をクリックします。
> ※ 画像は一例ですのでお好みで設定してください

![BootVirtualMachine-7](https://user-images.githubusercontent.com/80967103/200107672-1be7368a-aa1f-4590-9a36-cf3ad914aa04.png)

---

5-9. インストール開始。

![BootVirtualMachine-8](https://user-images.githubusercontent.com/80967103/159129325-84554dfb-4062-4c90-ab26-baa3422c2fd5.png)

---

5-10. インストール完了後、VMの再起動を求められるので「`今すぐ再起動する`」をクリックし、`Enterキーを押下`します。

![BootVirtualMachine-9](https://user-images.githubusercontent.com/80967103/200108019-76aad33a-f170-4538-94fc-e7aabafeb8d8.png)

---

5-11. 再起動後、ユーザー名をクリックし、パスワードを入力してログインします。

---

5-12. `オンラインアカウントへの接続`の設定では右上の「`スキップ`」をクリックします。

![BootVirtualMachine-10](https://user-images.githubusercontent.com/80967103/200108172-78dbeb3e-3c06-4c51-84e6-e9ea906f80e1.png)

---

5-13. `Livepatch`の設定では右上の「`次へ`」をクリックします。

![BootVirtualMachine-11](https://user-images.githubusercontent.com/80967103/200108232-edb1f8e4-ae79-4c8b-8245-df9349df33ca.png)

---

5-14. `Ubuntuの改善を支援する`の設定では、「`いいえ、送信しません`」を選択後、右上の「`次へ`」をクリックします。

![BootVirtualMachine-12](https://user-images.githubusercontent.com/80967103/200108403-e4ce931d-4fac-43da-aca3-5bbadc4947b3.png)

---

5-15. `プライバシー`の設定では右上の「`次へ`」をクリックします。

![BootVirtualMachine-13](https://user-images.githubusercontent.com/80967103/200108468-8109b5b6-1b2e-407e-936d-19703d0f7525.png)

---

5-16. `準備完了`と表示されたら右上の「`完了`」をクリックします。

![BootVirtualMachine-14](https://user-images.githubusercontent.com/80967103/200108519-0226b6db-95b1-48c0-9bed-b9f746c3c310.png)

---

5-17. `ソフトウェアの更新`を求められたら「`アップグレードしない`」をクリックし、その後「`OK`」をクリックします。

![BootVirtualMachine-14](https://user-images.githubusercontent.com/80967103/203997822-2d823615-395b-49e4-be07-aa36fa2153a3.png)

---

5-18. `アップデート情報→不完全な言語サポート`が表示されたら「`この操作を今すぐ実行する`」→「`インストール`」をクリック後、認証を求められるのでパスワードを入力し、「`システム全体に適用`」をクリックします。

![BootVirtualMachine-14](https://user-images.githubusercontent.com/80967103/204000214-49e1af9b-780f-4cea-a90d-6dfc33c00f75.png)

---

## 6- Guest Additionsのインストール
6-1. ターミナルを開いて以下を実行します。
> 1. Guest Additionsがインストールされていない状態なのでホストからゲストにコピーアンドペーストできないため、タイプミスに留意してください  
> 2. また以下の手順を行なっても、共有フォルダがGUIで表示されない、共有フォルダ化されていない場合は、一度VBox_GAs_X.X.XXをアンマウントしてから再度挿入し、再起動すると共有フォルダは完了します  
> 3. それでもダメなら[`GUI操作でGuest Additionsがインストールできなかった場合`](#GUI操作でGuest-Additionsがインストールできなかった場合)を試してください
```console
sudo apt update -y
sudo apt upgrade -y
sudo apt install gcc make perl -y
```

---

6-2. ホストメイン画面上部の「`Devices`」タブから`Insert Guest Additions CD image...`→「`OK`」をクリックします。

---

6-3. 以下のメッセージが表示されたら「`実行`」をクリックした後、パスワードを入力します。

![BootVirtualMachine-15](https://user-images.githubusercontent.com/80967103/200109416-73ade24b-33bf-4a74-aa6a-2f032254f8cd.png)

---

6-4. 処理完了のメッセージが表示されたらEnterキーを押下します。
> 画面が点滅した場合は、リサイズが行われているのでそのまま少し待っていると点滅しなくなるはずです

![BootVirtualMachine-16](https://user-images.githubusercontent.com/80967103/159153823-eb6c79b5-a6d8-46e8-9ae9-a392ed33de8e.png)

---

6-5. ユーザーを`vboxsf`グループに追加して再起動します。
```console
sudo adduser $USER vboxsf
sudo reboot
```

---

6-6. `View`→`Auto-resize　Guest　Display`にチェックが入っている事を確認します。  
> 確認後、`右クリック`→「`取り出す`」をクリックします

![BootVirtualMachine-18](https://user-images.githubusercontent.com/80967103/200109672-4e4d6dde-23d9-408d-96ff-a9ab28c2039f.png)

---

6-7. テストファイル作成  
ターミナルを開いて以下を実行します。  
> 共有フォルダにテストファイルを作成してホスト側で確認できたら成功です

```console
touch /media/sf_share/test.txt
ls /media/sf_share/
```

実行結果としてVMとホストに`test.txt`が作成されていることを確認します。
![BootVirtualMachine-18](https://user-images.githubusercontent.com/80967103/200110310-c3f060e1-0184-4aa5-8bfd-7d7fea5eef3f.png)

---

## 7- Swapファイルの作成  
7-1. 既存Swapファイルを削除  
```console
sudo swapoff /swapfile
```
```console
sudo rm /swapfile
```

---

7-2. 新規Swapファイルを作成  
```console
cd $HOME
sudo fallocate -l 6G /swapfile
```
```console
sudo chmod 600 /swapfile
```
```console
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
```
```console
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
cat /proc/sys/vm/vfs_cache_pressure
cat /proc/sys/vm/swappiness
```

---

### 本番運用で使用する際の注意点

- `本番運用で使用される場合`は必ず`ネットワークアダプターを有効化`の`チェックを外してください`。  
[2-8. エアギャップマシンセットアップ](https://docs.spojapanguild.net/setup/2-node-setup/#2-8)を終えた後に行ってください。

![BootVirtualMachine-21](https://user-images.githubusercontent.com/80967103/200110479-30bdd7ea-88b4-41f2-8642-b6653e45762a.png)

---

## 補足

### GUI操作でGuest Additionsがインストールできなかった場合
Virtualbox guest addition packagesをインストールします。
> 1. ターミナルを開いて以下のコマンドを実行してください  
> 2. Guest Additionsがインストールされていない状態なのでホストからゲストにコピーアンドペーストできません。タイプミスに留意してください  
> 3. 成功していれば再起動後、コピーアンドペーストできます
```console
sudo apt update -y
sudo apt upgrade -y
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
> 共有フォルダにテストファイルを作成してホスト側で確認できたら成功です

```console
touch /media/sf_share/test.txt
ls /media/sf_share/
```

実行結果としてVMとホストに`test.txt`が作成されていることを確認します。
![BootVirtualMachine-18](https://user-images.githubusercontent.com/80967103/200110310-c3f060e1-0184-4aa5-8bfd-7d7fea5eef3f.png)
