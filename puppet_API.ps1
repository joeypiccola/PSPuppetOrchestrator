Function Get-PuppetJobReport {
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

    $result  = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
    $content = $result.content | ConvertFrom-Json
    $report  = $content.report

    foreach ($server in $report) {
        write-output $server
    }
}

Function Get-PuppetJob {
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

    $result  = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
    $content = $result.content | ConvertFrom-Json

    Write-Output $content
}

Function Get-PuppetTasks {
    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master
    )

    $hoststr = "https://$master`:8143/orchestrator/v1/tasks"
    $headers = @{'X-Authentication' = $Token}

    $result  = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
    $content = $result | ConvertFrom-Json

    Write-Output $content.items
}

Function Get-PuppetTask {
    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master,
        [Parameter()]
        [string]$Module,
        [Parameter(Mandatory)]
        [string]$Name
    )

    $hoststr = "https://$master`:8143/orchestrator/v1/tasks/$Module/$Name"
    $headers = @{'X-Authentication' = $Token}

    # try and get the task in it's standard form $moduleName/$taskName
    try {
        $result  = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers -ErrorAction SilentlyContinue
    } catch {
        # try and get the task again assuming it's built in with a default task name of 'init' (e.g. reboot/init)
        try {
            $hoststr = "https://$master`:8143/orchestrator/v1/tasks/$Module/init"
            $result  = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
        } catch {
            Write-Error $_.exception.message
        }
    }

    if ($result) {
        $content = $result | ConvertFrom-Json
        Write-Output $content
    }
}

Function Get-PuppetJobNodes {
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

    $result  = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
    $content = $result.content | ConvertFrom-Json

    Write-Output $content.items
}

Function Invoke-PuppetTask {
<#
$scope = @('den3-node-1.ad.piccola.us','den3-node-3.ad.piccola.us','den3-node-4.ad.piccola.us','den3-node-5.ad.piccola.us')

$splat = @{
    Token = 'AKSeiFY0KJkQxUe6ovYfRQ9JbKjXY8So1GoCApkAMzOZ'
    Master = 'puppet.piccola.us'
    Task = 'powershell_tasks::disablesmbv1'
    Environment = 'development'
    Parameters = [PSCustomObject]@{
        action = 'get'
    }
    Description = 'This was run from PowerShell'
    Scope = $scope
    ScopeType = 'nodes'
}

Invoke-PuppetTask @splat -Wait -Timeout 120
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
        [switch]$Wait,
        [Parameter()]
        [int]$Timeout = 300
    )

    $req = [PSCustomObject]@{
        environment = $Environment
        task        = $Task
        params      = $Parameters
        description = $Description
        scope       = [PSCustomObject]@{
        $ScopeType = $Scope
        }
    } | ConvertTo-Json

    $hoststr = "https://$master`:8143/orchestrator/v1/command/task"
    $headers = @{'X-Authentication' = $Token}

    $result  = Invoke-WebRequest -Uri $hoststr -Method Post -Headers $headers -Body $req
    $content = $result.content | ConvertFrom-Json

    if ($wait) {
        # sleep 5s for the job to register
        Start-Sleep -Seconds 5

        $jobSplat = @{
            token = $Token
            master = $master
            id = $content.job.name
        }

        # create a timespan
        $timespan = New-TimeSpan -Seconds $timeout
        # start a timer
        $stopwatch = [diagnostics.stopwatch]::StartNew()

        # get the job state every 5 seconds until our timeout is met
        while ($stopwatch.elapsed -lt $timespan) {
            # optoins are new, ready, running, stopping, stopped, finished, or failed
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
            Write-Error "Timeout of $Timeout`s has exceeded."
            break
        }
    } else {
        Write-Output $content
    }
}

function Get-PuppetPCPNodeBrokerDetails {
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

    $result  = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
    $content = $result | ConvertFrom-Json
    Write-Output $content
}

Function Wait-PuppetNodePCPBroker {
    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master,
        [Parameter(Mandatory)]
        [string]$Node,
        [Parameter()]
        [int]$Timeout = 300
    )

    $detailsSplat = @{
        token = $Token
        master = $master
        node = $node
    }

    # create a timespan
    $timespan = New-TimeSpan -Seconds $timeout
    # start a timer
    $stopwatch = [diagnostics.stopwatch]::StartNew()

    # get the broker status every 5 seconds until our timeout is met
    while ($stopwatch.elapsed -lt $timespan) {
        # get the broker status
        if (($one = Get-PuppetPCPNodeBrokerDetails @detailsSplat).connected -eq $false) {
            # broker status is disconnected, sleep 5s and check agian to confirm not a blip or false positive
            Write-Verbose "Broker status is $($one.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
            Write-Verbose "Sleping 5 seconds and checking again."
            Start-Sleep -Seconds 5
            if (($two = Get-PuppetPCPNodeBrokerDetails @detailsSplat).connected -eq $false) {
                Write-Verbose "Broker status is still $($two.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
                # broker status is disconnected, break out of the loop
                break
            }
        } else {
            Write-Verbose "Broker status is $($one.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
        }
        Start-Sleep -Seconds 5
    }
    if ($stopwatch.elapsed -ge $timespan) {
        Write-Error "Timeout of $Timeout`s has exceeded."
        break
    }

    Write-Verbose "$Node broker status confirmed disconnected."

    # get the broker status every 5 seconds until our timeout is met
    while ($stopwatch.elapsed -lt $timespan) {
        # get the broker status
        if (($three = Get-PuppetPCPNodeBrokerDetails @detailsSplat).connected -eq $true) {
            # broker status is connected, sleep 5s and check agian to confirm not a blip or false positive
            Write-Verbose "Broker status is $($three.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
            Write-Verbose "Sleping 5 seconds and checking again."
            Start-Sleep -Seconds 5
            if (($four = Get-PuppetPCPNodeBrokerDetails @detailsSplat).connected -eq $true) {
                Write-Verbose "Broker status is still $($four.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
                # broker status is connected, break out of the loop
                break
            }
        } else {
            Write-Verbose "Broker status is $($three.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
        }
        Start-Sleep -Seconds 5
    }
    if ($stopwatch.elapsed -ge $timespan) {
        Write-Error "Timeout of $Timeout`s has exceeded."
        break
    }

    Write-Verbose "$Node broker status confirmed connected."
}

Function Get-PuppetNodeFacts {
    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master,
        [Parameter(Mandatory)]
        [string]$Node
    )

    $hoststr = "https://$master`:8081/pdb/query/v4/facts"
    $headers = @{'X-Authentication' = $Token}

    $query = @{
        query = "[""="", ""certname"", ""$node""]"
    }

    $result = Invoke-WebRequest -Uri $hoststr -Method Get -Body $query -Headers $headers
    $content = $result | ConvertFrom-Json

    # borrowed from Warren Frame
    $h = @{}
    $content | foreach-object { [void]$h.set_item($_.Name, $_.Value) }
    [pscustomobject]$h

}

Function Get-PuppetNodeFact {
    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master,
        [Parameter(Mandatory)]
        [string]$Node,
        [Parameter(Mandatory)]
        [string]$Fact
    )

    # This is a shortcut to the /pdb/query/v4/facts endpoint.
    $hoststr = "https://$master`:8081/pdb/query/v4/nodes/$node/facts/$Fact"
    $headers = @{'X-Authentication' = $Token}

    $result = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
    $content = $result.content | ConvertFrom-Json

    Write-Output $content.value
}