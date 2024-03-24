#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

cd $NODE_HOME
./relay-topology_pull.sh

function ask_yes_no {
  while true; do
    echo -n "$* [y/n]: "
    read ANS
    case $ANS in
      [Yy]*)
        return 0
        ;;  
      [Nn]*)
        return 1
        ;;
      *)
        echo "yまたはnを入力してください"
        ;;
    esac
  done
}

if ask_yes_no "ノード再起動します。よろしいですか？"; then
  sudo systemctl reload-or-restart cardano-node
  echo "> ノードを再起動しました"
  journalctl --unit=cardano-node --follow
else
  echo "> 設定を更新したら再起動が必要ですので、後ほど実施してください"
  exit
fi
