# PoolToolと連携

詳しくは以下参照。  
> CNCLI Toolタブ  
[Integrating with PoolTool](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-iii-operation/configuring-slot-leader-calculation) (PoolToolとの統合)  
> PoolToolは、ステーク・プールの以下のデータを送信するためのサンプル・スクリプトを提供します。  
> - 現在のブロックの高さ

[Sugar](https://twitter.com/sugar417K)さんの次のサイトがとても参考になりました。ありがとうございます！
[cardano-kb](https://sugar-stake-pool.gitbook.io/cardano-kb/tools/pooltool)

## 1.pooltool.json作成
```console
PORT=`grep "PORT=" $NODE_HOME/startBlockProducingNode.sh`
b_PORT=${PORT#"PORT="}
echo "BPポートは${b_PORT}です"
```

```console
cat > $NODE_HOME/scripts/pooltool.json << EOF
{
    "api_key": "<UPDATE WITH YOUR API KEY FROM POOLTOOL PROFILE PAGE>",
    "pools": [
        {
            "name": "<UPDATE TO MY POOL TICKER>",
            "pool_id": "$(cat ${NODE_HOME}/stakepoolid_hex.txt)",
            "host" : "127.0.0.1",
            "port": $(echo ${b_PORT})
        }
    ]
}
EOF
```

## 2.API_KeyとTickerNameを編集します。
```
nano $NODE_HOME/scripts/pooltool.json
```

## 3.サービスファイル作成
```console
cat > $NODE_HOME/service/cncli-sendtip.service << EOF
# file: /etc/systemd/system/cncli-sendtip.service

[Unit]
Description=CNCLI Sendtip
After=multi-user.target

[Service]
Type=simple
Restart=always
RestartSec=5
LimitNOFILE=131072
ExecStart=${HOME}/.cargo/bin/cncli sendtip --cardano-node /usr/local/bin/cardano-node --config ${NODE_HOME}/scripts/pooltool.json
KillSignal=SIGINT
SuccessExitStatus=143
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=cncli-sendtip

[Install]
WantedBy=multi-user.target
EOF
```

## 4.サービスファイルをコピーして、有効化と起動をします。
```
sudo cp $NODE_HOME/service/cncli-sendtip.service /etc/systemd/system/cncli-sendtip.service
```
```
sudo chmod 644 /etc/systemd/system/cncli-sendtip.service
```
```
sudo systemctl daemon-reload
```
```
sudo systemctl enable cncli-sendtip.service
```
```
sudo systemctl start cncli-sendtip.service
```

## 5.確認

[pooltool.io](https://pooltool.io/) にて同期済みブロック高が緑色で表示されていたら成功です。

![同期済みブロック高](https://user-images.githubusercontent.com/80967103/175799326-885b1a52-98ff-4885-a165-2f7e16031cd5.png)
