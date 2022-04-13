## ノード停止
```
sudo systemctl stop cardano-node
```

## ノード起動
```
sudo systemctl start cardano-node
```

## ノード再起動
```
sudo systemctl reload-or-restart cardano-node
```

## サーバ再起動
### 補足
- ノード停止してから実施しましょう。
```
sudo reboot
```

## プロセス確認
### 補足
- カルダノノードサービス
```
ps aux | grep cardano-node
```

## ネットワーク確認
```
networkctl status -a
```

## ネットワーク疎通確認
```
nc -vz <IP> <Port>
```

## 各サービス再起動
### 補足
- (cncli leaderlog validate logmonitor)
```
sudo systemctl reload-or-restart cnode-cncli-sync.service
```

## ブロックチェックサービス再起動
```
sudo systemctl reload-or-restart cnode-blockcheck.service
```

## パラメータファイル更新
### 補足
- バックアップ及び更新、確認
```
cd $NODE_HOME
mv params.json params-v*.json
cardano-cli query protocol-parameters \
    --mainnet \
    --out-file params.json
```
````nano params.json````
