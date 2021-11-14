<#
.SYNOPSIS
Runs the Pester tests

.DESCRIPTION
Sets up the tests and runs them

.PARAMETER TestsPath
[Mandatory] Path to the test files

.PARAMETER Publish
[Optional] switch to decide whether to publish results or not

.PARAMETER ResultsPath
[Mandatory] Path to the test results file.

.PARAMETER TestResultsFile
[Mandatory] Name of the test results file.

.PARAMETER Tag
[Mandatory] Name of the Tag

.PARAMETER Verbosity
[Mandatory] Verbosity of the results

.EXAMPLE
Pester.ps1 -TestsPath $(System.DefaultWorkingDirectory)\${{ parameters.TestsPath }} -ResultsPath $(System.DefaultWorkingDirectory)\${{ parameters.ResultsPath }} -Publish -TestResultsFile ${{ parameters.TestResultsFile }} -Tag 'Quality' -Verbosity 'Diagnostic'

#>

param (
    [Parameter(Mandatory = $true)]
    [string]
    $TestsPath,

    [Parameter(Mandatory = $false)]
    [switch]
    $Publish,

    [Parameter(Mandatory=$true)]
    [string]
    $ResultsPath,

    [Parameter(Mandatory=$true)]
    [string]
    $TestResultsFile,

    [Parameter(Mandatory=$true)]
    [string]
    $Tag,

    [Parameter(Mandatory=$false)]
    [string]
    $Verbosity = 'Detailed'

)

$pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
if (!$pesterModule) {
    try {
        Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -MinimumVersion "5.0"
        $pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
    }
    catch {
        Write-Error "Failed to install the Pester module."
    }
}

Write-Host "Pester version: $($pesterModule.Version.Major).$($pesterModule.Version.Minor).$($pesterModule.Version.Build)"
$pesterModule | Import-Module

Import-Module -Name .\Resources\PowerShellScripts\DemoModule.psm1 -Verbose

if ($Publish) {
    if (!(Test-Path -Path $ResultsPath)) {
        New-Item -Path $ResultsPath -ItemType Directory -Force | Out-Null
    }
}

# Write-Host "Fetching tests files"
$Tests = (Get-ChildItem -Path $($TestsPath) -Recurse | Where-Object {$_.Name -like "*.Tests.ps1"}).FullName

$Params = [ordered]@{
    Path = $Tests;
}

$Container = New-PesterContainer @Params

$Configuration = [PesterConfiguration]@{
    Run          = @{
        Container = $Container
    }
    Output       = @{
        Verbosity = $Verbosity
    }
    Filter = @{
        Tag = $Tag
    }
    TestResult   = @{
        Enabled      = $true
        OutputFormat = "NUnitXml"
        OutputPath   = "$($ResultsPath)\$($TestResultsFile)"
    }
    Should = @{
        ErrorAction = 'Continue'
    }
}

if ($Publish) {
    Invoke-Pester -Configuration $Configuration
}
else {
    Invoke-Pester -Container $Container -Output Detailed
}