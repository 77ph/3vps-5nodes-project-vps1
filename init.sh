cp ~/workspace/quorum-maker/vps1-3/genesis.json ./
cp ~/workspace/quorum-maker/vps1-3/bootnode.key ./
cp ~/workspace/quorum-maker/vps1-3/enode.txt ./

for nodeName in node11 node12 node13 node14 node15
do
	echo "This is: ${nodeName}"
	rm -rf ${nodeName}	
	mkdir -p ${nodeName}/qdata/logs
        mkdir -p ${nodeName}/qdata/keystore
        mkdir -p ${nodeName}/keys

        cp ~/workspace/quorum-maker/vps1-3/keys/${nodeName}*.key  ${nodeName}/keys
        cp ~/workspace/quorum-maker/vps1-3/keys/${nodeName}*.pub  ${nodeName}/keys
        
        cp ~/workspace/quorum-maker/vps1-3/keys/${nodeName}BM  ${nodeName}/qdata/keystore/${nodeName}BM
            
        cp ~/workspace/quorum-maker/vps1-3/keys/${nodeName}V ${nodeName}/qdata/keystore/${nodeName}V

        geth --datadir ${nodeName}/qdata init genesis.json

        cp ~/workspace/quorum-maker/vps1-3/setup/${nodeName}.conf ${nodeName}-tmp.conf

        cp ~/workspace/quorum-maker/vps1-3/setup/start_${nodeName}.sh start_${nodeName}.sh

        chmod +x start_${nodeName}.sh
done
