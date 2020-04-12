InModuleScope PSPuppetOrchestrator {
    Describe 'Get-PuppetAuthToken' -Tag unit {
        function Invoke-RestMethod {param([switch]$SkipCertificateCheck)}
        $password = ConvertTo-SecureString "password" -AsPlainText -Force
        $creds = New-Object System.Management.Automation.PSCredential -ArgumentList ('admin', $password)
        Mock Invoke-RestMethod { [pscustomobject]@{token = "MockedTokenText" } }

        context 'Invoke-RestMethod Supports Skip Certificate Check' {
            Mock Get-Help { $true }
            Mock Set-ServerCertificateValidationCallback {}

            it "Should use -SkipCertificateCheck if Invoke-RestMethod supports it" {
                Get-PuppetAuthToken -Master 'master' -Credential $creds -SkipCertificateCheck | Should -Be "MockedTokenText"
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It -ParameterFilter { $true -eq $PSBoundParameters.ContainsKey('SkipCertificateCheck')}
                Assert-MockCalled -CommandName 'Set-ServerCertificateValidationCallback' -Times 0 -Scope It
            }

            it "Should not use -SkipCertificateCheck if the invocation omits it" {
                Get-PuppetAuthToken -Master 'master' -Credential $creds | Should -Be "MockedTokenText"
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It -ParameterFilter { $false -eq $PSBoundParameters.containsKey('SkipCertificateCheck') }
                Assert-MockCalled -CommandName 'Set-ServerCertificateValidationCallback' -Times 0 -Scope It
            }
        }

        context 'Invoke-RestMethod does not support Skip Certificate Check' {
            Mock Get-Help { $false }
            Mock Set-ServerCertificateValidationCallback {}

            it "Should set cert callback method it" {
                Get-PuppetAuthToken -Master 'master' -Credential $creds -SkipCertificateCheck | Should -Be "MockedTokenText"
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It -ParameterFilter {$false -eq $PSBoundParameters.ContainsKey('SkipCertificateCheck')}
                Assert-MockCalled -CommandName 'Set-ServerCertificateValidationCallback' -Scope It
            }

            it "Should not use set the callback method if the invocation omits it" {
                Get-PuppetAuthToken -Master 'master' -Credential $creds | Should -Be "MockedTokenText"
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It -ParameterFilter {$false -eq $PSBoundParameters.ContainsKey('SkipCertificateCheck')}
                Assert-MockCalled -CommandName 'Set-ServerCertificateValidationCallback' -Times 0 -Scope It
            }
        }
    }
}
