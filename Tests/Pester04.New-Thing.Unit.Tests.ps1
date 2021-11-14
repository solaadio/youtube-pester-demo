<#
.SYNOPSIS
Runs the New-Thing Unit tests

.DESCRIPTION
Runs the New-Thing Unit tests

.EXAMPLE
Pester04.New-Thing.Unit.Tests.ps1

#>

Import-Module ..\Resources\PowerShellScripts\DemoModule.psm1 -Force
Describe "New-Thing" -Tag "Unit" {
    Context "Thing" {
        It "should be of type string" {
            New-Thing | Should -BeOfType System.String
        }
        It "should return the real thing" {
            New-Thing | should -Be "Thing"
        }
        It "should return the fake thing" {
            Mock -CommandName New-Thing -MockWith { "FakeThing" }
            New-Thing | should -Be "FakeThing"
        }
        It "should return assert that it was called" {
            Mock -CommandName New-Thing -MockWith { "FakeThing" }
            New-Thing
            Should -Invoke New-Thing -Times 1
        }
    }
}