#!/bin/bash
cd $HOME
sudo tee swapoff /swapfile
sudo tee rm /swapfile
sudo tee fallocate -l 8G /swapfile
sudo tee chmod 600 /swapfile
sudo tee mkswap /swapfile
sudo tee swapon /swapfile
sudo tee swapon --show
sudo tee cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
cat /proc/sys/vm/vfs_cache_pressure
cat /proc/sys/vm/swappiness
