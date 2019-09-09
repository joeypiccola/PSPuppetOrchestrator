Function Get-PuppetJobResults {
    <#
    .SYNOPSIS
        Returns Hello world
    .DESCRIPTION
        Returns Hello world
    .PARAMETER ID
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
        [int]$ID,
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master
    )

    $hoststr = "https://$master`:8143/orchestrator/v1/jobs/$id/nodes"
    $headers = @{'X-Authentication' = $Token}
    $result  = Invoke-RestMethod -Uri $hoststr -Method Get -Headers $headers
    Write-Output $result.items
}
