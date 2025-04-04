Function Remove-PSARecord {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-ValidPSAEndpoint -type $wordToComplete -method 'delete'
            })]
        [string]$type,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$id,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$parentId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$grandparentId
    )

    begin {
        Write-Verbose "`n`tType:`t$type"
    }

    process {

        $uriParams = @{
            query = $type
            id = $id
            parentId = $parentId
            grandparentId = $grandparentId
        }

        $uri = Get-PSARequestURI @uriParams -noPagination
        $record = (Invoke-PSARequest -uri $uri -method 'GET').content | ConvertFrom-Json -depth 100

        Write-Verbose "Deleting Record:`n$($record | Format-List | Out-String)"

        if ($PSCmdlet.ShouldProcess("$type", "Are you sure you want to Delete?")) {
            $response = Invoke-PSARequest -uri $uri -method 'DELETE'
            if ($response.StatusCode -eq 204) {
                Write-Output "Record Deleted"
            } else {
                Write-Output $response
            }
        }
    }

    end {
        Write-Verbose "Get-PSARecord Complete."
    }
}

