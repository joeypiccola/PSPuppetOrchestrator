Function Get-PuppetPCPNodeBrokerDetails {
    <#
    .SYNOPSIS
        Get a node's PCP broker details.
    .DESCRIPTION
        Get a node's PCP broker details. This is useful if you want to know the status of PCP before executing a task or plan.
    .PARAMETER Node
        The Puppet node name.
    .PARAMETER Token
        The Puppet API orchestrator token.
    .PARAMETER Master
        The Puppet master.
    .EXAMPLE
        PS> Get-PuppetPCPNodeBrokerDetails -Master $master -Token $token -Node 'den3w108r2psv3'

        name      : den3w108r2psv3
        connected : True
        broker    : pcp://puppet/server
        timestamp : 10/2/19 2:01:53 AM
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
