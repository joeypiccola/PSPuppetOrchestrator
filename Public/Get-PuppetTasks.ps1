Function Get-PuppetTasks {
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