<#
===========================================================================
 AUTHOR  : Andrew Shen  
 DATE    : 2018-03-08 
 VERSION : 1.1
===========================================================================

.SYNOPSIS
    Generate a random complex password

.DESCRIPTION
    Generate a random complex password at least 16 characters long with
    no symbols.
    
.PARAMETER Length
    The required length of the password.

    Default: 16
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
        [Parameter(HelpMessage="Enter complexity requirement. Minimum 1 - Maximum 4")]
        [ValidateScript({$_ -ge 1})]
        [Int] $Completxity = 4,
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
        [Parameter(HelpMessage="Exclude ambiguous characters (e.g. { } [ ] ( ) / \ ' "" ` ~ , ; : . < >)")]
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
            $exclusions += 34,39,40,41,44,46,47,58,59,60,62,76,91,92,93,96,123,125,126
        }

        if ($set.Count -eq 0) {
            Throw "There are no characters to create a password with. Try using less exclusions."
        }

        if ($exclusions.Count -gt 0) {
            foreach ($character in $exclusions) {
                $set = $set -ne $character
            }
        }

    }
    PROCESS {
        do {
            $randomPassword = $null
            $d = 0
            for ($i=1; $i -le $Length; $i++) {
                $c = $set | Get-Random
                $randomPassword += [char][byte]$c
            }
            Write-Verbose $randomPassword            
            if ($randomPassword -match "[^a-zA-Z0-9]") { $d++ }
            if ($randomPassword -match "[0-9]") { $d++ }
		    if ($randomPassword -cmatch "[a-z]") { $d++ }
		    if ($randomPassword -cmatch "[A-Z]") { $d++ }
        } while ($d -lt $Completxity)
        $randomPassword
    }
}