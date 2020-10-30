Function Get-IDRACPowerSupply {

<#
    .SYNOPSIS
        Retrieves information about IDRAC PowerSupplies 

    .PARAMETER Server
        Name or IP of IDRAC.

    .PARAMETER Credential
        Credential object that has permissions to IDRAC.

    .LINK
        https://www.dell.com/support/manuals/en-us/idrac7-8-lifecycle-controller-v2.40.40.40/redfish%202.40.40.40/overview?guid=guid-e85fd9c0-f4d1-4eff-be5d-550ebb77ff0d&lang=en-us

#>
    
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory = $True, Position = 0)]
        [String]$Server,

        [Parameter (Mandatory = $True, Position = 1)]
        [PSCredential]$Credential
    )

    Write-Verbose "Retrieving Powersupply info for $Server"

    $URL = "https://$Server/redfish/v1/Chassis/System.Embedded.1/Power"

    $result = Invoke-WebRequest -Uri $Url -Credential $Credential -Method Get -UseBasicParsing -Headers @{"Accept"="application/json"}

    Write-Output ($Result.Content | ConvertFrom-Json | Select $Type ).PowerSupplies
}