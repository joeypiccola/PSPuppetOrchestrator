---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Invoke-PuppetTask

## SYNOPSIS
Returns Hello world

## SYNTAX

```
Invoke-PuppetTask [-Token] <String> [-Master] <String> [-Task] <String> [[-Environment] <String>]
 [[-Parameters] <PSObject>] [[-Description] <String>] [-Scope] <PSObject[]> [-ScopeType] <String>
 [[-Wait] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns Hello world

## EXAMPLES

### EXAMPLE 1
```
Get-HelloWorld
```

Runs the command

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

### -Task
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

### -Environment
x

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
x

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
x

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
x

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScopeType
x

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
x

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
