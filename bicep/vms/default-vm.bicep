param location string = resourceGroup().location
param vmName string

module defaultVm '../modules/ubuntu-vm.bicep' = {
  name: 'default-vm'
  params: {
    vmName: vmName
    location: location
    adminUsername: 'henrik'
    sshKeyResourceName: '${vmName}-key'
    ubuntuOSVersion: 'Ubuntu-2204'
    vmSize: 'Standard_B2s'
    virtualNetworkName: 'vNet'
    subnetName: 'Subnet'
    networkSecurityGroupName: 'SecGroupNet'
    securityType: 'TrustedLaunch'
    publicIPAllocationMethod: 'Static'
  }
}

output sshCommand string = defaultVm.outputs.sshCommand
