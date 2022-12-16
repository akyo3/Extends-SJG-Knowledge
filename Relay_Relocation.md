# リレーノードの移行方法20221029

※不備がありましたらDiscordかTwitterでAichiStakePoolまでDMなどでご連絡ください。

※主にDNSベースでの移行方法となります。DNSの割り当て変更の反映時間が読めない（最大で数日かかることも）ので、複数リレーを持っている人に推奨します。
リレーが１基のみの場合のリレーノードの移行は、IPベースで行うことを推奨します。IPベースの場合も一応対応しています。（文章中に「IPベースの場合」と書いておきました）

※Aichiの方で事前確認は行いましたが、今後のアップデートで仕様が変わったり、また他の環境では同様の手順でできないことがあります。トラブルがあっても、Aichiの方で責任はとれませんのでご了承ください。（サポートなどはギルドのチャンネルに書き込みください。きっとベテランの方々が助けてくれます）

## 1.ubuntu初期設定を行う。
- https://docs.spojapanguild.net/setup/1-ubuntu-setup/
- アカウント名・ノードのポート番号（sshログインポート番号ではなく、startRelayNode1.shに入力している番号）は旧Relayと極力同じにする。同じでない場合は２の※にて、ファイルパスや内容が異なるので旧Relayからコピーせずにファイルをダウンロード→sed置換でOK
- ファイアーウォール設定は、旧Relayと同じで良い。
- 旧RelayとつないでいるBPのファイアーウォールに新Relayを追加する。
sudo ufw allow from <NEW_RELAY_IP> to any port <BP_PORT>

## 2．ノードインストールを行う。
- https://docs.spojapanguild.net/setup/2-node-setup/
- 「2-7. gLiveViewのインストール」まででOK。「2-8. エアギャップオフラインマシンの作成」は不要。
- 以下のファイルは同階層に旧RelayからコピーすればOK。
mainnet-config.jsonやenvファイルなどのsedコマンドによる更新の必要もありません。ただ、作業を進めていったりメンテナンスをするうちに「Permission denied」と表示されることがあるので、chmod +xコマンドでその都度ファイルのパーミッションを許可すること。
- ただし、mainnet-topology.jsonのみは手順３が終わってからコピーすること。

| cnodeにコピー  | cnode/scriptsにコピー |
| ------------- | ------------- |
| mainnet-byron-genesis.json  | gLiveView.sh  |
| mainnet-topology.json  | env  |
| mainnet-shelley-genesis.json  |
| mainnet-alonzo-genesis.json  |
| mainnet-config.json  |
| relay-topology_pull.sh  |
| topologyUpdater.sh  |

- IPベースの場合はmainnet-topology.json,relay-topology_pull.shの内容を新しいIPに変更する。

## 3.ブロックチェーンが同期されるのを待つ。２日～３日程度必要。
- できる人は、旧Relayや近くのロケーションのサーバーからrsinc+sshでdbフォルダを送ると待つ必要が無くなる。

　事前設定https://docs.spojapanguild.net/operation/rsync-ssh/

　実際のコマンドhttps://docs.spojapanguild.net/operation/node-update/#3rsyncssh

## 4.BPのgLiveViewにて、新Relayからの疎通確認をする。
- ３が完了していなければ疎通が行われない。
- 疎通がない場合は以下の項目を確認

　BPのファイアーウォール許可設定に新RelayのIP/ポート番号が含まれているか
 
　
　以下の番号がすべて等しいか確認
 
　　　新Relayの$NODE_HOME/relay-topology_pull.shのポート番号

　　　新Relayのcat $NODE_HOME/mainnet-topology.jsonのポート番号

　　　BPの$NODE_HOME/startBlockProducingNode.shのポート番号

- gLiveViewを用いない疎通確認コマンド

`新Relay`
```
　nc -vz <BP-DNSorIP> xxxxx
```
　xxxxxは、BPノードポート番号を入力します。<>は無しで入力。
 
  例：nc -vz xxxx.com 54321
  
　succeeded! と表示されればOKです。　


## 5.DNSサーバーにてAレコードの割り当て変更を行う。
- 割り当て変更の反映には数分～数日（とはいっても、おそらく６時間以内には反映される）かかる。
- IPベースの場合はこの手順はスキップする。
- 割り当て変更が反映されたかの確認をするには

`BP`
```
　nslookup <DNS>
```
　このコマンドでで表示された結果が新RelayのIPになっていれば、反映されている。
- [Cexplorer.io](https://cexplorer.io/)の反映はさらに最大１日程度かかる。

## 6.旧Relayのノードを停止する。
- これによりトポロジー設定は４時間に自動削除されます。これをしないと手順７でtopologyUpdater.shの戻り値で競合エラーが起こる。
- その後サーバーのコンソールで停止。様子を見て特に問題なければインスタンスを削除。
- BPにて、旧Relayのファイアーウォール設定を解除しておく。

## 7.P2Pトポロジー設定を行う。
- https://docs.spojapanguild.net/setup/8.topology-setup/
- topologyUpdater.shの戻り値で最初の１回だけは「２回起動しないでね」的なエラーメッセージが表示される可能性がある。（旧RelayでのtopologyUpdater.shの起動時間と近いとエラーが生じる）しかし、そのまま放っておけばOK。
- 新Relayのトポロジー設定が登録されるのに４時間かかります。（旧Relayの削除と同時並行）
- ４時間後に以下の戻り値が最終行に表示されているかどうか確認する。
```
cd $NODE_HOME/logs
cat topologyUpdater_lastresult.json
```
戻り値
```
{ "resultcode": "201", "datetime":"2021-01-10 18:30:06", "clientIp": "000.000.000.000", "iptype": 4, "msg": "nice to meet you" }
{ "resultcode": "203", "datetime":"2021-01-10 19:30:03", "clientIp": "000.000.000.000", "iptype": 4, "msg": "welcome to the topology" }
{ "resultcode": "204", "datetime":"2021-01-10 20:30:04", "clientIp": "000.000.000.000", "iptype": 4, "msg": "glad you're staying with us" }
```
## 8.BPの再起動を行う。その後新RelayのgLiveViewにて、BPからの疎通確認をする。
- 疎通がない場合は以下の番号がすべて等しいか確認する。
 
　　　BPのcat $NODE_HOME/mainnet-topology.jsonのポート番号
  
  　　　リレーで/home/ubuntu/cnode/startRelayNode1.shのポート番号
  
  　　　リレーで$NODE_HOME/relay-topology_pull.shのポート番号
  
　　　新Relayのファイアーウォール許可設定の番号
- IPベースの場合は、以下を参考にプール情報の更新も行う。

　https://docs.spojapanguild.net/operation/cert-update/#0-1spo

- gLiveViewを用いない疎通確認コマンド

`BP`
```
nc -vz <NEW-Relay-DNSorIP> xxxxx
```
　xxxxxは、新リレーのポート番号を入力します。<>は無しで入力。

　例：nc -vz xxxx.com 54321

　succeeded! と表示されればOKです。
 
## 9.監視ツールセットアップを行う。
https://docs.spojapanguild.net/setup/9-monitoring-tools-setup/#2-4
- Grafanaの表示は７を終えれば正しく表示されるようになる。ただししばらくは旧Relayの情報が残る。
- 時間がたてば新Relayの情報だけを参照できるようになる。

以上で終了です。お疲れさまでした！
