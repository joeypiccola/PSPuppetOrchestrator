Get-Module $env:BHProjectName | Remove-Module -Force
$ModuleManifestPath = Join-Path -Path $env:BHBuildOutput -ChildPath "$($env:BHProjectName).psd1"
Import-Module $ModuleManifestPath -Force

InModuleScope PSPuppetOrchestrator {
    Describe 'Get-PuppetTask' -Tag unit {
        function Invoke-RestMethod {}
        context 'returns tasks as expected' {
            it "should return module task" -Skip {
                # $ptask = 'myTask'
                # $pModule = 'myModule'
                # $returnTask = "$pTask::$pModule"
                # $master = 'pm'
                # $header_param = @{'X-Authentication' = 1}
                # $uri_param = "https://$master`:8143/orchestrator/v1/tasks/$ptask/$pModule"
                # $method_param = 'Get'
                # $ea_param = 'SilentlyContinue'
                # Mock -CommandName Invoke-RestMethod -MockWith { return @{name = $returnTask}} -ParameterFilter {$uri -eq $uri_param -and $method -eq $method_param -and $headers -eq $header_param -and $erroraction -eq $ea_param}
                # (Get-PuppetTask -Token 1 -Master $master -Name $ptask -Module $pModule).name | should -be $returnTask
                # Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly -Scope It
            }
            it "should return built-in task" -Skip {
                # $ptask = 'reboot'
                # $pModule = ''
                # $master = 'pm'
                # $uri_param_1st = "https://$master`:8143/orchestrator/v1/tasks/$pModule/$ptask"
                # $uri_param_2nd = "https://$master`:8143/orchestrator/v1/tasks/$ptask/init"
                # $token = 1
                # $header_param = @{'X-Authentication' = $token}
                # $method_param = 'Get'
                # Mock -CommandName Invoke-RestMethod -MockWith { throw } -ParameterFilter { ($uri -eq $uri_param_1st) -and ($method -eq $method_param) -and ($headers -eq $header_param) }
                # Mock -CommandName Invoke-RestMethod -MockWith { return @{name = $ptask}} -ParameterFilter { ($uri -eq $uri_param_2nd) -and ($method -eq $method_param) -and ($headers -eq $header_param) }
                # (Get-PuppetTask -Token $token -Master $master -Name $ptask).name | should -be $ptask
                # Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 5 -Exactly -Scope It
            }
        }
    }
}
