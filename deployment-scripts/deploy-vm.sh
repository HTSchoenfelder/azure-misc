#!/bin/bash

resourceGroupName=$1
vmName=$2
bicepFile=$3

if [ "$#" -ne 3 ]; then
    echo "Error: Exactly three arguments are required (resource group name, VM name, and parameter file)."
    exit 1
fi

if [ -z "$resourceGroupName" ] || [ -z "$vmName" ]; then
    echo "Error: Arguments must not be empty."
    exit 1
fi

if [ ! -f "$bicepFile" ]; then
    echo "Error: Parameter file '$bicepFile' does not exist."
    exit 1
fi

if [ $(az group exists --name $resourceGroupName) = false ]; then
    echo "Creating '$resourceGroupName'"
    az group create --name $resourceGroupName --location westeurope
fi

if az sshkey list --resource-group "$resourceGroupName" | grep -q "$vmName-key"; then
    echo "SSH-Key resource $vmName-key already exists."
else
    output=$(az sshkey create --name "$vmName-key" --resource-group "$resourceGroupName" 2>&1)
    privateKeyPath=$(echo "$output" | grep -oP '(?<=Private key is saved to ").*(?=")')
    publicKeyPath="$privateKeyPath.pub"
    newPrivateKeyPath="${privateKeyPath%/*}/$vmName-key.pem"
    mv "$privateKeyPath" "$newPrivateKeyPath"
    rm "$publicKeyPath"
fi

timestamp=$(date +%s)

deploymentOutput=$(az deployment group create \
    --name "deployment-$vmName-$timestamp" \
    --resource-group $resourceGroupName \
    --template-file $bicepFile \
    --parameters vmName=$vmName)

sshCommand=$(echo "$deploymentOutput" | jq -r '.properties.outputs.sshCommand.value')
completeSshCommand="$sshCommand -i ~/.ssh/$vmName-key.pem"
chmod 600 ~/.ssh/$vmName-key.pem

echo "$completeSshCommand"
