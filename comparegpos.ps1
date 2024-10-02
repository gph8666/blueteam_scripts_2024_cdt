# compare gpos
$current = [int]$env:indexer - 1
$backup_gpos = "C:\backups\GPO_Backups\GPO_Backup_v$current"
$gpos = Get-GPO -All

$results = @()

foreach ($gpo in $gpos) {

    $gpoName = $gpo.DisplayName
    $gpoBackupPath = Join-Path -Path $backupPath -ChildPath $gpoName

    # Check if backup exists
    if (Test-Path $gpoBackupPath) {
        # Export current GPO settings to a temporary file
        $currentGpoReportPath = Join-Path -Path $env:TEMP -ChildPath "$($gpoName)_CurrentGPOReport.xml"
        Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $currentGpoReportPath

        # Compare the current GPO report with the backup
        $backupReportPath = Join-Path -Path $gpoBackupPath -ChildPath "$gpoName.xml" # assuming backup file is named GPOName.xml
        if (Test-Path $backupReportPath) {
            # Compare the two reports
            $comparison = Compare-Object -ReferenceObject (Get-Content $currentGpoReportPath) -DifferenceObject (Get-Content $backupReportPath)

            if ($comparison) {
                $results += [PSCustomObject]@{
                    GPOName      = $gpoName
                    Differences  = $comparison
                }
            } else {
                $results += [PSCustomObject]@{
                    GPOName      = $gpoName
                    Differences  = "No differences found"
                }
            }
        } else {
            $results += [PSCustomObject]@{
                GPOName      = $gpoName
                Differences  = "Backup not found"
            }
        }
    } else {
        $results += [PSCustomObject]@{
            GPOName      = $gpoName
            Differences  = "Backup directory does not exist"
        }
    }
}

# Output results
$results | Format-Table -AutoSize