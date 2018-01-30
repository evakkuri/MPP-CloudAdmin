### Define Deployment Variables
{
    $location = 'southcentralus'
    $resourceGroupName = 'rg856073'
    $resourceDeploymentName = 'contoso-iaas-deployment'
    $templatePath = $env:SystemDrive + '\Users\LabUser\Documents\HOL_Lab_Files\2_Building_Azure_Resource_Manager_Infrastructure'
    $templateFile = 'ContosoIaaS.json'
    $template = $templatePath + '\' + $templateFile
    $password = "C0nts0sP@55"
    $securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
}

### Deploy Resources
{
    New-AzureRmResourceGroupDeployment `
        -Name $resourceDeploymentName `
        -ResourceGroupName $resourceGroupName `
        -TemplateFile $template `
        -Verbose -Force
}