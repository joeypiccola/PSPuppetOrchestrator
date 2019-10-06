InModuleScope PSPuppetOrchestrator {
    Describe 'Get-PuppetJobResults' -Tag unit {
        function Invoke-RestMethod {}
        context 'returns reports as expected' {
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    items = @('a')
                }
            }
            it "returns one result" {
                (Get-PuppetJobResults -Token 1 -Master 'pm' -ID 100 | Measure-Object).count | should -be 1
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    items = @('a','b')
                }
            }
            it "returns two result" {
                (Get-PuppetJobResults -Token 1 -Master 'pm' -ID 100 | Measure-Object).count | should -be 2
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    items = @{
                        name = 'node1'
                    }
                }
            }
            it "returns single result for node1" {
                (Get-PuppetJobResults -Token 1 -Master 'pm' -ID 100).name | should -be 'node1'
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
        }
    }
}
