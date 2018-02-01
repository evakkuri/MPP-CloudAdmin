# Select subscription
Select-AzureRmSubscription -SubscriptionName "Pay-As-You-Go"

# Declare variables
$VNetName = "VNet1"
$FESubName = "FrontEnd"
$BESubName = "Backend"
$GWSubName = "GatewaySubnet"
$VnetPrefix1 = "192.168.0.0/16"
$VnetPrefix2 = "10.254.0.0/16"
$FESubPrefix = "192.168.1.0/24"
$BESubPrefix = "10.254.1.0/24"
$GWSubPrefix = "192.168.200.0/26"
$VPNClientAddressPool = "172.16.201.0/24"
$RG = "TestRG"
$Location = "East US"
$DNS = "8.8.8.8"
$GWName = "GW"
$GWIPName = "GWIP"
$GWIPconfName = "gwipconf"
$P2SRootCertName = "ARMP2SRootCert.cer"

# Create resource group
New-AzureRmResourceGroup -Name $RG -Location $Location

# Create frontend subnet config
$fesub = New-AzureRmVirtualNetworkSubnetConfig `    -Name $FESubName `    -AddressPrefix $FESubPrefix# Create backend subnet config$besub = New-AzureRmVirtualNetworkSubnetConfig `    -Name $BESubName `    -AddressPrefix $BESubPrefix# Gateway subnet config$gwsub = New-AzureRmVirtualNetworkSubnetConfig `    -Name $GWSubName `    -AddressPrefix $GWSubPrefix# Create VNETNew-AzureRmVirtualNetwork `    -Name $VNetName `    -ResourceGroupName $RG `    -Location $Location `    -AddressPrefix $VnetPrefix1,$VnetPrefix2 `    -Subnet $fesub,$besub,$gwsub `    -DnsServer $DNS# Store VNET to variable$vnet = Get-AzureRmVirtualNetwork `    -Name $VNetName `    -ResourceGroupName $RG# Store gateway subnet$subnet = Get-AzureRmVirtualNetworkSubnetConfig `    -Name "GatewaySubnet" `    -VirtualNetwork $vnet# Request a public IP address for the VPN gateway$pip = New-AzureRmPublicIpAddress `    -Name $GWIPName `    -ResourceGroupName $RG `    -Location $Location `    -AllocationMethod Dynamic# Create gateway IP config$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig `    -Name $GWIPconfName `    -Subnet $subnet `    -PublicIpAddress $pip