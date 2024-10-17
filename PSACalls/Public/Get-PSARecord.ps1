Function Get-PSARecord {
    [CmdletBinding()]
    param (
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-ValidPSAEndpoint -type $wordToComplete -method 'get'
            })]
        [string]$type,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string]$parentId,
        [string]$recordId,
        [array]$fields,
        [hashtable]$conditions,
        [switch]$asJSON = $false
    )

    begin {

        Write-Verbose "Using API Path:`n`tURI:`t{BaseURI}$type"

    }

    process {
        $query = $($type -replace "{parentId}", $parentId -replace "{id}", $recordId)

        if ( $conditions -and
            !$conditions.ContainsKey('conditions') -and
            !$conditions.ContainsKey('childconditions') -and
            !$conditions.ContainsKey('customfieldconditions')) {
            Write-Error "parameter '-conditions' expecting [hashtable] containing at least one of the following keys: conditions, childconditions, customfieldconditions`n`tExample: ...-conditions @{conditions = 'id=1234'}"
            break
        }

        $uriParams = @{
            query = $query
            fields = $fields
            conditions = $conditions
        }

        $uri = Get-PSARequestURI @uriParams
        Write-Verbose "Sending Get Request to path:`n`tURI:`t$uri"

        $output = [System.Collections.Generic.List[Object]]::new()

        do {
            $response = Invoke-PSARequest -uri $uri -method 'GET'
            $content = $response.content | ConvertFrom-Json -depth 10
            foreach ( $record in $content ) {
                $output.add($record)
            }
            if ( $response.headers.ContainsKey('Link') ) {
                $next = $response.headers.link | Out-String
                Write-Verbose "Next Link:`n`t$next"
            } else {
                $next = $null
            }
            $nextExists = $next -match '<(?<uri>.+)>; rel="next"'
            if ( $nextExists ) {
                $uri = $matches.uri -replace 'pageSize=\d+', 'pageSize=1000'
            }
        } while ( $nextExists )

        Write-Output $output
    }

    end {
        Write-Verbose "Get-PSARecord Complete."
    }
}
