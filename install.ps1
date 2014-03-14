$OS = "windows"
$DOTFILES = Get-Location

Function Install-Symlinks {
    $filesToSymlink = Get-ChildItem $DOTFILES\*\* | where {$_.Name -match "\.($OS-)?symlink$"}

    foreach ($file in $filesToSymlink) {
        $name = Get-Basename $file.Name
        $symlink = "$HOME\$name"
        $target = $file.FullName

        New-Symlink "$symlink" "$target"
    }
}

Function Install-ConfigurableSymlinks {
    $symlinkConfigFiles = Get-ChildItem $DOTFILES\*\* | where {$_.Name -match "\.symlinks$"}

    foreach ($configFile in $symlinkConfigFiles) {
        $config = cat $configFile.FullName
        $configuredName = $config | % {$null = $_ -match "^$OS" + ':\s+(?<link>.+)$'; $matches.link} | select -f 1

        if ($configuredName) {
            $symlink = "$HOME\$configuredName"
            $target = Get-Basename $configFile.FullName

            New-Symlink "$symlink" "$target"
        }
    }
}

Function Get-Basename {
    Param($string)
    return $string.Substring(0, $string.LastIndexOf('.'))
}

Function New-Symlink {
    Param($symlink, $target)

    if (Test-Path $target -pathType container) {
        # Remove-Item cannot be used to remove folder symlinks,
        # because it also removes the target folder.
        if (Test-Path $symlink) { cmd /c rmdir /s /q $symlink }
        (cmd /c mklink /d $symlink $target) > $null
    }
    else {
        if (Test-Path $symlink) { Remove-Item $symlink }
        (cmd /c mklink $symlink $target) > $null
    }

    Write-Host "$symlink -> $target"
}

Write-Host "-> Creating symbolic links..."
Install-Symlinks
Install-ConfigurableSymlinks
Write-Host "-> Done!"
