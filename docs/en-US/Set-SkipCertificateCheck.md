---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Set-SkipCertificateCheck

## SYNOPSIS
Detect Invoke-RestMethod version and ignore server ssl certs.

## SYNTAX

```
Set-SkipCertificateCheck [-SkipCertificateCheck] <Boolean> [-params] <Hashtable> [<CommonParameters>]
```

## DESCRIPTION
Detect whether certificate checking should be skipped via the switch
parameter on Invoke-RestMethod or via setting the ServerCertificateCallback
setting.

## EXAMPLES

### EXAMPLE 1
```
$invokeParams = @{
>>         Uri                  = $uri
>>         Method               = 'Post'
>>         Body                 = $req
>>         ContentType          = 'application/json'
>>     }
```

PS \> $invokeParams = Set-SkipCertificateCheck -SkipCertificateCheck $SkipCertificateCheck -Params $invokeParams

PS \> Invoke-RestMethod @invokeParams | Select-Object -ExpandProperty token

This example detect if the current version of Invoke-RestMethod implements the -SkipCertificateCheck switch parameter
If it does then it will add that key to the $invokeParams hash table for use when splatting with Invoke-RestMethod.
If it does not then it will set the ServerCertificateValidationCallback method in .NET to always return $true
to acheive the same effect in PowerShell 5.1

## PARAMETERS

### -SkipCertificateCheck
Indicate that you would like to skip SSL Certificate validation from
the Master server and trust the certificate you receive.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -params
The hash table of params you will eventually use with Invoke-RestMethod.
This cmdlet will add a SkipCertificateCheck key and set it to true if
the current version of Invoke-RestMethod supports that switch.
If it
does not then it will set the ServerCertificateValidationCallback
method to always return true and achieve the same effect.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
