<#
.SYNOPSIS
    Test if an image file is in format supported for Windows background.
.DESCRIPTION
    Test file headers for supported image types namely, bmp, gif, tiff, png, jpg.
.EXAMPLE
    PS C:\> Test-Image -Path 'C:\Path\To\Image.jpg'
.EXAMPLE
    PS C:\> Get-ChildItem | Test-Image -Path 'C:\Path\To\Image.jpg' -PassThru
.INPUTS
    String or object that can be resolved as file path.
.OUTPUTS
    None, System.Boolean, or System.Object
    When PassThru parameter is used, it returns the input object if test is positive, and None if test is negative.
    By default, it returns boolean value corresponding to the test results.
.NOTES
    Reference: https://devblogs.microsoft.com/scripting/psimaging-part-1-test-image
#>
function Test-Wallpaper {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
        [Alias("Path")]
        [System.IO.FileInfo]
        $File,

        [Parameter()]
        [switch]
        $PassThru
    )

    begin {
        $SupportedFileHeaders = @{
            BMP  = @("42", "4D");
            GIF  = @("47", "49", "46");
            TIF  = @("49", "49", "2A");
            TIFF = @("4D", "4D", "2A");
            PNG  = @("89", "50", "4E", "47");
            JPG  = @("FF", "D8", "FF", "E0");
            JPEG = @("FF", "D8", "FF", "E1")
        }
    }

    process {
        $File | Add-Member -NotePropertyName Path -NotePropertyValue $File.FullName # Get-Content looks for 'Path' property
        $Bytes = $File | Get-Content -Encoding Byte -ReadCount 1 -TotalCount 8
        foreach ($Type in $SupportedFileHeaders.Keys) {
            $FileHeader = $Bytes | Select-Object -First $SupportedFileHeaders[$Type].Length | ForEach-Object { $_.ToString("X2") }
            if (-not $FileHeader -or $FileHeader.Length -eq 0) {
                continue 
            }
            $Diff = Compare-Object -ReferenceObject $SupportedFileHeaders[$Type] -DifferenceObject $FileHeader
            if (($Diff | Measure-Object).Count -eq 0) {
                Write-Verbose ('{0} is a {1} file.' -f $File, $Type.ToLower())
                if ($PassThru) {
                    return ($File | Add-Member -NotePropertyName ImageType -NotePropertyValue $Type.ToLower() -PassThru)
                }
                else {
                    return $true
                }
            }
        }
        Write-Verbose ('{0} does not match any of the {1} format.' -f $File, ($SupportedFileHeaders.Keys -join ', ').ToLower())
        if (-not $PassThru) {
            return $false
        }
    }
}

Export-ModuleMember -Function Test-Wallpaper