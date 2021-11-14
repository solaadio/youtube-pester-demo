<#
.SYNOPSIS
Runs the Sample tests

.DESCRIPTION
Runs the Sample tests to demonstrate discovery and run phases

.EXAMPLE
Pester00.Sample.Tests.ps1
#>

BeforeDiscovery {
    Write-Host "Before Discovery, this is to set stuff up that we may need to inject into the Describe"
}
Describe "d"  -Tag "DontRun" {
    BeforeDiscovery {
        Write-Host "Before Discovery inside the Describe"
    }
    Write-Host "We are finding tests in this describe."
    BeforeAll {
        Write-Host "Before All tests"
    }
    BeforeEach {
        Write-Host "Before Each test"
    }
    AfterAll {
        Write-Host "After All tests"
    }
    AfterEach {
        Write-Host "After Each test"
    }
    Context "Context 1"{
        BeforeDiscovery {
            Write-Host "Before Discovery inside context 1"
        }
        Write-Host "We are finding tests in this context."
        It "1" {
            Write-Host "I am running test 1!"
        }
        It "2" {
            Write-Host "I am running test 2!"
        }
        Write-Host "We are leaving context 1"
    }
    Context "Context 2"{
        BeforeDiscovery {
            Write-Host "Before Discovery inside context 2"
        }
        Write-Host "We are finding tests in this context."
        It "3" {
            Write-Host "I am running test 3!"
        }
        It "4" {
            Write-Host "I am running test 4!"
        }
        Write-Host "We are leaving context 2"
    }
    Write-Host "We are leaving this describe."
}
Write-Host "We are done with discovery but no tests have been run yet!"