#Requires -Assembly 'System.Drawing'

function Select-Image {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateScript( { $_ | Test-Path -PathType Leaf })]
		[System.IO.FileInfo]
		$Path,

		[Int32] $Width,
		[Int32] $Height
	)
	
	begin {
		$ImageSize = [System.Drawing.Size]::new($Width, $Height)
	}
	
	process {
		try {
			$FileStream = [System.IO.File]::Open($Path.FullName, [System.IO.FileMode]::Open)
			$Image = [System.Drawing.Image]::FromStream($FileStream, 0, 0)
			if ($Width * $Height -eq 0) { return $Path }
			$Diff = Compare-Object -ReferenceObject $ImageSize -DifferenceObject $Image.Size
			if (($Diff | Measure-Object).Count -eq 0) { return $Path }
		}
		catch {
			Throw '{0} is invalid image or not supported.' -f $Path.Fullname
		}
		finally {
			$FileStream.Close()
		}
	}
}

Export-ModuleMember -Function Select-Image