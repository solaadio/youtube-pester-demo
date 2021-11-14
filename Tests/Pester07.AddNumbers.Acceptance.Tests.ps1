<#
.SYNOPSIS
Runs the AddNumbers Acceptance tests

.DESCRIPTION
Runs the AddNumbers Acceptance tests

.EXAMPLE
Pester07.AddNumbers.Acceptance.Tests.ps1

#>

Import-Module ..\Resources\PowerShellScripts\DemoModule.psm1 -Force

Describe "Addition Acceptance Tests" -Tag "Acceptance" {

    Context "when both parameters are used" {
        BeforeDiscovery {
            $numbersBothParams = @()
            for ($i = 1; $i -le 100; $i++) {
                $input1 = $i + $i + 1
                $input2 = $i + 37 - 2
                $answer = $($input1 + $input2)
                $numbersBothParams += @{number1 = $input1; number2 = $input2; expected = $answer }
            }
        }
        It "<number1> plus <number2> should Return <expected>" -ForEach @(
            @{ number1 = 1; number2 = 2; expected = 3 }
        ) {
            AddNumbers -number1 $number1 -number2 $number2 | Should -Be $expected
        }

        It "<number1> plus <number2> should Return <expected>" -ForEach @($numbersBothParams) {
            AddNumbers -number1 $number1 -number2 $number2 | Should -Be $expected
        }

    }

    Context "when one parameter is used" {
        BeforeDiscovery {
            $numbersOneParam = @()
            for ($i = 1; $i -le 100; $i++) {
                $input1 = $i + $i + 1
                $answer = $($input1 + 2)
                $numbersOneParam += @{number1 = $input1; expected = $answer }
            }
        }
        It "number1 = <number1> should Return (<number1> + 2) = <expected>" -ForEach @(
            @{ number1 = 1; expected = 3 }
        ) {
            AddNumbers -number1 $number1 | Should -Be $expected
        }

        It "number1 = <number1> should Return (<number1> + 2) = <expected>" -ForEach @($numbersOneParam) {
            AddNumbers -number1 $number1 | Should -Be $expected
        }
    }
}