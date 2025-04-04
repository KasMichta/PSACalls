BeforeAll {
    $here = Split-Path -Parent $PSCommandPath
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . "$here/$sut"
    function Get-PSARequestURI {}
    function Invoke-PSARequest {}
}

Describe "'Get-PSARecord' Function Tests" {

    Context "Parameter Tests" {

        It "Should throw an error if 'Type' parameter is empty" {
            { Get-PSARecord '' -ErrorAction stop } | Should -Throw
        }

        It "Should throw an error if 'Type' is invalid" {
            { Get-PSARecord 'invalid' -ErrorAction stop } | Should -Throw
        }

        It "Should not throw an error if 'Type' is valid" {
            Mock Invoke-PSARequest {@{
                content = '{ "type": "valid" }'
                headers = @{}
            }}
            { Get-PSARecord '/service/tickets' -ErrorAction stop } | Should -Not -Throw
        }

        It "Should invoke 'Get-PSARequestURI' function with correct parameters" {
            Mock Get-PSARequestURI { $params }
            Mock Invoke-PSARequest {
                [pscustomobject]@{
                    content = $params | ConvertTo-Json
                    headers = @{}
                }
            }
            Mock Write-Output { $output }
            $type = '/service/tickets'
            $params = @{
                type = $type
                id = 1
                parentId = 2
                grandparentId = 3
                fields = 'id,summary'
                conditions = @{
                    conditions='id=1234'
                    childconditions='id=5678'
                    customfieldconditions='id=91011'
                }
            }
            $test = Get-PSARecord @params
            Should -Invoke Get-PSARequestURI -Times 1
            $test.type | Should -Be $type
            $test.id | Should -Be 1
            $test.parentId | Should -Be 2
            $test.grandparentId | Should -Be 3
            $test.fields | Should -Be 'id,summary'
            $test.conditions.conditions | Should -Be 'id=1234'
            $test.conditions.childconditions | Should -Be 'id=5678'
            $test.conditions.customfieldconditions | Should -Be 'id=91011'
        }
    }

    Context "Output Tests" {
        BeforeAll {
            Mock Invoke-PSARequest {
                [pscustomobject]@{
                    content = '{
                        "type":"service/tickets",
                        "id":"1",
                        "parentId":"2",
                        "grandparentId":"3",
                        "fields":"id,summary",
                        "conditions": {
                            "conditions":"id=1234",
                            "childconditions":"id=5678",
                            "customfieldconditions":"id=91011"
                        }
                    }'
                    headers = @{}
                }
            }
        }

        It "Should return an object" {
            $test = Get-PSARecord '/service/tickets'
            $test | Should -BeOfType [Object]
        }

        It "Should return an object with correct properties" {
            $test = Get-PSARecord '/service/tickets'
            $test.type | Should -Be 'service/tickets'
            $test.id | Should -Be '1'
            $test.parentId | Should -Be '2'
            $test.grandparentId | Should -Be '3'
            $test.fields | Should -Be 'id,summary'
            $test.conditions.conditions | Should -Be 'id=1234'
            $test.conditions.childconditions | Should -Be 'id=5678'
            $test.conditions.customfieldconditions | Should -Be 'id=91011'
        }

        It "Should return valid JSON when -asJSON switch is present" {
            $test = Get-PSARecord '/service/tickets' -asJSON
            $test | Should -BeOfType [String]
            $test | ConvertFrom-Json | Should -BeOfType [Object]
        }
    }
}
