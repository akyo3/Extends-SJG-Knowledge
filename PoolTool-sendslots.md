- XXXは、PoolToolのAPI KEYに置き換えてください。
```console
PT_API_KEY=XXX
```

- cncli.shファイルを修正します
```console
PORT=`grep "PORT=" $NODE_HOME/startBlockProducingNode.sh`
b_PORT=${PORT#"PORT="}
echo "BPポートは${b_PORT}です"
```
```console
sed -i $NODE_HOME/scripts/cncli.sh \
-e '1,73s!#PT_API_KEY=""!PT_API_KEY="'${PT_API_KEY}'"!' \
-e '1,73s!#POOL_TICKER=""!POOL_TICKER="'$(echo `jq -r '.ticker' $NODE_HOME/poolMetaData.json`)'"!' \
-e '1,73s!#PT_HOST="127.0.0.1"!PT_HOST="127.0.0.1"!' \
-e '1,73s!#PT_PORT="${CNODE_PORT}"!PT_PORT="'${b_PORT}'"!' \
-e '1,73s!#PT_SENDSLOTS_START=30!PT_SENDSLOTS_START=30!' \
-e '1,73s!#PT_SENDSLOTS_STOP=60!PT_SENDSLOTS_STOP=60!' \
-e '1,73s!#SLEEP_RATE=60!SLEEP_RATE=60!'
```

- サービスファイル作成・登録
```console
cat > $NODE_HOME/service/cnode-cncli-pt-sendslots.service << EOF 
# file: /etc/systemd/system/cnode-cncli-pt-sendslots.service

[Unit]
Description=Cardano Node - CNCLI PT sendslots
BindsTo=cnode-cncli-sync.service
After=cnode-cncli-sync.service

[Service]
Type=oneshot
RemainAfterExit=yes
Restart=on-failure
RestartSec=20
User=$(whoami)
WorkingDirectory=$NODE_HOME/scripts
ExecStart=/bin/bash -c "sleep 25;/usr/bin/tmux new -d -s ptsendslots"
ExecStartPost=/usr/bin/tmux send-keys -t ptsendslots ./cncli.sh Space ptsendslots Enter
ExecStop=/usr/bin/tmux kill-session -t ptsendslots
KillSignal=SIGINT
RestartKillSignal=SIGINT
SuccessExitStatus=143
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=cnode-cncli-pt-sendslots
TimeoutStopSec=5

[Install]
WantedBy=cnode-cncli-sync.service
EOF
```

- サービスファイルをコピーして、有効化と起動をします。
```console
sudo cp $NODE_HOME/service/cnode-cncli-pt-sendslots.service /etc/systemd/system/cnode-cncli-pt-sendslots.service
sudo chmod 644 /etc/systemd/system/cnode-cncli-pt-sendslots.service
sudo systemctl daemon-reload
sudo systemctl enable cnode-cncli-pt-sendslots.service
sudo systemctl start cnode-cncli-pt-sendslots.service
```
