param (
    [Parameter(Mandatory = $true)]
    [string]
    $ModulePath,

    [Parameter(Mandatory = $false)]
    [switch]
    $Publish,

    [Parameter(Mandatory=$false)]
    [string]
    $ResultsPath,

    [Parameter(Mandatory = $true)]
    [string]
    $TestType,

    [Parameter(Mandatory = $true)]
    [string]
    $Organizationname,

    [Parameter(Mandatory = $true)]
    [string]
    $AzdoPatToken
)

$pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
if (!$pesterModule) {
    try {
        Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -MinimumVersion "5.0"
        $pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
    }
    catch {
        Write-Error "Failed to install the Pester module."
    }
}

$yamlModule = Get-Module -Name powershell-yaml -ListAvailable | Where-Object {$_.Version -like '0.*'}
if (!$yamlModule) {
    try {
        Install-Module -Name powershell-yaml -Scope CurrentUser -Force
        $yamlModule = Get-Module -Name powershell-yaml -ListAvailable | Where-Object {$_.Version -like '0.*'}

    }
    catch {
        Write-Error "Failed to install the powershell-yaml module."
    }
}

$yamlVSTeamModule = Get-Module -Name VSTeam -ListAvailable | Where-Object {$_.Version -like '6.*'}
if (!$yamlVSTeamModule) {
    try {
        Install-Module -Name VSTeam -Scope CurrentUser -Force
        $yamlVSTeamModule = Get-Module -Name VSTeam -ListAvailable | Where-Object {$_.Version -like '6.*'}

    }
    catch {
        Write-Error "Failed to install the VSTeam module."
    }
}


Write-Host "Pester version: $($pesterModule.Version.Major).$($pesterModule.Version.Minor).$($pesterModule.Version.Build)"
$pesterModule | Import-Module

Write-Host "Poweshell Yaml version: $($yamlModule.Version.Major).$($yamlModule.Version.Minor).$($yamlModule.Version.Build)"
$yamlModule | Import-Module

if ($Publish) {
    if (!(Test-Path -Path $ResultsPath)) {
        Write-Host "Create new folder for output of the files"
        New-Item -Path $ResultsPath -ItemType Directory -Force | Out-Null
    }
}

Write-Host "Getting all test case for $($TestType)"
$tests = (Get-ChildItem -Path $($ModulePath) -Recurse | Where-Object {$_.Name -like "*$($TestType).psm1" -or $_.Name -like "*$($TestType).ps1" -and $_.FullName -notlike "*\scripts\*"}).FullName

$configuration = [PesterConfiguration]::Default;
$configuration.Output.Verbosity = 'Detailed'
$configuration.Run.Path = $tests;
$configuration.Run.Exit = $true
$configuration.Should.ErrorAction = 'silentlyContinue'

#For AzDo yaml template validation
Set-VSTeamAccount -Account $Organizationname -PersonalAccessToken $AzdoPatToken

if ($Publish) {
    # Generate the JaCoCo file 'coverage.xml' in /output.
    $configuration.CodeCoverage.Enabled = $true
    $configuration.CodeCoverage.OutputFormat = 'JaCoCo' #JaCoCo
    $configuration.CodeCoverage.OutputPath = "$($ResultsPath)/Pester-$($TestType)-CodeCoverage.xml"
    $configuration.CodeCoverage.OutputEncoding = 'UTF8'
    $configuration.CodeCoverage.ExcludeTests = $true # Exclude our own test code from code coverage.

    # Generate the NUNit 2.5 file 'testResults.xml' in /output
    $configuration.TestResult.Enabled = $true
    $configuration.TestResult.OutputFormat = 'NUnitXml' #NUnitXml
    $configuration.TestResult.OutputPath =  "$($ResultsPath)/Pester-$($TestType).xml"
    $configuration.TestResult.OutputEncoding = 'UTF8'
    $configuration.TestResult.TestSuiteName = "Pester5 $($TestType)" # Can be set to any name, preferably the module name?

    Write-Host "Run Pester Scripts Command"
    $results = Invoke-Pester -Configuration $configuration
} else {
    Write-Host "Run Pester Scripts Command"
    $results = Invoke-Pester -Configuration $configuration
}

[xml]$pesterCoverageOut = get-content -path "$($ResultsPath)/Pester-$($TestType)-CodeCoverage.xml"
foreach ($classNode in $pesterCoverageOut.SelectNodes("//class")) {
    $classNode.sourcefilename = "tests/azure-devops/$($classNode.sourcefilename)"
}
foreach ($sourceFileNode in $pesterCoverageOut.SelectNodes("//sourcefile")) {
    $sourceFileNode.name = "tests/azure-devops/$($sourceFileNode.name)"
}
$pesterCoverageOut.Save("$($ResultsPath)/Pester-$($TestType)-CodeCoverage.xml")

# Set the path to the output SonarQube Generic Test Coverage format XML file
$outputFile = "$($ResultsPath)/sonar-generic-coverage.xml"

[xml]$inputXml = Get-Content "$($ResultsPath)/Pester-$($TestType)-CodeCoverage.xml"
$indent = "  " # Two spaces
$newline = "`r`n" # Windows-style line ending
$outputXml = '<coverage version="1">' + $newline
foreach ($sourcefile in $inputXml.report.package.sourcefile) {
    $filePath = $sourcefile.name -replace "/", "/"
    $fileNode = $indent + "<file path=`"$filePath`">" + $newline
    foreach ($line in $sourcefile.line) {
        $covered = $line.ci -gt 0
        $lineNode = $indent + $indent + "<lineToCover lineNumber=`"$($line.nr)`" covered=`"$covered`"/>" + $newline
        $fileNode += $lineNode
    }
    $fileNode += $indent + "</file>" + $newline
    $outputXml += $fileNode
}
$outputXml += "</coverage>"

$outputXml | Out-File $outputFile -Encoding UTF8