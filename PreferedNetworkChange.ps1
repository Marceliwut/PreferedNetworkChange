$progress = 0
$LogFile = ".\logs\log_"  + $(Get-Date -Format "dd") + "-" + $(Get-Date -Format "MM") + "-" + $(Get-Date -Format "yyyy") + "_" + $(Get-Date -Format "HH") + $(Get-Date -Format "mm") + ".log"
$PreferredBand = "3. Prefer 5GHz band", "3 - Prefer 5Ghz Band", "3 - Prefer 5.2Ghz Band", "3. Prefer 5.2GHz band"
if(Test-Path .\RemoveList.txt){
    Write-Host "List not found"    
}

else {
foreach($line in Get-Content .\list.txt){
    $progress++
    }
    Write-Output "Performing prefered network change for: " $progress " computers"
	foreach($line in Get-Content .\list.txt){
	#test if client is online
		if(Test-Connection $line -Count 1){
			Write-Host $line "online. Starting the process"
			#copying files to client
			robocopy .\Set-NICto52GHzBandwidth \\$line\c$\temp\Set-NICto52GHzBandwidth\ /e /z /R:1 /W:2
			if(Test-Path \\$line\c$\temp\Set-NICto52GHzBandwidth){
				Write-Output "File transfer completed"
				Invoke-Command -ComputerName $line -ScriptBlock { Register-ScheduledTask -Xml (get-content 'C:\temp\Set-NICto52GHzBandwidth\Set-NICto52GHzBandwidth.xml' | out-string) -TaskName "Set-NICto52GHzBandwidth" –Force }
				Write-Output "$line ok" | Out-File $LogFile -Append				
			}
			else {
				Write-Output "File transfer to $line failed" | Out-File $LogFile -Append
			}
		}
		else {
		Write-Output "$line offline" | Out-File $LogFile -Append
		}
	}
 }