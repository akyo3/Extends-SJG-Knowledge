# PoolToolと連携(現在のブロックの高さ)

詳しくは以下参照。  
> CNCLI Toolタブ  
[Integrating with PoolTool](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-iii-operation/configuring-slot-leader-calculation)

## 1.pooltool.json作成
```console
cat > $NODE_HOME/scripts/pooltool.json << EOF
{
    "api_key": "<UPDATE WITH YOUR API KEY FROM POOLTOOL PROFILE PAGE>",
    "pools": [
        {
            "name": "<UPDATE TO MY POOL TICKER>",
            "pool_id": "$(cat ${NODE_HOME}/stakepoolid_hex.txt)",
            "host" : "127.0.0.1",
            "port": "<BPNodePort>"
        }
    ]
}
EOF
```

## 2.API_KeyとTickerName、Portを編集します。
```
nano $NODE_HOME/scripts/pooltool.json
```

## 3.cncli-sendtip.serviceのサービスファイル作成
```console
cat > $NODE_HOME/service/cncli-sendtip.service << EOF
# file: /etc/systemd/system/cncli-sendtip.service

[Unit]
Description=CNCLI Sendtip
After=multi-user.target

[Service]
User=$USER
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
sudo systemctl enable cncli-sendtip.service
```
```
sudo systemctl start cncli-sendtip.service
```
