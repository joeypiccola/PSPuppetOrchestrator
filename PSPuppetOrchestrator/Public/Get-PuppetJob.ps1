Function Get-PuppetJob {
    <#
    .SYNOPSIS
        Get details on a puppet job.
    .DESCRIPTION
        Get details on a puppet job.
    .PARAMETER ID
        The ID of the job.
    .PARAMETER Token
        The Puppet API orchestrator token.
    .PARAMETER Master
        The Puppet master.
    .EXAMPLE
        PS> Get-PuppetJob -ID $id -Token $token -Master $master

        output
    #>

    Param(
        [Parameter(Mandatory)]
        [int]$ID,
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master
    )

    $hoststr = "https://$master`:8143/orchestrator/v1/jobs/$id"
    $headers = @{'X-Authentication' = $Token}
    $result  = Invoke-RestMethod -Uri $hoststr -Method Get -Headers $headers
    $content = $result

    Write-Output $content
}
