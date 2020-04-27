Get-Module $env:BHProjectName | Remove-Module -Force
$ModuleManifestPath = Join-Path -Path $env:BHBuildOutput -ChildPath "$($env:BHProjectName).psd1"
Import-Module $ModuleManifestPath -Force

InModuleScope PSPuppetOrchestrator {
    Describe 'Get-PuppetTasks' -Tag unit {
        function Invoke-RestMethod {}
        context 'returns tasks as expected' {
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    items = @('a')
                }
            }
            it "returns one task" {
                (Get-PuppetTasks -Token 1 -Master 'pm' | Measure-Object).count | should -be 1
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    items = @('a','b')
                }
            }
            it "returns two tasks" {
                (Get-PuppetTasks -Token 1 -Master 'pm' | Measure-Object).count | should -be 2
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
        }
    }
}
