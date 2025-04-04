Function New-PSARecord {
    [CmdletBinding()]
    param (
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-ValidPSAEndpoint -type $wordToComplete -method 'post'
            })]
        [string]$type,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$id,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$parentId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$grandparentId,
        [string]$body,
        [array]$fields,
        [switch]$asJSON = $false
    )

    begin {
        Write-Verbose "`n`tType:`t$type"
    }

    process {
        $uriParams = @{
            query = $type
            fields = $fields
            id = $id
            parentId = $parentId
            grandparentId = $grandparentId
        }

        $uri = Get-PSARequestURI @uriParams -noPagination

        $output = [System.Collections.Generic.List[Object]]::new()

        $response = Invoke-PSARequest -uri $uri -method 'POST' -body $body
        $content = $response.content | ConvertFrom-Json -depth 10
        foreach ( $record in $content ) {
            $output.add($record)
        }

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

