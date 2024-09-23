Function Get-PSARecord {
    [CmdletBinding()]
    param (
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

<<<<<<< HEAD
                $schema = Get-Content './dummyLocation' | ConvertFrom-Json -depth 100 -AsHashtable
                $schema.paths.keys |
                    Where-Object { $_ -match $($wordToComplete -replace "'", '') } |
                    ForEach-Object { "'$_'" }
            }
        )
        ]
=======
                Get-ValidPSAEndpoint -type $wordToComplete
            })]
>>>>>>> 3a202ef (use Get-ValidPSAEndpoint for $type parameter argumentcompleter)
        [string]$type,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $parentId,
        $recordId,
        $fields,
        $conditions,
        [switch]$asJSON = $false
    )


    Write-Output "Type: $type"
}
