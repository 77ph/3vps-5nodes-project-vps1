#!/bin/bash
set -u
set -e
NETID=87234


# BOOTNODE_KEYHEX=3f8fc62f6addd0b56d3cabdb79cc3bee348f8668647c27c5d4133e3b42abb64e

BOOTNODE_PORT=33445
CURRENT_NODE_IP=141.105.65.227
MAIN_NODE_IP=141.105.65.227
MAIN_C_PORT=9000
C_PORT=9000
R_PORT=22000
W_PORT=21000

echo 'CURRENT_IP='$CURRENT_NODE_IP 
echo 'RPC_PORT='$R_PORT 
echo 'WHISPER_PORT='$W_PORT 
echo 'CONSTELLATION_PORT='$C_PORT 
echo 'BOOTNODE_PORT='$BOOTNODE_PORT 
echo 'MASTER_IP='$MAIN_NODE_IP 
echo 'MASTER_CONSTELLATION_PORT='$MAIN_C_PORT 

BOOTNODE_ENODE=enode://1d86386962d720798e61991fefc9d138e4c8eaa09da270f1bc51791fb246a790a2790233af3304e5b7b951b42e81d2f4547c165d18d990221bc562dc9d727633@[$MAIN_NODE_IP]:$BOOTNODE_PORT

GLOBAL_ARGS="--bootnodes $BOOTNODE_ENODE --networkid $NETID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

echo "[*] Starting Constellation node" > node11/qdata/logs/node11.log

cp node11-tmp.conf node11.conf

PATTERN="s/#CURRENT_NODE_IP#/${CURRENT_NODE_IP}/g"
PATTERN2="s/#MAIN_NODE_IP#/${MAIN_NODE_IP}/g"
PATTERN3="s/#C_PORT#/${C_PORT}/g"
PATTERN4="s/#M_C_PORT#/${MAIN_C_PORT}/g"

sed -i "$PATTERN" node11.conf
sed -i "$PATTERN2" node11.conf
sed -i "$PATTERN3" node11.conf
sed -i "$PATTERN4" node11.conf

mv node11.conf ./node11/
cd ./node11/

nohup constellation-node node11.conf 2>> qdata/logs/node11.log &
sleep 1

echo "[*] Starting node11 node" >> qdata/logs/constellation_node11.log
echo "[*] geth --verbosity 6 --datadir qdata" $GLOBAL_ARGS" --rpcport "$R_PORT "--port "$W_PORT "--blockmakeraccount "0x93623082dccd9fe905c2cd9f4264d3cc040ebac6" --blockmakerpassword ""  --voteaccount "0xae2409376edbbfbaf9df05f434a3287f7e0caae1" --votepassword "" --minblocktime 2 --maxblocktime 5" >> qdata/logs/node11.log

PRIVATE_CONFIG=node11.conf nohup geth --verbosity 6 --datadir qdata $GLOBAL_ARGS --rpcport $R_PORT --port $W_PORT --blockmakeraccount "0x93623082dccd9fe905c2cd9f4264d3cc040ebac6" --blockmakerpassword ""  --voteaccount "0xae2409376edbbfbaf9df05f434a3287f7e0caae1" --votepassword "" --minblocktime 2 --maxblocktime 5 2>>qdata/logs/node11.log & 
cd ..

