Function Get-PSARequestURI {
    [CmdletBinding()]
    param (
        $BaseURI = $env:PSA_BaseURI,
        [Parameter(Mandatory=$true)]
        [string]$query,
        [array]$fields,
        [hashtable]$conditions,
        [int]$pageSize = 1000,
        [int]$page = 1
    )

    $uri = $BaseURI + $query

    $filters = [System.Collections.Generic.List[string]]::new()

    if ( $fields ) {
        $filters.Add("fields=$($fields -join ',')")
    }

    if ( $conditions ) {
        if ( $conditions.ContainsKey('conditions') ) {
            $filters.Add("Conditions=$($conditions.conditions -join ' ')")
        }

        if ( $conditions.ContainsKey('childconditions') ) {
            $filters.Add("ChildConditions=$($conditions.childconditions -join ' ')")
        }

        if ( $conditions.ContainsKey('customfieldconditions') ) {
            $filters.Add("CustomFieldConditions=$($conditions.customfieldconditions -join ' ')")
        }
    }

    $filters.Add("pagesize=$pageSize&page=$page")

    $uri += "?$($filters -join '&')"

    Write-Output $([uri]::EscapeUriString($uri))
}
