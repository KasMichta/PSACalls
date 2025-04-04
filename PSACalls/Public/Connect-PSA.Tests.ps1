BeforeAll {
    $here = Split-Path -Parent $PSCommandPath
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . "$here/$sut"
    function Set-PSAAPIKey {}
}


Describe "'Connect-PSA' Function Tests" {
    Context "Using Direct Parameters" {
        It "Should invoke 'Set-PSAAPIKey'" {
            Mock Set-PSAAPIKey {}
            Connect-PSA -ClientId '1234' -company 'company' -publickey 'publickey' -privatekey 'privatekey'
            Should -Invoke Set-PSAAPIKey -Times 1
        }
        It "Should set environment variables" {
            Mock Set-PSAAPIKey { 'publickey:privatekey' }
            Connect-PSA -ClientId '1234' -company 'company' -publickey 'publickey' -privatekey 'privatekey' -baseuri 'testUri'
                (Get-Item Env:/PSA_ClientID).value | Should -Be '1234'
                (Get-Item Env:/PSA_APIKey).value | Should -Be 'publickey:privatekey'
                (Get-Item Env:/PSA_BaseURI).value | Should -Be 'testUri'
        }
    }

    Context "Using authFile" {
        It "Should invoke 'Set-PSAAPIKey'" {
            Mock Set-PSAAPIKey {}
            Mock Get-Content {
                '{
                "ClientId": "1234",
                "Company": "company",
                "PublicKey": "publickey",
                "PrivateKey": "privatekey"
            }'
            }
            Connect-PSA -authFile 'testFile'
            Should -Invoke Set-PSAAPIKey -Times 1
        }
        It "Should set environment variables" {
            Mock Set-PSAAPIKey { 'publickey:privatekey' }
            Mock Get-Content {
                '{
                "ClientId": "1234",
                "Company": "company",
                "PublicKey": "publickey",
                "PrivateKey": "privatekey"
            }'
            }
            Connect-PSA -authFile 'testFile' -baseuri 'testUri'
                (Get-Item Env:/PSA_ClientID).value | Should -Be '1234'
                (Get-Item Env:/PSA_APIKey).value | Should -Be 'publickey:privatekey'
                (Get-Item Env:/PSA_BaseURI).value | Should -Be 'testUri'
        }
    }
}
