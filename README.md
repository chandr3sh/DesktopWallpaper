# DesktopWallpaper

A PowerShell module to change desktop background.

Contains two cmdlets:

1. `Test-Wallpaper`
2. `Set-Wallpaper`
3. `Select-Image`

`Test-Wallpaper` cmdlet supports these file types:
- BMP
- GIF
- TIFF
- PNG
- JPEG

`Set-Wallpaper` cmdlet changes the desktop background to the given image. It also has an optional parameter `-Fit` to change the fit style of the background as shown in the background personalization menu of Windows 10.

![backgdound fit styles](Assets/fit-styles.png)

**NOTE:** Requires Windows PowerShell 5.1 or above.

`Select-Image` tests whether a file is image or not (similar to `Test-Wallpaper` but more generic) and can filter out images based on **width** and **height**.

## Installation

```powershell
New-Item -ItemType Directory ~/Documents/WindowsPowerShell/Modules -ea 0
Set-Location ~/Documents/WindowsPowerShell/Modules
git clone https://github.com/chandr3sh/DesktopWallpaper.git
```

## Usage

If the directory contains images only, you can get a random image and pipe it to `Set-Wallpaper` cmdlet.

```powershell
Import-Module DesktopWallpaper
Get-ChildItem -File ~/Pictures | Get-Random | Set-Wallpaper -Fit Fill
```

If the directory has mixed file types, use `Test-Wallpaper` cmdlet to filter the supported image types.

```powershell
Get-ChildItem -File ~/Pictures | Test-Wallpaper -PassThru | Get-Random | Set-Wallpaper
```
