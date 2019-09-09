Function Get-PuppetPCPNodeBrokerDetails {
    <#
    .SYNOPSIS
        Returns Hello world
    .DESCRIPTION
        Returns Hello world
    .PARAMETER Node
        x
    .PARAMETER Token
        x
    .PARAMETER Master
        x
    .EXAMPLE
        PS> Get-HelloWorld

        Runs the command
    #>

    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master,
        [Parameter(Mandatory)]
        [string]$Node
    )

    $hoststr = "https://$master`:8143/orchestrator/v1/inventory/$node"
    $headers = @{'X-Authentication' = $Token}
    $result  = Invoke-RestMethod -Uri $hoststr -Method Get -Headers $headers
    Write-Output $result
}
