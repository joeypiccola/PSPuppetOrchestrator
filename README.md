| Appveyor | Appveyor Tests  | PS Gallery Downloads | PS Gallery Version|
|--------|--------|--------|--------|
[![AppVeyor][appveyor-badge]][appveyor] | [![AppVeyor][appveyor-badge-tests]][appveyor] | [![PowerShell Gallery][powershellgallery-downloads]][powershellgallery] | [![PowerShell Gallery][powershellgallery-version]][powershellgallery]

# PSPuppetOrchestrator

PowerShell module for calling the Puppet Orchestrator API.

## Installation

```powershell
PS> Install-Module -Name PSPuppetOrchestrator
```

## Included Functions

`Invoke-PuppetTask`

`Get-PuppetTask`

`Get-PuppetTasks`

`Get-PuppetJob`

`Get-PuppetJobReport`

`Get-PuppetJobResults`

`Get-PuppetPCPNodeBrokerDetails`

## Token

In order to call the `orchestrator` API endpoint you'll need a user token. There are a couple methods to acquire a Puppet Enterprise user token. In the spirit of using PowerShell, below is a script to get a token via the `rbac-api` endpoint. Specify a numeric value followed by “y” (years), “d” (days), “h” (hours), “m” (minutes), or “s”(seconds) for `lifetime`. If you do not want the token to expire, set the lifetime to “0”. Setting it to zero gives the token a lifetime of approximately 10 years. Do consider correctly filling out 'description', 'client', and 'label' with accurate information (they're all optional and can be removed if needed). 'description', 'client', and 'label' help with token audits.

```powershell
$master = 'puppet.contoso.com'
$cred = Get-Credential -Message 'Puppet Credentials (e.g. myuser-p)'
$req = [PSCustomObject]@{
    login       = $cred.UserName
    password    = $cred.GetNetworkCredential().Password
    lifetime    = '1d'
    description = "Token used for testing puppet tasks"
    client      = ""
    label       = "personal workstation token"
} | ConvertTo-Json
$rbacUri = "https://$master`:4433/rbac-api/v1/auth/token"
$result  = Invoke-RestMethod -Uri $rbacUri -Method Post -Body $req -ContentType 'application/json'
$result
```

OUTPUT

```plaintext
token
-----
***********************************wCB8
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

`Invoke-PuppetTask` can target nodes three different ways by specifying **one** of the following parameters.

- Nodes
  - EXAMPLE: `-Nodes @('node1.contoso.com','node2.contoso.com','node3.contoso.com','node4.contoso.com')`
- Query
  - EXAMPLE: `-Query '["from", "inventory", ["=", "facts.os.name", "windows"]]'`
- Node_group
  - EXAMPLE: `-Node_group '7a692b61-8087-4452-9cf8-58ed2acee2a0'`

#### Invoke-PuppetTask Parameter Splat Examples

Create an `Invoke-PuppetTask` parameter splat to target and array of nodes.

```powershell
$invokePuppetTaskSplat = @{
    Token  = $token
    Master = $master
    Task   = 'jpi::get_dns'
    Nodes  = @('node1.contoso.com','node2.contoso.com','node3.contoso.com','node4.contoso.com')
}
```

Create an `Invoke-PuppetTask` parameter splat to target nodes from a PQL query.

```powershell
$invokePuppetTaskSplat = @{
    Token  = $token
    Master = $master
    Task   = 'jpi::get_dns'
    Query  = '["from", "inventory", ["=", "facts.os.name", "windows"]]'
}
```

Create an `Invoke-PuppetTask` parameter splat to target a node group.

```powershell
$invokePuppetTaskSplat = @{
    Token      = $token
    Master     = $master
    Task       = 'jpi::get_dns'
    Node_group = '7a692b61-8087-4452-9cf8-58ed2acee2a0'
}
```

Create an `Invoke-PuppetTask` parameter splat specifying additional parameters for the `jpi::set_dns` Puppet Task.

```powershell
$invokePuppetTaskSplat = @{
    Token            = $token
    Master           = $master
    Task             = 'jpi::set_dns'
    Parameters       = @{
        primary   = '10.0.3.24'
        secondary = '10.0.3.22'
        tertiary  = '8.8.8.8'
    }
    Nodes            = @('node1.contoso.com', 'node2.contoso.com')
}
```

Create an `Invoke-PuppetTask` parameter splat specifying additional parameters for the `jpi::set_dns` Puppet Task and `-Wait` 120 seconds for the job to complete. **Note, the job will continue to run even if the job exceeds the `-Wait` time of 120 seconds.**

```powershell
$invokePuppetTaskSplat = @{
    Token            = $token
    Master           = $master
    Task             = 'jpi::set_dns'
    Parameters       = @{
        primary   = '10.0.3.24'
        secondary = '10.0.3.22'
        tertiary  = '8.8.8.8'
    }
    Nodes            = @('node1.contoso.com', 'node2.contoso.com')
    Wait             = 120
}
```

