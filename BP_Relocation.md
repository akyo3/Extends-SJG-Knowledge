# BPの移設手順（旧VPS会社→新VPS会社）

<details>
<summary>サーバー選定について</summary>

カルダノは最も分散化されたネットワークでセキュリティ向上を目指しており、世界中に分散されたノードネットワークの形成が、カルダノにとって最も重要になります。このことから「おすすめのサーバー(VPS)業者」の情報共有は行っておりませんので、各自で選定をお願いいたします。AWS EC2及びlightsailは想定していません。

</details>

<details>
<summary>サーバースペック要件</summary>
<div>

推奨:
| 項目 | 要件 |
|:-------------|:------------|
| OS | 64-bit Linux (Ubuntu 20.04 LTS) |
| CPU | 2Ghz以上 4コアのIntelまたはAMD x86プロセッサー |
| メモリ | 16GB |
| ストレージ | 256GB以上 |
| ネットワーク | 100Mbps |
| 帯域 | 無制限 |
| 電力 | 24時間365日安定供給 |


最小:
| 項目 | 要件 |
|:-------------|:------------|
| OS | 64-bit Linux (Ubuntu 20.04 LTS) |
| CPU | 2Ghz以上 2コアのIntelまたはAMD x86プロセッサー |
| メモリ | 12GB |
| ストレージ | 150GB |
| ネットワーク | 10Mbps |
| 帯域 | 1時間あたり1GBの帯域 |
| 電力 | 24時間365日安定供給 |

</div>

</details>

## 前提注意事項
本まとめは現VPS会社→新VPS会社へと**BPのみ**を移行するまとめです。

実際に行う際には、**自己責任**でお願いします。

ブロック生成予定まで余裕がある時に実施してください。

> 旧BPは「2-5. ~旧BPのノードを停止する。」まで、稼働させたままにしておいてください。

---

<details>
<summary>お好み設定</summary>
(実施するしないは、各自調べてお好みで)

- CPU情報の確認

自分のサーバーのCPU情報の確認:
<div>

```console
grep 'model name' /proc/cpuinfo | uniq
```
もしくは
```console
cat /proc/cpuinfo | grep -E "physical id|cpu cores|siblings|processor|model name" | sort | uniq
```
出力例:
```
cpu cores       : 4 ←1個の物理CPUに搭載されている"物理"コア数
model name      : Intel(R) Core(TM) i5-8257U CPU @ 1.40GHz ←　型名CPU
physical id     : 0 ←物理CPU（1個目）
physical id     : 1 ←物理CPU（2個目）
processor       : 0 ←論理プロセッサ（＝合計論理コア数:1個目）
processor       : 1 ←論理プロセッサ（＝合計論理コア数:2個目）
processor       : 2 ←論理プロセッサ（＝合計論理コア数:3個目）
processor       : 3 ←論理プロセッサ（＝合計論理コア数:4個目）
processor       : 4 ←論理プロセッサ（＝合計論理コア数:5個目）
processor       : 5 ←論理プロセッサ（＝合計論理コア数:6個目）
processor       : 6 ←論理プロセッサ（＝合計論理コア数:7個目）
processor       : 7 ←論理プロセッサ（＝合計論理コア数:8個目）
siblings        : 4 ←1個の物理CPUに搭載されている"論理"コア数
```

<div>

---

</div>

- ホスト名設定:ホスト名を恒久的に変更
<div>

> <新しいホスト名>を変更したいホスト名へと変更。
```console
sudo hostnamectl set-hostname <新しいホスト名>
```

設定確認
```console
sudo hostnamectl
```

補足:
ホスト名は「/etc/hostname」というファイルで管理しています。  「hostnamectl」で設定すると、「/etc/hostname」に反映され、永続的に変更できます。

</div>
</div>
</details>

---

### 1- Ubuntu初期設定

