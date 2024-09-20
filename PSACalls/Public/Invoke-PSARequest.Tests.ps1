BeforeAll {
    $here = Split-Path -Parent $PSCommandPath
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . "$here/$sut"
}

Describe "'Invoke-PSARequest' Function Tests" {
    Context 'Ran Once' {
        It 'Should run' {
            Invoke-PSARequest | Should -Be "Invoke-PSARequest Ran. Method: GET"
        }
    }
}
