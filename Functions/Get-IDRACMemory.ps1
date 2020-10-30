Function Get-IDRACMemory {

<#
    .SYNOPSIS
        look at a IDRAC Memory objects


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

    Write-Verbose "Retrieving Processor info from $Server"

    $URL = "https://$Server/redfish/v1/Systems/System.Embedded.1/Memory"
    
    $Mem = Invoke-WebRequest -Uri $Url -Credential $Credential -Method Get -UseBasicParsing -Headers @{"Accept"="application/json"} 


    foreach ( $M in ($Mem.Content | ConvertFrom-JSON).members.'@odata.id' ) {
        Write-Output (Invoke-WebRequest -Uri "https://$Server$M" -Credential $Credential -Method Get -UseBasicParsing -Headers @{"Accept"="application/json"} | ConvertFrom-JSON)  
    }
}