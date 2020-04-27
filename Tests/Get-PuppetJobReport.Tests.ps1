Get-Module $env:BHProjectName | Remove-Module -Force
$ModuleManifestPath = Join-Path -Path $env:BHBuildOutput -ChildPath "$($env:BHProjectName).psd1"
Import-Module $ModuleManifestPath -Force

InModuleScope PSPuppetOrchestrator {
    Describe 'Get-PuppetJobReport' -Tag unit {
        function Invoke-RestMethod {}
        context 'returns reports as expected' {
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    report = @('a')
                }
            }
            it "returns one report" {
                (Get-PuppetJobReport -Token 1 -Master 'pm' -ID 100 | Measure-Object).count | should -be 1
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    report = @('a','b')
                }
            }
            it "returns two reports" {
                (Get-PuppetJobReport -Token 1 -Master 'pm' -ID 100 | Measure-Object).count | should -be 2
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    report = @{
                        node = 'node1'
                    }
                }
            }
            it "returns single report for node1" {
                (Get-PuppetJobReport -Token 1 -Master 'pm' -ID 100).node | should -be 'node1'
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
        }
    }
}
