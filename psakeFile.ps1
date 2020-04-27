properties {
    # vars to support psake task UploadTestResults used in appveyor.yml
    $testResultsPath = Join-Path -Path $PSScriptRoot -ChildPath "output/$env:BHProjectName/testResults.xml"
    $PSBPreference.Test.OutputFile = $testResultsPath
    # other PowerShellBuild preferences
    $PSBPreference.Build.CompileModule = $true
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.4.0'

task UploadTestResults {
    $wc = New-Object 'System.Net.WebClient'
    $wc.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", $testResultsPath)
} -description 'Uploading tests'
