<#
.SYNOPSIS
Runs the SubtractNumbers Acceptance tests

.DESCRIPTION
Runs the SubtractNumbers Acceptance tests

.EXAMPLE
Pester08.SubtractNumbers.Acceptance.Tests.ps1

#>

Import-Module ..\Resources\PowerShellScripts\DemoModule.psm1 -Force

Describe "Subtraction Acceptance Tests" -Tag "Acceptance" {
    Context "when both parameters are used" {
        BeforeDiscovery {
            $numbersBothParams = @()
            for ($i = 1; $i -le 100; $i++) {
                $input1 = $i + 37 - 2
                $input2 = $i + $i + 1
                $answer = $($input1 - $input2)
                $numbersBothParams += @{number1 = $input1; number2 = $input2; expected = $answer }
            }
        }
        It "<number1> minus <number2> should return <expected>" -ForEach @(
            @{ number1 = 81; number2 = 2; expected = 79 }
        ) {
            SubtractNumbers -number1 $number1 -number2 $number2 | Should -Be $expected
        }

        It "<number1> minus <number2> should return <expected>" -ForEach @($numbersBothParams) {
            SubtractNumbers -number1 $number1 -number2 $number2 | Should -Be $expected
        }
    }

    Context "when one parameter is used" {
        BeforeDiscovery {
            $numbersOneParam = @()
            for ($i = 1; $i -le 100; $i++) {
                $input1 = $i + $i + 1
                $answer = $($input1 - 0)
                $numbersOneParam += @{number1 = $input1; number2 = $input2; expected = $answer }
            }
        }
        It "number1 = <number1> should return <expected>" -ForEach @(
            @{ number1 = 5; expected = 5 }
        ) {
            SubtractNumbers -number1 $number1 | Should -Be $expected
        }

        It "number1 = <number1> should return <expected>" -ForEach @($numbersOneParam) {
            SubtractNumbers -number1 $number1 | Should -Be $expected
        }
    }
}