Get-Module $env:BHProjectName | Remove-Module -Force
$ModuleManifestPath = Join-Path -Path $env:BHBuildOutput -ChildPath "$($env:BHProjectName).psd1"
Import-Module $ModuleManifestPath -Force

InModuleScope PSPuppetOrchestrator {
    Describe 'Get-PuppetJob' -Tag unit {
        function Invoke-RestMethod {}
        Mock Invoke-RestMethod { return @{name = 100} }
        context 'returns jobs as expected' {
            it "should return job 100" {
                (Get-PuppetJob -Token 1 -Master 'pm' -ID 100).name | should -be 100
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
        }
    }
}
