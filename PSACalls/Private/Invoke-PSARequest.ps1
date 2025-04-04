Function Invoke-PSARequest {
    [cmdletbinding()]
    Param (
        [validateset('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        $method = 'GET',
        [parameter(Mandatory)]
        [string]$uri,
        [hashtable]$headers,
        [string]$body
    )

    begin {
        If ($null -eq $env:PSA_APIKey -or $null -eq $env:PSA_ClientID) {
            Throw "PSA_APIKey and PSA_ClientID must be set in the environment variables."
        }
        Write-Verbose "`n`tMethod:`t$method`n`tURI:`t$uri"
        If ($Body) {
            Write-Verbose ":`n`tBody:`t$body"
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
            AllowInsecureRedirect = $true
        }

        if ($body) {
            $requestParams.Add('body', $body)
        }

        $response = Try {
            Invoke-WebRequest @requestParams -ErrorAction Stop
        } Catch {
            Write-Error $_
            "`n--- Script Stacktrace ---`n`n$($_.ScriptStackTrace)"
            "`n--- Exception Message ---`n`n$($_.Exception.Message)"
            "`n--- Response Error ---`n$($_.ErrorDetails.Message)`n"
            Break
        }
    }

    end {
        Write-Output $response
        Write-Verbose "Invoke-PSARequest Complete."
    }
}
