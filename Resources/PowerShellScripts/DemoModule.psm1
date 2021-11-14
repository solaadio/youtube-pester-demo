function Get-Something {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string] $ThingToGet = "something"
    )

    Write-Output "I got $ThingToGet!"
}

function New-Thing {
    "Thing"
}

function AddNumbers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int] $number1 = 2,
        [Parameter(Mandatory=$false)]
        [int] $number2 = 2
    )

    $number1 + $number2
}

function SubtractNumbers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int] $number1 = 0,
        [Parameter(Mandatory=$false)]
        [int] $number2 = 0
    )

    $number1 - $number2
}