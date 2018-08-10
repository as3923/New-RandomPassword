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
    Minimum: 3

.EXAMPLE
    New-RandomPassword -Length 8

#>

function New-RandomPassword {
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage="Enter minimum length of the password. Minimum 3")]
        [ValidateScript({$_ -ge 3})]
        [Int] $Length = 16,
        [Parameter(HelpMessage="Exclude symbols (e.g. @#$%)")]
        [Switch] $NoSymbols,
        [Parameter(HelpMessage="Exclude numbers (e.g. 123456)")]
        [Switch] $NoNumbers,
        [Parameter(HelpMessage="Exclude lowercahse characters (e.g. abcdefgh)")]
        [Switch] $NoLowercase,
        [Parameter(HelpMessage="Exclude uppercase characters (e.g. ABCDEFGH)")]
        [Switch] $NoUppercase,
        [Parameter(HelpMessage="Exclude similar characters (e.g. i, l, 1, L, o, 0, O )")]
        [Switch] $NoSimilarChars,
        [Parameter(HelpMessage="Exclude ambiguous characters ({ } [ ] ( ) / \ ' "" ` ~ , ; : . < > )")]
        [Switch] $NoAmbiguousChars
    )
    BEGIN {
        ### Symbols ###
        33..47
        58..64
        91..96
        123..126
        161..255

        ### Numbers ###
        48..57

        ### Lowercase ###
        97..122
        
        ### Uppercase ###
        65..90

        ### Similar Characters ###
        
        ### Ambiguous Characters ###        

    }
    PROCESS {
#        Add-Type -AssemblyName System.Web
#        $randomPassword = [System.Web.Security.Membership]::GeneratePassword($Length,1)$numbers=$null
        $randomPassword
    }
}