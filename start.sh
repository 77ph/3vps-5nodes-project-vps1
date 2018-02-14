#!/bin/bash
set -u
set -e
NETID=87234

B_PORT=33445
BOOTNODE_KEYHEX=3f8fc62f6addd0b56d3cabdb79cc3bee348f8668647c27c5d4133e3b42abb64e

mkdir -p node11/qdata/logs
LOCAL_NODE_IP="$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"

echo "[*] Starting bootnode"
bootnode --nodekeyhex "$BOOTNODE_KEYHEX" --addr="$LOCAL_NODE_IP:$B_PORT" 2>node11/qdata/logs/bootnode.log &
echo "wait for bootnode to start..."
sleep 3
echo "Bootnode started"

./start_node11.sh
./start_node12.sh
./start_node13.sh
./start_node14.sh
./start_node15.sh
