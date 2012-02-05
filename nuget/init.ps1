﻿param($installPath, $toolsPath, $package, $project)

$rootPath = (Resolve-Path "$installPath\..\..").Path
$buildPath = "$rootPath\build"
if(!(Test-Path($buildPath))) { New-Item $buildPath -ItemType Directory | Out-Null }
$buildPath = (Resolve-Path $buildPath).Path

$buildToolsPath = "$toolsPath\build"
$folders = Get-ChildItem $buildToolsPath -recurse -force | ?{ $_.PSIsContainer } 
$folders | % { $newpath=(($_.FullName).Replace($buildToolsPath,$buildPath)); if(!(test-path $newpath)){ New-Item -ItemType Directory -Path "$newpath" -Force } }

# copy main scripts
$files = Get-ChildItem "$buildToolsPath" -recurse -exclude settings.ps1, build.ps1 | ? { !$_.PSIsContainer } 

$files | % { $newpath=(($_.FullName).Replace($buildToolsPath,$buildPath)); Copy-Item $_.FullName $newpath -Force }

# copy the build.ps1 and settings.ps1, ignore if they already exist

if(!(Test-Path("$buildToolsPath\settings.ps1"))) { Move-Item  "$buildToolsPath\settings.ps1" -Destination $buildPath }
if(!(Test-Path("$buildToolsPath\build.ps1"))) { Move-Item  "$buildToolsPath\build.ps1" -Destination $buildPath }

# copy the solution level build scripts, ignore if they already exist

$toolCommandPath = "$toolsPath\commands"
if(!(Test-Path("$toolCommandPath\build.ps1"))) { Move-Item  "$toolCommandPath\build.ps1" -Destination $rootPath }
if(!(Test-Path("$toolCommandPath\build.cmd"))) { Move-Item  "$toolCommandPath\build.cmd" -Destination $rootPath }
if(!(Test-Path("$toolCommandPath\build-release.cmd"))) { Move-Item  "$toolCommandPath\build-release.cmd" -Destination $rootPath }

# remove everything as we have copied it over.

#Remove-Item $installPath -recurse -Force
