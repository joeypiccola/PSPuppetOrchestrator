function Get-PuppetAuthToken {
    <#
    .SYNOPSIS
        Get a Puppet Auth Token for use with API calls.
    .DESCRIPTION
        Call the /rbac-api/v1/auth/token end point with a username and password
        to obtain an authorization token that can be used with the other
        cmdlets in this module.

    .PARAMETER Master
        The FQDN of the Puppet Master server that your DNS can resolve. You do
        not need to include the HTTPS portion of the address. Only the server name.

    .PARAMETER Lifetime
        An integer value specifying how long you would like the token to last
        paired with one of the letter [smhdy] (example '2d' for two days) to
        specify the units of time in seconds, minutes, hours, days, or years. If
        you call this cmdlet to request a token within the valid lifetime of
        your current token, you will receive your current token back again.

    .PARAMETER Port
        The port your Puppet Master API end poins are listening on. Be default
        this will be 4433, but it is configurable.

    .PARAMETER Credential
        A PSCredential object that contains the username and password for the user
        you would like to receive a token for. If you do not provide one you will
        be prompted at the commandline for one.

    .PARAMETER SkipCertificateCheck
        Skip certificate validation on the SSL certificate provided by the Puppet
        master server you connect to. This parameter will function as expected
        for both PowerShell 5.1 and 6+.

    .EXAMPLE
        $cred = Get-Credential -Username Admin
        PS > $token = Get-PuppetAuthToken -Master 'pe-master.corp.net' -SkipCertificateCheck -Credential $cred

        Create a credential object and then call this cmdlet to retrieve a token

    .EXAMPLE
        $token = Get-PuppetAuthToken -Master 'pe-master.corp.net' -SkipCertificateCheck

        If you do not pass a credential object, you will be prompted for credentials.

    .EXAMPLE
        $token = Get-PuppetAuthToken -Lifetime '2m' -Master 'pe-master.corp.net' -SkipCertificateCheck

        Create a short lived token so that an automated process can use it but it
        dies quickley thereafter.
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        [String] Authorization Token Value.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Master,
        [Parameter()]
        [String]
        $Lifetime = '1d',
        [Parameter()]
        [Int]$Port = 4433,
        [Parameter(Mandatory)]
        [PSCredential]$Credential,
        [Parameter()]
        [Switch]$SkipCertificateCheck = $false
    )
    process {
        $uri = "https://$Master`:$port/rbac-api/v1/auth/token"

        $req = [PSCustomObject]@{
            login       = $credential.UserName
            password    = $credential.GetNetworkCredential().Password
            lifetime    = $Lifetime
            description = "Token used for authentication to Puppet api requests."
            label       = "Personal Workstation token"
        } | ConvertTo-JSON

        $invokeParams = @{
            Uri                  = $uri
            Method               = 'Post'
            Body                 = $req
            ContentType          = 'application/json'
        }

        $invokeParams = Set-SkipCertificateCheck -SkipCertificateCheck $SkipCertificateCheck -Params $invokeParams

        try {
            Invoke-RestMethod @invokeParams | Select-Object -ExpandProperty token
        }
        catch {
            Write-Error $_.Exception.Message
        }
        finally {
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
        }
    }
}
