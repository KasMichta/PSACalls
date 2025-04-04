Function Get-PSARecord {
    [CmdletBinding()]
    param (
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-ValidPSAEndpoint -type $wordToComplete -method 'get'
            })]
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$type,
        [Parameter(ValueFromPipelineByPropertyName)]
        $id,
        [Parameter(ValueFromPipelineByPropertyName)]
        $parentId,
        [Parameter(ValueFromPipelineByPropertyName)]
        $grandparentId,
        [array]$fields,
        $conditions,
        [switch]$asJSON = $false
    )

    begin {
        Write-Verbose "`n`tType:`t$type"
    }

    process {
        if ( $conditions ) {
            if ( ($conditions.GetType().Name -eq 'Hashtable')  -and
                !$conditions.ContainsKey('conditions') -and
                !$conditions.ContainsKey('childconditions') -and
                !$conditions.ContainsKey('customfieldconditions')) {
                Write-Error "parameter '-conditions' expecting [hashtable] containing at least one of the following keys: conditions, childconditions, customfieldconditions`n`tExample: ...-conditions @{conditions = 'id=1234'}"
                break
            }
        }

        $uriParams = @{
            query = $type
            fields = $fields
            conditions = $conditions
            id = $id
            parentId = $parentId
            grandparentId = $grandparentId
        }

        $uri = Get-PSARequestURI @uriParams

        $output = [System.Collections.Generic.List[Object]]::new()

        do {
            $response = Try {
                Invoke-PSARequest -uri $uri -method 'GET' -ErrorAction Stop
            } Catch {
                Write-Error $_
                Break
            }
            $content = $response.content | ConvertFrom-Json -depth 10
            foreach ( $record in $content ) {
                $output.add($record)
            }
            if ( $response.headers.ContainsKey('Link') ) {
                $next = $response.headers.link | Out-String
                Write-Verbose "`n`tNext Link:`t$next"
            } else {
                $next = $null
            }
            $nextExists = $next -match '<(?<uri>.+)>; rel="next"'
            if ( $nextExists ) {
                $uri = $matches.uri -replace 'pageSize=\d+', 'pageSize=1000'
            }
        } while ( $nextExists )

        if ( $asJSON ) {
            Write-Output ($output | ConvertTo-Json -Depth 100)
        } else {
            Write-Output $output
        }
    }

    end {
        Write-Verbose "Get-PSARecord Complete."
    }
}
