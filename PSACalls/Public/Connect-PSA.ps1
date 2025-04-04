Function Connect-PSA {
    [CmdletBinding(DefaultParameterSetName = 'direct')]
    param(
        [Parameter(Mandatory,
            ParameterSetName = 'direct',
            Position = 0)]
        [string]$clientID,
        [Parameter(Mandatory,
            ParameterSetName = 'direct',
            Position = 1)]
        [string]$company,
        [Parameter(Mandatory,
            ParameterSetName = 'direct',
            Position = 2)]
        [string]$publicKey,
        [Parameter(Mandatory,
            ParameterSetName = 'direct',
            Position = 3)]
        [string]$privateKey,
        [string]$baseURI = 'https://api-eu.myconnectwise.net/v4_6_release/apis/3.0',
        [Parameter(Mandatory,
            ParameterSetName = 'file',
            Position = 0)]
        [string]$authFile
    )

    Write-Verbose "Connecting to PSA instance"

    $env:PSA_BaseURI = $baseURI

    if ($PSCmdlet.ParameterSetName -eq 'file') {
        $auth = Get-Content -Path $authFile | ConvertFrom-Json
        $env:PSA_ClientID = $auth.clientID
        $env:PSA_APIKey = Set-PSAApiKey -company $auth.company -publicKey $auth.publicKey -privateKey $auth.privateKey
        Write-Output "Connected to PSA instace: $($auth.company)"
    } else {
        $env:PSA_ClientID = $clientID
        $env:PSA_APIKey = Set-PSAApiKey -company $company -publicKey $publicKey -privateKey $privateKey
        Write-Output "Connected to PSA instace: $company"
    }

    Write-Verbose "Connection credentials set"
}
