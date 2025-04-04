Function Find-ValidPath {
    [CmdletBinding()]
    param (
        $path,
        $parent = '',
        $method
    )
    Write-Verbose "Searching for valid paths"

    $validPaths = [System.Collections.Generic.List[string]]::new()

    foreach ($key in $($path.keys | Where-Object { $_ -ne 'methods' })) {
        $newParent = "$parent/$key"

        if ($path[$key].ContainsKey('methods')) {
            if ($path[$key].methods -contains $method) {
                $validPaths.Add("$parent/$key")
            }
        }
        $childPaths = Find-ValidPath -path $path[$key] -parent $newParent -method $method

        foreach ($childPath in $childPaths) {
            $validPaths.Add($childPath)
        }
    }

    Write-Output $validPaths
}

Function Get-ValidPSAEndpoint {
    [CmdletBinding()]
    param (
        [string]$type,
        [string]$method = 'get',
        [string]$schemaPath = (Split-Path -parent $PSScriptRoot) + '/schemaTree.json'
    )

    Write-Verbose "Searching for endpoint: $type"

    # clean the input, no quotes or leading slashes
    $type = $type -replace "'", ''

    if ( $type.StartsWith('/') ) {
        $type = $type.Substring(1)
    }

    $paths = Get-Content $schemaPath | ConvertFrom-Json -Depth 100 -AsHashtable

    # check if the type is a root level endpoint
    if ( !($type.Contains('/')) -or $type -eq '/' ) {

        $paths.keys | Where-Object { $_ -match $type } | ForEach-Object { "/$_" }

    } else {
        $nodes = $type -split '/'
        $searchTerm = $nodes[-1]
        if ($searchTerm.length -eq 0) {
            $searchTerm = '.'
        }
        $nodes = $nodes[0..($nodes.Length - 2)]
        $prefix = $nodes -join '/'

        # traverse the tree to find the endpoint
        $current = $paths
        foreach ($node in $nodes) {
            if ( !($current.ContainsKey($node)) ) {
                throw "Invalid endpoint: $node"
            }
            $current = $current[$node]
        }

        # Recursively search for child paths that match the search term and request method
        $validPaths = Find-ValidPath -path $current -method $method
        $validPaths | Where-Object { $_ -match $searchTerm } | ForEach-Object { "'/$prefix$_'" }
    }

}
