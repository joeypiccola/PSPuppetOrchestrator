Function Get-PuppetTasks {
    <#
    .SYNOPSIS
        Returns Hello world
    .DESCRIPTION
        Returns Hello world
    .PARAMETER Environment
        x
    .PARAMETER Token
        x
    .PARAMETER Master
        x
    .EXAMPLE
        PS> Get-HelloWorld

        Runs the command
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
    Write-Output $result
}
