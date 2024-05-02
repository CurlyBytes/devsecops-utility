#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.1.0" }
$ScriptAnalyzerResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot -Severity Warning

BeforeAll {
 
     #Any one valid azure devops projectname
     $azdoProjectname = "Public"

     #Any valid pipeline Id on $azdoProjectname being define
     $azdoPipelineId = 9

    $filename = "azdo_container_task.yml"
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

Describe "azdo_container_task.yml" {

    Context "yaml file parameters" {
        It "Has a required parameter <parameter.name> with type <parameter.type>" {
            $template["parameters"].Where( { $_["name"] -eq $parameter.name } ) | Should -HaveCount 1
            $template["parameters"].Where( { $_["name"] -eq $parameter.name } )[0]["type"] | Should -BeExactly $parameter.type

        } -ForEach @(
                #Begin of adding template parameter here
                @{ parameter = @{ name = "task"; type = "string" }},
                @{ parameter = @{ name = "name"; type = "string" }},
                @{ parameter = @{ name = "displayName"; type = "string" }},
                @{ parameter = @{ name = "condition"; type = "string" }},
                @{ parameter = @{ name = "continueOnError"; type = "boolean" }},
                @{ parameter = @{ name = "enabled"; type = "boolean" }},
                @{ parameter = @{ name = "timeoutInMinutes"; type = "string" }},
                @{ parameter = @{ name = "retryCountOnTaskFailure"; type = "string" }},
                @{ parameter = @{ name = "inputs"; type = "object" }},
                @{ parameter = @{ name = "env"; type = "object" }}
                #End of adding template parameter here
        )
    }

    Context "yaml syntax key:value pair validation" {
        It "Match the expected parameters.task" {
            $Elements = '${{ parameters.task }}'
            $templateResources = $template.steps.task
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected condition" {
            $Elements = '${{ parameters.condition }}'
            $templateResources = $template.steps.condition
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.continueOnError" {
            $Elements = '${{ parameters.continueOnError }}'
            $templateResources = $template.steps.continueOnError
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.timeoutInMinutes" {
            $Elements = '${{ parameters.timeoutInMinutes }}'
            $templateResources = $template.steps.timeoutInMinutes
            $Elements | Should -BeIn $templateResources
            $templateResources | Should -Not -BeNullOrEmpty
        }

        It "Match the expected parameters.retryCountOnTaskFailure" {
            $Elements = '${{ parameters.retryCountOnTaskFailure }}'
            $templateResources = $template.steps.retryCountOnTaskFailure
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
