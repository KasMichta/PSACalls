BeforeAll {
    $here = Split-Path -Parent $PSCommandPath
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . "$here/$sut"
}

Describe "'Invoke-PSARequest' Function Tests" {
    Context 'API Call Methods' {
        BeforeEach{
            Mock Invoke-WebRequest {
                param($method, $uri, $headers, $body)
                Write-Output "Method: $method"
            }
        }
        It 'Should return <_> Method' -ForEach 'GET', 'POST', 'PATCH', 'DELETE' {
            Invoke-PSARequest -method $_ -uri 'https://api.example.com' | Should -Be "Method: $_"
        }
    }

    Context 'API Call URI' {
        BeforeEach{
            Mock Invoke-WebRequest {
                param($method, $uri, $headers, $body)
                Write-Output "URI: $uri"
            }
        }
        It 'Should return URI' {
            Invoke-PSARequest -uri 'https://api.example.com/' | Should -Be 'URI: https://api.example.com/'
        }
    }

    Context 'API Call Headers' {
        BeforeEach{
            Mock Invoke-WebRequest {
                param($method, $uri, $headers, $body)
                Write-Output "Headers: $headers"
            }
        }
        It 'Should return Headers' {
            Invoke-PSARequest -uri 'https://api.example.com' -headers @{ 'Content-Type' = 'application/json' } | Should -Be 'Headers: System.Collections.Hashtable'
        }
    }

    Context 'API Call Body' {
        BeforeEach{
            Mock Invoke-WebRequest {
                param($method, $uri, $headers, $body)
                Write-Output "Body: $body"
            }
        }
        It 'Should return Body' {
            Invoke-PSARequest -uri 'https://api.example.com' -body 'Test Body' | Should -Be 'Body: Test Body'
        }
    }
}
