<#
.SYNOPSIS
    Powershell script for changing Prefered wireless adapter bandwith to 5.x GHz
.EXAMPLE 
   .\SetNICto52GHzBandwidth
.PARAMETER
    None
.DESCRIPTION
	Changes Wi-Fi Prefered Bandwith to work on 5.x Ghz. Saves log in C:\Temp\Set-NICto52GhzBandwidth_$ComputerName.log file.
.NOTES 
	Author: Marcin Mirzynski
	Script inspiried by another one found online. Unable to identify its original author.
#> 

function getPrefix {
[string]$ComputerName = $env:computerName
 $prefix = "[ $ComputerName ] [" + $(Get-Date -Format "dd") + "-" + $(Get-Date -Format "MM") + "-" + $(Get-Date -Format "yyyy") + "_" + $(Get-Date -Format "HH") + ":" + $(Get-Date -Format "mm") + "]"
 return $prefix
 }

#Getting computer name for log file creation
[string]$ComputerName = $env:computerName

#Log file will containt name of the script and ComputerName
$LogFile = "C:\Windows\@MYPCMGT\LOGS\Set-NICto52GHzBandwidth_" + $ComputerName + ".log"
if(Test-Path $LogFile){
    Remove-Item $LogFile
}
#Preferred Band possible values: "1. No Preference", "2. Prefer 2.4GHz band", "3. Prefer 5.2GHz band"
$PreferredBand = "3. Prefer 5GHz band", "3 - Prefer 5Ghz Band", "3 - Prefer 5.2Ghz Band", "3. Prefer 5.2GHz band"

#Get the name of the wireless network adapter
$WLAN_NIC = Get-NetAdapter | ? {$_.InterfaceDescription.Contains("Wireless")} | Select Name
if($WLAN_NIC){
#Save the original configuration
#Write-Output "Getting original preferred band configuration" | Out-File $LogFile -Append
$OrigPreferredBand = Get-NetAdapterAdvancedProperty -Name $WLAN_NIC.name | ? {$_.DisplayName.Contains("Preferred Band")}

Write-Output $(getPrefix) "Original preferred band is `"$($OrigPreferredBand.DisplayValue)`"..." | Out-File $LogFile -Append

If ($PreferredBand -Contains $OrigPreferredBand.DisplayValue) {
	Write-Output $(getPrefix) "No need to change the setting to 5.XGHz band" | Out-File $LogFile -Append
}
else {
    #try all possible values for 5.X band
    $success = $false
    foreach ($value in $PreferredBand) {
         $outputString = $(getPrefix) + " Trying `"$value`""
         Write-Ouput $outputString | Out-File $LogFile -Append
        Set-NetAdapterAdvancedProperty -Name $WLAN_NIC.name -DisplayName "Preferred Band" -DisplayValue $value -ErrorAction SilentlyContinue -ErrorVariable CheckError
        If ($CheckError.Count -eq 0) {
            $success = $true
            #Write-Output "Preferred band setting successfully changed to `"$value`"" | Out-File $LogFile -Append
            break
        }
        else {
           $outputString = $(getPrefix) + " Preferred band setting `"$value`" not accepted." 
           Write-Output = $outputString | Out-File $LogFile -Append
            Continue
        }
    }
    if (!($success)) {
        $outputString = $(getPrefix) + " This machine doesn't have any 5.X GHz band capability"
         Write-Output = $outputString | Out-File $LogFile -Append
    }
    $OrigPreferredBand = Get-NetAdapterAdvancedProperty -Name $WLAN_NIC.name | ? {$_.DisplayName.Contains("Preferred Band")}
   
}
 If ($PreferredBand -Contains $OrigPreferredBand.DisplayValue) {
	 $outputString = $(getPrefix) + " Double-check OK"
     Write-Output $outputString | Out-File $LogFile -Append
}
else {
    $outputString = $(getPrefix) + " Double-check FAILED."
    Write-Output $outputString | Out-File $LogFile -Append
}
}
else {
    $outputString = $(getPrefix) + " Machine does not have any Wireless adapter... Exiting"
    Write-Output $outputString | Out-File $LogFile
    }