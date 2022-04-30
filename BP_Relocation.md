# BPの移設手順（旧VPS会社→新VPS会社）

<details>
<summary>サーバー選定について</summary>
カルダノは最も分散化されたネットワークでセキュリティ向上を目指しており、世界中に分散されたノードネットワークの形成が、カルダノにとって最も重要になります。
このことから、「おすすめのサーバー(VPS)業者」の情報共有は行っておりませんので、各自で選定をお願いいたします。
AWS EC2及びlightsailは想定していません。
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

### 前提注意事項
本まとめは現VPS会社→新VPS会社へと**BPのみ**を移行するまとめです。
実際に行う際には、**自己責任**でお願いします。
- 旧BPは「2-5. ~旧BPのノードを停止する。」まで、稼働させたままにしておいてください。

---

<details>
<summary>お好み設定</summary>
(実施するしないは、各自調べてお好みで)

- VPSガチャの為のリマセラ

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

- ホスト名設定
<div>

ホスト名を恒久的に変更:
<新しいホスト名>を変更したいホスト名へと変更。
```console
sudo hostnamectl set-hostname <新しいホスト名>
```

設定確認:
```console
sudo hostnamectl
```

補足:
ホスト名は「/etc/hostname」というファイルで管理しています。
「hostnamectl」で設定すると、「/etc/hostname」に反映され、永続的に変更できます。


</div>
</div>
</details>

---

## 1- Ubuntu初期設定

1-1. 以下のリンク先を参照し実施します。

