---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Get-PuppetJobResults

## SYNOPSIS
Get the results from a Puppet job.

## SYNTAX

```
Get-PuppetJobResults [-ID] <Int32> [-Token] <String> [-Master] <String> [<CommonParameters>]
```

## DESCRIPTION
Get the results from a Puppet job.

## EXAMPLES

### EXAMPLE 1
```
Get-PuppetJobResults -Master $master -Token $token -ID 930
```

finish_timestamp : 10/4/19 3:45:26 PM
transaction_uuid :
start_timestamp  : 10/4/19 3:45:18 PM
name             : den3w108r2psv5
duration         : 7.767
state            : finished
details          :
result           : @{Source=DEN3W108R2PSV5; HotFixID=KB2620704; Description=Security Update; InstalledBy=NT AUTHORITY\SYSTEM; InstalledOn=Thursday, September 06, 2018 12:00:00 AM}
latest-event-id  : 5709
timestamp        : 10/4/19 3:45:26 PM

finish_timestamp : 10/4/19 3:45:34 PM
transaction_uuid :
start_timestamp  : 10/4/19 3:45:19 PM
name             : den3w108r2psv3
duration         : 15.264
state            : finished
details          :
result           : @{Source=DEN3W108R2PSV3; HotFixID=KB2620704; Description=Security Update; InstalledBy=; InstalledOn=Friday, September 07, 2018 12:00:00 AM}
latest-event-id  : 5712
timestamp        : 10/4/19 3:45:34 PM

finish_timestamp : 10/4/19 3:45:34 PM
transaction_uuid :
start_timestamp  : 10/4/19 3:45:19 PM
name             : den3w108r2psv4
duration         : 15.505
state            : finished
details          :
result           : @{Source=DEN3W108R2PSV4; HotFixID=KB2620704; Description=Security Update; InstalledBy=; InstalledOn=Friday, September 07, 2018 12:00:00 AM}
latest-event-id  : 5713
timestamp        : 10/4/19 3:45:34 PM

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
