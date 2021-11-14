<#
.SYNOPSIS
Create app authentication

.DESCRIPTION
Create app authentication

.PARAMETER ResourceGroup
The name of the resource group that contains the APIM instnace

.PARAMETER FunctionAppName
The name of the function app

.EXAMPLE
Create-AppAuthentication -ResourceGroup dfc-foo-bar-rg -FunctionAppName

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String]$ResourceGroup,
    [Parameter(Mandatory = $true)]
    [String]$FunctionAppName
)

try {

    Write-Verbose "Getting FQDN"
    $WebAppFDQN = $(az webapp show -n $FunctionAppName -g $ResourceGroup --query "defaultHostName" --out tsv);


    $AADsuffix = "/.auth/login/aad/callback" # AD Online is hardcoded to redirect to this path!!
    $urls = "https://$($WebAppFDQN)$($AADsuffix)";

    $AADappName = $FunctionAppName

    Write-Verbose "Checking if appId exists"
    $appCheck = az ad app list --display-name $AADappName | ConvertFrom-Json
    $appExists = $appCheck.Length -gt 0
    if (!$appExists) {

        Write-Verbose "appId doesnt exist, so creatinbg a new one"
        az ad app create --display-name $AADappName --homepage="https://$($WebAppFDQN)" --reply-urls $urls --oauth2-allow-implicit-flow true

    }

    Write-Verbose "Get appp id"
    $AADappId = $(az ad app list --display-name $AADappName --query [].appId -o tsv)
    $MSGraphAPI = "00000003-0000-0000-c000-000000000000" #UID of Microsoft Graph
    $Permission = "e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope" # ID: Read permission, Type: Scope

    # Write-Verbose "Create associated service principal"
    # az ad sp create --id $AADappId

    Write-Verbose "set app permission"
    az ad app permission add --id $AADappId --api $MSGraphAPI --api-permissions $Permission
    az ad app permission grant --id $AADappId --api $MSGraphAPI

    Write-Verbose "Get appp id"
    $AADappId = $(az ad app list --display-name $AADappName --query [].appId -o tsv)
    Write-Verbose "Update webapp auth"
    az webapp auth update -g $ResourceGroup -n $FunctionAppName --enabled true --action LoginWithAzureActiveDirectory --aad-client-id $AADappId  --aad-allowed-token-audiences "https://$($WebAppFDQN)" --token-store true --aad-token-issuer-url "https://sts.windows.net/2107104e-d4f3-468b-9202-8451051cc80a"


    $AADappId = $(az ad app list --display-name $AADappName --query [].appId -o tsv)
    Write-Host "##vso[task.setvariable variable=FunctionAppId]$($AADappId)"
    Write-Output "##vso[task.setvariable variable=FunctionAppId]$($AADappId)"

}
catch {
    throw $_
}