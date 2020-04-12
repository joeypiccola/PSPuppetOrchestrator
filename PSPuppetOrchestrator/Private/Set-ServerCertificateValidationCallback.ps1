function Set-ServerCertificateValidationCallback {
    <#
    .SYNOPSIS
        A stub for testing purposes.
    .DESCRIPTION
        This cmdlet stubs the call to setting the callback to true so that it
        can tested via pester and it's use can be detected via Assert-MockCalled

    .EXAMPLE
        Set-ServerCertificateValidationCallback

        This is a stub method used internally to make Pester Testing easier. It sets
        the ServerCertificateValidationCallback method in a way that's easier to
        Mock during testing.
    #>

    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
}
