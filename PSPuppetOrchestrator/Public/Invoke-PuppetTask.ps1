Function Invoke-PuppetTask {
    <#
    .SYNOPSIS
        Returns Hello world
    .DESCRIPTION
        Returns Hello world
    .PARAMETER Token
        x
    .PARAMETER Master
        x
    .PARAMETER Task
        x
    .PARAMETER Environment
        x
    .PARAMETER Parameters
        x
    .PARAMETER Description
        x
    .PARAMETER Scope
        x
    .PARAMETER ScopeType
        x
    .PARAMETER Wait
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
        [string]$Task,
        [Parameter()]
        [string]$Environment = 'production',
        [Parameter()]
        [PSCustomObject]$Parameters = @{},
        [Parameter()]
        [string]$Description = '',
        [Parameter(Mandatory)]
        [PSCustomObject[]]$Scope,
        [Parameter(Mandatory)]
        [ValidateSet('nodes')]
        [string]$ScopeType,
        [Parameter()]
        [int]$Wait
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
            if (($job.State -eq 'stopped') -or ($job.State -eq 'finished') -or ($job.State -eq 'failed')) {
                $taskJobContent = [PSCustomObject]@{
                    task = $content
                    job = $job
                }
                Write-Output $taskJobContent
                break
            }
            Start-Sleep -Seconds 5
        }
        if ($stopwatch.elapsed -ge $timespan) {
            Write-Error "Timeout of $wait`s has exceeded."
            break
        }
    } else {
        Write-Output $content
    }
}
