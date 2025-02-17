# FIM
File Integrity Monitor 👁

## Intro
a simple powershell script [FIM.ps1](FIM.ps1) that act as a FIM (file integrity monitor)

**File integrity monitoring** is a security **process** that **monitors** and analyzes the **integrity** of critical assets.

This script is designed to watch some files and alert if they are modified or any changes.

## How it works
There are 4 main steps for this code :

* Get the path of the files we want to monitor
  
* Create a baseline
  
* Monitor and verify file integrity
  
* Issue an alert in case of any changes

  more details  in next part :

## 1. Get the Path of the Files We Want to Monitor
Prompting the user to enter the folder path where the files to be monitored are located :

```powershell
$folderPath = Read-Host -Prompt "Please enter the path"
```

## 2. Create a baseline
Prompting the user to select a hashing algorithm and generating a baseline file with file paths and hashes

```powershell
# A = if the user wants to create a new baseline
if ($response.ToUpper() -eq "A") {
# choose a hashing algorithm
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
# Remove baseline if it exists
    Erase-Baseline-If-Already-Exists -baselinePath $baselinePath

# Get all files in the specified folder, excluding the baseline file
    $files = Get-ChildItem -Path $folderPath | Where-Object { $_.FullName -ne $baselinePath }

 # Generate hash for each file and save to baseline
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName $selectedAlgorithm
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath $baselinePath -Append
    }
    Write-Host "baseline is created."
}


```




## 3. Monitor and verify file integrity 
Monitoring files continuously, comparing their hashes to the baseline, and identifying any modification in integrity 


```powershell
# B = If the user wants to begin monitoring using the saved baseline
elseif ($response.ToUpper() -eq "B") {

# Create a dictionary to store file paths and hashes
    $fileHashDictionary = @{}

# Read the content of the baseline file
    $filePathsAndHashes = Get-Content -Path $baselinePath

 # Collecting Paths and Hashes
    foreach ($f in $filePathsAndHashes) {
# first part of splited string is Path
# second part of splited string is Hash
        $fileHashDictionary.Add($f.Split("|")[0], $f.Split("|")[1])
    }
```
### Continuous Monitoring and Actions

```powershell
# Continuous monitoring of the files
    while ($true) {
        Start-Sleep -Seconds 2

# Get all files in the folder again, excluding the baseline file
        $files = Get-ChildItem -Path $folderPath | Where-Object { $_.FullName -ne $baselinePath }

        foreach ($f in $files) {
# Calculate the hash of the current $f
            $hash = Calculate-File-Hash $f.FullName $selectedAlgorithm

# Check if the file is new or if the hash has "changed"
            if (-Not $fileHashDictionary.ContainsKey($hash.Path)) {
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            } else {
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                } else {
                    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                }
            }
        }

 # Check if any files from the baseline have been "deleted"
        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
}


```




## 4. Issue an alert in case of any changes
issueing alerts to the user if a file has been created, modified, or deleted

```powershell
# Alerts :
if (-Not $fileHashDictionary.ContainsKey($hash.Path)) {
    # File Created ---> Green
    Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
} elseif ($fileHashDictionary[$hash.Path] -ne $hash.Hash) {
    # File modified ---> Yellow
    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
} else {
    # File deleted ---> Red
    Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
}
```














  

## Example Test 
I have a folder named "file to monitor" and it contains 3 .txt files :

![files to monitor](https://github.com/user-attachments/assets/cb9f93e3-a5ae-4065-8c13-f8bdb6bc5c67)

running the script.

The first input is the path of the files that we want to monitor. so i will run the code and pass the path as the first input :

![run and give path](https://github.com/user-attachments/assets/48d70d8b-9c44-43b2-b0c4-d7ef643e7143)

next we must choose whether we want to create a new baseline or begin monitoring.

there is two option : 'A' and 'B'.
A for creating new baseline and B for start monitoring with existing baseline.


![A or B](https://github.com/user-attachments/assets/8cab0def-32f4-4340-841c-c1f452b49a4a)


Selecting 'A' to create the baseline of my files.

The next step is to choose which Hashing Algorithm you want to use.

There are 4 algorithms available in powershell: SHA1, SHA256, SHA384, and SHA512.

(i recommend choosing SHA512 for the best security experience)

after choosing algorithm the baseline is created : 


![choosed algo](https://github.com/user-attachments/assets/4a8b9651-de7c-4bc8-8f18-29442305287a)

checking the baseline :


![chech baseline](https://github.com/user-attachments/assets/48a9bad4-568f-4419-9b28-2c88d7bf7b23)

once again i run the code and choose B after giving it the path

at this point the script is continuously monitoring the files in the given path and create hashes of the files

and compare them to baseline.

its ready to alert in case of any changes :

![B](https://github.com/user-attachments/assets/29e825a5-0d68-493b-b122-a0e3d44fd050)


there are 3 possible actions that might occur in case of changes :


* Modifying existing files
  
  in this case the output will be a yellow prompt that says "x has changed!"

* Deleting existing files
  
  in this case the output will be a red prompt that says "x has been deleted!"

  
* Adding new files
  
  in this case the output will be a green prompt that says "x has been created!"


now i will change the `test1.txt` content to see the resutl:

![yellow](https://github.com/user-attachments/assets/d6fe237d-4b13-454c-b4dc-d9c174ae1f32)

for next lets create a new file :

![green](https://github.com/user-attachments/assets/82e7606e-6100-4f94-81cf-2e9aefc1ab72)

and for the last delete some file :

![red](https://github.com/user-attachments/assets/1511e5c1-2e5a-4688-bd91-a8ea5ba6da6d)







