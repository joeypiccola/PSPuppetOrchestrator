properties {
    $projectRoot = $ENV:BHProjectPath
    if(-not $projectRoot) {
        $projectRoot = $PSScriptRoot
    }
    $modulePath = $env:BHModulePath
    $tests = "$projectRoot\Tests"
    $outputDir = $ENV:BHBuildOutput
    $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    $psVersion = $PSVersionTable.PSVersion.Major
}

task default -depends Test

task Init {
    "`nSTATUS: Testing with PowerShell $psVersion"
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
} -description 'Initialize build environment'

task Test -Depends Init, Analyze, Pester -description 'Run test suite'

task Analyze -Depends Build {
    $analysis = Invoke-ScriptAnalyzer -Path $outputModDir -Verbose:$false
    $errors = $analysis | Where-Object {$_.Severity -eq 'Error'}
    $warnings = $analysis | Where-Object {$_.Severity -eq 'Warning'}

    if (($errors.Count -eq 0) -and ($warnings.Count -eq 0)) {
        '    PSScriptAnalyzer passed without errors or warnings'
    }

    if (@($errors).Count -gt 0) {
        Write-Error -Message 'One or more Script Analyzer errors were found. Build cannot continue!'
        $errors | Format-Table
    }

    if (@($warnings).Count -gt 0) {
        Write-Warning -Message 'One or more Script Analyzer warnings were found. These should be corrected.'
        $warnings | Format-Table
    }
} -description 'Run PSScriptAnalyzer'

task Pester -Depends Build {
    Push-Location
    Set-Location -PassThru $outputModDir
    if (-not $ENV:BHProjectPath) {
        Set-BuildEnvironment -Path $PSScriptRoot\..
    }

    $origModulePath = $env:PSModulePath
    if ( $env:PSModulePath.split($pathSeperator) -notcontains $outputDir ) {
        $env:PSModulePath = ($outputDir + $pathSeperator + $origModulePath)
    }

    Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue -Verbose:$false
    Import-Module -Name $outputModDir -Force -Verbose:$false
    $testResultsXml = Join-Path -Path $outputDir -ChildPath 'testResults.xml'
    $testResults = Invoke-Pester -Path $tests -PassThru -OutputFile $testResultsXml -OutputFormat NUnitXml

    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
    }
    Pop-Location
    $env:PSModulePath = $origModulePath
} -description 'Run Pester tests'

task Build -depends Compile, CreateMarkdownHelp, CreateExternalHelp {
    $OutputModDirDataFile = Join-Path -Path $OutputModDir -ChildPath "$($ENV:BHProjectName).psd1"
    # Bump the module version if we didn't already
    Try
    {
        $GalleryVersion = Get-NextNugetPackageVersion -Name $env:BHProjectName -ErrorAction Stop
        $GithubVersion = Get-MetaData -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -ErrorAction Stop
        if($GalleryVersion -ge $GithubVersion) {
            Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $GalleryVersion -ErrorAction stop
        }
    }
    Catch
    {
        "Failed to update version for '$env:BHProjectName': $_.`nContinuing with existing version"
    }
    Push-Location -Path $OutputDir
    Write-Verbose -Message 'Adding exported functions to psd1...'
    Set-ModuleFunction
    Pop-Location
    "    Exported public functions added to output data file at [$OutputModDirDataFile]"
} -description 'Adds exported functions to psd1'

task Compile -depends Clean {
    # Create module output directory
    New-Item -Path $OutputModDir -ItemType Directory > $null

    # Append items to psm1
    Write-Verbose -Message 'Creating psm1...'
    $psm1 = Copy-Item -Path (Join-Path -Path $ModulePath -ChildPath "$($ENV:BHProjectName).psm1") -Destination (Join-Path -Path $OutputModDir -ChildPath "$($ENV:BHProjectName).psm1") -PassThru

    # Add public and private functions to psms1-
    Get-ChildItem -Path (Join-Path -Path $ModulePath -ChildPath 'Private') -Recurse |
        Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8
    Get-ChildItem -Path (Join-Path -Path $ModulePath -ChildPath 'Public') -Recurse |
        Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8
    Copy-Item -Path $env:BHPSModuleManifest -Destination $OutputModDir
    "    Created compiled module at [$OutputModDir]"
} -description 'Compiles module from source'

task Clean -depends Init {
    Remove-Module -Name $env:BHProjectName -Force -ErrorAction SilentlyContinue

    if (Test-Path -Path $outputDir) {
        Get-ChildItem -Path $outputDir -Recurse | Remove-Item -Force -Recurse
    } else {
        New-Item -Path $outputDir -ItemType Directory > $null
    }
    "    Cleaned previous output directory [$outputDir]"
} -description 'Cleans module output directory'

task CreateMarkdownHelp -Depends Compile {
    # functions
    Import-Module -Name $outputModDir -Verbose:$false -Global
    $mdHelpPath = Join-Path -Path $projectRoot -ChildPath 'docs/reference/functions'
    $mdFiles = New-MarkdownHelp -Module $env:BHProjectName -OutputFolder $mdHelpPath -WithModulePage -Force
    "    $env:BHProjectName markdown help created at [$mdHelpPath]"

    @($env:BHProjectName).ForEach({
        Remove-Module -Name $_ -Verbose:$false
    })
} -description 'Create initial markdown help files'

task UpdateMarkdownHelp -Depends Compile {
    #Import-Module -Name $sut -Force -Verbose:$false
    # Import-Module -Name $outputModDir -Verbose:$false -Force
    Import-Module -Name $outputModDir -Verbose:$false -Global
    $mdHelpPath = Join-Path -Path $projectRoot -ChildPath 'docs/reference/functions'
    $mdFiles = Update-MarkdownHelpModule -Path $mdHelpPath -Verbose:$false
    "    Markdown help updated at [$mdHelpPath]"
} -description 'Update markdown help files'

task CreateExternalHelp -Depends CreateMarkdownHelp {
    New-ExternalHelp "$projectRoot\docs\reference\functions" -OutputPath "$OutputModDir\en-US" -Force > $null
} -description 'Create module help from markdown files'

Task RegenerateHelp -Depends UpdateMarkdownHelp, CreateExternalHelp

task Publish -Depends Test {
    "    Publishing version [$($manifest.ModuleVersion)] to PSGallery..."
    Publish-Module -Path $OutputModDir -NuGetApiKey $env:PSGALLERY_API_KEY -Repository PSGallery
} -description 'Publish module'

task UploadTestResults {
    # upload results to AppVeyor
    $wc = New-Object 'System.Net.WebClient'
    $wc.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Join-Path -Path $OutputDir -ChildPath 'testResults.xml'))
} -description 'Uploading tests'
