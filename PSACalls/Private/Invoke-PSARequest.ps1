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
        If ($null -eq $env:PSA_APIKey -or $null -eq $env:PSA_ClientID) {
            Throw "PSA_APIKey and PSA_ClientID must be set in the environment variables."
        }
        Write-Verbose "Method: $method"
        Write-Verbose "URI: $uri"
        If ($Body) {
            Write-Verbose "Body Included in Request (Length: $($Body.Length))"
        }
    }

    process {
        $requestParams = @{
            uri        = $uri
            method     = $method
            ContentType = 'application/json'
            headers    = if ($headers) {
                $headers
            } else {
                @{
                    authorization  = "basic $env:PSA_APIKey"
                    clientid       = "$env:PSA_ClientID"
                }
            }
        }

        if ($body) {
            $requestParams.Add('body', $body)
        }

        $response = Invoke-WebRequest @requestParams -ErrorAction Stop
    }

    end {
        Write-Output $response
        Write-Verbose "Invoke-PSARequest Complete."
    }
}
