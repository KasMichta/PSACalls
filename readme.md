# Overview
This is a PowerShell module that provides a wrapper for the ConnectWise Manage/PSA API.

# Usage
## Connecting to the API
Once imported, you connect to the API using the `Connect-PSA`.

You can connect using credentials explicitly or by using an JSON file.

### Explicit Credentials
```powershell
Connect-PSA -clientID <clientID> -company <company> -publicKey <publicKey> -privateKey <privateKey> -baseURI <baseURI>
```

### JSON File
Contents of a valid `./authFile.json`

```json
{
  "clientId": "<clientID>",
  "company": "<company>",
  "privateKey": "<privateKey>",
  "publicKey": "<publicKey>",
}
```

```powershell
Connect-PSA -AuthFile ./authFile.json
```

## API Calls

### Get Requests
```powershell
Get-PSARecord
```

### Post Requests
```powershell
New-PSARecord
```

### Patch Requests
```powershell
Set-PSARecord
```

### Delete Requests
```powershell
Remove-PSARecord
```
