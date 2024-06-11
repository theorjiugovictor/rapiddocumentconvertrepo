#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source_file> <output_zip_file>"
  exit 1
fi

# Assign arguments to variables
SOURCE_FILE=$1
OUTPUT_ZIP=$2

# Check if the source file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: Source file $SOURCE_FILE does not exist."
  exit 1
fi

# Create a temporary PowerShell script
PS_SCRIPT=$(mktemp --suffix=.ps1)

# Generate PowerShell script content
cat <<EOF > "$PS_SCRIPT"
param (
    [string] \$zipFile,
    [string[]] \$sourceFiles
)
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Create-ZipFile {
    param (
        [string] \$zipFile,
        [string[]] \$sourceFiles
    )
    if (Test-Path \$zipFile) {
        Remove-Item \$zipFile
    }
    Compress-Archive -Path \$sourceFiles -DestinationPath \$zipFile
}
Create-ZipFile -zipFile "\$zipFile" -sourceFiles \$sourceFiles
EOF

# Run the PowerShell script
powershell.exe -File "$PS_SCRIPT" -zipFile "$OUTPUT_ZIP" -sourceFiles "$SOURCE_FILE"

# Clean up the temporary PowerShell script
rm "$PS_SCRIPT"
