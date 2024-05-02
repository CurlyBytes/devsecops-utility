#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.1.0" }
$ScriptAnalyzerResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot -Severity Warning

BeforeAll {

     #Any one valid azure devops projectname
     $azdoProjectname = "Public"

     #Any valid pipeline Id on $azdoProjectname being define
     $azdoPipelineId = 439

    $filename = "task_publish_code_coverage_result.yml"
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

Describe "task_publish_code_coverage_result.yml" {

    Context "yaml file parameters" {
        It "Has a required parameter <parameter.name> with type <parameter.type>" {
            $template["parameters"].Where( { $_["name"] -eq $parameter.name } ) | Should -HaveCount 1
            $template["parameters"].Where( { $_["name"] -eq $parameter.name } )[0]["type"] | Should -BeExactly $parameter.type

        } -ForEach @(
                #Begin of adding template parameter here
                @{ parameter = @{ name = "yamlPipelineConfiguration"; type = "object" }},
                @{ parameter = @{ name = "projectName"; type = "string" }},
                @{ parameter = @{ name = "instrumentationKey"; type = "string" }},
                @{ parameter = @{ name = "powershellScriptFullFilePath"; type = "string" }},
                @{ parameter = @{ name = "displayName"; type = "string" }},
                @{ parameter = @{ name = "condition"; type = "string" }},
                @{ parameter = @{ name = "continueOnError"; type = "boolean" }},
                @{ parameter = @{ name = "codeCoverageTool"; type = "string" }},
                @{ parameter = @{ name = "summaryFileLocation"; type = "string" }},
                @{ parameter = @{ name = "pathToSources"; type = "string" }},
                @{ parameter = @{ name = "additionalCodeCoverageFiles"; type = "string" }},
                @{ parameter = @{ name = "failIfCoverageEmpty"; type = "boolean" }}
                #End of adding template parameter here
        )
    }

    Context "yaml syntax key:value pair validation" {
        It "Match the expected azdo_container_step.yml template" {
            $Elements = 'azdo_container_step.yml'
            $templateResources = $template.steps.template
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.yamlPipelineConfiguration" {
            $Elements = '${{ parameters.yamlPipelineConfiguration }}'
            $templateResources = $template.steps.parameters.yamlPipelineConfiguration
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.projectName" {
            $Elements = '${{ coalesce( parameters.yamlPipelineConfiguration.baseline.projectName, parameters.projectName) }}'
            $templateResources = $template.steps.parameters.projectName
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.instrumentationKey" {
            $Elements = '${{ coalesce( parameters.yamlPipelineConfiguration.baseline.instrumentationKey, parameters.instrumentationKey) }}'
            $templateResources = $template.steps.parameters.instrumentationKey
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.yamlFullFilePath" {
            $Elements = 'src/pipeline-as-code/azure-devops/components/task_publish_code_coverage_result.yml'
            $templateResources = $template.steps.parameters.yamlFullFilePath
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.powershellScriptFullFilePath" {
            $Elements = '${{ coalesce( parameters.yamlPipelineConfiguration.baseline.powershellScriptFullFilePath, parameters.powershellScriptFullFilePath) }}'
            $templateResources = $template.steps.parameters.powershellScriptFullFilePath
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected task" {
            $Elements = 'PublishCodeCoverageResults@1.228.0'
            $templateResources = $template.steps.parameters.objectTask.task
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.displayName" {
            $Elements = '${{ parameters.displayName }}'
            $templateResources = $template.steps.parameters.objectTask.displayName
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.condition" {
            $Elements = '${{ parameters.condition }}'
            $templateResources = $template.steps.parameters.objectTask.condition
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }


        It "Match the expected parameters.continueOnError" {
            $Elements = '${{ parameters.continueOnError }}'
            $templateResources = $template.steps.parameters.objectTask.continueOnError
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.codeCoverageTool" {
            $Elements = '${{ parameters.codeCoverageTool }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.codeCoverageTool
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.summaryFileLocation" {
            $Elements = '${{ parameters.summaryFileLocation }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.summaryFileLocation
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.pathToSources" {
            $Elements = '${{ parameters.pathToSources }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.pathToSources
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.additionalCodeCoverageFiles" {
            $Elements = '${{ parameters.additionalCodeCoverageFiles }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.additionalCodeCoverageFiles
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.failIfCoverageEmpty" {
            $Elements = '${{ parameters.failIfCoverageEmpty }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.failIfCoverageEmpty
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
