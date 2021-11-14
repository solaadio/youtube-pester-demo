<#
.SYNOPSIS
Runs the AddNumbers Unit tests

.DESCRIPTION
Runs the AddNumbers Unit tests

.EXAMPLE
Pester05.AddNumbers.Unit.Tests.ps1

#>

Import-Module ..\Resources\PowerShellScripts\DemoModule.psm1 -Force

Describe "AddNumbers" -Tag "Unit" {
    Context "testing parameters" {
        It "should have a parameter named number1" {
            Get-Command AddNumbers | Should -HaveParameter number1 -Type Int
            Get-Command AddNumbers | Should -HaveParameter number1 -DefaultValue 2
            Get-Command AddNumbers | Should -HaveParameter number1 -Not -Mandatory
        }
        It "should have a parameter named number2" {
            Get-Command AddNumbers | Should -HaveParameter number2 -Type Int
            Get-Command AddNumbers | Should -HaveParameter number2 -DefaultValue 2
            Get-Command AddNumbers | Should -HaveParameter number2 -Not -Mandatory
        }
    }

    Context "when no parameters are used" {
        It "should return 4" {
            AddNumbers | Should -Be 4
        }

        It "should return an int" {
            AddNumbers | Should -BeOfType Int
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
        It "$number1 plus default(2) should return $($number1+2)" {
            AddNumbers -number1 $number1 | Should -Be 6
        }

        It "$number1 plus default(2) should return an int" {
            AddNumbers -number1 $number1 | Should -BeOfType Int
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
        It "$number1 plus $number2 should return $($number1+$number2)" {
            AddNumbers -number1 $number1 -number2 $number2 | Should -Be $($number1+$number2)
        }

        It "$number1 plus $number2 should return an int" {
            AddNumbers -number1 $number1 -number2 $number2 | Should -BeOfType Int
        }
    }
}