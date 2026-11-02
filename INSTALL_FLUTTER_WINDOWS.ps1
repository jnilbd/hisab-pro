# HisabPro Windows setup helper
# Run in PowerShell. Installs Git + Flutter SDK; Android Studio is optional but recommended.
$ErrorActionPreference = "Stop"
Write-Host "=== HisabPro Windows Setup ===" -ForegroundColor Cyan
$root = "C:\src"
$flutterDir = Join-Path $root "flutter"
New-Item -ItemType Directory -Force -Path $root | Out-Null
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw "winget পাওয়া যায়নি। Microsoft App Installer আপডেট করুন।" }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements }
if (-not (Test-Path (Join-Path $flutterDir "bin\flutter.bat"))) {
  Write-Host "Flutter stable SDK download করছি..."
  $releases = Invoke-RestMethod "https://storage.googleapis.com/flutter_infra_release/releases/releases_windows.json"
  $hash = $releases.current_release.stable
  $release = $releases.releases | Where-Object { $_.hash -eq $hash -and $_.channel -eq "stable" } | Select-Object -First 1
  if (-not $release) { throw "Flutter stable release পাওয়া যায়নি।" }
  $zip = Join-Path $env:TEMP "flutter_windows_stable.zip"
  Invoke-WebRequest -Uri ("https://storage.googleapis.com/flutter_infra_release/releases/" + $release.archive) -OutFile $zip
  $extract = Join-Path $env:TEMP "hisabpro_flutter_extract"
  if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }
  Expand-Archive $zip $extract -Force
  if (Test-Path $flutterDir) { Remove-Item $flutterDir -Recurse -Force }
  Move-Item (Join-Path $extract "flutter") $flutterDir
  Remove-Item $extract -Recurse -Force; Remove-Item $zip -Force
}
$bin = Join-Path $flutterDir "bin"
$path = [Environment]::GetEnvironmentVariable("Path","User")
if (($path -split ';') -notcontains $bin) { [Environment]::SetEnvironmentVariable("Path", (($path.TrimEnd(';') + ";" + $bin).TrimStart(';')), "User") }
$env:Path = "$bin;$env:Path"
& (Join-Path $bin "flutter.bat") --version
& (Join-Path $bin "flutter.bat") doctor
Write-Host "পরবর্তী: Android Studio install করে Android SDK/Platform Tools দিন; তারপর flutter doctor --android-licenses চালান।" -ForegroundColor Yellow
