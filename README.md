| Appveyor | Appveyor Tests  | PS Gallery Downloads | PS Gallery Version|
|--------|--------|--------|--------|
[![AppVeyor][appveyor-badge]][appveyor] | [![AppVeyor][appveyor-badge-tests]][appveyor] | [![PowerShell Gallery][powershellgallery-downloads]][powershellgallery] | [![PowerShell Gallery][powershellgallery-version]][powershellgallery]

# PSPuppetOrchestrator

PowerShell module for calling the Puppet Orchestrator API.

## Installation

```powershell
PS> Install-Module -Name PSPuppetOrchestrator
```

## Examples
### Get tasks
Get a list of tasks.
```powershell
PS> Get-PuppetTasks -token $token -master $master
```
OUTPUT
```plaintext
id                                                                       name                            permitted
--                                                                       ----                            ---------
https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/getkb         powershell_tasks::getkb         True
https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/account_audit powershell_tasks::account_audit True
https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/switch        powershell_tasks::switch        True
https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/ps1exec       powershell_tasks::ps1exec       True
https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/disablesmbv1  powershell_tasks::disablesmbv1  True
```

### Run tasks
Create a parameter splat.
```powershell
$invokePuppetTaskSplat = @{
    Token       = $token
    Master      = $master
    Task        = 'powershell_tasks::disablesmbv1'
    Environment = 'production'
    Parameters  = @{action = 'set'; reboot = $true}
    Description = 'Disable smbv1 on 08r2 nodes.'
    Scope       = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3')
}
```
Invoke the task `powershell_tasks::disablesmbv1`.
```powershell
PS> Invoke-PuppetTask @invokePuppetTaskSplat
```
OUTPUT
```plaintext
id                                           name
--                                           ----
https://puppet:8143/orchestrator/v1/jobs/910 910
```

Invoke the task `powershell_tasks::disablesmbv1` and `-Wait` a max of 120 seconds for the job to complete before returning. Note, the job will continue to run even if we exceed our `-Wait` time of 120 seconds.
```powershell
PS> Invoke-PuppetTask @invokePuppetTaskSplat -Wait 120
```
OUTPUT
```
description : Disable smbv1 on 08r2 nodes.
report      : @{id=https://puppet:8143/orchestrator/v1/jobs/940/report}
name        : 940
events      : @{id=https://puppet:8143/orchestrator/v1/jobs/940/events}
command     : task
type        : task
state       : finished
nodes       : @{id=https://puppet:8143/orchestrator/v1/jobs/940/nodes}
status      : {@{state=ready; enter_time=10/4/19 6:17:50 PM; exit_time=10/4/19 6:17:50 PM}, @{state=running; enter_time=10/4/19 6:17:50 PM; exit_time=10/4/19 6:17:52 PM}, @{state=finished; enter_time=10/4/19
              6:17:52 PM; exit_time=}}
id          : https://puppet:8143/orchestrator/v1/jobs/940
environment : @{name=production}
options     : @{description=Disable smbv1 on 08r2 nodes.; transport=pxp; noop=False; task=powershell_tasks::disablesmbv1; sensitive=System.Object[]; scheduled-job-id=; params=; scope=; environment=production}
timestamp   : 10/4/19 6:17:52 PM
owner       : @{email=; is_revoked=False; last_login=10/4/19 5:52:55 PM; is_remote=False; login=admin; is_superuser=True; id=42bf351c-f9ec-40af-84ad-e976fec7f4bd; role_ids=System.Object[];
              display_name=Administrator; is_group=False}
node_count  : 3
node_states : @{finished=3}
```

### Get task report
Using the `name` value of `940` returned from previously executed `Invoke-PuppetTask` get the report.
```powershell
PS> Get-PuppetJobReport -Master $master -Token $token -ID 940
```
OUTPUT
```plaintext
node             : den3w108r2psv3
state            : finished
start_timestamp  : 2019-09-09T16:54:07Z
finish_timestamp : 2019-09-09T16:54:09Z
timestamp        : 2019-09-09T16:54:09Z
events           : {}

node             : den3w112r2psv4
state            : finished
start_timestamp  : 2019-09-09T16:54:07Z
finish_timestamp : 2019-09-09T16:54:13Z
timestamp        : 2019-09-09T16:54:13Z
events           : {}
```

