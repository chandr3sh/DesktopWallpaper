#Requires -Assembly 'System.Runtime.InteropServices'

# https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfoa
# https://docs.microsoft.com/en-us/windows/win32/controls/themesfileformat-overview#control-paneldesktop-section

Add-Type -TypeDefinition @"

using System;
using System.Runtime.InteropServices;

public class Desktop {
	public const int SetDesktopWallpaper = 0x0014;
	public const int UpdateIniFile = 0x01;
	public const int SendWinIniChange = 0x02;

	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
	private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

	public static void SetWallpaper(string path) {
        SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
	}
}

"@

$WALLPAPER = @{

    Center  = @{ TileWallpaper = 0; WallpaperStyle = 0 ; }
    Fill    = @{ TileWallpaper = 0; WallpaperStyle = 10; }
    Fit     = @{ TileWallpaper = 0; WallpaperStyle = 6 ; }
    Stretch = @{ TileWallpaper = 0; WallpaperStyle = 2 ; }
    Span    = @{ TileWallpaper = 0; WallpaperStyle = 22; }
    Tile    = @{ TileWallpaper = 1; WallpaperStyle = 0 ; }
}

function Set-Wallpaper {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript( { Test-Image -Path $_ })]
        [System.IO.FileInfo]
        $Path,

        [Parameter(Mandatory)]
        [ValidateScript( { $_ -in @($WALLPAPER.Keys) })]
        [string]
        $Fit
    )

    $DesktopRegKey = 'HKCU:\Control Panel\Desktop'
    Set-ItemProperty -Path $DesktopRegKey -Name TileWallpaper -Value $WALLPAPER[$Fit].TileWallpaper
    Set-ItemProperty -Path $DesktopRegKey -Name WallpaperStyle -Value $WALLPAPER[$Fit].WallpaperStyle
    
    [Desktop]::SetWallpaper((Get-Item $Path).FullName)
}

Export-ModuleMember -Function Set-Wallpaper