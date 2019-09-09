Function Get-PuppetJobReport {
    <#
    .SYNOPSIS
        Get the report for a given Puppet job.
    .DESCRIPTION
        Get the report for a given Puppet job.
    .PARAMETER ID
        The ID of the job.
    .PARAMETER Token
        The Puppet API orchestrator token.
    .PARAMETER Master
        The Puppet master.
    .EXAMPLE
        PS> Get-PuppetJobReport -Master $master -Token $token -ID 906

        node           state    start_timestamp      finish_timestamp     timestamp            events
        ----           -----    ---------------      ----------------     ---------            ------
        den3w108r2psv2 failed   2019-09-04T16:50:10Z 2019-09-04T16:50:12Z 2019-09-04T16:50:12Z {}
        den3w108r2psv3 finished 2019-09-04T16:50:10Z 2019-09-04T16:50:42Z 2019-09-04T16:50:42Z {}
        den3w108r2psv4 finished 2019-09-04T16:50:10Z 2019-09-04T16:50:43Z 2019-09-04T16:50:43Z {}
    #>

    Param(
        [Parameter(Mandatory)]
        [int]$ID,
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master
    )

    $hoststr = "https://$master`:8143/orchestrator/v1/jobs/$id/report"
    $headers = @{'X-Authentication' = $Token}
    $result  = Invoke-RestMethod -Uri $hoststr -Method Get -Headers $headers
    $result.count
    foreach ($server in $result.report) {
        Write-Output $server
    }
}
