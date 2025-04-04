Function Set-PSAApiKey {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        $company,
        $publicKey,
        $privateKey
    )

    if ( $PSCmdlet.ShouldProcess($company)) {
        $plainText = $company + "+" + $publicKey + ":" + $privateKey
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($plainText)
        $base64 = [Convert]::ToBase64String($bytes)

        Write-Verbose "API Key set for $company"
        Write-Output $base64
    }
}
