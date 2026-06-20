param(
  [Parameter(Mandatory = $true)]
  [string]$Source
)

Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$iconDirectory = Join-Path $root 'web\icons'
$sourceImage = [System.Drawing.Image]::FromFile($Source)

function Save-SquareIcon([int]$size, [string]$path, [int]$padding = 0) {
  $bitmap = New-Object System.Drawing.Bitmap($size, $size)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.DrawImage(
    $sourceImage,
    $padding,
    $padding,
    $size - ($padding * 2),
    $size - ($padding * 2)
  )
  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $graphics.Dispose()
  $bitmap.Dispose()
}

Save-SquareIcon 512 (Join-Path $iconDirectory 'vijnanadeepam-512.png')
Save-SquareIcon 192 (Join-Path $iconDirectory 'vijnanadeepam-192.png')
Save-SquareIcon 512 (Join-Path $iconDirectory 'vijnanadeepam-maskable-512.png') 42
Save-SquareIcon 192 (Join-Path $iconDirectory 'vijnanadeepam-maskable-192.png') 16
Save-SquareIcon 48 (Join-Path $root 'web\vijnanadeepam-favicon.png')

$sourceImage.Dispose()
