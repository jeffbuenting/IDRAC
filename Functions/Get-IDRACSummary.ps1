Function Get-IDRACSummary {

<#
    .SYNOPSIS
        test function for look at a IDRAC Summary


    .LINK
        https://www.dell.com/support/manuals/en-us/idrac7-8-lifecycle-controller-v2.40.40.40/redfish%202.40.40.40/overview?guid=guid-e85fd9c0-f4d1-4eff-be5d-550ebb77ff0d&lang=en-us

#>
    
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory = $True)]
        [String]$Server,

        [Parameter (Mandatory = $True)]
        [PSCredential]$Credential
    )

    $Url = "https://$Server/redfish/v1/Systems/System.Embedded.1"    

    $result = Invoke-WebRequest -Uri $Url -Credential $Credential -Method Get -UseBasicParsing -Headers @{"Accept"="application/json"}

    Write-Output ($Result | ConvertFrom-JSON )
    



}