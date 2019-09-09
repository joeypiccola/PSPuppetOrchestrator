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
        PS> Get-PuppetJob -Token $token -Master $master -ID 906

        description :
        report      : @{id=https://puppet:8143/orchestrator/v1/jobs/906/report}
        name        : 906
        events      : @{id=https://puppet:8143/orchestrator/v1/jobs/906/events}
        command     : task
        type        : task
        state       : failed
        nodes       : @{id=https://puppet:8143/orchestrator/v1/jobs/906/nodes}
        status      : {@{state=ready; enter_time=2019-09-04T16:50:09Z; exit_time=2019-09-04T16:50:10Z}, @{state=running; enter_time=2019-09-04T16:50:10Z; exit_time=2019-09-04T16:50:43Z}, @{state=failed; enter_time=2019-09-04T16:50:43Z; exit_time=}}
        id          : https://puppet:8143/orchestrator/v1/jobs/906
        environment : @{name=production}
        options     : @{description=; transport=pxp; noop=False; task=powershell_tasks::getkb; sensitive=System.Object[]; params=; scope=; environment=production}
        timestamp   : 2019-09-04T16:50:43Z
        owner       : @{email=; is_revoked=False; last_login=2019-09-04T16:48:50.049Z; is_remote=False; login=admin; is_superuser=True; id=42bf351c-f9ec-40af-84ad-e976fec7f4bd; role_ids=System.Object[]; display_name=Administrator; is_group=False}
        node_count  : 3
        node_states : @{failed=1; finished=2}
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
