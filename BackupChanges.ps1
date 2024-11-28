$CurrentLocation = Get-Location
$CurrentDate = (Get-Date).toString('yyyyMMddhhmmss');

# * to save at the desktop location
# $DesktopPath = (New-Object –ComObject Shell.Application).namespace(0x10).Self.Path # https://superuser.com/a/1789849
# $TargetFolder = "$DesktopPath\Backup\$CurrentDate"

# * To save at the current location
$TargetFolder = "$CurrentLocation\Backup\$CurrentDate" 

# * get the all modified file last 8 hours
$TargetTime = (Get-Date).addHours(-8).ToString("MM/dd/yyyy hh:mm:ss tt")

$TargetDirs = "$CurrentLocation\directories.txt"

$Directories = Get-Content $TargetDirs

foreach($Directory in $Directories){
  # Get all files that match the criteria
  Get-ChildItem -Path $Directory -File -Recurse | 
  Where-Object { $_.LastWriteTime -gt  $TargetTime} | 
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

Get-ChildItem -Path $TargetFolder -File -Recurse | `
  Foreach-Object {
    $_.FullName.Substring($TargetFolder.Length + 1)
  } | `
  Out-File BackupFilenames.txt


