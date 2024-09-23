BeforeAll {
    $here = Split-Path -Parent $PSCommandPath
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . "$here\$sut"
}

Describe "'Get-ValidPSAEndpoint' Function Tests" {
    BeforeEach {
        Mock Get-Content {
            '{
                "service": {
                    "tickets":{
                        "{id}":{}
                    }
                },
                "system":{
                    "members":{},
                    "myMembers":{}
                }
            }'
        }
    }
    Context "'/' character" {
        It "Should return all root level endpoints" {
            $type = '/'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Be '/service', '/system'
        }
    }
    Context "Partial root-level match" {
        It "Should return the matching endpoint when only one match" {
            $type = 'serv'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Be '/service'
        }
        It "Should return all matching endpoints when multiple matches" {
            $type = 'e'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Be '/service', '/system'
        }
    }
    Context "Full root-level match" {
        It "Should return the matching endpoint" {
            $type = 'system'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Be '/system'
        }
    }

    Context "Trailing slash" {
        It "Should return single-quote enclosed endpoint" {
            $type = '/system/'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Not -Be '/system/members', '/system/myMembers'
            $result | Should -Be "'/system/members'", "'/system/myMembers'"
        }
        It "Should return all child endpoints for type" {
            $type = '/system/'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Be "'/system/members'", "'/system/myMembers'"
        }
    }

    Context "Partial match after right-most slash" {
        It "Should return the matching endpoint when only one match" {
            $type = '/system/mymem'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Be "'/system/myMembers'"
        }
        It "Should return all matching endpoints when multiple matches" {
            $type = '/system/members'
            $result = Get-ValidPSAEndpoint -type $type
            $result | Should -Be "'/system/members'", "'/system/myMembers'"
        }
    }
}
