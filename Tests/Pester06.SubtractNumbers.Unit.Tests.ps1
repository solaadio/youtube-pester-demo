<#
.SYNOPSIS
Runs the SubtractNumbers Unit tests

.DESCRIPTION
Runs the SubtractNumbers Unit tests

.EXAMPLE
Pester06.SubtractNumbers.Unit.Tests.ps1

#>

Import-Module ..\Resources\PowerShellScripts\DemoModule.psm1 -Force

Describe "SubtractNumbers" -Tag "Unit" {
    Context "testing parameters" {
        It "should have a parameter named number1" {
            Get-Command SubtractNumbers | Should -HaveParameter number1 -Type Int
            Get-Command SubtractNumbers | Should -HaveParameter number1 -DefaultValue 0
            Get-Command SubtractNumbers | Should -HaveParameter number1 -Not -Mandatory
        }
        It "should have a parameter named number2" {
            Get-Command SubtractNumbers | Should -HaveParameter number2 -Type Int
            Get-Command SubtractNumbers | Should -HaveParameter number2 -DefaultValue 0
            Get-Command SubtractNumbers | Should -HaveParameter number2 -Not -Mandatory
        }
    }

    Context "when no parameters are used" {
        It "should return 0" {
            SubtractNumbers | Should -Be 0
        }

        It "should return an int" {
            SubtractNumbers | Should -BeOfType Int
        }
    }

    Context "when one parameter is used" {
        BeforeDiscovery{
            $number1 = 4
            Write-Output "setting number1 to $number1"
        }
        BeforeAll{
            $number1 = 4
            Write-Output "setting number1 to $number1"
        }
        It "$number1 minus default(0) should return $($number1-0)" {
            SubtractNumbers -number1 $number1 | Should -Be $number1
        }

        It "$number1 minus default(0) should return an int" {
            SubtractNumbers -number1 $number1 | Should -BeOfType Int
        }
    }

    Context "when both parameters are used" {
        BeforeDiscovery{
            $number1 = 14
            $number2 = 4
            Write-Output "setting number1 to $number1 and number2 to $number2"
        }
        BeforeAll{
            $number1 = 14
            $number2 = 4
            Write-Output "setting number1 to $number1 and number2 to $number2"
        }
        It "$number1 minus $number2 should return $($number1-$number2)" {
            SubtractNumbers -number1 $number1 -number2 $number2 | Should -Be $($number1-$number2)
        }

        It "$number1 minus $number2 should return an int" {
            SubtractNumbers -number1 $number1 -number2 $number2 | Should -BeOfType Int
        }
    }
}