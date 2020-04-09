function Set-SkipCertificateCheck {
    <#
    .SYNOPSIS
        Detect Invoke-RestMethod version and ignore server ssl certs.

    .DESCRIPTION
        Detect whether certificate checking should be skipped via the switch
        parameter on Invoke-RestMethod or via setting the ServerCertificateCallback
        setting.

    .PARAMETER SkipCertificateCheck
        Indicate that you would like to skip SSL Certificate validation from
        the Master server and trust the certificate you receive.

    .PARAMETER PARAMS
        The hash table of params you will eventually use with Invoke-RestMethod.
        This cmdlet will add a SkipCertificateCheck key and set it to true if
        the current version of Invoke-RestMethod supports that switch. If it
        does not then it will set the ServerCertificateValidationCallback
        method to always return true and achieve the same effect.

    .EXAMPLE
        $invokeParams = @{
        >>         Uri                  = $uri
        >>         Method               = 'Post'
        >>         Body                 = $req
        >>         ContentType          = 'application/json'
        >>     }

        PS > $invokeParams = Set-SkipCertificateCheck -SkipCertificateCheck $SkipCertificateCheck -Params $invokeParams

        PS > Invoke-RestMethod @invokeParams | Select-Object -ExpandProperty token

        This example detect if the current version of Invoke-RestMethod implements the -SkipCertificateCheck switch parameter
        If it does then it will add that key to the $invokeParams hash table for use when splatting with Invoke-RestMethod.
        If it does not then it will set the ServerCertificateValidationCallback method in .NET to always return $true
        to acheive the same effect in PowerShell 5.1

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [bool]
        $SkipCertificateCheck,
        [Parameter(Mandatory)]
        [hashtable]
        $params
    )

    process {
        if ($SkipCertificateCheck) {
            if (Get-Help Invoke-RestMethod -Parameter SkipCertificateCheck -ErrorAction SilentlyContinue) {
                $params.SkipCertificateCheck = $true
            } else {
                Set-ServerCertificateValidationCallback
            }
        }
        $params
    }
}
