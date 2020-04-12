---
external help file: PSPuppetOrchestrator-help.xml
Module Name: PSPuppetOrchestrator
online version:
schema: 2.0.0
---

# Get-PuppetAuthToken

## SYNOPSIS
Get a Puppet Auth Token for use with API calls.

## SYNTAX

```
Get-PuppetAuthToken [-Master] <String> [[-Lifetime] <String>] [[-Port] <Int32>] [-Credential] <PSCredential>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Call the /rbac-api/v1/auth/token end point with a username and password
to obtain an authorization token that can be used with the other
cmdlets in this module.

## EXAMPLES

### EXAMPLE 1
```
$cred = Get-Credential -Username Admin
PS > $token = Get-PuppetAuthToken -Master 'pe-master.corp.net' -SkipCertificateCheck -Credential $cred
```

Create a credential object and then call this cmdlet to retrieve a token

### EXAMPLE 2
```
$token = Get-PuppetAuthToken -Master 'pe-master.corp.net' -SkipCertificateCheck
```

If you do not pass a credential object, you will be prompted for credentials.

### EXAMPLE 3
```
$token = Get-PuppetAuthToken -Lifetime '2m' -Master 'pe-master.corp.net' -SkipCertificateCheck
```

Create a short lived token so that an automated process can use it but it
dies quickley thereafter.

## PARAMETERS

### -Master
The FQDN of the Puppet Master server that your DNS can resolve.
You do
not need to include the HTTPS portion of the address.
Only the server name.

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

### -Lifetime
An integer value specifying how long you would like the token to last
paired with one of the letter \[smhdy\] (example '2d' for two days) to
specify the units of time in seconds, minutes, hours, days, or years.
If
you call this cmdlet to request a token within the valid lifetime of
your current token, you will receive your current token back again.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1d
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port your Puppet Master API end poins are listening on.
Be default
this will be 4433, but it is configurable.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 4433
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
A PSCredential object that contains the username and password for the user
you would like to receive a token for.
If you do not provide one you will
be prompted at the commandline for one.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Skip certificate validation on the SSL certificate provided by the Puppet
master server you connect to.
This parameter will function as expected
for both PowerShell 5.1 and 6+.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Inputs (if any)
## OUTPUTS

### [String] Authorization Token Value.
## NOTES

## RELATED LINKS
