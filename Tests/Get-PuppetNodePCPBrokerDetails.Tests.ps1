Get-Module $env:BHProjectName | Remove-Module -Force
$ModuleManifestPath = Join-Path -Path $env:BHBuildOutput -ChildPath "$($env:BHProjectName).psd1"
Import-Module $ModuleManifestPath -Force

InModuleScope PSPuppetOrchestrator {
    Describe 'Get-PuppetPCPNodeBrokerDetails' -Tag unit {
        function Invoke-RestMethod {}
        Mock Invoke-RestMethod { return @{name = 'node1'} }
        context 'returns PCP Broker Details as expected' {
            it "should return pcp broker details for node1" {
                (Get-PuppetPCPNodeBrokerDetails -Token 1 -Master 'pm' -Node 'node1').name | should -be 'node1'
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
        }
    }
}
