<#
.SYNOPSIS
Toggle app authentication

.DESCRIPTION
Toggle app authentication

.PARAMETER ResourceGroup
The name of the resource group that contains the APIM instnace

.PARAMETER FunctionAppName
The name of the function app

.PARAMETER Toggle
Toggle

.EXAMPLE
Toggle-AppAuthentication -ResourceGroup dfc-foo-bar-rg -FunctionAppName functionApp -Toggle true

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [String]$ResourceGroup,
    [Parameter(Mandatory=$true)]
    [String]$FunctionAppName,
    [Parameter(Mandatory=$true)]
    [bool]$Toggle
)

try {
    az webapp auth update -g $ResourceGroup -n $FunctionAppName --enabled $Toggle

    $AADappId = $(az ad app list --display-name $FunctionAppName --query [].appId -o tsv)
    Write-Host "##vso[task.setvariable variable=FunctionAppId]$($AADappId)"
    Write-Output "##vso[task.setvariable variable=FunctionAppId]$($AADappId)"
}
catch {
   throw $_
}