### Get tasks results
Using the `name` returned from `Invoke-PuppetTask` get the results. In this example there is no output result.
```powershell
PS> Get-PuppetJobResults -Master $master -Token $token -ID 940
```
OUTPUT
```plaintext
finish_timestamp : 2019-09-09T16:54:09Z
transaction_uuid :
start_timestamp  : 2019-09-09T16:54:07Z
name             : den3w108r2psv3
duration         : 2.032
state            : finished
details          :
result           : @{_output=}
latest-event-id  : 5581
timestamp        : 2019-09-09T16:54:09Z

finish_timestamp : 2019-09-09T16:54:13Z
transaction_uuid :
start_timestamp  : 2019-09-09T16:54:07Z
name             : den3w112r2psv4
duration         : 5.071
state            : finished
details          :
result           : @{_output=}
latest-event-id  : 5582
timestamp        : 2019-09-09T16:54:13Z

finish_timestamp : 2019-09-09T16:54:13Z
transaction_uuid :
start_timestamp  : 2019-09-09T16:54:07Z
name             : den3w112r2psv5
duration         : 5.071
state            : finished
details          :
result           : @{_output=}
latest-event-id  : 5582
timestamp        : 2019-09-09T16:54:13Z
```
### Get task results continued
The following output is from the `powershell_tasks::getkb` that generates output.
```powershell
PS> Get-PuppetJobResults -Master $master -Token $token -ID 915 -OutVariable 'PuppetJobResults'
```
OUTPUT
```plaintext
finish_timestamp : 2019-09-09T17:16:03Z
transaction_uuid :
start_timestamp  : 2019-09-09T17:15:48Z
name             : den3w108r2psv3
duration         : 15.645
state            : finished
details          :
result           : @{Source=DEN3W108R2PSV3; HotFixID=KB2620704; Description=Security Update; InstalledBy=; InstalledOn=Friday, September 07, 2018 12:00:00 AM}
latest-event-id  : 5596
timestamp        : 2019-09-09T17:16:03Z

finish_timestamp : 2019-09-09T17:16:04Z
transaction_uuid :
start_timestamp  : 2019-09-09T17:15:48Z
name             : den3w108r2psv4
duration         : 15.989
state            : finished
details          :
result           : @{Source=DEN3W108R2PSV4; HotFixID=KB2620704; Description=Security Update; InstalledBy=; InstalledOn=Friday, September 07, 2018 12:00:00 AM}
latest-event-id  : 5597
timestamp        : 2019-09-09T17:16:04Z

finish_timestamp : 2019-09-09T17:16:09Z
transaction_uuid :
start_timestamp  : 2019-09-09T17:15:48Z
name             : den3w108r2psv5
duration         : 21.802
state            : finished
details          :
result           : @{Source=DEN3W108R2PSV5; HotFixID=KB2620704; Description=Security Update; InstalledBy=NT AUTHORITY\SYSTEM; InstalledOn=Thursday, September 06, 2018 12:00:00 AM}
latest-event-id  : 5598
timestamp        : 2019-09-09T17:16:09Z
```
Using `-OutVariable 'PuppetJobResults'` from before we can access the `results` for each node the task was run against.
```powershell
PS C:\> $PuppetJobResults.result
```
OUTPUT
```plaintext
Source      : DEN3W108R2PSV3
HotFixID    : KB2620704
Description : Security Update
InstalledBy :
InstalledOn : Friday, September 07, 2018 12:00:00 AM

Source      : DEN3W108R2PSV4
HotFixID    : KB2620704
Description : Security Update
InstalledBy :
InstalledOn : Friday, September 07, 2018 12:00:00 AM

Source      : DEN3W108R2PSV5
HotFixID    : KB2620704
Description : Security Update
InstalledBy : NT AUTHORITY\SYSTEM
InstalledOn : Thursday, September 06, 2018 12:00:00 AM
```

## License
Timezone_win is released under the [MIT license](http://www.opensource.org/licenses/MIT).

[appveyor]: https://ci.appveyor.com/project/joeypiccola/pspuppetorchestrator
[appveyor-badge]: https://ci.appveyor.com/api/projects/status/6g7fk7xes4vn5fog/branch/master?svg=true&passingText=master%20-%20PASSING&pendingText=master%20-%20PENDING&failingText=master%20-%20FAILING
[appveyor-badge-tests]: https://img.shields.io/appveyor/tests/joeypiccola/pspuppetorchestrator/master
[powershellgallery]: https://www.powershellgallery.com/packages/PSPuppetOrchestrator
[powershellgallery-downloads]: https://img.shields.io/powershellgallery/dt/pspuppetorchestrator
[powershellgallery-version]: https://img.shields.io/powershellgallery/v/pspuppetorchestrator
