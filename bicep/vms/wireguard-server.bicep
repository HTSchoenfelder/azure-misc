param location string = resourceGroup().location
param vmName string

module wireguardServer '../modules/ubuntu-vm.bicep' = {
  name: 'wireguardServer'
  params: {
    vmName: vmName
    location: location
    adminUsername: 'henrik'
    sshKeyResourceName: '${vmName}-key'
    ubuntuOSVersion: 'Ubuntu-2204'
    vmSize: 'Standard_B1ls'
    virtualNetworkName: 'vNet'
    subnetName: 'Subnet'
    networkSecurityGroupName: 'SecGroupNet'
    securityType: 'TrustedLaunch'
    publicIPAllocationMethod: 'Static'
    additionalSecurityRules: [
      {
        name: 'WireGuard'
        properties: {
          priority: 2000
          protocol: 'Udp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '51820'
        }
      }
    ]
    // scriptUris : [
    //   {
    //     uri: 'https://raw.githubusercontent.com/hwdsl2/wireguard-install/master/wireguard-install.sh'
    //     parameters: [
    //       '--auto'    
    //     ]
    //   }
    // ]    
  }
}

output sshCommand string = wireguardServer.outputs.sshCommand
