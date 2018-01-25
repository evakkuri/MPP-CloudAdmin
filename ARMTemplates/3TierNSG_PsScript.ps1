# Subscription info
Get-AzureRmSubscription
get-azurermsubscription -SubscriptionID "701c646b-841a-4974-8e1f-d9ae841e83f7" | select-azurermsubscription

# Create blank network security group NSG-DB
New-AzureRMNetworkSecurityGroup -Name "NSG-DB" -Location "southcentralus" -ResourceGroupName "rg848301"

# Create NSG rules
$rule1 = New-AzureRmNetworkSecurityRuleConfig `
    -Name APP-DB `
    -Description "Allow APP to DB" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 300 `
    -SourceAddressPrefix 10.10.1.0/24 `
    -SourcePortRange * `
    -DestinationAddressPrefix 10.10.2.0/24 `
    -DestinationPortRange *

$rule2 = New-AzureRmNetworkSecurityRuleConfig `
    -Name DB-WFE `
    -Description "Deny DB to WFE" `
    -Access Deny `
    -Protocol Tcp `
    -Direction Outbound `
    -Priority 500 `
    -SourceAddressPrefix 10.10.2.0/24 `
    -SourcePortRange * `
    -DestinationAddressPrefix 10.10.0.0/24 `
    -DestinationPortRange *

$rule3 = New-AzureRmNetworkSecurityRuleConfig `
    -Name DB-APP `
    -Description "Allow DB to APP" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Outbound `
    -Priority 600 `
    -SourceAddressPrefix 10.10.2.0/24 `
    -SourcePortRange * `
    -DestinationAddressPrefix 10.10.1.0/24 `
    -DestinationPortRange *

$rule4 = New-AzureRmNetworkSecurityRuleConfig `
    -Name DB-Internet `
    -Description "Deny DB to Internet" `
    -Access Deny `
    -Protocol Tcp `
    -Direction Outbound `
    -Priority 601 `
    -SourceAddressPrefix 10.10.2.0/24 `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange *

# Add rules to NSG-DB

$nsg = New-AzureRmNetworkSecurityGroup `
    -ResourceGroupName "rg848301" `
    -Location "southcentralus" `
    -Name "NSG-DB" `
    -SecurityRules $rule1,$rule2,$rule3,$rule4 `
    -force

# Add NSG to DB subnet

$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName "rg848301" -Name LOB_Vnet # Get VNET ID

Set-AzureRmVirtualNetworkSubnetConfig `
    -VirtualNetwork $vnet `
    -Name DatabaseTierSubnet `
    -AddressPrefix 10.10.2.0/24 `
    -NetworkSecurityGroup $nsg