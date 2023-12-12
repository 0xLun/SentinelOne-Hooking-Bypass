# SentinelOne-Hooking-Bypass
```bash
PoC name : Scout - Escape EDR Hooking
Author: Evenson Jeunesse (0xLun)
Date : 10/11/2023
```
## Description 

It seems that some pentesters are able to evade EDR hooking monitoring by locating the directory in which performance focus or interoperability exclusions are configured. This allows them to bypass hooking monitoring. To reproduce this technique, I used a naive approach: I scan all the sub-folders of a specified location. In each subfolder, I copy a simple binary that does just one thing : check if a specific dll is loaded in the current memory and exit with 0 or 1 depending on the result. If the result is 1, then we've found a folder where the EDR dll is not loaded in the process memory. Note that this technic can also be implemented for linux OS and could affect a large number of EDR products. 


## Usage

### FS Explorer 
> FS Explorer will copy the scout executable to all folders in the directory provided (first argument). In each folder, the scout binary will be renamed to o0o.exe and launched. The scout executable will check whether any of the supplied dll files are loaded in its memory. If none of the dlls is loaded in memory, it can conclude that the EDR is not monitoring the executables in the current folder. After execution, the scout executable is deleted. The script stop once an excluded folder is found. 

Scout Compilation : g++ .\main.cpp -o scout.exe -static

Test for SentinelOne : 
```bash
.\fs-explorer.ps1 'C:\Program Files' 'InProcessClient64.dll,InProcessClient32.dll,MinProcessClient.dll'
```
```bash
.\fs-explorer.ps1 'C:\Program Files' 'InProcessClient64.dll,InProcessClient32.dll,MinProcessClient.dll,kern3l32.dll,ntd1l.dll'  
```

### PS Explorer
> PS Explorer will list all running processes. For each process, it will check if the provided are loaded by the process. If none of them are loaded, the process binary path will be displayed. This technic allows us to find process

Test for SentinelOne : 
```bash
.\ps-explorer.ps1 'InProcessClient64\.dll|InProcessClient32\.dll|MinProcessClient\.dll|kern3l32\.dll|ntd1l\.dll' 
```

## Limitations

- Administrator rights are required to make full use of these techniques (they are not intended to be used as a means of escalating privileges, but rather as a means of escaping hooking).
- Please note that none of these scripts are optimized for execution time (no parallelism), so they may take some time to run in large or deep folders.

## System Information 

```bash
Nom de l’hôte:                              PC99
Nom du système d’exploitation:              Microsoft Windows 10 Professionnel
Version du système:                         10.0.19045 N/A build 19045
Fabricant du système d’exploitation:        Microsoft Corporation
Configuration du système d’exploitation:    Station de travail membre
Type de build du système d’exploitation:    Multiprocessor Free
Propriétaire enregistré:                    Eve
Organisation enregistrée:
Identificateur de produit:                  00331-20097-79622-AA129
Date d’installation originale:              12/08/2023, 17:55:37
Heure de démarrage du système:              10/11/2023, 16:43:54
Fabricant du système:                       VMware, Inc.
Modèle du système:                          VMware20,1
Type du système:                            x64-based PC
Processeur(s):                              2 processeur(s) installé(s).
                                            [01] : AMD64 Family 25 Model 97 Stepping 2 AuthenticAMD ~3793 MHz
                                            [02] : AMD64 Family 25 Model 97 Stepping 2 AuthenticAMD ~3793 MHz
Version du BIOS:                            VMware, Inc. VMW201.00V.20648489.B64.2210180829, 18/10/2022
Répertoire Windows:                         C:\Windows
Répertoire système:                         C:\Windows\system32
Périphérique d’amorçage:                    \Device\HarddiskVolume1
Option régionale du système:                fr;Français (France)
Paramètres régionaux d’entrée:              fr;Français (France)
Fuseau horaire:                             (UTC+01:00) Bruxelles, Copenhague, Madrid, Paris
Mémoire physique totale:                    2 895 Mo
Mémoire physique disponible:                717 Mo
Mémoire virtuelle : taille maximale:        5 839 Mo
Mémoire virtuelle : disponible:             3 249 Mo
Mémoire virtuelle : en cours d’utilisation: 2 590 Mo
Emplacements des fichiers d’échange:        C:\pagefile.sys
Domaine:                                    capsule.corp
Serveur d’ouverture de session:             \\PC99
Correctif(s):                               8 Corrections installées.
                                            [01]: KB5029923
                                            [02]: KB5015684
                                            [03]: KB5020683
                                            [04]: KB5030211
                                            [05]: KB5014032
                                            [06]: KB5025315
                                            [07]: KB5028380
                                            [08]: KB5029709

```
