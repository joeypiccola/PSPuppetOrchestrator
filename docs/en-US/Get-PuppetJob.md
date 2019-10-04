---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Get-PuppetJob

## SYNOPSIS
Get details on a puppet job.

## SYNTAX

```
Get-PuppetJob [-ID] <Int32> [-Token] <String> [-Master] <String> [<CommonParameters>]
```

## DESCRIPTION
Get details on a puppet job.

## EXAMPLES

### EXAMPLE 1
```
Get-PuppetJob -Token $token -Master $master -ID 906
```

description :
report      : @{id=https://puppet:8143/orchestrator/v1/jobs/906/report}
name        : 906
events      : @{id=https://puppet:8143/orchestrator/v1/jobs/906/events}
command     : task
type        : task
state       : failed
nodes       : @{id=https://puppet:8143/orchestrator/v1/jobs/906/nodes}
status      : {@{state=ready; enter_time=2019-09-04T16:50:09Z; exit_time=2019-09-04T16:50:10Z}, @{state=running; enter_time=2019-09-04T16:50:10Z; exit_time=2019-09-04T16:50:43Z}, @{state=failed; enter_time=2019-09-04T16:50:43Z; exit_time=}}
id          : https://puppet:8143/orchestrator/v1/jobs/906
environment : @{name=production}
options     : @{description=; transport=pxp; noop=False; task=powershell_tasks::getkb; sensitive=System.Object\[\]; params=; scope=; environment=production}
timestamp   : 2019-09-04T16:50:43Z
owner       : @{email=; is_revoked=False; last_login=2019-09-04T16:48:50.049Z; is_remote=False; login=admin; is_superuser=True; id=42bf351c-f9ec-40af-84ad-e976fec7f4bd; role_ids=System.Object\[\]; display_name=Administrator; is_group=False}
node_count  : 3
node_states : @{failed=1; finished=2}

## PARAMETERS

### -ID
The ID of the job.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
The Puppet API orchestrator token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Master
The Puppet master.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
