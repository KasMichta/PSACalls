BeforeAll {
    $here = Split-Path -Parent $PSCommandPath
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . "$here/$sut"
}

Describe "'Set-PSAApiKey' Function Tests" {
}
