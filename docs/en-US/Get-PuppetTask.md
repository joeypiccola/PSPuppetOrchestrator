---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Get-PuppetTask

## SYNOPSIS
Get details on a Puppet task.

## SYNTAX

```
Get-PuppetTask [-Token] <String> [-Master] <String> [[-Module] <String>] [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Get details on a Puppet task.

## EXAMPLES

### EXAMPLE 1
```
Get-PuppetTask -Master $master -Token $token -Name 'reboot'
```

id          : https://puppet:8143/orchestrator/v1/tasks/reboot/init
name        : reboot
permitted   : True
metadata    : @{description=Reboots a machine; implementations=System.Object\[\]; input_method=stdin; parameters=; supports_noop=False}
files       : {@{filename=init.rb; sha256=fb7e0e0de640b82844be931e59405de73e1e290c9540c204a6c79838a0e39fce; size_bytes=2556; uri=}, @{filename=nix.sh; sha256=dfb2ddfe17056c316d7260bcce853aabc5b18a266888f76b23314d0d4c8daee5; size_bytes=692; uri=}, @{filename=win.ps1; sha256=155f5ab7d63f1913ccf8f4f5563f1b2be2a49130a4787a8c48ff770cfe8e6415; size_bytes=785; uri=}}
environment : @{name=production; code_id=}

### EXAMPLE 2
```
Get-PuppetTask -Master $master -Token $token -Module 'powershell_tasks' -Name 'disablesmbv1'
```

id          : https://puppet:8143/orchestrator/v1/tasks/powershell_tasks/disablesmbv1
name        : powershell_tasks::disablesmbv1
permitted   : True
metadata    : @{description=A task to test if SMBv1 is enabled and optionally disable it.; input_method=powershell; parameters=; puppet_task_version=1}
files       : {@{filename=disablesmbv1.ps1; sha256=c10f3ae37a6e2686c419ec955ee51f9894109ed073bf5c3b3280255b3785e0dc; size_bytes=3536; uri=}}
environment : @{name=production; code_id=}

## PARAMETERS

### -Token
The Puppet API orchestrator token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Module
The module of the puppet task, if applicable.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the Puppet task.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
