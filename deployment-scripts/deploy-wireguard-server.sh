#!/bin/bash

resourceGroupName="wireguard-server"
vmName="wireguard-server"
bicepFile="../bicep/vms/wireguard-server.bicep"

./deploy-vm.sh "$resourceGroupName" "$vmName" "$bicepFile"


# Todo: Deploy with Script Extension

# For now, use the following commands to install WireGuard on the VM

# curl -O https://raw.githubusercontent.com/hwdsl2/wireguard-install/master/wireguard-install.sh
# sudo bash wireguard-install.sh
