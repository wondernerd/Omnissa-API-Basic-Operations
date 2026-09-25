# Bypass cert validation (PS 5.1 & 7 compatible fallback)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$BaseUrl = "https://[connection server]/rest"

# Construct credentials body for initial login
$Body = @{
    "username" = "api_admin"
    "password" = "SecretPassword"
    "domain"   = "YOURDOMAIN"} | ConvertTo-Json
    
# Request the login token
$LoginResponse = Invoke-RestMethod -Uri "$BaseUrl/login" -Method Post -Body $Body -ContentType "application/json"

# Capture the Bearer token (Horizon returns access_token)
$BearerToken = $LoginResponse.access_token

# Define standard headers for future calls
$Headers = @{
    "Authorization" = "Bearer $BearerToken"
    "Accept"        = "application/json"}

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^The above is from Horizon_API-Connection.ps1 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#API location
$DSpoolPath = "inventory/v1/desktop-pools"

#Get pool information
$DSPoolList = Invoke-RestMethod -Uri "$BaseUrl/$DSPoolPath" -Method Get –Headers $Headers 

#Create JSON list of desktop pools
$DSpoolID = $DSPoolList.id
$DSPoolRawIDs = @("$DSpoolID")
$DSPoolJSONIDs = ConvertTo-json -inputobject $DSPoolRawIDs #for PowerShell 5.1+, because this is only a single ID and the JSON format expects an array we need to use the inputobject method to put it in [brackets] 

#Disable desktop pools
$DSPoolDisResult = Invoke-RestMethod -Uri "$BaseUrl/$DSpoolPath/action/disable" -Method Post -Headers $Headers -Body $DSPoolJSONIDs -contenttype "application/json"
