# BPポート番号変更手順

- 変更する理由：
なぜ6000ポートが割り当てられているかと言うと、CNTOOLデフォルトで6000ポートが割り当てられていて、こちらに合わせる形でCoin cashewのマニュアルも6000になっている。6000ポートは「x window system」に割り当てられてるポートですが、使わなければ使っても大丈夫となっているが、BPポート=6000という認識が広まっていくと、セキュリティ上は良くない。</br>

1. ダイナミックポート(49513～65535までの番号)を使う。
2. $NODE_HOME/startBlockProducingNode.shのPORT=6000を変更するポート番号へと書き換える。
3. $NODE_HOME/scripts/envのCNODE_PORT=6000を変更するポート番号へと書き換える。

## 前提条件
以下はポート番号を`49513`とする場合
山かっこ<>は不要です。

## BPにて実施
```
sed -i $NODE_HOME/startBlockProducingNode.sh \
    -e '1,73s!PORT=6000!PORT=49513!'
sed -i $NODE_HOME/scripts/env \
    -e '1,73s!CNODE_PORT=6000!CNODE_PORT=49513!'
```

## ufw設定変更（リレーが２台ある想定）
```
sudo ufw status numbered
sudo ufw delete <削除したい番号>
sudo ufw allow from <リレー１> to any port 49513
sudo ufw allow from <リレー２> to any port 49513
sudo ufw reload
```

- ノード再起動
```
sudo systemctl reload-or-restart cardano-node
```

## 変更確認
- BPポートがきちんと変更されたかを確認する。
戻り値の--port を確認する。
```
ps aux | grep cardano-node
```

- BPノードを再起動後、各サービスが正常稼働していることも併せて確認しておきます。（logmonitorは、20秒後に遅延起動。blockcheckサービスを導入している場合のコマンドも併せて記載してます。）
```
tmux a -t cncli
tmux a -t leaderlog
tmux a -t logmonitor
tmux a -t validate
tmux a -t blockcheck
```

### 補足
- サービス再起動コマンド
```
sudo systemctl reload-or-restart cnode-cncli-sync.service
```
- ブロックチェック再起動コマンド
```
sudo systemctl reload-or-restart cnode-blockcheck.service
```

- デタッチ方法
Ctrl + b → d

## リレーにて実施
- 疎通確認：port [tcp/*] succeeded! であること。
```
nc -vz <BPIP> 49513
```

- $NODE_HOME/relay-topology_pull.sh
BLOCKPRODUCING_PORT=6000を変更したポート番号へと書き換える。
(トポロジー共有のため別ファイルを自身で作成している場合は、そちらのポート番号変更を忘れずに)
```
sed -i $NODE_HOME/relay-topology_pull.sh \
    -e '1,10s!BLOCKPRODUCING_PORT=6000!BLOCKPRODUCING_PORT=49513!'
```

- 編集後に以下を実行
```
cd $NODE_HOME
./relay-topology_pull.sh
```

トポロジーファイルを再作成してからノード再起動
```
sudo systemctl reload-or-restart cardano-node
```

- BPポートを確認する。
```
cat $NODE_HOME/mainnet-topology.json
```
