## CNCLIのリビルド（Ubuntu22.04の場合）

- 依存関係の追加とアップデート
```console
sudo apt update -y && sudo apt install -y automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf musl-tools
```

- Rustパッケージアップデート
```console
rustup update
rustup target add x86_64-unknown-linux-musl
```

- インストール
```console
cd $HOME/git/cncli
git fetch --all --prune
git checkout $(curl -s https://api.github.com/repos/cardano-community/cncli/releases/latest | jq -r .tag_name)
cargo install --path . --force
```

- CNCLIのバージョンを確認します。
```console
cncli --version
```
> cncli 5.3.2 が最新バージョンです

## SendTip設定

- envファイルを修正します
```console
sed -i $NODE_HOME/scripts/env \
  -e '1,73s!#CNODEBIN="${HOME}/.local/bin/cardano-node"!CNODEBIN="/usr/local/bin/cardano-node"!'
```

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
cat > $NODE_HOME/service/cnode-cncli-pt-sendtip.service << EOF 
# file: /etc/systemd/system/cnode-cncli-pt-sendtip.service

[Unit]
Description=Cardano Node - CNCLI PT sendtip
BindsTo=cnode-cncli-sync.service
After=cnode-cncli-sync.service

[Service]
Type=oneshot
RemainAfterExit=yes
Restart=on-failure
RestartSec=20
User=$(whoami)
WorkingDirectory=$NODE_HOME/scripts
ExecStart=/bin/bash -c "sleep 25;/usr/bin/tmux new -d -s ptsendtip"
ExecStartPost=/usr/bin/tmux send-keys -t ptsendtip ./cncli.sh Space ptsendtip Enter
ExecStop=/usr/bin/tmux kill-session -t ptsendtip
KillSignal=SIGINT
RestartKillSignal=SIGINT
SuccessExitStatus=143
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=cnode-cncli-pt-sendtip
TimeoutStopSec=5

[Install]
WantedBy=cnode-cncli-sync.service
EOF
```

- サービスファイルをコピーして、有効化と起動をします。
```console
sudo cp $NODE_HOME/service/cnode-cncli-pt-sendtip.service /etc/systemd/system/cnode-cncli-pt-sendtip.service
sudo chmod 644 /etc/systemd/system/cnode-cncli-pt-sendtip.service
sudo systemctl daemon-reload
sudo systemctl enable cnode-cncli-pt-sendtip.service
sudo systemctl start cnode-cncli-pt-sendtip.service
```
