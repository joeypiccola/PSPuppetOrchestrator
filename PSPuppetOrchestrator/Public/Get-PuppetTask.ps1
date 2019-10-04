Function Get-PuppetTask {
    <#
    .SYNOPSIS
        Get details on a Puppet task.
    .DESCRIPTION
        Get details on a Puppet task.
    .PARAMETER Module
        The module of the puppet task, if applicable.
    .PARAMETER Name
        The name of the Puppet task.
    .PARAMETER Token
        The Puppet API orchestrator token.
    .PARAMETER Master
        The Puppet master.
    .EXAMPLE
        PS> Get-PuppetTask -Master $master -Token $token -Name 'reboot'

        id          : https://puppet:8143/orchestrator/v1/tasks/reboot/init
        name        : reboot
        permitted   : True
        metadata    : @{description=Reboots a machine; implementations=System.Object[]; input_method=stdin; parameters=; supports_noop=False}
        files       : {@{filename=init.rb; sha256=fb7e0e0de640b82844be931e59405de73e1e290c9540c204a6c79838a0e39fce; size_bytes=2556; uri=}, @{filename=nix.sh; sha256=dfb2ddfe17056c316d7260bcce853aabc5b18a266888f76b23314d0d4c8daee5; size_bytes=692; uri=}, @{filename=win.ps1; sha256=155f5ab7d63f1913ccf8f4f5563f1b2be2a49130a4787a8c48ff770cfe8e6415; size_bytes=785; uri=}}
        environment : @{name=production; code_id=}
    .EXAMPLE
        PS> Get-PuppetTask -Master $master -Token $token -Module 'powershell_tasks' -Name 'disablesmbv1'

        id          : https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/disablesmbv1
        name        : powershell_tasks::disablesmbv1
        permitted   : True
        metadata    : @{description=A task to test if SMBv1 is enabled and optionally disable it.; input_method=powershell; parameters=; puppet_task_version=1}
        files       : {@{filename=disablesmbv1.ps1; sha256=c10f3ae37a6e2686c419ec955ee51f9894109ed073bf5c3b3280255b3785e0dc; size_bytes=3536; uri=}}
        environment : @{name=production; code_id=}
    #>

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