#### Invoke-PuppetTask Outputs

When `Invoke-PuppetTask` is supplied the `-Wait` parameter and the job completes within the wait time you'll be returned the full job results (identical to the results given by `Get-PuppetJob`).

OUTPUT

```plaintext
description :
report      : @{id=https://puppet.contoso.us:8143/orchestrator/v1/jobs/1326/report}
name        : 1326
events      : @{id=https://puppet.contoso.us:8143/orchestrator/v1/jobs/1326/events}
command     : task
type        : task
state       : finished
nodes       : @{id=https://puppet.contoso.us:8143/orchestrator/v1/jobs/1326/nodes}
status      : {@{state=ready; enter_time=4/8/2020 6:22:21 PM; exit_time=4/8/2020 6:22:21 PM}, @{state=running; enter_time=4/8/2020 6:22:21 PM; exit_time=4/8/2020 6:22:24 PM}, @{state=finished; enter_time=4/8/2020 6:22:24 PM; exit_time=}}
id          : https://puppet.contoso.us:8143/orchestrator/v1/jobs/1326
environment : @{name=production}
options     : @{description=; transport=pxp; noop=False; task=jpi::set_dns; sensitive=System.Object[]; scheduled-job-id=; params=; scope=; environment=production}
timestamp   : 4/8/2020 6:22:24 PM
owner       : @{email=; is_revoked=False; last_login=4/8/2020 6:17:18 PM; is_remote=False; login=admin; is_superuser=True; id=42bf351c-f9ec-40af-84ad-e976fec7f4bd; role_ids=System.Object[]; display_name=Administrator; is_group=False}
node_count  : 1
node_states : @{finished=1}
```

When `Invoke-PuppetTask` is not supplied the `-Wait` parameter you'll immediately be returned the `id` and `name` of the job.

OUTPUT

```plaintext

id                                                       name
--                                                       ----
https://puppet.piccola.us:8143/orchestrator/v1/jobs/1324 1324
```

### Get task report

Using the `name` value of `1324` returned from previously executed `Invoke-PuppetTask` get the report.

```powershell
PS> Get-PuppetJobReport -Master $master -Token $token -ID 1324
```

OUTPUT

```plaintext
node             : node1.contoso.com
state            : finished
start_timestamp  : 4/8/2020 4:45:06 PM
finish_timestamp : 4/8/2020 4:45:08 PM
timestamp        : 4/8/2020 4:45:08 PM
events           : {}
```

### Get tasks results

Using the `name` returned from `Invoke-PuppetTask` get the results. Depending on the depth of the structured data returned from the task you may have to "dot explore" into it.

```powershell
PS> Get-PuppetJobResults -Master $master -Token $token -ID 1324 -OutVariable 'PuppetJobResults'
```

OUTPUT

```plaintext
PS> $PuppetJobResults
    transport        : pcp
    finish_timestamp : 4/8/2020 4:45:08 PM
    transaction_uuid :
    start_timestamp  : 4/8/2020 4:45:06 PM
    name             : node1.contoso.com
    duration         : 2.275
    state            : finished
    details          :
    result           : @{after=; before=}
    latest-event-id  : 9510
    timestamp        : 4/8/2020 4:45:08 PM
```

Though very specific to the `jpi::set_dns` Puppet Task, below is the extended result data returned from job `1324`. Retrieved with `$PuppetJobResults.result | ConvertTo-Json`.

```json
{
  "after": {
    "Index": 4,
    "IPAddress": [
      "10.0.3.117",
      "fe80::987b:9b0a:1532:8d2d"
    ],
    "MACAddress": "00:50:56:89:53:29",
    "DNSServerSearchOrder": [
      "10.0.3.24",
      "10.0.3.22",
      "8.8.8.8"
    ]
  },
  "before": {
    "Index": 4,
    "IPAddress": [
      "10.0.3.117",
      "fe80::987b:9b0a:1532:8d2d"
    ],
    "MACAddress": "00:50:56:89:53:29",
    "DNSServerSearchOrder": [
      "10.0.3.24",
      "10.0.3.22",
      "8.8.8.8"
    ]
  }
}
```

## License

PSPuppetOrchestrator is released under the [MIT license](http://www.opensource.org/licenses/MIT).

[appveyor]: https://ci.appveyor.com/project/joeypiccola/pspuppetorchestrator
[appveyor-badge]: https://ci.appveyor.com/api/projects/status/6g7fk7xes4vn5fog/branch/master?svg=true&passingText=master%20-%20PASSING&pendingText=master%20-%20PENDING&failingText=master%20-%20FAILING
[appveyor-badge-tests]: https://img.shields.io/appveyor/tests/joeypiccola/pspuppetorchestrator/master
[powershellgallery]: https://www.powershellgallery.com/packages/PSPuppetOrchestrator
[powershellgallery-downloads]: https://img.shields.io/powershellgallery/dt/pspuppetorchestrator
[powershellgallery-version]: https://img.shields.io/powershellgallery/v/pspuppetorchestrator
