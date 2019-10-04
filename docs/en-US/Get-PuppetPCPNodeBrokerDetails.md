---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Get-PuppetPCPNodeBrokerDetails

## SYNOPSIS
Get a node's PCP broker details.

## SYNTAX

```
Get-PuppetPCPNodeBrokerDetails [-Token] <String> [-Master] <String> [-Node] <String> [<CommonParameters>]
```

## DESCRIPTION
Get a node's PCP broker details.
This is useful if you want to know the status of PCP before executing a task or plan.

## EXAMPLES

### EXAMPLE 1
```
Get-PuppetPCPNodeBrokerDetails -Master $master -Token $token -Node 'den3w108r2psv3'
```

name      : den3w108r2psv3
connected : True
broker    : pcp://puppet/server
timestamp : 10/2/19 2:01:53 AM

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

### -Node
The Puppet node name.

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
