
[CmdletBinding()]
Param (
    [String[]]$Server,


    [PSCredential]$Credential
)

# ----- Ignore selfsigned cert errors and use TLS 1.2
Ignore-SSLCertificates
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12

Try{
    Import-Module $PSScriptRoot\IDRAC.psd1 -force -ErrorAction Stop
}
catch {
    $ExceptionMessage = $_.Exception.Message
    $ExceptionType = $_.Exception.GetType().Fullname
    Throw "Get-IDRACHealth : Error importing IDRAC module.`n`n     $ExceptionMessage`n`n $ExceptionType"
}


Foreach ( $I in $Server ) {

    "-----------------------"
    Write-Verbose "IDRAC Server : $I"

    $IDRAC = Get-IDRACSummary -Server $I -Credential $Credential 

    $IDRAC | Select-Object @{N='Health';E={$_.Status.Health}},@{N='Name';E={$I}},SKU | FT * -AutoSize

    if ( $IDRAC.Status.Health -ne "OK" ) {
    
        # ----- TODO : Battery Health

        Get-IDRACTemparature -Server $I -Credential $Credential | Select-Object @{N='Health';E={$_.Status.Health}},Name,ReadingCelsius | Sort-Object Name | FT * -AutoSize
        Get-IDRACProcessor -Server $I -Credential $Credential | Select-Object @{N='Health';E={$_.Status.Health}},Name,Model,ProcessorType,Totalcores,TotalThreads | Sort-Object Name | FT * -AutoSize
        Get-IDRACInstrusionSensor -Server $I -Credential $Credential | FT * -AutoSize
        Get-IDRACMemory -Server $I -Credential $Credential | Select-Object  @{N='Health';E={$_.Status.Health}},Name,Memoryype,@{N='SizeMB';E={$_.CapacityMiB/1KB}} | Sort-Object Name | FT * -AutoSize
        Get-IDRACNIC -Server $I -Credential $Credential | Select-Object  @{N='Health';E={$_.Status.Health}},@{N='Name';E={$_.ID}},MACAddress | Sort-Object Name | FT * -AutoSize
        Get-IDRACPowersupply -Server $I -Credential $Credential | Select-Object @{N='Health';E={$_.Status.Health}},Name | Sort-Object Name | FT * -AutoSize
        Get-IDRACVoltage -Server $I -Credential $Credential | Select-Object @{N='Health';E={$_.Status.Health}},Name,ReadingVolts | Sort-Object Name | FT * -AutoSize
    }

    Get-IDRACLog -Server $I -Credential $Credential | Select-Object Created,Message | FT * -AutoSize
}