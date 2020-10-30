Function Get-IDRACObject {

<#
    .SYNOPSIS
        test function for look at a IDRAC object


    .LINK
        https://www.dell.com/support/manuals/en-us/idrac7-8-lifecycle-controller-v2.40.40.40/redfish%202.40.40.40/overview?guid=guid-e85fd9c0-f4d1-4eff-be5d-550ebb77ff0d&lang=en-us

        surprisingly this doc is the best even if it is for ILO
        https://hewlettpackard.github.io/iLOAmpPack-Redfish-API-Docs/

#>
    
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory = $True, Position = 0)]
        [String]$Server,

        [Parameter (Mandatory = $True, Position = 1)]
        [PSCredential]$Credential
    )

    $URL = "https://$Server/redfish/v1/Managers/iDRAC.Embedded.1/LogServices/Sel/Entries"

    $Result = Invoke-WebRequest -Uri $Url -Credential $Credential -Method Get -UseBasicParsing -Headers @{"Accept"="application/json"} 

    $Result = @()
    (Invoke-WebRequest -Uri $Url -Credential $Credential -Method Get -UseBasicParsing -Headers @{"Accept"="application/json"} | convertfrom-json).members.'@odata.id' | foreach {
        $Result += (Invoke-WebRequest -Uri "https://$Server$_" -Credential $Credential -Method Get -UseBasicParsing -Headers @{"Accept"="application/json"} | ConvertFrom-Json)

    }
}