Function Set-PSARecord {
    [CmdletBinding()]
    param (
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-ValidPSAEndpoint -type $wordToComplete -method 'patch'
            })]
        [string]$type,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string]$parentId,
        [string]$recordId,
        [string]$body,
        [array]$fields,
        [switch]$asJSON = $false
    )

    begin {

        Write-Verbose "Using API Path:`n`tURI:`t{BaseURI}$type"

    }

    process {
        $query = $($type -replace "{parentId}", $parentId -replace "{id}", $recordId)

        $uriParams = @{
            query = $query
            fields = $fields
        }

        $uri = Get-PSARequestURI @uriParams
        Write-Verbose "Sending Get Request to path:`n`tURI:`t$uri"

        $output = [System.Collections.Generic.List[Object]]::new()

        $response = Invoke-PSARequest -uri $uri -method 'PATCH' -body $body
        $content = $response.content | ConvertFrom-Json -depth 10
        foreach ( $record in $content ) {
            $output.add($record)
        }

        Write-Output $output
    }

    end {
        Write-Verbose "Get-PSARecord Complete."
    }
}

