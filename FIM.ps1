Function Calculate-File-Hash($filepath, $algorithm) {
    $filehash = Get-FileHash -Path $filepath -Algorithm $algorithm
    return $filehash
}

Function Erase-Baseline-If-Already-Exists($baselinePath) {
    $baselineExists = Test-Path -Path $baselinePath

    if ($baselineExists) {
        Remove-Item -Path $baselinePath
    }
}


$folderPath = Read-Host -Prompt "Please enter the path"

if (-Not (Test-Path -Path $folderPath)) {
    Write-Host "The folder path specified does not exist. Exiting script." -ForegroundColor Red
    exit
}

$baselinePath = Join-Path -Path $folderPath -ChildPath "baseline.txt"

Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    A) new Baseline?"
Write-Host "    B) Begin monitoring with saved Baseline?"
Write-Host ""
$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

if ($response.ToUpper() -eq "A") {
    Write-Host "Available hashing algorithms:"
    Write-Host "    1) SHA1"
    Write-Host "    2) SHA256"
    Write-Host "    3) SHA384"
    Write-Host "    4) SHA512"
    
    $algorithmChoice = Read-Host -Prompt "Please enter the number of the desired hashing algorithm"

    switch ($algorithmChoice) {
        "1" { $selectedAlgorithm = "SHA1" }
        "2" { $selectedAlgorithm = "SHA256" }
        "3" { $selectedAlgorithm = "SHA384" }
        "4" { $selectedAlgorithm = "SHA512" }
        default {
            Write-Host "Invalid choice. Exiting script." -ForegroundColor Red
            exit
        }
    }

    Erase-Baseline-If-Already-Exists -baselinePath $baselinePath

    $files = Get-ChildItem -Path $folderPath | Where-Object { $_.FullName -ne $baselinePath }

    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName $selectedAlgorithm
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath $baselinePath -Append
    }
    Write-Host "baseline is created."
    
} elseif ($response.ToUpper() -eq "B") {
    
    $fileHashDictionary = @{}

    $filePathsAndHashes = Get-Content -Path $baselinePath
    
    foreach ($f in $filePathsAndHashes) {
        $fileHashDictionary.Add($f.Split("|")[0], $f.Split("|")[1])
    }

    while ($true) {
        Start-Sleep -Seconds 2
        
        $files = Get-ChildItem -Path $folderPath | Where-Object { $_.FullName -ne $baselinePath }

        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName $selectedAlgorithm

            if (-Not $fileHashDictionary.ContainsKey($hash.Path)) {
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            } else {
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                } else {
                    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                }
            }
        }

        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
} else {
    Write-Host "Invalid option selected. Exiting script." -ForegroundColor Red
}