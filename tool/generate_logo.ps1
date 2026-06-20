Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$iconDirectory = Join-Path $root 'web\icons'

function New-Logo([int]$size, [string]$path) {
  $bitmap = New-Object System.Drawing.Bitmap($size, $size)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $scale = $size / 512.0

  $background = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(8, 18, 29))
  $gold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(222, 181, 87))
  $ivory = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(247, 232, 189))
  $goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(90, 222, 181, 87), (5 * $scale))
  $ivoryPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(185, 247, 232, 189), (5 * $scale))
  $ivoryPen.StartCap = $ivoryPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

  $graphics.FillRectangle($background, 0, 0, $size, $size)
  $graphics.DrawEllipse($goldPen, 82 * $scale, 70 * $scale, 348 * $scale, 348 * $scale)

  # Cross
  $graphics.FillRectangle($gold, 247 * $scale, 72 * $scale, 18 * $scale, 76 * $scale)
  $graphics.FillRectangle($gold, 218 * $scale, 97 * $scale, 76 * $scale, 18 * $scale)

  # Flame
  $flame = New-Object System.Drawing.Drawing2D.GraphicsPath
  $flame.AddBezier(256 * $scale, 143 * $scale, 202 * $scale, 202 * $scale, 211 * $scale, 265 * $scale, 256 * $scale, 278 * $scale)
  $flame.AddBezier(256 * $scale, 278 * $scale, 241 * $scale, 255 * $scale, 252 * $scale, 235 * $scale, 268 * $scale, 196 * $scale)
  $flame.AddBezier(268 * $scale, 196 * $scale, 314 * $scale, 244 * $scale, 295 * $scale, 274 * $scale, 256 * $scale, 278 * $scale)
  $flame.CloseFigure()
  $graphics.FillPath($gold, $flame)

  # Lamp
  $graphics.FillRectangle($gold, 162 * $scale, 274 * $scale, 188 * $scale, 20 * $scale)
  $graphics.FillEllipse($gold, 178 * $scale, 264 * $scale, 156 * $scale, 94 * $scale)
  $graphics.FillRectangle($background, 174 * $scale, 264 * $scale, 164 * $scale, 31 * $scale)
  $graphics.FillEllipse($ivory, 208 * $scale, 286 * $scale, 96 * $scale, 25 * $scale)
  $graphics.FillRectangle($gold, 184 * $scale, 359 * $scale, 144 * $scale, 18 * $scale)
  $graphics.FillRectangle($gold, 153 * $scale, 389 * $scale, 206 * $scale, 19 * $scale)

  # Open book
  $leftBook = New-Object System.Drawing.Drawing2D.GraphicsPath
  $leftBook.AddBezier(83 * $scale, 365 * $scale, 146 * $scale, 342 * $scale, 199 * $scale, 354 * $scale, 239 * $scale, 383 * $scale)
  $leftBook.AddLine(239 * $scale, 383 * $scale, 239 * $scale, 441 * $scale)
  $leftBook.AddBezier(239 * $scale, 441 * $scale, 194 * $scale, 414 * $scale, 142 * $scale, 407 * $scale, 83 * $scale, 424 * $scale)
  $leftBook.CloseFigure()
  $graphics.FillPath($gold, $leftBook)

  $rightBook = New-Object System.Drawing.Drawing2D.GraphicsPath
  $rightBook.AddBezier(429 * $scale, 365 * $scale, 366 * $scale, 342 * $scale, 313 * $scale, 354 * $scale, 273 * $scale, 383 * $scale)
  $rightBook.AddLine(273 * $scale, 383 * $scale, 273 * $scale, 441 * $scale)
  $rightBook.AddBezier(273 * $scale, 441 * $scale, 318 * $scale, 414 * $scale, 370 * $scale, 407 * $scale, 429 * $scale, 424 * $scale)
  $rightBook.CloseFigure()
  $graphics.FillPath($gold, $rightBook)

  $graphics.DrawLine($ivoryPen, 256 * $scale, 382 * $scale, 256 * $scale, 444 * $scale)
  $graphics.DrawBezier($ivoryPen, 96 * $scale, 383 * $scale, 143 * $scale, 371 * $scale, 190 * $scale, 378 * $scale, 225 * $scale, 401 * $scale)
  $graphics.DrawBezier($ivoryPen, 416 * $scale, 383 * $scale, 369 * $scale, 371 * $scale, 322 * $scale, 378 * $scale, 287 * $scale, 401 * $scale)

  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $graphics.Dispose()
  $bitmap.Dispose()
  $background.Dispose()
  $gold.Dispose()
  $ivory.Dispose()
  $goldPen.Dispose()
  $ivoryPen.Dispose()
}

New-Logo 512 (Join-Path $iconDirectory 'vijnanadeepam-512.png')
New-Logo 192 (Join-Path $iconDirectory 'vijnanadeepam-192.png')
New-Logo 512 (Join-Path $iconDirectory 'vijnanadeepam-maskable-512.png')
New-Logo 192 (Join-Path $iconDirectory 'vijnanadeepam-maskable-192.png')
New-Logo 48 (Join-Path $root 'web\vijnanadeepam-favicon.png')
