# DesktopWallpaper

A PowerShell module to change desktop background.

Contains two cmdlets:

1. `Test-Image`
2. `Set-Wallpaper`

## Installation

```powershell
New-Item -ItemType Directory ~/Documents/WindowsPowerShell/Modules -ea 0
Set-Location ~/Documents/WindowsPowerShell/Modules
git clone https://github.com/chandr3sh/DesktopWallpaper.git
```

## Usage

```powershell
Get-Module DesktopWallpaper
Get-ChildItem -File ~/Pictures | Get-Random | Set-Wallpaper
```

**NOTE:** Requires Windows PowerShell 5.1 or above.
