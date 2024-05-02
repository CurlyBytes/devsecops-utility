#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.1.0" }
$ScriptAnalyzerResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot -Severity Warning

BeforeAll {
 
     #Any one valid azure devops projectname
     $azdoProjectname = "Public"

     #Any valid pipeline Id on $azdoProjectname being define
     $azdoPipelineId = 9

    $filename = "azdo_container_step.yml"
    $filepath = "$PSScriptRoot/../../../src/pipeline-as-code/azure-devops/components/$filename"
    # Deserialize the template file for each technology

    $validationResult = Test-VSTeamYamlPipeline -PipelineId $azdoPipelineId -FilePath  $filePath -Branch 'main' -ProjectName $azdoProjectname
    # Deserialize the template file for each technology
    try {
        $template = Get-Content -Path $filepath -raw -ErrorAction Stop | ConvertFrom-Yaml
    . $filepath
    }
    catch {
        # Storing a potential exception in a variable to assert on it later
        $templateException = $_
    }

    Write-Host "Begin Test - $filename" -BackgroundColor DarkMagenta
}

AfterAll {
    Write-Host "End Test - $filename" -BackgroundColor DarkMagenta
}

Describe "azdo_container_step.yml" {

    Context "yaml file parameters" {
        It "Has a required parameter <parameter.name> with type <parameter.type>" {
            $template["parameters"].Where( { $_["name"] -eq $parameter.name } ) | Should -HaveCount 1
            $template["parameters"].Where( { $_["name"] -eq $parameter.name } )[0]["type"] | Should -BeExactly $parameter.type

        } -ForEach @(
              #Begin of adding template parameter here
              @{ parameter = @{ name = "projectName"; type = "string" }},
              @{ parameter = @{ name = "instrumentationKey"; type = "string" }},
              @{ parameter = @{ name = "yamlFullFilePath"; type = "string" }},
              @{ parameter = @{ name = "powershellScriptFullFilePath"; type = "string" }},
              @{ parameter = @{ name = "objectTask"; type = "object" }}
              #End of adding template parameter here
        )
    }

    Context "yaml syntax key:value pair validation" {

        It "Match the expected azdo_container_task.yml (Pipeline Task)" {
            $Elements = 'azdo_container_task.yml'
            $templateResources = $template.steps.template
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }
        
    }

    Context "yaml standards" {
        It 'Should not return any violation' {
            $ScriptAnalyzerResults | Should -BeNullOrEmpty
        }

        It "Should $filename file exist" {
            Test-Path -Path $filepath -PathType Leaf | Should -Be $true
        }

        It "Should $filename is valid yaml file" {
            $filepath | ConvertFrom-Yaml -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }

        It "Should not throw an exception" {
            $templateException | Should -BeNullOrEmpty
        }

        It "<fileName> all #TODO*, #TODO?, #TODO tags are removed" {
            $filePath | Should -Not -FileContentMatch $([regex]::escape('#TODO'))
            $filePath | Should -Not -FileContentMatch $([regex]::escape('#TODO*'))
            $filePath | Should -Not -FileContentMatch $([regex]::escape('#TODO?'))
        }

        It "Should be valid $filename azdo template" {
            $validationResult.id | Should -BeLessOrEqual 0
        }
    }
}