- [Ubuntu初期設定](https://docs.spojapanguild.net/setup/1-ubuntu-setup/#0-3)
- さくらのパケットフィルタや、AWSのUFW設定など、サーバー独自の機能にも注意する。
- 旧BPのログインアカウント名（例えばubuntu）と新BPのログインアカウント名は変更しない方が良いです。もし変更する場合は、下記移行手順2-5にてstartBlockProducingNode.sh内の変数DIRECTORYのパス名を手動で変更してください。

```console
DIRECTORY=/home/<new account_name>/cnode
```
 
## 2- Cabal/GHCインストール 〜 gLiveViewのインストール

2-1. 以下のリンク先を参照し「gLiveViewのインストール」まで実施します。

- [Cabal/GHCインストール](https://docs.spojapanguild.net/setup/2-node-setup/#2-1-cabalghc)

2-2. 旧BPのmainnet-topology.json、mainnet-config.jsonを新BPに上書きコピーし、新BPのノードを再起動します。

`新BP`
```console
sudo systemctl reload-or-restart cardano-node
```
ノードログ確認
```console
journalctl --unit=cardano-node --follow
```

2-3. 念の為、新BPでブロック生成確認できるまで旧BPとの疎通を残しておきます。（2-14で旧BPの情報を削除します）

- IOHKノード情報の後に "|" で区切って旧BPの「IPアドレス:ポート番号:Valency の形式」で追加します。以下、例です。

<details>
<summary>DNSではなくIPで入力したほうがお勧めする理由</summary>
以下の２つのメリットから、精神的にゆとりがあるため。<br>
①DNSのAレコード変更のタイムラグを無くすことができる<br>
②ブロック生成に失敗した場合でも「新BPノードを停止し旧BPノードの再稼働」をするだけで元の状態に戻せる<br>
DNSのAレコードの変更は数分～数日かかります。2-14で書いてありますが、変更が反映されたら、IPをDNSに置き換えてください。
</details>
 
`リレー`
```console:relay-topology_pull.sh
|relays-new.cardano-mainnet.iohk.io:3001:2|relay1-eu.xstakepool.com:3001:1|00.000.000.00:3001:1|aaa.aaa.aaa.aaa:XXXX:X
```
- relay-topology_pull.shを実行し、リレーノードを再起動します。（2-4に進む前に、ノードが起動するまでしばらく待ちます）
```console
 cd $NODE_HOME
 ./relay-topology_pull.sh
 sudo systemctl reload-or-restart cardano-node
```
 
2-4. gLiveViewで新BPとリレーの双方向の疎通(I/O)ができているかを確認します。
```console
cd $NODE_HOME/scripts
./gLiveView.sh
```

2-5. 新BPのキー設定を行う為、旧BPのノードを停止します。また、旧BPのノードが絶対に起動しないようにVPS管理コンソールからサーバーを停止しておきます。
- ここで**旧BPとリレーとの接続が切れます。**

- [ ] 以下のファイルを旧BPから新BPにコピーします。

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
- その他のファイルを移動するならしておいてください。
- 過去のブロック生成履歴については、後々ブロックログの手順の途中で取得できます。
-  [ブロック生成履歴を取得](https://docs.spojapanguild.net/setup/10-blocklog-setup/#10-6)

2-6. 新BPでparams.jsonを再作成します。

`新BP`
```console
cd $NODE_HOME
cardano-cli query protocol-parameters \
    --mainnet \
    --out-file params.json
```

2-7.ステークプールIDを出力します。

- [プール登録確認](http://49.12.225.142:8000/setup/7-register-stakepool/?h=stakepoolid_hex.txt#4)

2-8. VRFキーのパーミッションを変更します。
```console
chmod 400 vrf.skey
chmod 400 vrf.vkey
chmod +x startBlockProducingNode.sh
```

2-9. ノードを再起動します。
```console
sudo systemctl reload-or-restart cardano-node
```
ノードログ確認
```console
journalctl --unit=cardano-node --follow
```

2-10. gLiveView.shを起動して「Txが増加しているか」、「上段表示がRelayではなくCoreに変わっているか」を確認します。
```console
cd $NODE_HOME/scripts
./gLiveView.sh
```

2-11. ブロックが生成できる状態にあるかどうか、SPO JAPAN GUILD TOOLでチェックします。

- [SPO JAPAN GUILD TOOL](https://docs.spojapanguild.net/operation/tool/#spo-japan-guild-tool)

2-12. ブロックログの設定をします。

- [ステークプールブロックログ導入手順](http://49.12.225.142:8000/setup/10-blocklog-setup/)

2-13. ブロック生成を確認したら、旧BPのバックアップ(スナップショット)を取得します。インスタンスは不要なので削除します。

2-14. リレーにて`relay-topology_pull.sh`に設定している旧BPの情報を削除した後、トポロジーファイルの更新をし、ノード再起動します。

`リレー`
```console
cd $NODE_HOME
./relay-topology_pull.sh
```
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
- DNSベースで接続している人は、DNSのAレコードの変更が反映されたらIPをDNSに書き換えます。
 
2-15. Prometheus,Grafanaの設定…prometheus.ymlおよびGrafana内のメトリックの旧BPのIPを新BPのIPに書き換えます。
- 新BPにて`prometheus node exporter`をインストールします。

` 新BP`
```console
sudo apt install -y prometheus-node-exporter
```

- サービスを有効にして、自動的に開始されるように設定します。
```console
sudo systemctl enable prometheus-node-exporter.service
```

- Grafanaを搭載しているサーバで`prometheus.yml` 内のBPIPを変更します。ただし、DNSベースで接続している人は、DNSの変更が反映されたら自動的に切り替わるのでこの作業は不要です。
 
- 変更後、サービス再起動します。

`Grafanaを搭載しているサーバ`
```console
sudo systemctl restart grafana-server.service
sudo systemctl restart prometheus.service
sudo systemctl restart prometheus-node-exporter.service
```

- サービスが正しく実行されていることを確認します。
```console
sudo systemctl --no-pager status grafana-server.service prometheus.service prometheus-node-exporter.service
```

- ノードを再起動し設定ファイルを有効化します。

`Grafanaを搭載しているサーバ/BP`
```console
sudo systemctl reload-or-restart cardano-node
```
ノードログ確認
```console
journalctl --unit=cardano-node --follow
```

---
- 補足:
Txの増加が確認できたらTracemempoolを無効にします。

`新BP`
```console
sed -i $NODE_HOME/${NODE_CONFIG}-config.json \
    -e "s/TraceMempool\": true/TraceMempool\": false/g"
```

---

執筆：[AICHI/TOKAI Stake Pool](https://adapools.org/pool/970e9a7ae4677b152c27a0eba3db996b372de094d24fc2974768f3da) 
編集：[WYAM Stake Pool](https://adapools.org/pool/940d6893606290dc6b7705a8aa56a857793a8ae0a3906d4e2afd2119)

また、作成に当たっては以下の方々のご助言もいただきました！
- BTBFさん
- sakakibaraさん
- でーちゃん
- Daikonさん
- conconさん
- こちらの手順で不備がありましたら今後のコミュニティのためにAichiまたはWYAMにDMなどで教えていただけると幸いです。（不備が無かったら、「無かったです！」と一方いただけると、自分の投稿に自信が持てますので、無くても教えていただけると幸いです）

