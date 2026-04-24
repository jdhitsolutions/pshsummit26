BeforeAll {
    # Build the module before running tests
    $projectPath = "$PSScriptRoot/../src/PsStrongTypes"
    dotnet build $projectPath -c Debug | Out-Null
    $dll = "$projectPath/bin/Debug/netstandard2.0/PsStrongTypes.dll"
    Import-Module $dll -Force
}

Describe "Get-Greeting" {
    It "returns a GreetingResult for a given name" {
        $result = Get-Greeting -Name "World"
        $result | Should -BeOfType [PsStrongTypes.GreetingResult]
        $result.Name | Should -Be "World"
        $result.Message | Should -BeLike "*World*"
    }

    It "accepts pipeline input by property name" {
        $input = [PSCustomObject]@{ Name = "Alice" }
        $result = $input | Get-Greeting
        $result.Name | Should -Be "Alice"
    }

    It "rejects empty Name" {
        { Get-Greeting -Name "" } | Should -Throw
    }

    It "emits Count results when Count is specified" {
        $results = Get-Greeting -Name "World" -Count 3
        $results | Should -HaveCount 3
    }

    It "accepts ByTemplate parameter set" {
        $result = Get-Greeting -Template "Greetings, earthling!"
        $result | Should -BeOfType [PsStrongTypes.GreetingResult]
        $result.Message | Should -Be "Greetings, earthling!"
    }
}
