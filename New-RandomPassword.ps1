<#
===========================================================================
 AUTHOR  : Andrew Shen  
 DATE    : 2018-03-08 
 VERSION : 1.1
===========================================================================

.SYNOPSIS
    Generate a random complex password

.DESCRIPTION
    Generate a random complex password at least 12 characters long with
    no symbols.
    
.PARAMETER Length
    The required length of the password.

    Default: 12
    Minimum: 4

.EXAMPLE
    New-RandomPassword -Length 8

#>

function New-RandomPassword {
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage="Enter minimum length of the password. Minimum 3")]
        [ValidateScript({$_ -ge 4})]
        [Int] $Length = 16,
        [Parameter(HelpMessage="Exclude symbols (e.g. @#$%)")]
        [Switch] $NoSymbols,
        [Parameter(HelpMessage="Exclude numbers (e.g. 123456)")]
        [Switch] $NoNumbers,
        [Parameter(HelpMessage="Exclude lowercahse characters (e.g. abcdefgh)")]
        [Switch] $NoLowercase,
        [Parameter(HelpMessage="Exclude uppercase characters (e.g. ABCDEFGH)")]
        [Switch] $NoUppercase,
        [Parameter(HelpMessage="Exclude similar characters (e.g. i, l, 1, L, o, 0, O)")]
        [Switch] $NoSimilarChars,
        [Parameter(HelpMessage="Exclude ambiguous characters ({ } [ ] ( ) / \ ' "" ` ~ , ; : . < >)")]
        [Switch] $NoAmbiguousChars
    )
    BEGIN {
        $set = @()
        $exclusions = @()
        ### Symbols ###
        if ($NoSymbols) {
        } else {
            $set += 33..47
            $set += 58..64
            $set += 91..96
            $set += 123..126
            #$set += 161..255
        }

        ### Numbers ###
        if ($NoNumbers) {
        } else {
            $set += 48..57
        }

        ### Lowercase ###
        if ($NoLowercase) {
        } else {
            $set += 97..122
        }

        ### Uppercase ###
        if ($NoUppercase) {
        } else {
            $set += 65..90
        }

        ### Similar Characters ###
        if ($NoSimilarChars) {
            $exclusions += 48,49,73,79,105,108,111,124
        }

        ### Ambiguous Characters ###
        if ($NoAmbiguousChars) {
            $exclusions += 34,39,40,41,44,46,47,58,59,60,62,91,92,93,96,123,125,126
        }

        if ($set.Count -eq 0) {
            Throw "There are no characters to create a password with. Try using less exclusions."
        }

    }
    PROCESS {

        $randomPassword
    }
}