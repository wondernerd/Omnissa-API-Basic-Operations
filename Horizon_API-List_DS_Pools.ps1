# Bypass cert validation (PS 5.1 & 7 compatible fallback)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$BaseUrl = "https://[connection server]/rest"

# Construct credentials body for initial login
$Body = @{
    "username" = "api_admin"
    "password" = "SecretPassword"
    "domain"   = "YOURDOMAIN"} | ConvertTo-Json
    
# Request the login token
$LoginResponse = Invoke-RestMethod –Uri "$BaseUrl/login" -Method Post -Body $Body -ContentType "application/json"

# Capture the Bearer token (Horizon returns access_token)
$BearerToken = $LoginResponse.access_token

# Define standard headers for future calls
$Headers = @{
    "Authorization" = "Bearer $BearerToken"
    "Accept"        = "application/json"}

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^The above is from Horizon_API-Connection.ps1 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#API location
$DSpoolPath = "inventory/v1/desktop-pools"

#API Get call
$DSPoolList = Invoke-RestMethod -Uri "$BaseUrl/$DSpoolPath" -	Method Get -Headers $Headers

#Display the result
$DSPoolList
