#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.1.0" }
$ScriptAnalyzerResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot -Severity Warning

BeforeAll {

     #Any one valid azure devops projectname
     $azdoProjectname = "Public"

     #Any valid pipeline Id on $azdoProjectname being define
     $azdoPipelineId = 9

    $filename = "task_powershell.yml"
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

Describe "task_powershell.yml" {

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
                @{ parameter = @{ name = "name"; type = "string" }},
                @{ parameter = @{ name = "displayName"; type = "string" }},
                @{ parameter = @{ name = "condition"; type = "string" }},
                @{ parameter = @{ name = "continueOnError"; type = "boolean" }},
                @{ parameter = @{ name = "targetType"; type = "string" }},
                @{ parameter = @{ name = "script"; type = "string" }},
                @{ parameter = @{ name = "filePath"; type = "string" }},
                @{ parameter = @{ name = "arguments"; type = "string" }},
                @{ parameter = @{ name = "workingDirectory"; type = "string" }},
                @{ parameter = @{ name = "errorActionPreference"; type = "string" }},
                @{ parameter = @{ name = "progressPreference"; type = "string" }},
                @{ parameter = @{ name = "failOnStderr"; type = "boolean" }},
                @{ parameter = @{ name = "showWarnings"; type = "boolean" }},
                @{ parameter = @{ name = "ignoreLASTEXITCODE"; type = "boolean" }},
                @{ parameter = @{ name = "pwsh"; type = "boolean" }}
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
            $Elements = 'src/pipeline-as-code/azure-devops/components/task_powershell.yml'
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
            $Elements = 'PowerShell@2.230.1'
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

        It "Match the expected parameters.workingDirectory" {
            $Elements = '${{ parameters.workingDirectory }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.workingDirectory
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.workingDirectory" {
            $Elements = '${{ parameters.workingDirectory }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.workingDirectory
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }
        
        It "Match the expected parameters.errorActionPreference" {
            $Elements = '${{ parameters.errorActionPreference }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.errorActionPreference
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.progressPreference" {
            $Elements = '${{ parameters.progressPreference }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.progressPreference
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.showWarnings" {
            $Elements = '${{ parameters.showWarnings }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.showWarnings
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.ignoreLASTEXITCODE" {
            $Elements = '${{ parameters.ignoreLASTEXITCODE }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.ignoreLASTEXITCODE
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.pwsh" {
            $Elements = '${{ parameters.pwsh }}'
            $templateResources = $template.steps.parameters.objectTask.inputs.pwsh
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
    }
}
