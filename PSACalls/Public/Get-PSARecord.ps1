Function Get-PSARecord {
    [CmdletBinding()]
    param (
        [ArgumentCompleter(
            {
                param($commandtname, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

                $schema = Get-Content './dummyLocation' | ConvertFrom-Json -depth 100 -AsHashtable
                $schema.paths.keys |
                    Where-Object { $_ -match $($wordToComplete -replace "'", '') } |
                    ForEach-Object { "'$_'" }
            }
        )
        ]
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
