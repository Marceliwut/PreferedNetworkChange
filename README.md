# PreferedNetworkChange

## Synopsis
Powershell project for changing Prefered wireless adapter bandwith to 5.x GHz for multiple computers.


## Explanation
### PreferedNetworkChange.ps1:
Copies files to clients from .\list.txt file. Registers XML file as scheduled task on machines.
### Set-NICto52GHzBandwidth.ps1
Changes Wi-Fi Prefered Bandwith to work on 5.x Ghz. Saves log in C:\Temp\Set-NICto52GhzBandwidth_$ComputerName.log file.
### Set-NICto52GHzBandwidth.xml
Contains information about Task Scheduler Task that runs script above when user locks the computer.

## Motivation
Wireless adapters does not always know what is best for them :)

## License
Beerware. You folks know how it works.
