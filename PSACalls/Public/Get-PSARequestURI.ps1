Function Get-PSARequestURI {
    [CmdletBinding()]
    param (
        $BaseURI = $env:PSA_BaseURI,
        [Parameter(Mandatory=$true)]
        [string]$query,
        $id,
        $parentId,
        $grandparentId,
        [array]$fields,
        $conditions,
        [int]$pageSize = 1000,
        [int]$page = 1,
        [switch]$noPagination = $false
    )
    switch ( $query ) {
        {($query -match '{id}') -and ($query -notmatch '{parentId}')} {
            $query = $query -replace '{id}', $id
            break
        }
        {($query -match '{parentId}') -and ($query -notmatch '{id}')} {
            $query = $query -replace '{parentId}', $id -replace '{grandparentId}', $parentId
            break
        }
        default {
            $query = $query -replace '{id}', $id -replace '{parentId}', $parentId -replace '{grandparentId}', $grandparentId
        }
    }

    $uri = $BaseURI + $query

    $filters = [system.collections.generic.list[string]]::new()

    if ( $fields ) {
        $filters.Add("fields=$($fields -join ',')")
    }

    if ( $conditions ) {
        if ( $conditions.GetType().Name -eq 'String' ) {
            $conditions = [System.Web.HttpUtility]::UrlEncode($conditions)
            $filters.Add("Conditions=$conditions")
        } elseif ( $conditions.GetType().Name -eq 'Hashtable' ) {
            if ( $conditions.ContainsKey('conditions') ) {
                $uriConditions = [System.Web.HttpUtility]::UrlEncode(($conditions.conditions -join ' '))
                $filters.Add("Conditions=$($uriConditions)")
            }

            if ( $conditions.ContainsKey('childconditions') ) {
                $uriChildConditions = [System.Web.HttpUtility]::UrlEncode(($conditions.childconditions -join ' '))
                $filters.Add("ChildConditions=$($uriChildConditions)")
            }

            if ( $conditions.ContainsKey('customfieldconditions') ) {
                $uriCustomFieldConditions = [System.Web.HttpUtility]::UrlEncode(($conditions.customfieldconditions -join ' '))
                $filters.Add("CustomFieldConditions=$($uriCustomFieldConditions)")
            }
        } else {
            Write-Error "Conditions must be a string or hashtable"
        }
    }

    if ( !$noPagination ) {
        $filters.Add("pagesize=$pageSize&page=$page")
    }

    if ( $filters.count -gt 0 ) {
        $uri += "?$($filters -join '&')"
    }

    Write-Verbose "`n`tURI:`t$uri"

    #$uri = [System.Web.HttpUtility]::UrlEncode($uri)
    #$uri = $([uri]::EscapeUriString($uri))
    Write-Output $uri
}
