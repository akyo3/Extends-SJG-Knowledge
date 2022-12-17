maintenance.shは、システム更新、トポロジーファイルの更新をしています。
```console
cd $NODE_HOME
curl -s -o maintenance.sh https://raw.githubusercontent.com/akyo3/Extends-SJG-Knowledge/main/script/maintenance.sh
chmod 755 maintenance.sh 
echo alias mt='"./maintenance.sh"' >> $HOME/.bashrc
source $HOME/.bashrc
mt
```
