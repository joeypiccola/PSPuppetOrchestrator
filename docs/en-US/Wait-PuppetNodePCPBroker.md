---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Wait-PuppetNodePCPBroker

## SYNOPSIS
Returns Hello world

## SYNTAX

```
Wait-PuppetNodePCPBroker [-Token] <String> [-Master] <String> [-Node] <String> [[-Timeout] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Wait-PuppetNodePCPBroker was originally written in an effort to detect when nodes rebooted by
evaluating a nodes's PCP Broker connected state.
Since the advent of the reboot plan as seen
in https://github.com/puppetlabs/puppetlabs-reboot/blob/master/plans/init.pp Wait-PuppetNodePCPBroker
is no longer a viable solution.
Never was to begin with really.

## EXAMPLES

### EXAMPLE 1
```
Get-HelloWorld
```

Runs the command

## PARAMETERS

### -Token
x

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
x

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
x

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

### -Timeout
x

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
