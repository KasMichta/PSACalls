Function Invoke-PSARequest {
    [cmdletbinding()]
    Param (
        [validateset('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        $method = 'GET',
        [parameter(Mandatory)]
        [string]$uri,
        [hashtable]$headers,
        [string[]]$body
    )

    begin {
        Write-Verbose "Running Invoke-PSARequest"
    }

    process {
        Write-Output "Invoke-PSARequest Ran. Method: $method"
    }

    end {
        Write-Verbose "Invoke-PSARequest Complete."
    }
}
