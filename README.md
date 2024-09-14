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

  more details in next part :

## Example Test 
I have a folder named "file to monitor" and it contains 3 .txt files :

![files to monitor](https://github.com/user-attachments/assets/cb9f93e3-a5ae-4065-8c13-f8bdb6bc5c67)


Let's run the script.

The first input is the path of the files that we want to monitor. so i will run the code and pass the path as the first input :

![run and give path](https://github.com/user-attachments/assets/48d70d8b-9c44-43b2-b0c4-d7ef643e7143)

next we must choose whether we want to create a new baseline or begin monitoring.

there is two option : 'A' and 'B'.
A for creating new baseline and B for start monitoring with existing baseline.


![A or B](https://github.com/user-attachments/assets/8cab0def-32f4-4340-841c-c1f452b49a4a)


i choose 'A' to create the baseline of my files.

The next step is to choose which Hashing Algorithm you want to use.

There are 4 algorithms available in powershell: SHA1, SHA256, SHA384, and SHA512.

(i recommend choosing SHA512 for the best security experience! )

after choosing algorithm the baseline is created : 


![choosed algo](https://github.com/user-attachments/assets/4a8b9651-de7c-4bc8-8f18-29442305287a)

lets check the baseline :


![chech baseline](https://github.com/user-attachments/assets/48a9bad4-568f-4419-9b28-2c88d7bf7b23)



