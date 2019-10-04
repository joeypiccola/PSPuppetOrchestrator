Function Invoke-PuppetTask {
    <#
    .SYNOPSIS
        Invoke a Puppet task.
    .DESCRIPTION
        Invoke a Puppet task.
    .PARAMETER Task
        The name of the Puppet task to invoke.
    .PARAMETER Environment
        The name of the Puppet task environment.
    .PARAMETER Parameters
        A hash of parameters to supply the Puppet task, e.g. $Parameters = @{tp1 = 'foo';tp2 = 'bar'; tp3 = $true}.
    .PARAMETER Description
        A description to submit along with the task.
    .PARAMETER Scope
        An array of nodes the Puppet task will be invoked against, e.g. $Scope = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3').
    .PARAMETER ScopeType
        When executing tasks against the /command/task API endpoint you can either use
        a scope type of 'node' or 'query'. At this time, PSPuppetOrchestrator only
        supports a ScopeType of 'node' which is the DEFAULT and only allowed option for
        the ScopeType parameter.
    .PARAMETER Wait
        An optional wait value in seconds that Invoke-PuppetTask will use to wait until
        the invoked task completes. If the wait time is exceeded Invoke-PuppetTask will
        return a warning.
    .PARAMETER WaitLoopInterval
        An optional time in seconds that the wait feature will re-check the invoked task.
        DEFAULTS to 5s.
    .PARAMETER Token
        The Puppet API orchestrator token.
    .PARAMETER Master
        The Puppet master.
    .EXAMPLE
        $invokePuppetTaskSplat = @{
            Token            = $token
            Master           = $master
            Task             = 'powershell_tasks::disablesmbv1'
            Environment      = 'production'
            Parameters       = @{action = 'set'; reboot = $true}
            Description      = 'Disable smbv1 on 08r2 nodes.'
            Scope            = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3')
            ScopeType        = 'nodes'
            Wait             = 120
            WaitLoopInterval = 2
        }
        PS> Invoke-PuppetTask @invokePuppetTaskSplat
    #>

    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master,
        [Parameter(Mandatory)]
        [string]$Task,
        [Parameter()]
        [string]$Environment = 'production',
        [Parameter()]
        [hashtable]$Parameters = @{},
        [Parameter()]
        [string]$Description = '',
        [Parameter(Mandatory)]
        [string[]]$Scope,
        [Parameter()]
        [ValidateSet('nodes')]
        [string]$ScopeType = 'nodes',
        [Parameter()]
        [int]$Wait,
        [Parameter()]
        [int]$WaitLoopInterval = 5
    )

    $req = [PSCustomObject]@{
        environment = $Environment
        task        = $Task
        params      = $Parameters
        description = $Description
        scope       = [PSCustomObject]@{
            $ScopeType  = $Scope
        }
    } | ConvertTo-Json
    $req
    $hoststr = "https://$master`:8143/orchestrator/v1/command/task"
    $headers = @{'X-Authentication' = $Token}

    $result  = Invoke-RestMethod -Uri $hoststr -Method Post -Headers $headers -Body $req
    $content = $result

    if ($wait) {
        # sleep 5s for the job to register
        Start-Sleep -Seconds 5

        $jobSplat = @{
            token = $Token
            master = $master
            id = $content.job.name
        }

        # create a timespan
        $timespan = New-TimeSpan -Seconds $Wait
        # start a timer
        $stopwatch = [diagnostics.stopwatch]::StartNew()

        # get the job state every 5 seconds until our timeout is met
        while ($stopwatch.elapsed -lt $timespan) {
            # options are new, ready, running, stopping, stopped, finished, or failed
            $job = Get-PuppetJob @jobSplat
            Write-Verbose $job.node_states
            if (($job.State -eq 'stopped') -or ($job.State -eq 'finished') -or ($job.State -eq 'failed')) {
                Write-Output $job
                break
            }
            Start-Sleep -Seconds $WaitLoopInterval
        }
        if ($stopwatch.elapsed -ge $timespan) {
            Write-Warning "Timeout of $wait`s has exceeded. Job $($job.name) may still be running. Last job status: $($job.State)."
            break
        }
    } else {
        Write-Output $content.job
    }
}
