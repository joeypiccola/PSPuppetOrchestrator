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
        $result  = Invoke-RestMethod -Uri $hoststr -Method Get -Headers $headers -ErrorAction SilentlyContinue
    } catch {
        # try and get the task again assuming it's built in with a default task name of 'init' (e.g. reboot/init)
        try {
            $hoststr = "https://$master`:8143/orchestrator/v1/tasks/$name/init"
            $result  = Invoke-RestMethod -Uri $hoststr -Method Get -Headers $headers
        } catch {
            Write-Error $_.exception.message
        }
    }

    if ($result) {
        Write-Output $result
    }
}