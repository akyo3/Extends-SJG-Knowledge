# MacOSでのVirtualBoxのセットアップ

#### 環境
- macOS Ventura 13.4

#### ダウンロード/インストール
- VirtualBox バージョン `7.0.8`
- Ubuntu Desktop `22.04.2 LTS` (Jammy Jellyfish)

---

## 1- Ubuntuイメージファイルのダウンロード

1-1. 以下のリンク先からISOイメージファイルをダウンロードします。

| リンク | ファイル名 |
| --- | --- |
| [Ubuntu Desktop `22.04.2 LTS` (Jammy Jellyfish)](https://releases.ubuntu.com/jammy/) | ubuntu-`22.04.2`-desktop-amd64.iso |
> ダウンロード完了まで少しかかるのでしばらくお待ちください

![Ubuntu-22.04-Install](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/243997998-9ae3d178-0dfa-4149-88d4-1e6bd3a8d035.png)

---

## 2- VirtualBoxのダウンロード/インストール

2-1. 以下のリンク先からVirtualBoxをインストールします。

| リンク | ファイル名 |
| --- | --- |
| [VirtualBox-`7.0.8`](https://www.virtualbox.org/wiki/Downloads) | VirtualBox-`7.0.8`-156879-OSX.dmg |

![virtualbox-7.0.8-install-1](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245137245-ac9cbc87-c2b6-4032-bf24-5ad8b021e5c2.png)

---

2-2. ダウンロードしたファイルをクリック、インストールウィザードに従ってインストールし、完了したら「`閉じる`」をクリックして終了します。  
> macOS BigSur 以降では、インストールしたカーネル拡張をロードできるようにするために再起動が必要です。

![virtualbox-7.0.8-install-2](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245145217-f901435b-5ef4-4895-9c5c-47e786ed78f0.png)

---

## 3- VirtualBoxで仮想マシンを作成
3-1. VirtualBoxのアイコンをクリックし、起動したら「`新規(N)`」をクリックします。

![ubuntu-vm-create-1](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245146540-5b231dd7-c364-4100-8431-316bb444d7df.png)

---

3-2. 以下の項目を設定し、「`次へ`」をクリックします。
1. `名前`は`お好み`で入力してください。(例) airGap  
2. `Folder`は、`デフォルトでOK`です。
3. `ISO Image`は、「`その他`」を選択し、`ダウンロードしたubuntuのISOイメージファイルを選択`します。  
4. `Skip Unattended Installation`に`チェック`します。  
> タイプ、バージョンについてはデフォルトで設定されます    

![ubuntu-vm-create-2](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245148683-7b6558ee-e0ca-4bff-8b8f-312f3f60f244.png)

---

3-3. 仮想マシンに割当てる`メモリサイズ`は`4096MB`、`Processors`は`2`を選択し「`次へ`」をクリックします。

![ubuntu-vm-create-3](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245149972-af76f158-e963-4b9d-9644-2db0797b917b.png)

---

3-4. `Virtual Hard disk`は`50GB`を入力し、「`次へ`」をクリックします。

![ubuntu-vm-create-4](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245150955-77a2f0d6-a222-4c75-83ba-019a5996cbe2.png)

---

3-5. 概要を確認して「`完了`」をクリックします。

![ubuntu-vm-create-5](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245151842-1f1ca111-3ee6-4480-85e5-18430ca34f20.png)

---

## 4- 仮想マシンの仕様設定
「`完了`」をクリック後、`Oracle VM VirtualBox マネージャー`画面に遷移しますので、「`設定`」をクリックしてください。

## 一般

4-1. 「`高度`」タブを選択後、項目を以下のように設定し、「`OK`」をクリックします。

| タブ | クリップボードの共有 | ドラッグ＆ドロップ |
| --- | --- | --- |
| 高度 | `双方向` | `双方向` |

![ubuntuSpecSettings-1](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245159770-92ac5802-e25e-4907-bbd8-d7cc3ff58a2e.png)

---

## システム

4-2. 「`マザーボード`」タブを選択後、項目を以下のように設定し、「`OK`」をクリックします。

| タブ | 起動順序 | チップセット | ポインティングデバイス |
| --- | --- | --- | --- |
| マザーボード | `光学`、`ハードディスク`にチェック | `ICH9` | `PS/2マウス` |

![ubuntuSpecSettings-2](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245161367-062423be-6965-460b-b0df-465046d71032.png)

---

## ディスプレイ

4-3. 「`スクリーン`」タブを選択後、項目を以下のように設定し、「`OK`」をクリックします。

| タブ | ビデオメモリー | 表示倍率 | グラフィックスコントローラー |
| --- | --- | --- | --- |
| スクリーン | `64MB` | `200%` | `VMSVGA` |

![ubuntuSpecSettings-3](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245162651-74eb839f-265c-4d72-ba73-469d0533b1f3.png)

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
1. 「`共有フォルダー`」タブからフォルダアイコンをクリック
2. `フォルダーのパス：`のドロップダウン「`その他...`」（PATHは、$HOME/airGap/share）を選択
3. 「`自動マウント`」にチェックし、「`OK`」→「`OK`」をクリック
![UbuntuSpecSettings-4](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245156292-7fba4771-eda3-40fb-b220-7c7a4d6d6231.png)

---

## 5- 仮想マシンにUbuntuをインストール

5-1. 仮想マシンを起動します。

![BootVirtualMachine-1](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245169679-7fdf18d0-887a-48e2-ad94-f1f86f998b94.png)
> PCから権限許可を求められたら「セキュリティとプライバシー」にて必要な権限を許可し、VirtualBoxを再起動します。

---

5-2. 読み込み終了後、言語は「`日本語`」を選択し、「`Install Ubuntu`」をクリックします。

![BootVirtualMachine-2](https://user-images.githubusercontent.com/80967103/200107225-fab3855e-ffe1-4291-9337-2d2dd908ba18.png)

---

5-3. お使いのキーボードによって設定する内容は変わります。設定が完了したら「`続ける`」をクリックします。  
- 日本語キーボードの方は、両方とも「`Japanese`」を選択。  
- USキーボードの方は「`キーボードレイアウト`」→「`キーボードレイアウトの検出`」を選択。  
> `画面が見切れていた場合の対処法`：`Alt＋F7`を押下すると動かすことができます

---

5-4. `アップデートと他のソフトウェア`の設定では「`最小インストール`」、「`Ubuntuのインストール中にアップデートをダウンロードする`」を選択し、「`続ける`」をクリックします。

![BootVirtualMachine-3](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244850242-1b0ad467-04b8-4890-9e85-3cc6f3fd3997.png)

---

5-5. `インストールの種類`の設定では「`ディスクを削除してUbuntuをインストール`」を選択し、「`インストール`」をクリックします。

![BootVirtualMachine-4](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244850319-973c30cc-e0f3-47e7-b257-e74e8ccc0d6c.png)

---

5-6. `ディスクに変更を書き込みますか?`の設定では「`続ける`」をクリックします。

![BootVirtualMachine-5](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244850429-4ae97f70-a700-4deb-9c87-33186537c89a.png)

---

5-7. `タイムゾーンの設定`は、デフォルトの「`Tokyo`」を選択し、「`続ける`」をクリックします。

![BootVirtualMachine-6](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244850535-edede03c-a0b2-43e6-962e-7c2e09583873.png)

---

5-8. 必要な情報を入力し、「`続ける`」をクリックします。
> ※ 画像は一例ですのでお好みで設定してください

![BootVirtualMachine-7](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245178067-670f3fb2-f858-4c9c-a340-783de4591984.png)

---

5-9. インストール開始。

![BootVirtualMachine-8](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244348538-5aaf3c59-23a3-43f1-a319-79aeaa9a3b3d.png)

---

5-10. インストール完了後、VMの再起動を求められるので「`今すぐ再起動する`」をクリックし、Ubuntuのロゴが表示され、`Please~`と表示されたら`Enterキーを押下`します。

![BootVirtualMachine-9](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244351064-70bb85b6-5b9e-4927-a250-b1a48f359624.png)

---

5-11. 再起動後、ユーザー名をクリックし、パスワードを入力してログインします。

---

5-12. `オンラインアカウントへの接続`の設定では右上の「`スキップ`」をクリックします。

![BootVirtualMachine-10](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244352277-b2af5844-995a-41bb-9112-f9dddbe4a8fa.png)

---

5-13. `Ubuntu Pro`の設定では「`Skip for now`」を選択し、右上の「`次へ`」をクリックします。

![BootVirtualMachine-11](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244353520-53d0317f-4ad3-4cea-aedf-93b028c5795b.png)

---

5-14. `Ubuntuの改善を支援する`の設定では、「`いいえ、送信しません`」を選択後、右上の「`次へ`」をクリックします。

![BootVirtualMachine-12](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244851066-0ab092f1-30a3-48c7-8776-21765fe84b57.png)

---

5-15. `プライバシー`の設定では右上の「`次へ`」をクリックします。

![BootVirtualMachine-13](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244851124-c430e8f2-167f-4b27-97bc-375cc7a8758a.png)

---

5-16. `準備完了`と表示されたら右上の「`完了`」をクリックします。

![BootVirtualMachine-14](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/244851172-ee48bfa6-0ba4-420b-846d-1fb906df3175.png)

---

5-17. `アップデート情報→不完全な言語サポート`が表示されたら「`この操作を今すぐ実行する`」→「`インストール`」をクリック後、認証を求められるのでパスワードを入力し、「`システム全体に適用`」をクリックします。

![BootVirtualMachine-15](https://user-images.githubusercontent.com/80967103/204000214-49e1af9b-780f-4cea-a90d-6dfc33c00f75.png)

---

## 6- Guest Additionsのインストール
6-1. ターミナルを開いて以下を実行します。
> 1. Guest Additionsがインストールされていない状態なのでホストからゲストにコピーアンドペーストできないため、タイプミスに留意してください  
> 2. また以下の手順を行なっても、共有フォルダがGUIで表示されない、共有フォルダ化されていない場合は、一度VBox_GAs_X.X.XXをアンマウントしてから再度挿入し、再起動すると共有フォルダは完了します  
> 3. それでもダメなら[`GUI操作でGuest Additionsがインストールできなかった場合`](#GUI操作でGuest-Additionsがインストールできなかった場合)を試してください
```console
sudo apt update -y && sudo apt upgrade -y
```

---

6-2. ホストメイン画面上部の「`Devices`」タブから`Insert Guest Additions CD image...`→「`OK`」をクリックします。

---

6-3. 以下の通りに操作します。
1. ファイルアイコンをクリック（添付画像の黄枠箇所）
2. CDドライブ (VBox_GAs_*.*.) をクリック
3. 「`autorun.sh`」を右クリックして「`プログラムとして実行(R)`」をクリックします。
4. `認証が必要です`と表示されるのでパスワード欄にパスワードを入力して、「`認証`」をクリックします。
> しばらく待ちます。また画面が点滅した場合は、リサイズが行われているのでそのまま少し待っていると点滅しなくなります
5. `Press Return to close this window...`と表示されたら`Enterキー`を押下します。
6. ユーザーを`vboxsf`グループに追加して、再起動します。
```console
sudo adduser $USER vboxsf
sudo reboot
```
> 再起動後、パスワード入力画面が表示されるまでしばらく待ちます

![BootVirtualMachine-16](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245088185-681346c9-6545-458c-b256-76d858ee98c9.png)

---

6-4. `View`→`Auto-resize　Guest　Display`にチェックが入っている事を確認し、確認後にCDアイコンを`右クリック`→「`取り出す`」をクリックします。

![BootVirtualMachine-17](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245096391-b7992610-467b-4cd0-8175-1a37cac67ce8.png)

---

6-5. テストファイル作成  
ターミナルを開いて以下を実行します。

```console
touch /media/sf_share/test.txt
ls /media/sf_share/
```
実行結果として共有フォルダに`test.txt`が作成されていることを確認します。
> VM側とホスト側の両方で確認しておくと良いでしょう
![BootVirtualMachine-18](https://user-images.githubusercontent.com/80967103/200110310-c3f060e1-0184-4aa5-8bfd-7d7fea5eef3f.png)

---

## 7- ブラケットペーストモードOFFの設定
```console
echo "set enable-bracketed-paste off" >> ~/.inputrc
```
デーモン再起動自動化
```console
echo "\$nrconf{restart} = 'a';" | sudo tee /etc/needrestart/conf.d/50local.conf
```
```console
echo "\$nrconf{blacklist_rc} = [qr(^cardano-node\\.service$) => 0,];" | sudo tee -a /etc/needrestart/conf.d/50local.conf
```

---

## 8- Swapファイルの作成  
8-1. 既存Swapファイルを削除  
```console
sudo swapoff /swapfile
```
```console
sudo rm /swapfile
```

---

8-2. 新規Swapファイルを作成  
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

![BootVirtualMachine-19](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245509613-4e361f43-93f5-4db9-a4cc-aec501fe557f.png)

---

## 補足

### GUI操作でGuest Additionsがインストールできなかった場合
Virtualbox guest addition packagesをインストールします。
> 1. ターミナルを開いて以下のコマンドを実行してください  
> 2. Guest Additionsがインストールされていない状態なのでホストからゲストにコピーアンドペーストできません。タイプミスに留意してください  
> 3. 成功していれば再起動後、コピーアンドペーストできます

1. ホストメイン画面上部の「`Devices`」タブから`Insert Guest Additions CD image...`→「`OK`」をクリックします。

2. システムアップデート、アップグレード実行
```console
sudo apt update -y && sudo apt upgrade -y
```

3. ISOディレクトリに移動
```console
cd /media/$USER/VBox_GAs_*
```
4. スクリプトを実行し、Guest Additionsをインストール
```console
sudo ./VBoxLinuxAdditions.run
```
> しばらく待ちます。また画面が点滅した場合は、リサイズが行われているのでそのまま少し待っていると点滅しなくなります

5. ユーザーを`vboxsf`グループに追加して、再起動します。
> コマンド入力がうまくいかない場合、ターミナルを立ち上げ直して入力してみてください
```console
sudo adduser $USER vboxsf
sudo reboot
```

![BootVirtualMachine-16](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245101416-105ecc03-fcb7-4b9e-bdbe-5b1a7b8bdb38.png)

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

`View`→`Auto-resize　Guest　Display`にチェックが入っている事を確認し、確認後にCDアイコンを`右クリック`→「`取り出す`」をクリックします。

![BootVirtualMachine-17](https://github-production-user-asset-6210df.s3.amazonaws.com/80967103/245096391-b7992610-467b-4cd0-8175-1a37cac67ce8.png)

テストファイル作成  
ターミナルを開いて以下を実行します。

```console
touch /media/sf_share/test.txt
ls /media/sf_share/
```
実行結果として共有フォルダに`test.txt`が作成されていることを確認します。
> VM側とホスト側の両方で確認しておくと良いでしょう
![BootVirtualMachine-18](https://user-images.githubusercontent.com/80967103/200110310-c3f060e1-0184-4aa5-8bfd-7d7fea5eef3f.png)
