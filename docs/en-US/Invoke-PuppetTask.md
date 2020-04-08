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

### nodes
```
Invoke-PuppetTask -Token <String> -Master <String> -Task <String> [-Environment <String>]
 [-Parameters <Hashtable>] [-Description <String>] [-Wait <Int32>] [-WaitLoopInterval <Int32>]
 -Nodes <String[]> [<CommonParameters>]
```

### query
```
Invoke-PuppetTask -Token <String> -Master <String> -Task <String> [-Environment <String>]
 [-Parameters <Hashtable>] [-Description <String>] [-Wait <Int32>] [-WaitLoopInterval <Int32>] -Query <String>
 [<CommonParameters>]
```

### node_group
```
Invoke-PuppetTask -Token <String> -Master <String> -Task <String> [-Environment <String>]
 [-Parameters <Hashtable>] [-Description <String>] [-Wait <Int32>] [-WaitLoopInterval <Int32>]
 -Node_group <String> [<CommonParameters>]
```

## DESCRIPTION
Invoke a Puppet task.

## EXAMPLES

### EXAMPLE 1
```
$invokePuppetTaskSplat = @{
    Token            = $token
    Master           = $master
    Task             = 'powershell_tasks::disablesmbv1'
    Environment      = 'production'
    Parameters       = @{action = 'set'; reboot = $true}
    Description      = 'Disable smbv1 on 08r2 nodes.'
    Nodes            = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3')
}
PS> Invoke-PuppetTask @invokePuppetTaskSplat
```

id                                                       name
--                                                       ----
https://puppet.contoso.us:8143/orchestrator/v1/jobs/1318 1318

### EXAMPLE 2
```
$invokePuppetTaskSplat = @{
    Token            = $token
    Master           = $master
    Task             = 'powershell_tasks::disablesmbv1'
    Environment      = 'production'
    Parameters       = @{action = 'set'; reboot = $true}
    Description      = 'Disable smbv1 on 08r2 nodes.'
    Query            = '["from", "inventory", ["=", "facts.os.name", "windows"]]'
}
PS> Invoke-PuppetTask @invokePuppetTaskSplat
```

id                                                       name
--                                                       ----
https://puppet.contoso.us:8143/orchestrator/v1/jobs/1318 1318

### EXAMPLE 3
```
$invokePuppetTaskSplat = @{
    Token            = $token
    Master           = $master
    Task             = 'powershell_tasks::disablesmbv1'
    Environment      = 'production'
    Parameters       = @{action = 'set'; reboot = $true}
    Description      = 'Disable smbv1 on 08r2 nodes.'
    Node_group       = '7a692b61-8087-4452-9cf8-58ed2acee2a0'
}
PS> Invoke-PuppetTask @invokePuppetTaskSplat
```

id                                                       name
--                                                       ----
https://puppet.contoso.us:8143/orchestrator/v1/jobs/1318 1318

## PARAMETERS

### -Token
The Puppet API orchestrator token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
Default value: None
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
Position: Named
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
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -Nodes
An array of node names to target, e.g.
$Scope = @('DEN3W108R2PSV5','DEN3W108R2PSV4','DEN3W108R2PSV3').

```yaml
Type: String[]
Parameter Sets: nodes
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
A PuppetDB or PQL query to use to discover nodes.
The target is built from the certname values collected at
the top level of the query, e.g.
'\["from", "inventory", \["=", "facts.os.name", "windows"\]\]'.

```yaml
Type: String
Parameter Sets: query
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Node_group
A classifier node group ID.
The ID must correspond to a node group that has defined rules.
It is not sufficient
for parent groups of the node group in question to define rules.
The user must also have permissions to view the
node group.
Any nodes specified in the scope that the user does not have permissions to run the task on are
excluded, e.g.
7a692b61-8087-4452-9cf8-58ed2acee2a0.

```yaml
Type: String
Parameter Sets: node_group
Aliases:

Required: True
Position: Named
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
