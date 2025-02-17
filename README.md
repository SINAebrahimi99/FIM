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







