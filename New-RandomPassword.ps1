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
    
.PARAMETER Complexity
    The required complexity of the password. It must contain characters 
    from (x) of the following four (4) categories:
    * Numbers
    * Symbols
    * Uppercase
    * Lowercase
    
    Default: 4
    Minimum: 0 (No complexity requirement)

.PARAMETER NoSymbols
    Specify this switch to exclude symbols (e.g. @#$%)
    
.PARAMETER NoNumbers
    Specify this switch to exclude numbers (e.g. 123456)

.PARAMETER NoLowercase
    Specify this switch to exclude lowercase letters
    (e.g. abcdefgh)

.PARAMETER NoUppercase
    Specify this switch to exclude uppercase letters
    (e.g. ABCDEFGH)

.PARAMETER NoSimilarChars
    Specify this switch to exclude similar characters 
    (e.g. i, l, 1, L, o, 0, O)

.PARAMETER NoAmbiguousChars
    Specify this switch to exclude ambiguous characters
    (e.g. { } [ ] ( ) / \ ' "" ` ~ , ; : . < >)

.EXAMPLE
    New-RandomPassword -Length 8 -Complexity 3 -NoNumbers -NoSimilarChars -NoAmbiguousChars

#>

function New-RandomPassword {
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage="Enter minimum length of the password. Minimum 3")]
        [ValidateScript({$_ -ge 4})]
        [Int] $Length = 16,
        [Parameter(HelpMessage="Enter complexity requirement. Minimum 0 - Maximum 4")]
        [ValidateScript({($_ -ge 0) -and ($_ -le 4)})]
        [Int] $Complexity = 4,
        [Parameter(HelpMessage="Exclude symbols")]
        [Switch] $NoSymbols,
        [Parameter(HelpMessage="Exclude numbers")]
        [Switch] $NoNumbers,
        [Parameter(HelpMessage="Exclude lowercase characters")]
        [Switch] $NoLowercase,
        [Parameter(HelpMessage="Exclude uppercase characters")]
        [Switch] $NoUppercase,
        [Parameter(HelpMessage="Exclude similar characters")]
        [Switch] $NoSimilarChars,
        [Parameter(HelpMessage="Exclude ambiguous characters (e.g. { } [ ] ( ) / \ ' "" ` ~ , ; : . < >)")]
        [Switch] $NoAmbiguousChars
    )
    BEGIN {
        $exclusionCount = 0
        $set = @()
        $exclusions = @()
        ### Symbols ###
        if ($NoSymbols) {
            $exclusionCount += 1
        } else {
            $set += 33..47
            $set += 58..64
            $set += 91..96
            $set += 123..126
            #$set += 161..255
        }

        ### Numbers ###
        if ($NoNumbers) {
            $exclusionCount += 1
        } else {
            $set += 48..57
        }

        ### Lowercase ###
        if ($NoLowercase) {
            $exclusionCount += 1
        } else {
            $set += 97..122
        }

        ### Uppercase ###
        if ($NoUppercase) {
            $exclusionCount += 1
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
        
        if ($Complexity -gt (4 - $exclusionCount)) {
            Throw "There are too many exclusions to meet the input complexity requirements."
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
        } while ($d -lt $Complexity)
        $randomPassword
    }
}