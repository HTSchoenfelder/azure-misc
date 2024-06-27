#!/bin/bash

resourceGroupName="rg-bck-env1-vrp-eun"
vmName="runner-vm"
bicepFile="../bicep/vms/default-vm.bicep"

./deploy-vm.sh "$resourceGroupName" "$vmName" "$bicepFile"