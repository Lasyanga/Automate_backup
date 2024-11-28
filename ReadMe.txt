BackupChanges.ps1 is a PowerShell script that automates the process of backing up files modified in the last 8 hours. 
It scans directories specified in a directories.txt file, recreates the directory structure, and copies the modified files to a timestamped backup folder. 
Additionally, it logs the names of the backed-up files for easy reference.
After the copy it creates a txt file containing filename that has backup.

How it works
	1. Read Directories:
		The script reads a list of source directories from directories.txt. Each line in this file should contain the full path to a directory you want to back up.

	2. Scan for Changes:
		It scans the specified directories for files that were modified within the last 8 hours.

	3. Recreate Directory Structure:
		If modified files are found, their parent directories are recreated in the backup folder to preserve the structure.

	4. Copy Files:
		All modified files are copied to the backup folder under a new folder named with the current timestamp (format: YYYYMMDDHHMMSS).

	5. Log Backup:
		After the backup, the script creates a log file in the backup folder that lists all the files copied.


Folder Format:
 Backup
  └── <YYYYMMDDHHMMSS>
        ├── <subdirectory_1>
        ├── <subdirectory_2>
        └── <file1>, <file2>, ...

Setup Instruction
    1. Edit directories.txt:

        Add the full path of the directories you want to back up.
        Each path should be on a new line. Example:

            C:\Users\YourUsername\Documents
            D:\Projects

    2. Place the Script:
        Ensure BackupChanges.ps1 and directories.txt are in the same folder, or modify the script to locate your directories.txt.

How to Run the Script

    1. Prepare:
        Open PowerShell.
        Navigate to the folder where BackupChanges.ps1 is saved.

    2. Execute:
        Run the script by typing:

        .\BackupChanges.ps1

    3. Done:
        The backup will be created, and a log file will be generated in the backup folder.

Customization Options

    1. Time Window:
        You can modify the script to change the 8-hour time window if needed. Look for the part in the script where the time is calculated and adjust it accordingly.

    2. Backup Folder:
        Change the destination of the backup folder in the script to a custom path.