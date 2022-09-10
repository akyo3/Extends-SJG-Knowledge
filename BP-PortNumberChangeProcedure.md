# BPポート番号変更手順

## BPポート番号を変更する理由
なぜ6000ポートが割り当てられているかと言うと、CNTOOLデフォルトで6000ポートが割り当てられていて、こちらに合わせる形でCoin cashewのマニュアルも6000になっており、6000ポートは「x window system」に割り当てられてるポートですが、使わなければ使っても大丈夫となっています。  ただし、BPポート=6000という認識が広まっていくと、セキュリティ上、良くないためです。

### 変更点
1. ダイナミックポート(49513～65535までの番号)を使います。
2. $NODE_HOME/`startBlockProducingNode.sh`のPORT=6000を変更するポート番号へと書き換えます。
3. $NODE_HOME/scripts/`env`のCNODE_PORT=6000を変更するポート番号へと書き換えます。

### BPにて実施
BPノードポート番号を決める為、xxxxxを以下の範囲内で選択して入力します。
> 49513～65535の範囲
```console
PORT=xxxxx
```
```console
sed -i $NODE_HOME/startBlockProducingNode.sh \
    -e '1,73s!PORT=6000!PORT='${PORT}'!'
sed -i $NODE_HOME/scripts/env \
    -e '1,73s!CNODE_PORT=6000!CNODE_PORT='${PORT}'!'
```

### ufw設定変更（リレーが２台ある想定）

> 山かっこ<>は不要です
```console
sudo ufw status numbered
sudo ufw delete <削除したい番号>
sudo ufw allow from <リレー１> to any port 49513
sudo ufw allow from <リレー２> to any port 49513
sudo ufw reload
```

ノード再起動
```console
sudo systemctl reload-or-restart cardano-node
```

### 変更確認
- BPポートがきちんと変更されたかを確認します。
> 戻り値の --port を確認します。
```console
ps aux | grep cardano-node
```

- BPノードを再起動後、各サービスが正常稼働していることも併せて確認しておきます。

> logmonitorは、20秒後に遅延起動。blockcheckサービスを導入している場合のコマンドも併せて記載してます。
```console
tmux a -t cncli
tmux a -t leaderlog
tmux a -t logmonitor
tmux a -t validate
tmux a -t blockcheck
```

<details>
<summary>補足</summary>

<div>

サービス再起動コマンド
```console
sudo systemctl reload-or-restart cnode-cncli-sync.service
```
ブロックチェック再起動コマンド
```console
sudo systemctl reload-or-restart cnode-blockcheck.service
```

デタッチ方法
```
Ctrl + b → d
```

</div>

</details>

### リレーにて実施
疎通確認
> port [tcp/*] succeeded! であればOKです。
```console
nc -vz <BPIP> 49513
```

$NODE_HOME/`relay-topology_pull.sh`のBLOCKPRODUCING_PORT=6000を変更したポート番号へと書き換えます。

> トポロジー共有のため別ファイルを自身で作成している場合は、そちらでも忘れずにポート番号を変更しておいてください。
> xxxxxは、BPノードポート番号を入力します。
```console
PORT=xxxxx
```
```console
sed -i $NODE_HOME/relay-topology_pull.sh \
    -e '1,10s!BLOCKPRODUCING_PORT=6000!BLOCKPRODUCING_PORT='${PORT}'!'
```

トポロジーファイルの更新をします。
```console
cd $NODE_HOME
./relay-topology_pull.sh
```

ノード再起動します。
```console
sudo systemctl reload-or-restart cardano-node
```

BPポートを確認します。
```console
cat $NODE_HOME/mainnet-topology.json
```
