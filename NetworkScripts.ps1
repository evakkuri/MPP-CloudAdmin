Get-AzureRmVM

Get-AzureRmNetworkInterface -ResourceGroupName "SERVER2012R2-RG" -Name "server-01927"

$NIC = Get-AzureRmNetworkInterface -Name "server-01927" -ResourceGroupName "SERVER2012R2-RG"

$NIC.IpConfigurations[0].PrivateIpAllocationMethod = "Static"

$NIC.IpConfigurations[0].PrivateIpAddress = "10.0.0.50"

Set-AzureRmNetworkInterface -NetworkInterface $NIC

Get-AzureRmVM -Name "SERVER-01" -ResourceGroupName “SERVER2012R2-RG” | Stop-AzureRmVM