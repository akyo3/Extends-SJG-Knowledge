#!/bin/bash
# Note, I'm using "echo 1", because using "echo 3" is not recommended in production.
# VPSでは使用できそうにないです。 別案を検討します。
echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null
