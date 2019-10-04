---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Get-PuppetJobReport

## SYNOPSIS
Get the report for a given Puppet job.

## SYNTAX

```
Get-PuppetJobReport [-ID] <Int32> [-Token] <String> [-Master] <String> [<CommonParameters>]
```

## DESCRIPTION
Get the report for a given Puppet job.

## EXAMPLES

### EXAMPLE 1
```
Get-PuppetJobReport -Master $master -Token $token -ID 906
```

node           state    start_timestamp      finish_timestamp     timestamp            events
----           -----    ---------------      ----------------     ---------            ------
den3w108r2psv2 failed   2019-09-04T16:50:10Z 2019-09-04T16:50:12Z 2019-09-04T16:50:12Z {}
den3w108r2psv3 finished 2019-09-04T16:50:10Z 2019-09-04T16:50:42Z 2019-09-04T16:50:42Z {}
den3w108r2psv4 finished 2019-09-04T16:50:10Z 2019-09-04T16:50:43Z 2019-09-04T16:50:43Z {}

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
