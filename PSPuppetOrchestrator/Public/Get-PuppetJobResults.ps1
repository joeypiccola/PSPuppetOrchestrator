Function Get-PuppetJobResults {
    <#
    .SYNOPSIS
        Get the results from a Puppet job.
    .DESCRIPTION
        Get the results from a Puppet job.
    .PARAMETER ID
        The ID of the job.
    .PARAMETER Token
        The Puppet API orchestrator token.
    .PARAMETER Master
        The Puppet master.
    .EXAMPLE
        PS> Get-PuppetJobResults -Master $master -Token $token -ID 930

        finish_timestamp : 10/4/19 3:45:26 PM
        transaction_uuid :
        start_timestamp  : 10/4/19 3:45:18 PM
        name             : den3w108r2psv5
        duration         : 7.767
        state            : finished
        details          :
        result           : @{Source=DEN3W108R2PSV5; HotFixID=KB2620704; Description=Security Update; InstalledBy=NT AUTHORITY\SYSTEM; InstalledOn=Thursday, September 06, 2018 12:00:00 AM}
        latest-event-id  : 5709
        timestamp        : 10/4/19 3:45:26 PM

        finish_timestamp : 10/4/19 3:45:34 PM
        transaction_uuid :
        start_timestamp  : 10/4/19 3:45:19 PM
        name             : den3w108r2psv3
        duration         : 15.264
        state            : finished
        details          :
        result           : @{Source=DEN3W108R2PSV3; HotFixID=KB2620704; Description=Security Update; InstalledBy=; InstalledOn=Friday, September 07, 2018 12:00:00 AM}
        latest-event-id  : 5712
        timestamp        : 10/4/19 3:45:34 PM

        finish_timestamp : 10/4/19 3:45:34 PM
        transaction_uuid :
        start_timestamp  : 10/4/19 3:45:19 PM
        name             : den3w108r2psv4
        duration         : 15.505
        state            : finished
        details          :
        result           : @{Source=DEN3W108R2PSV4; HotFixID=KB2620704; Description=Security Update; InstalledBy=; InstalledOn=Friday, September 07, 2018 12:00:00 AM}
        latest-event-id  : 5713
        timestamp        : 10/4/19 3:45:34 PM
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
    foreach ($item in $result.items) {
        Write-Output $item
    }
}
