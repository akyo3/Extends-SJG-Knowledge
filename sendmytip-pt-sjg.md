- sendmytip.shをダウンロードします。
```console
cd $NODE_HOME/scripts
wget https://raw.githubusercontent.com/papacarp/pooltool.io/master/sendmytip/shell/sendmytip.sh -O ./sendmytip.sh
```

- XXXは、PoolToolのAPI KEYに置き換えてください。
```console
PT_MY_API_KEY=XXX
```

- sendmytip.shファイルを修正します
```
pool_hex=`cat $NODE_HOME/stakepoolid_hex.txt`
printf "\nプールID(hex)は \e[32m${pool_hex}\e[m です\n\n"
```
```
sed -i $NODE_HOME/scripts/sendmytip.sh \
  -e '1,73s!PT_MY_POOL_ID="xxxx"!PT_MY_POOL_ID="'${pool_hex}'"!' \
  -e '1,73s!PT_MY_API_KEY="xxxx-xx-xx-xx-xxxx"!PT_MY_API_KEY="'${PT_MY_API_KEY}'"!' \
  -e '1,73s!LOG_FILE="/opt/cardano/cnode/logs/node0.json"!LOG_FILE="$NODE_HOME/logs/node.json"!' \
  -e '1,73s!export CARDANO_NODE_SOCKET_PATH="/opt/cardano/cnode/sockets/node0.socket"!export CARDANO_NODE_SOCKET_PATH="$NODE_HOME/db/socket"!'
```
