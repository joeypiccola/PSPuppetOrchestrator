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
    .PARAMETER Nodes
        An array of node names to target, e.g. $Scope = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3').
    .PARAMETER Query
        A PuppetDB or PQL query to use to discover nodes. The target is built from the certname values collected at
        the top level of the query, e.g. '["from", "inventory", ["=", "facts.os.name", "windows"]]'.
    .PARAMETER Node_group
        A classifier node group ID. The ID must correspond to a node group that has defined rules. It is not sufficient
        for parent groups of the node group in question to define rules. The user must also have permissions to view the
        node group. Any nodes specified in the scope that the user does not have permissions to run the task on are
        excluded, e.g. 7a692b61-8087-4452-9cf8-58ed2acee2a0.
    .PARAMETER WaitLoopInterval
        An optional time in seconds that the wait feature will re-check the invoked task. DEFAULTS to 5s.
    .PARAMETER Wait
        An optional wait value in seconds that Invoke-PuppetTask will use to wait until
        the invoked task completes. If the wait time is exceeded Invoke-PuppetTask will
        return a warning.
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
            Nodes            = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3')
        }
        PS> Invoke-PuppetTask @invokePuppetTaskSplat

        id                                                       name
        --                                                       ----
        https://puppet.contoso.us:8143/orchestrator/v1/jobs/1318 1318
    .EXAMPLE
        $invokePuppetTaskSplat = @{
            Token            = $token
            Master           = $master
            Task             = 'powershell_tasks::disablesmbv1'
            Environment      = 'production'
            Parameters       = @{action = 'set'; reboot = $true}
            Description      = 'Disable smbv1 on 08r2 nodes.'
            Query            = '["from", "inventory", ["=", "facts.os.name", "windows"]]'
        }
        PS> Invoke-PuppetTask @invokePuppetTaskSplat

        id                                                       name
        --                                                       ----
        https://puppet.contoso.us:8143/orchestrator/v1/jobs/1318 1318
    .EXAMPLE
        $invokePuppetTaskSplat = @{
            Token            = $token
            Master           = $master
            Task             = 'powershell_tasks::disablesmbv1'
            Environment      = 'production'
            Parameters       = @{action = 'set'; reboot = $true}
            Description      = 'Disable smbv1 on 08r2 nodes.'
            Node_group       = '7a692b61-8087-4452-9cf8-58ed2acee2a0'
        }
        PS> Invoke-PuppetTask @invokePuppetTaskSplat

        id                                                       name
        --                                                       ----
        https://puppet.contoso.us:8143/orchestrator/v1/jobs/1318 1318
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
        [Parameter()]
        [int]$Wait,
        [Parameter()]
        [int]$WaitLoopInterval = 5,
        [Parameter(Mandatory, ParameterSetName = "nodes")]
        [string[]]$Nodes,
        [Parameter(Mandatory, ParameterSetName = "query")]
        [string]$Query,
        [Parameter(Mandatory, ParameterSetName = "node_group")]
        [string]$Node_group
    )

    # set the scope type to the name of the oh so cleverly named parameter set
    $scopeType = $PSCmdlet.ParameterSetName
    # set the scope to the value of the single parameter of the choosen parameter set
    switch ($scopeType) {
        'nodes'      {$scope = $Nodes}
        'query'      {$scope = $Query}
        'node_group' {$scope = $Node_group}
    }

    $req = [PSCustomObject]@{
        environment = $Environment
        task        = $Task
        params      = $Parameters
        description = $Description
        scope       = [PSCustomObject]@{
            $scopeType  = $scope
        }
    } | ConvertTo-Json

    $hoststr = "https://$master`:8143/orchestrator/v1/command/task"
    $headers = @{'X-Authentication' = $Token}

    $result  = Invoke-RestMethod -Uri $hoststr -Method Post -Headers $headers -Body $req

    if ($PSBoundParameters.ContainsKey('wait')) {
        # sleep 5s for the job to register
        Start-Sleep -Seconds 5

        $jobSplat = @{
            token  = $Token
            master = $master
            id     = $result.job.name
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
        Write-Output $result.job
    }
}
