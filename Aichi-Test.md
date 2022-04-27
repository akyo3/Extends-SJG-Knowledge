# 見出し1
- 項目1
- 項目2
## 見出し2
- 項目1
- 項目2
### 見出し3
#### 見出し4
 - 表の追加
| 項目 | 要件 |
|:-------------|:------------|
| OS | 64-bit Linux (Ubuntu 20.04 LTS) |
| CPU | 2Ghz以上 4コアのIntelまたはAMD x86プロセッサー |
| メモリ | 16GB |
| ストレージ | 256GB以上 |
| ネットワーク | 100Mbps |

# BPの移設手順（旧VPS会社→新VPS会社）
- サーバー選定について
カルダノは最も分散化されたネットワークでセキュリティ向上を目指しており、世界中に分散されたノードネットワークの形成が、カルダノにとって最も重要になります。

このことから、「おすすめのサーバー(VPS)業者」の情報共有は行っておりませんので、各自で選定をお願い致します。
- **AWS EC2及びlightsailは想定していません。**

## 前提
本まとめは現VPS会社⇨新VPS会社へとBPのみを移行するまとめです。
ただし実際に行う際には、**自己責任**でお願いします。
旧BPは〜まで、稼働させたままにしておいてください。

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

---

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

---

## 1- Ubuntu初期設定

1-1. 以下のリンク先を参照し実施します。

[Ubuntu初期設定](https://docs.spojapanguild.net/setup/1-ubuntu-setup/#0-3)

---

## 2- Cabal/GHCインストール 〜 gLiveViewのインストール

2-1. 以下のリンク先を参照し「gLiveViewのインストール」まで実施します。

[Cabal/GHCインストール](https://docs.spojapanguild.net/setup/2-node-setup/#2-1-cabalghc)

---

2-2. 旧BPのmainnet-topology.json、mainnet-config.jsonを新BPに上書きコピーし、新BPのノードを再起動する。

---

2-3. 念の為、新BPでブロック生成確認できるまで旧BPとの疎通を残しておく。
`Relayのrelay-topology_pull.sh`
- IOHKノード情報の後に "|" で区切って旧BPの「IPアドレス:ポート番号:Valency の形式」で追加。
`（例）`
```
|relays-new.cardano-mainnet.iohk.io:3001:2|relay1-eu.xstakepool.com:3001:1|00.000.000.00:3001:1|aaa.aaa.aaa.aaa:XXXX:X
```

---

2-4. gLiveViewで新BPとリレーの双方向の疎通(I/O)ができているかを確認する。

---

2-5. 新BPのキー設定を行う。(ここで旧BPとリレーとの接続が切れます。)

---

2-6. 旧BPのノードを停止する。また、旧BPのノードが絶対に起動しないようにVPS管理コンソールからサーバーを停止する。

---

2-7. 以下のファイルを旧BPから新BPにコピーする。

| ファイル名 | 用途 |
:----|:----
| vrf.skey | ブロック生成に必須 |
| vrf.vkey | ブロック生成に必須 |
| kes.skey | ブロック生成に必須 |
| kes.vkey | kesKey |
| node.cert | ブロック生成に必須 |
| payment.addr | 残高確認で必要 |
| stake.addr | 残高確認で必要 |
| poolMetaData.json | pool.cert作成時に必要 |
| poolMetaDataHash.txt | pool.cert作成時に必要 |
| startBlockProducingNode.sh | ノード起動スクリプト |
| stakepoolid.txt | 登録VRFの確認時に必要 |
- その他必要ファイルを移動するならしておく。

---

2-8. 新BPでparams.jsonを再作成する
```
cd $NODE_HOME
cardano-cli query protocol-parameters \
    --mainnet \
    --out-file params.json
```

---

2-9. VRFキーのパーミッションを変更
```
chmod 400 vrf.skey
chmod 400 vrf.vkey
chmod +x startBlockProducingNode.sh
```

---

2-10. 新BPのノードを再起動する。
```
sudo systemctl reload-or-restart cardano-node
```

---

2-11. gLiveView.shを起動して「Txが増加しているか」「上段表示がRelayではなくCoreに変わっているか」を確認する。

---

2-12. ブロックが生成できる状態にあるかどうか、SPO JAPAN GUILD TOOLでチェックする。

[SPO JAPAN GUILD TOOL](https://docs.spojapanguild.net/operation/tool/#spo-japan-guild-tool)

---

2-13. ブロックログの設定

[ステークプールブロックログ導入手順](http://49.12.225.142:8000/setup/10-blocklog-setup/)

---

2-14. 手順１５の「BPノード」の設定を行う。 (忘れたので調べる)

---

2-15. ブロック生成を確認したら、旧BPのバックアップ(スナップショット)を取得後、インスタンスを削除。

---

2-16. Relayにて`relay-topology_pull.sh`に設定している旧BPの情報を削除した後、実行、ノード再起動。
```
sudo systemctl reload-or-restart cardano-node
```

---

2-17. Prometheus,Grafanaの設定…prometheus.ymlおよびGrafana内のメトリックの旧BPのIPを新BPのIPに書き換える。

- BPの`prometheus node exporter`をインストールします。
```
sudo apt install -y prometheus-node-exporter
```

- サービスを有効にして、自動的に開始されるように設定します。
```
sudo systemctl enable prometheus-node-exporter.service
```

- Grafanaを搭載しているサーバで`prometheus.yml` 内のBPIPを変更してください。

- 以下、サービス再起動。
```
sudo systemctl restart grafana-server.service
sudo systemctl restart prometheus.service
sudo systemctl restart prometheus-node-exporter.service
```

- サービスが正しく実行されていることを確認します。
```
sudo systemctl --no-pager status grafana-server.service prometheus.service prometheus-node-exporter.service
```

- ノードを再起動し設定ファイルを有効化します。

`Grafanaを搭載しているサーバ/BP`
```
sudo systemctl reload-or-restart cardano-node
```

まだ書き途中です。
