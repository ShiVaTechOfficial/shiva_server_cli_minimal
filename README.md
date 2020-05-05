# shiva_server_cli_minimal
Script for packaging a minimal ShiVa CLI Server on Linux

## Usage
`ServerCLIMinimal.sh binary [targetpath]`

- Supply the script with the ShiVa Server CLI binary you want to package:
`ServerCLIMinimal.sh /path/to/ShiVaEditorCLI`
- Optional: supply Supply the script with the ShiVa Server CLI binary you want to package:
`ServerCLIMinimal.sh /path/to/ShiVaEditorCLI /export/path`

## Benefits
- much smaller storage footprint: 160MB vs 3.7GB
- pulls all local dependencies into a single archive for easy distribution
