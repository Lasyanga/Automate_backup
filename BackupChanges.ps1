# Get current location and timestamp
$CurrentLocation = Get-Location
$CurrentDate = (Get-Date).ToString('yyyyMMddhhmmss')

# Target folder for backups
$TargetFolder = "$CurrentLocation\Backup\$CurrentDate"

# Get all modified files from the last 8 hours
$TargetTime = (Get-Date).AddHours(-8)

# List of directories to scan
$TargetDirs = "$CurrentLocation\directories.txt"
$Directories = Get-Content $TargetDirs

# Create the backup directory if it doesn't exist
if (-Not (Test-Path -Path $TargetFolder)) {
	New-Item -Path $TargetFolder -ItemType Directory -Force
}

# Process files in each directory
foreach ($Directory in $Directories) {
	# Get all files that match the criteria
	Get-ChildItem -Path $Directory -File -Recurse |
	Where-Object { $_.LastWriteTime -gt $TargetTime } |
	ForEach-Object {
		# Recreate the directory structure in the target folder
		$SubDirectory = Split-Path -Path $_.Directory -NoQualifier
		$DestinationPath = Join-Path -Path $TargetFolder -ChildPath $SubDirectory
		
		# Ensure the subdirectory exists at the destination
		if (-Not (Test-Path -Path $DestinationPath)) {
			New-Item -Path $DestinationPath -ItemType Directory -Force
		}
		
		# Copy the file to the appropriate subdirectory in the target
		Copy-Item -Path $_.FullName -Destination $DestinationPath -Force
	}
}

# Create a log file of all backed-up files
$LogDir = "$CurrentLocation\logs"

if (-Not (Test-Path -Path $LogDir)) {
	New-Item -Path $LogDir -ItemType Directory -Force
}

$LogFile = "$LogDir\BackupFilenames_$CurrentDate.txt"
Get-ChildItem -Path $TargetFolder -File -Recurse |
ForEach-Object {
	$_.FullName.Substring($TargetFolder.Length + 1)
} | Out-File $LogFile

# Compress the backup folder into a zip file
$ZipFile = "$CurrentLocation\Backup\Backup_$CurrentDate.zip"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($TargetFolder, $ZipFile)

# Delete the unzipped backup folder after zipping
if (Test-Path -Path $TargetFolder) {
	Remove-Item -Path $TargetFolder -Recurse -Force
}

Write-Output "Backup completed successfully."
Write-Output "Backup folder compressed to: $ZipFile"
Write-Output "Log file created at: $LogFile"

Write-Host "Press any key to exit..." -ForegroundColor Yellow
[System.Console]::ReadKey() > $null