1-1. [Ubuntu初期設定](https://docs.spojapanguild.net/setup/1-ubuntu-setup/#0-3)を実施します。

- さくらのパケットフィルタや、AWSのUFW設定などのサーバー独自の機能に気をつけてください。
- 旧BPのユーザー名（例：ubuntu）と新BPのユーザー名は変更しないでください。  もし変更する場合は、下記2-5にて旧BPから新BPにコピーするファイル`startBlockProducingNode.sh`内の変数DIRECTORYのパス名を手動で変更してください。
```console:startBlockProducingNode.sh
DIRECTORY=/home/<new_user_name>/cnode
```
- リレーとの接続のための、新BPのファイヤーウォール設定は、旧BPのものと同じで良い。
    
### 2- Cabal/GHCインストール 〜 gLiveViewのインストール

2-1. [Cabal/GHCインストール](https://docs.spojapanguild.net/setup/2-node-setup/#2-1-cabalghc) 〜
[gLiveViewのインストール](https://docs.spojapanguild.net/setup/2-node-setup/#2-7-gliveview)まで実施します。

2-2. 旧BPのcnodeディレクトリにある`mainnet-topology.json`、`mainnet-config.json`を新BPのcnodeディレクトリにコピーし、新BPのノードを再起動します。

`新BP`

ノード再起動
```console
sudo systemctl reload-or-restart cardano-node
```
ノードログ確認
```console
journalctl --unit=cardano-node --follow
```

2-3. リレーの`relay-topology_pull.sh`の内容を旧BPのIPとPORTから新BPのIPとPORTへと変更します。また念の為、新BPでブロック生成確認できるまで旧BPとの疎通を残しておきます。（2-14で旧BPの情報を削除します）

- 以下は、旧BPのパブリックIPとノードポートを新BPのパブリックIPとノードポートに書き換えてからコマンドを実行します。

    
<details>
<summary>DNSではなくIPで入力したほうがお勧めする理由</summary>

<div>

以下の２つのメリットから、精神的にゆとりがあるため。
1. DNSのAレコード変更のタイムラグを無くすことができる
2. ブロック生成に失敗した場合でも「新BPノードを停止し旧BPノードの再稼働」をするだけで元の状態に戻せる

DNSのAレコードの変更は数分～数日かかります。  2-14で書いてありますが、変更が反映されたら、IPをDNSに置き換えてください。

</div>
</details>

<details>
<summary>やっぱり最初からDNSベースで移設したい人（正式に動作するかは2022/09/12時点では未検証）</summary>

<div>

IPベースよりも多少リスクがありますが、DNSベースのほうが手順は最小限で済みます。
Aレコードの変更が各ノードにいきわたるまでの時間が読めない（最大で数日かかる）ため、
複数リレーノードを起動している方、もしくはブロック生成スケジュールに相当余裕がある方向けです。
    
- 現在Aレコードの割り当てをしているサーバーで、割り当てIPを新BPのIPに変更する。
- 以下、留意事項
    
    ①手順2-3では、BLOCKPRODUSING_PORTの値だけを新BPのものに変更するだけで良い。
    
    ②手順2-13で旧BPを再稼働したい場合は、再度Aレコードを旧BPのIPにする。（反映されるまでに最大で数日かかる）
    
    ③手順2-14では、旧BPの情報はすでに新BPのものに置き換わっているので、特に操作の必要はない。    
    
</div>
</details>
    
なお、ご自身で`relay-topology_pull.sh`ファイルのメモがある場合はそちらを編集して実行してください。
> IOHKノード情報の後に "|" で区切って旧BPの「IPアドレス:ポート番号:Valency の形式」で追加します。


        
`リレー`
```console:relay-topology_pull.sh
cat > $NODE_HOME/relay-topology_pull.sh << EOF
#!/bin/bash
BLOCKPRODUCING_IP=xxx.xxx.xxx
BLOCKPRODUCING_PORT=6000
PEERS=18
curl -4 -s -o $NODE_HOME/${NODE_CONFIG}-topology.json "https://api.clio.one/htopology/v1/fetch/?max=\${PEERS}&customPeers=\${BLOCKPRODUCING_IP}:\${BLOCKPRODUCING_PORT}:1|relays-new.cardano-mainnet.iohk.io:3001:2|relay1-eu.xstakepool.com:3001:1|00.000.000.00:3001:1|aaa.aaa.aaa.aaa:XXXX:X"
EOF
```

> 保存して閉じます。

relay-topology_pull.shを実行し、リレーノードを再起動します。（2-4に進む前に、ノードが起動するまでしばらく待ちます）
```console
cd $NODE_HOME
./relay-topology_pull.sh
```
ノード再起動
```console
sudo systemctl reload-or-restart cardano-node
```
    
2-4. gLiveViewで新BPとリレーの双方向の疎通(I/O)ができているかを確認します。

gLiveView確認
```console
cd $NODE_HOME/scripts
./gLiveView.sh
```

2-5. 新BPのキー設定を行う為、旧BPのノードを停止します。また、旧BPのノードが絶対に起動しないようにVPS管理コンソールからサーバーを停止しておきます。

`旧BP`

ノードを停止します。また、次の作業でサーバーを停止しますが、万が一サーバーが再起動してしまった際も考慮し、自動起動をオフにしておきます。
```console
sudo systemctl stop cardano-node
sudo systemctl disable cardano-node
```
> 旧BPのノードが絶対に起動しないようにVPS管理コンソールからサーバーを停止しておいてください。

- ここで**旧BPとリレーとの接続が切れます。**

以下のファイルを旧BPのcnodeディレクトリから新BPのcnodeディレクトリにコピーします。

| ファイル名 | 用途 |
:----|:----
| vrf.skey | ブロック生成に必須 |
| vrf.vkey | ブロック生成に必須 |
| kes.skey | ブロック生成に必須 |
| kes.vkey | KES公開鍵 |
| node.cert | ブロック生成に必須 |
| payment.addr | 残高確認で必要 |
| stake.addr | 残高確認で必要 |
| poolMetaData.json | pool.cert作成時に必要 |
| poolMetaDataHash.txt | pool.cert作成時に必要 |
| startBlockProducingNode.sh | ノード起動スクリプト |
> その他のファイルを移動するならしておいてください。過去のブロック生成履歴については、後々ステークプールブロックログ導入手順の途中( [過去のブロック生成実績取得](https://docs.spojapanguild.net/setup/10-blocklog-setup/#10-6) )で取得できます。


`新BP`

2-6. VRFキーのパーミッションを変更します。
```console
chmod 400 vrf.skey
chmod 400 vrf.vkey
chmod +x startBlockProducingNode.sh
```

2-7. ノードを再起動します。
```console
sudo systemctl reload-or-restart cardano-node
```
ノードログ確認
```console
journalctl --unit=cardano-node --follow
```

2-8. `gLiveView.sh`を起動して「Txが増加しているか」、「上段表示がRelayではなくCoreに変わっているか」を確認します。

gLiveView確認
```console
cd $NODE_HOME/scripts
./gLiveView.sh
```

2-9. `params.json`を再作成します。

`新BP`
```console
cd $NODE_HOME
cardano-cli query protocol-parameters \
    --mainnet \
    --out-file params.json
```

2-10. エアギャップマシンにて`stakepoolid_bech32.txt`と`stakepoolid_hex.txt`を生成し、新BPのcnodeディレクトリにコピーします。

`エアギャップマシン`
```console
chmod u+rwx $HOME/cold-keys
cardano-cli stake-pool id --cold-verification-key-file $HOME/cold-keys/node.vkey --output-format bech32 > stakepoolid_bech32.txt
cardano-cli stake-pool id --cold-verification-key-file $HOME/cold-keys/node.vkey --output-format hex > stakepoolid_hex.txt
chmod a-rwx $HOME/cold-keys
```

2-11. ブロックログの設定をします。

- [ステークプールブロックログ導入手順](https://docs.spojapanguild.net/setup/10-blocklog-setup/)

2-12. ブロックが生成できる状態にあるかどうか、`SPO JAPAN GUILD TOOL`でチェックします。

- [SPO JAPAN GUILD TOOL](https://docs.spojapanguild.net/operation/tool/#spo-japan-guild-tool)

2-13. ブロック生成を確認したら、旧BPのバックアップ(スナップショット)を取得し、インスタンスは不要なので削除します。
<details>
<summary>何らかの事情で、旧BPを再稼働したい場合(IP接続のとき）</summary>
<div>
    
新BPのノードを停止します。
    
`新BP`
```console
sudo systemctl stop cardano-node
```
    
新BPのノードが自動起動しないように設定します。また、新BPが絶対に起動しないように、コンソールで停止しておきます。

`新BP`
```console
sudo systemctl disable cardano-node
```
        
旧BPをコンソールで起動し、自動起動する設定をします。
    
`旧BP`
```console
sudo systemctl enable cardano-node
```

旧BPのノードを起動します。
    
`旧BP`
 ```console
sudo systemctl start cardano-node
```
    
</div>
</details>
2-14. リレーにて`relay-topology_pull.sh`に設定している旧BPの情報を削除した後、トポロジーファイルの更新をし、ノード再起動します。

`リレー`
```console
cd $NODE_HOME
./relay-topology_pull.sh
```
ノード再起動
```console
sudo systemctl reload-or-restart cardano-node
```
ノードログ確認
```console
journalctl --unit=cardano-node --follow
```
gLiveView確認
```console
cd $NODE_HOME/scripts
./gLiveView.sh
```
> DNSベースで接続している人は、DNSのAレコードの変更が反映されたらIPをDNSに書き換えます。

2-15. Prometheus、Grafanaの設定

- 新BPにて`prometheus node exporter`をインストールします。

`新BP`
```console
sudo apt install -y prometheus-node-exporter
```

サービスを有効にして、自動的に開始されるように設定します。
```console
sudo systemctl enable prometheus-node-exporter.service
```

- Grafanaを搭載しているサーバにて`prometheus.yml`内のBPIPを旧BPのIPから新BPのIP変更し、サービス再起動します。
> DNSベースで接続している人は、DNSの変更が反映されたら自動的に切り替わるのでこの作業は不要です。

`Grafanaを搭載しているサーバ`
```console:prometheus.yml
sudo nano /etc/prometheus/prometheus.yml
```
> 定義ファイルを書き換え、保存して閉じます。

サービス再起動
```console
sudo systemctl restart grafana-server.service
sudo systemctl restart prometheus.service
sudo systemctl restart prometheus-node-exporter.service
```

サービスが正しく実行されていることを確認します。
```console
sudo systemctl --no-pager status grafana-server.service prometheus.service prometheus-node-exporter.service
```

ノードを再起動し設定ファイルを有効化します。

`Grafanaを搭載しているサーバ/BP`

ノードを再起動
```console
sudo systemctl reload-or-restart cardano-node
```
ノードログ確認
```console
journalctl --unit=cardano-node --follow
```

`Grafana`

Grafanaダッシュボードのメトリクスを旧BPのIPから新BPのIPに書き換えてください。

---
### 補足
- Txの増加が確認できたらTracemempoolを無効にします。

`新BP`
```console
sed -i $NODE_HOME/${NODE_CONFIG}-config.json \
    -e "s/TraceMempool\": true/TraceMempool\": false/g"
```

- ブロック生成ステータス通知セットアップ

旧BPで[ブロック生成ステータス通知](https://docs.spojapanguild.net/setup/11-blocknotify-setup/#_1)を設定されていた方は設定し直しておくとよいでしょう。

---
### 執筆・編集

元ネタ執筆/校正：[AICHI/TOKAI Stake Pool](https://adapools.org/pool/970e9a7ae4677b152c27a0eba3db996b372de094d24fc2974768f3da)
見やすく編集/改良：[WYAM-StakePool](https://adapools.org/pool/940d6893606290dc6b7705a8aa56a857793a8ae0a3906d4e2afd2119)

また、作成に当たっては以下の方々のご助言もいただきました！
- BTBFさん
- sakakibaraさん
- でーちゃん
- Daikonさん
- conconさん

こちらの手順で不備がありましたら今後のコミュニティのためにAichiまたはWYAMにDMなどで教えていただけると幸いです。（不備が無かったら、「無かったです！」と一報いただけると、自分の投稿に自信が持てますので、無くても教えていただけると幸いです）
