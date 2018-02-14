#!/bin/bash
set -u
set -e
NETID=87234


BOOTNODE_PORT=33445
CURRENT_NODE_IP=141.105.65.227
MAIN_NODE_IP=141.105.65.227
MAIN_C_PORT=9000
C_PORT=9001
R_PORT=22001
W_PORT=21001

echo 'CURRENT_IP='$CURRENT_NODE_IP 
echo 'RPC_PORT='$R_PORT 
echo 'WHISPER_PORT='$W_PORT 
echo 'CONSTELLATION_PORT='$C_PORT 
echo 'BOOTNODE_PORT='$BOOTNODE_PORT 
echo 'MASTER_IP='$MAIN_NODE_IP 
echo 'MASTER_CONSTELLATION_PORT='$MAIN_C_PORT 


BOOTNODE_ENODE=enode://1d86386962d720798e61991fefc9d138e4c8eaa09da270f1bc51791fb246a790a2790233af3304e5b7b951b42e81d2f4547c165d18d990221bc562dc9d727633@[$MAIN_NODE_IP]:$BOOTNODE_PORT

GLOBAL_ARGS="--bootnodes $BOOTNODE_ENODE --networkid $NETID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

echo "[*] Starting Constellation node" > node12/qdata/logs/node12.log


cp node12-tmp.conf node12.conf

PATTERN="s/#CURRENT_NODE_IP#/${CURRENT_NODE_IP}/g"
PATTERN2="s/#MAIN_NODE_IP#/${MAIN_NODE_IP}/g"
PATTERN3="s/#C_PORT#/${C_PORT}/g"
PATTERN4="s/#M_C_PORT#/${MAIN_C_PORT}/g"

sed -i "$PATTERN" node12.conf
sed -i "$PATTERN2" node12.conf
sed -i "$PATTERN3" node12.conf
sed -i "$PATTERN4" node12.conf

mv node12.conf ./node12/
cd ./node12/

nohup constellation-node node12.conf 2>> qdata/logs/node12.log &
sleep 1

echo "[*] Starting node12 node" >> qdata/logs/constellation_node12.log
echo "[*] geth --verbosity 6 --datadir qdata" $GLOBAL_ARGS" --rpcport "$R_PORT "--port "$W_PORT "--blockmakeraccount "0x21bdb18ca5e098d9dd5f4c3ff9e0428f2028ca3e" --blockmakerpassword ""  --voteaccount "0x6bdac73e2695678ff17a8438b27a21531c1d4141" --votepassword "" --minblocktime 2 --maxblocktime 5" >> qdata/logs/node12.log

PRIVATE_CONFIG=node12.conf nohup geth --verbosity 6 --datadir qdata $GLOBAL_ARGS --rpcport $R_PORT --port $W_PORT --blockmakeraccount "0x21bdb18ca5e098d9dd5f4c3ff9e0428f2028ca3e" --blockmakerpassword ""  --voteaccount "0x6bdac73e2695678ff17a8438b27a21531c1d4141" --votepassword "" --minblocktime 2 --maxblocktime 5 2>>qdata/logs/node12.log &

cd ..

