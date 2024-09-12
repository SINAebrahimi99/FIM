# FIM
File Integrity Monitor 👁

## What is this Repo?
Its a powershell script that act as a FIM (file integrity monitor)

File integrity monitoring is a security process that monitors and analyzes the integrity of critical assets.

This script is designed to watch your files and alert you if they are modified or any changes.

## How it works
There are 4 main steps for this code :

* Get the path of the files we want to monitor
  
* Create a baseline
  
* Monitor and verify file integrity
  
* Issue an alert in case of any changes

## Code Review

First, the user provides the path of the files they want to monitor `($filepath)`. 
and check whether this path exists.

Next, the user must choose a hashing algorithm from the available algorithms in PowerShell `$validAlgorithms`.

("SHA1", "SHA256", "SHA384", "SHA512", "MD5").

