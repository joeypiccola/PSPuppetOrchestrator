Function Get-PuppetTasks {
    <#
    .SYNOPSIS
        Get a list of Puppet Tasks.
    .DESCRIPTION
        Get a list of Puppet Tasks.
    .PARAMETER Environment
        The environment to use.
    .PARAMETER Token
        The Puppet API orchestrator token.
    .PARAMETER Master
        The Puppet master.
    .EXAMPLE
        PS> Get-PuppetTasks -token $token -master $master

        id                                                                       name                            permitted
        --                                                                       ----                            ---------
        https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/getkb         powershell_tasks::getkb         True
        https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/account_audit powershell_tasks::account_audit True
        https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/switch        powershell_tasks::switch        True
        https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/ps1exec       powershell_tasks::ps1exec       True
        https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/disablesmbv1  powershell_tasks::disablesmbv1  True
    #>

    Param(
        [Parameter(Mandatory)]
        [string]$token,
        [Parameter(Mandatory)]
        [string]$master,
        [Parameter()]
        [string]$environment='production'
    )
    $uri     = "https://$master`:8143/orchestrator/v1/tasks"
    $headers = @{'X-Authentication' = $Token}
    $body    = @{'environment' = $environment}
    $result  = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -Body $body
    foreach ($item in $result.items) {
        Write-Output $item
    }
}
