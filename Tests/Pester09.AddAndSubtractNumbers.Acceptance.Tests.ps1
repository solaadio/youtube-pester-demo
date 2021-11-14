<#
.SYNOPSIS
Runs the AddNumbers and SubtractNumbers Acceptance tests

.DESCRIPTION
Runs the AddNumbers and SubtractNumbers Acceptance tests

.EXAMPLE
Pester09.AddAndSubtractNumbers.Acceptance.Tests.ps1

#>

Import-Module ..\Resources\PowerShellScripts\DemoModule.psm1 -Force

Describe "Addition and Subtraction Acceptance Tests" -Tag "Acceptance" {
    Context "(number1 plus number2) - (number3 plus number4)" {
        BeforeDiscovery {
            $numbersAddAndSubtract = @()
            for ($i = 1; $i -le 100; $i++) {
                $input1 = 3 * ( $i + 1) + 3
                $input2 = $i + 37 - 2
                $answer1 = $($input1 + $input2)
                $input3 = $i + 24 - 2
                $input4 = $i + 1
                $answer2 = $($input3 + $input4)
                $finalAnswer = $($answer1 - $answer2)
                $numbersAddAndSubtract += @{number1 = $input1; number2 = $input2; number3 = $input3; number4 = $input4; answer1 = $answer1; answer2 = $answer2; finalAnswer = $finalAnswer }
            }
        }
        It "(<number1> plus <number2>) - (<number3> plus <number4>) should return <finalAnswer>" -ForEach @($numbersAddAndSubtract) {
            AddNumbers -number1 $number1 -number2 $number2 | Should -Be $answer1
            AddNumbers -number1 $number3 -number2 $number4 | Should -Be $answer2
            SubtractNumbers -number1 $answer1 -number2 $answer2 | Should -Be $finalAnswer
        }
    }
}