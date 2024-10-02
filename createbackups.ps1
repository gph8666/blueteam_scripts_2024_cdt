<#
This is a script for creating backups on the domain controller
Backups will be compared to current file to see if changes were made. 
Backups will occur every 15 minutes
-----------------------------------
RUN THIS FIRST
[Environment]::SetEnvironmentVariable("indexer", "1", "Machine")
-----------------------------------
#>
$current = [int]$env:indexer
reg export HKLM "C:\backups\HKLM\HKLM_backup_$time.reg"
reg export HKCU "C:\backups\HKCU\HKCU_backup_$time.reg"
Get-GPO -All | ForEach-Object { Backup-GPO -Guid $_.Id -Path "C:\backups\GPO_Backups\GPO_Backup_$time" }
xcopy "\\airport.delta.local\SYSVOL" "C:\backups\SYSVOL\SYSVOL_backup_$time" /E /I /H

$new = $current + 1
[Environment]::SetEnvironmentVariable("indexer", $new.toString(), "Machine")