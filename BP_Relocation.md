# BPの移設手順（旧VPS会社→新VPS会社）
- サーバー選定について
カルダノは最も分散化されたネットワークでセキュリティ向上を目指しており、世界中に分散されたノードネットワークの形成が、カルダノにとって最も重要になります。

このことから、「おすすめのサーバー(VPS)業者」の情報共有は行っておりませんので、各自で選定をお願い致します。
- AWS EC2及びlightsailは想定していません。

#### サーバースペック要件
推奨構成
| 項目 | 要件 |
|:-------------|:------------|
| OS | 64-bit Linux (Ubuntu 20.04 LTS) |
| CPU | 2Ghz以上 4コアのIntelまたはAMD x86プロセッサー |
| メモリ | 16GB |
| ストレージ | 256GB以上 |
| ネットワーク | 100Mbps |

---

- VPSガチャの為のリマセラ(お好みで)
自分のサーバーのCPU情報の確認
```
grep 'model name' /proc/cpuinfo | uniq
```
- もしくは
```
cat /proc/cpuinfo | grep -E "physical id|cpu cores|siblings|processor|model name" | sort | uniq
```
`出力例`
```
cpu cores       : 4 ←1個の物理CPUに搭載されている"物理"コア数
model name      : Intel(R) Core(TM) i5-8257U CPU @ 1.40GHz ←　型名CPU
physical id     : 0 ←物理CPU（1個目）
physical id     : 1 ←物理CPU（2個目）
processor       : 0 ←論理プロセッサ（＝合計論理コア数：1個目）
processor       : 1 ←論理プロセッサ（＝合計論理コア数：2個目）
processor       : 2 ←論理プロセッサ（＝合計論理コア数：3個目）
processor       : 3 ←論理プロセッサ（＝合計論理コア数：4個目）
processor       : 4 ←論理プロセッサ（＝合計論理コア数：5個目）
processor       : 5 ←論理プロセッサ（＝合計論理コア数：6個目）
processor       : 6 ←論理プロセッサ（＝合計論理コア数：7個目）
processor       : 7 ←論理プロセッサ（＝合計論理コア数：8個目）
siblings        : 4 ←1個の物理CPUに搭載されている"論理"コア数
```

# [ 新BPシステム設定 ]
## ホスト名設定(お好みで)
- 設定確認
```
sudo hostnamectl
```

- ホスト名を恒久的に変更
```
sudo hostnamectl set-hostname [新しいホスト名]
```

- 補足　ホスト名は「/etc/hostname」というファイルで管理しています。「hostnamectl」で設定すると、「/etc/hostname」に反映され、永続的に変更できます。

## 1- Ubuntu初期設定

1-1. 以下のリンク先を参照し実施します。

[Ubuntu初期設定](https://docs.spojapanguild.net/setup/1-ubuntu-setup/#0-3)

---

## 2- Cabal/GHCインストール 〜 gLiveViewのインストール

2-1. 以下のリンク先を参照し「gLiveViewのインストール」まで実施します。

[Cabal/GHCインストール](https://docs.spojapanguild.net/setup/2-node-setup/#2-1-cabalghc)

---

旧BPのmainnet-topology.json、mainnet-config.jsonを新BPに上書きコピーし、新BPのノードを再起動する。

念の為、新BPでブロック生成確認できるまで旧BPとの疎通を残しておく。
`Relayのrelay-topology_pull.sh`
- IOHKノード情報の後に "|" で区切って旧BPの「IPアドレス:ポート番号:Valency の形式」で追加。
```
（例）|relays-new.cardano-mainnet.iohk.io:3001:2|relay1-eu.xstakepool.com:3001:1|00.000.000.00:3001:1|aaa.aaa.aaa.aaa:XXXX:X
```

- gLiveViewで新BPとリレーの双方向の疎通(I/O)ができているかを確認する。

- 新BPのキー設定を行う。
　1. 旧BPのノードを停止する。また、旧BPのノードが絶対に起動しないようにサーバーを停止する。
　2. 以下のファイルを旧BPから新BPにコピーする。

| ファイル名 | 用途 |
|:-------------|:------------|
| vrf.skey | ブロック生成に必須 |
| vrf.vkey | ブロック生成に必須 |
| kes.skey | ブロック生成に必須 |
| node.cert | ブロック生成に必須 |
| payment.addr | 残高確認で必要 |
| stake.addr | 残高確認で必要 |
| poolMetaData.json | pool.cert作成時に必要 |
| poolMetaDataHash.txt | pool.cert作成時に必要 |
| startBlockProducingNode.sh | ノード起動スクリプト |
| stakepoolid.txt | 登録VRFの確認時に必要 |
- その他必要ファイルを移動するならしておく。

- 新BPでparams.jsonを再作成する
```
cd $NODE_HOME
cardano-cli query protocol-parameters \
    --mainnet \
    --out-file params.json
```

- VRFキーのパーミッションを変更
```
chmod 400 vrf.skey
chmod 400 vrf.vkey
chmod +x startBlockProducingNode.sh
```

- 新BPのノードを再起動する。

- gLiveView.shを起動して「Txが増加しているか」「上段表示がRelayではなくCoreに変わっているか」を確認する。

- その他、ブロックが生成できる状態にあるかどうか、チェックシートでチェック。

- ブロックログの設定

- ブロック生成を確認したら、旧BPのバックアップ(スナップショット)を取得後、インスタンスを削除。

- `Relayのrelay-topology_pull.sh`に設定している旧BPの情報を削除した後、実行、ノード再起動。
- Prometheus,Grafanaの設定…prometheus.ymlおよびGrafana内のメトリックの旧BPのIPを新BPのIPに書き換える



cat > $NODE_HOME/startBlockProducingNode.sh << EOF
#!/bin/bash
DIRECTORY=$NODE_HOME
PORT=6000
HOSTADDR=0.0.0.0
TOPOLOGY=\${DIRECTORY}/${NODE_CONFIG}-topology.json
DB_PATH=\${DIRECTORY}/db
SOCKET_PATH=\${DIRECTORY}/db/socket
CONFIG=\${DIRECTORY}/${NODE_CONFIG}-config.json
/usr/local/bin/cardano-node run --topology \${TOPOLOGY} --database-path \${DB_PATH} --socket-path \${SOCKET_PATH} --host-addr \${HOSTADDR} --port \${PORT} --config \${CONFIG}
EOF





cat > $NODE_HOME/startBlockProducingNode.sh << EOF
#!/bin/bash
DIRECTORY=$NODE_HOME
PORT=6000
HOSTADDR=0.0.0.0
TOPOLOGY=\${DIRECTORY}/${NODE_CONFIG}-topology.json
DB_PATH=\${DIRECTORY}/db
SOCKET_PATH=\${DIRECTORY}/db/socket
CONFIG=\${DIRECTORY}/${NODE_CONFIG}-config.json
KES=\${DIRECTORY}/kes.skey
VRF=\${DIRECTORY}/vrf.skey
CERT=\${DIRECTORY}/node.cert
/usr/local/bin/cardano-node run --topology \${TOPOLOGY} --database-path \${DB_PATH} --socket-path \${SOCKET_PATH} --host-addr \${HOSTADDR} --port \${PORT} --config \${CONFIG} --shelley-kes-key \${KES} --shelley-vrf-key \${VRF} --shelley-operational-certificate \${CERT}
EOF
