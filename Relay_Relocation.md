# リレーノードの移行方法20221029<DNSバージョン>

※不備がありましたらDiscordかTwitterでAichiStakePoolまでDMなどでご連絡ください。

※DNSの割り当て変更の反映時間が読めない（最大で数日かかることも）ので、複数リレーを持っている人に推奨します。
リレーが１基のみの場合のリレーノードの移行は、IPベースで行うことを推奨します。

## 1.ubuntu初期設定を行う。
- アカウント名は旧Relayと極力同じにする。同じでない場合は２の※にて、ファイルパスが異なるので旧Relayからコピーせずにファイルをダウンロード→sed置換でOK
- ファイアーウォール設定は、旧Relayと同じで良い。
- 旧RelayとつないでいるBPのファイアーウォールに新Relayを追加する。
sudo ufw allow from <NEW_RELAY_IP> to any port <BP_PORT>

## 2．ノードインストールを行う。2-7. gLiveViewのインストールまででOK。2-8. エアギャップオフラインマシンの作成は不要。
- 以下のファイルは同階層に旧RelayからコピーすればOK。
mainnet-config.jsonやenvファイルなどのsedコマンドによる更新の必要もありません。

| cnodeにコピー  | cnode/scriptsにコピー |
| ------------- | ------------- |
| mainnet-byron-genesis.json  | gLiveView.sh  |
| mainnet-topology.jsonl  | env  |
| mainnet-shelley-genesis.json  |
| mainnet-alonzo-genesis.json  |
| mainnet-config.json  |
| relay-topology_pull.sh  |
| topologyUpdater.sh  |

## 3.ブロックチェーンが同期されるのを待つ。２日～３日程度必要。
- できる人は、旧Relayや近くのロケーションのサーバーからrsinc+sshでdbフォルダを送ると待つ必要が無くなる。

　事前設定https://docs.spojapanguild.net/operation/rsync-ssh/

　実際のコマンドhttps://docs.spojapanguild.net/operation/node-update/#3rsyncssh

## 4.BPのgLiveViewにて、新Relayからの疎通確認をする。
- ３が完了していなければ疎通が行われない。
- 疎通がない場合は以下の項目を確認
- 
　BPのファイアーウォール許可設定に新RelayのIP/ポート番号が含まれているか
 
　新Relayの$NODE_HOME/relay-topology_pull.shのポート番号
 ＝　新Relayのcat $NODE_HOME/mainnet-topology.jsonのポート番号
 ＝　BPの$NODE_HOME/startBlockProducingNode.shのポート番号
 
　となっているか

- 疎通確認コマンド

`新Relay`
```
　nc -vz <BP-IP> xxxxx
```
　xxxxxは、BPノードポート番号を入力します。<>は無しで入力。
 
  例：nc -vz 111.111.111.111 54321
  
　port [tcp/*] succeeded! であればOKです。　
　また、BPからリレーでも同じコマンドを行う。

## 5.DNSサーバーにてAレコードの割り当て変更を行う。割り当て変更の反映には数分～数日（とはいっても、おそらく６時間以内には反映される）かかる。
- 割り当て変更が反映されたかの確認をするには

`BP`
```
　nslookup <DNS>
```
　このコマンドでで表示された結果が新RelayのIPになっていれば、反映されている。

## 6.新RelayのgLiveViewにて、BPからの疎通確認をする。
- 疎通がない場合は以下の項目を確認
  
　まずはBPを再起動してみる。これでも治らなかったら
  
　BPのcat $NODE_HOME/mainnet-topology.jsonのポート番号
  ＝　リレーで/home/ubuntu/cnode/startRelayNode1.shのポート番号
  ＝　リレーで$NODE_HOME/relay-topology_pull.shのポート番号
  ＝　新Relayのファイアーウォール許可設定の番号
  
　となっているかを確認する。

## 7.監視ツールセットアップを行う。
https://docs.spojapanguild.net/setup/9-monitoring-tools-setup/#2-4
- Grafanaの表示は７を終えれば正しく表示されるようになる。ただししばらくは旧Relayの情報が残る。
- 時間がたてば新Relayの情報だけを参照できるようになる。

以上で終了です。お疲れさまでした！
