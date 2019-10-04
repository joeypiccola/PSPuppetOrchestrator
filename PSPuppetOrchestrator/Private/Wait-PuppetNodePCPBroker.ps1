Function Wait-PuppetNodePCPBroker {
    <#
    .SYNOPSIS
        Returns Hello world
    .DESCRIPTION
        Wait-PuppetNodePCPBroker was originally written in an effort to detect when nodes rebooted by
        evaluating a nodes's PCP Broker connected state. Since the advent of the reboot plan as seen
        in https://github.com/puppetlabs/puppetlabs-reboot/blob/master/plans/init.pp Wait-PuppetNodePCPBroker
        is no longer a viable solution. Never was to begin with really.

    .PARAMETER Timeout
        x
    .PARAMETER Token
        x
    .PARAMETER Master
        x
    .PARAMETER Node
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
        if (($one = Get-PuppetNodePCPBrokerDetails @detailsSplat).connected -eq $false) {
            # broker status is disconnected, sleep 5s and check again to confirm not a blip or false positive
            Write-Verbose "Broker status is $($one.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
            Write-Verbose "Sleping 5 seconds and checking again."
            Start-Sleep -Seconds 5
            if (($two = Get-PuppetNodePCPBrokerDetails @detailsSplat).connected -eq $false) {
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
        if (($three = Get-PuppetNodePCPBrokerDetails @detailsSplat).connected -eq $true) {
            # broker status is connected, sleep 5s and check again to confirm not a blip or false positive
            Write-Verbose "Broker status is $($three.connected), (timeout: $($stopwatch.elapsed.TotalSeconds)s of $Timeout`s elapsed)."
            Write-Verbose "Sleping 5 seconds and checking again."
            Start-Sleep -Seconds 5
            if (($four = Get-PuppetNodePCPBrokerDetails @detailsSplat).connected -eq $true) {
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
