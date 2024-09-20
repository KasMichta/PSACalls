Function Invoke-PSARequest {
    [cmdletbinding()]
    Param (
        $method = 'GET'
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
