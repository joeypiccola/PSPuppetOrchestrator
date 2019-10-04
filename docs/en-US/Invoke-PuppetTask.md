---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Invoke-PuppetTask

## SYNOPSIS
Invoke a Puppet task.

## SYNTAX

```
Invoke-PuppetTask [-Token] <String> [-Master] <String> [-Task] <String> [[-Environment] <String>]
 [[-Parameters] <Hashtable>] [[-Description] <String>] [-Scope] <String[]> [[-ScopeType] <String>]
 [[-Wait] <Int32>] [[-WaitLoopInterval] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Invoke a Puppet task.

## EXAMPLES

### EXAMPLE 1
```
$invokePuppetTaskSplat = @{
```

Token            = $token
    Master           = $master
    Task             = 'powershell_tasks::disablesmbv1'
    Environment      = 'production'
    Parameters       = @{action = 'set'; reboot = $true}
    Description      = 'Disable smbv1 on 08r2 nodes.'
    Scope            = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3')
    ScopeType        = 'nodes'
    Wait             = 120
    WaitLoopInterval = 2
}
PS\> Invoke-PuppetTask @invokePuppetTaskSplat

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

### -Task
The name of the Puppet task to invoke.

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

### -Environment
The name of the Puppet task environment.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Production
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parameters
A hash of parameters to supply the Puppet task, e.g.
$Parameters = @{tp1 = 'foo';tp2 = 'bar'; tp3 = $true}.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A description to submit along with the task.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
An array of nodes the Puppet task will be invoked against, e.g.
$Scope = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3').

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScopeType
When executing tasks against the /command/task API endpoint you can either use
a scope type of 'node' or 'query'.
At this time, PSPuppetOrchestrator only
supports a ScopeType of 'node' which is the DEFAULT and only allowed option for
the ScopeType parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Nodes
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
An optional wait value in seconds that Invoke-PuppetTask will use to wait until
the invoked task completes.
If the wait time is exceeded Invoke-PuppetTask will
return a warning.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WaitLoopInterval
An optional time in seconds that the wait feature will re-check the invoked task.
DEFAULTS to 5s.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
