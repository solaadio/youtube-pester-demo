<#
.SYNOPSIS
Runs the Code Quality tests

.DESCRIPTION
Runs the Code Quality tests

.EXAMPLE
Pester02.Code.Quality.Tests.ps1
#>

BeforeDiscovery {
    $files = New-Object System.Collections.Generic.List[System.Object]
    $files += Get-ChildItem -Path $PSScriptRoot\..\*.psm1 -File -Recurse
    $files += Get-ChildItem -Path $PSScriptRoot\..\*.ps1 -File -Recurse
    Write-Host "File count discovered for Code quality Tests: $($files.Count)"
}
Describe "Code quality tests" -ForEach @($files) -Tag "Quality" {

    BeforeDiscovery {
        $ScriptName = $_.FullName
        Write-Output "Script name: $($ScriptName)"
        $ExcludeRules = @(
            "PSUseSingularNouns",
            "PSAvoidUsingWriteHost",
            "PSAvoidUsingEmptyCatchBlock",
            "PSAvoidUsingPlainTextForPassword",
            "PSAvoidUsingConvertToSecureStringWithPlainText",
            "PSUseShouldProcessForStateChangingFunctions"
        )
        Write-Output "Exclude Rules Count: $($ExcludeRules.Count)"
        $Rules = Get-ScriptAnalyzerRule
        Write-Output "Rules Count: $($Rules.Count)"
    }

    Context "Code Quality Test $ScriptName" -Foreach @{scriptName = $scriptName; rules = $Rules; excludeRules = $ExcludeRules } {
        It "Should pass Script Analyzer rule '<_>'" -ForEach @($Rules) {
            $Result = Invoke-ScriptAnalyzer -Path $($scriptName) -IncludeRule $_ -ExcludeRule $ExcludeRules
            $Result.Count | Should -Be 0
        }
    }
}