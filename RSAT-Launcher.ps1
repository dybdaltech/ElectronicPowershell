#Lord Hagen / olehag04@nfk.no
#Rev 1.9.1


Write-Host ""
Write-Host "Input Credentials"
Write-Host ""


#Change "$env:userdomain\$env:username-admin" to fit your need.
$creds = Get-Credential $env:USERDOMAIN\$env:USERNAME-admin
Clear-Host

do {
        do { 
            Write-Host "`n`tRSAT Launcher`n" -ForegroundColor Magenta
            Write-Host "`t`tMain Meny`n" -ForegroundColor Cyan
            Write-Host "`t`t`t1. Users & Computers" -ForegroundColor Green
            Write-Host "`t`t`t2. Group Policy Object" -ForegroundColor Green
            Write-Host "`t`t`t3. Print Management" -ForegroundColor Green
            Write-Host "`t`t`t4. Wrong password" -ForegroundColor Green
            Write-Host "`t`t`t5. Download & install (For Win 10)" -ForegroundColor Green
            #Write-Host "`t`t`t6. " -ForegroundColor Green
            #Write-Host "`t`t`t7. " -ForegroundColor Green
            #Write-Host "`t`t`t8. " -ForegroundColor Green
            #Write-Host "`t`t`t9. " -ForegroundColor Green
            Write-Host ""
            Write-Host "`t`tX - Exit`n" -ForegroundColor Red
            Write-Host ""
            Write-Host -nonewline "`tSoftware: " -ForegroundColor Yellow
            
            $choice = read-host
            
            Write-Host ""
                #    Add (example: [1-6x]) if you have expanded the meny.
            $ok = $choice -match '^[1-5x]+$'
            
            if ( -not $ok) 
                {
                    Clear-Host
                    Write-Host "Invalid choice" -ForegroundColor Red
                }

            } until ( $ok )
        
        
        
        switch -Regex ( $choice ) 
            {
        
                "1" #Users & Computers.
                {
                    Start-Process powershell -workingdirectory $PSHOME -Credential $creds -ArgumentList "/c dsa.msc"
                    Start-Sleep -s 1
                    Clear-Host
                }
            
                "2" #Group Policy Object
                {
                    Start-Process powershell -workingdirectory $PSHOME -Credential $creds -ArgumentList "/c gpmc.msc"
                    Start-Sleep -s 1
                    Clear-Host
                }

                "3" #Print Management
                {
                    Start-Process powershell -workingdirectory $PSHOME -Credential $creds -ArgumentList "/c printmanagement.msc"
                    Start-Sleep -s 1
                    Clear-Host
                }

                "4" #Wrong password
                {
                    Clear-Host
                    Write-Host ""
                    Write-Host "Input Credentials"
                    Write-Host ""
                    $creds = Get-Credential $env:USERDOMAIN\$env:USERNAME-admin
                    Clear-Host
                }
            
                "5" #RSAT ###########!!!!!!!!!!   This will run a Powershell-Script from github!   !!!!!!!!!!!!#################
                {
                    #next line starts the script elevated. Needed to check for RSAT.
                    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
                    
                    #Try to find the windowsfeature. Download if not.
                    if((Get-WindowsOptionalFeature -online | Where-Object {$_.FeatureName -like "RSAT*"} | Format-Table -AutoSize) -eq $null)
                    {
                        Write-Host "`tCouldn't find Remote Server Administration Tools" -ForegroundColor Yellow
                        Write-Host "`tpress any button to download..." -ForegroundColor Yellow

                        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                        
                        #Get RSAT script, fetches x86 or x64 based on system. only for WIN 10.
                        $GitHubScript = Invoke-WebRequest https://raw.githubusercontent.com/olehag/Download-RSAT/master/GET-RSAT.ps1
                        Invoke-Expression $($GitHubScript.Content)
                    }
                    
                    else
                    {
                        if((Get-WindowsOptionalFeature -online | Where-Object {$_.FeatureName -like "RSAT*" -And $_.State -like "Disabled"} | Format-Table -AutoSize) -eq $null)
                        {
                            Write-Host "RSAT is already installed!" -ForegroundColor Green
                            Start-Sleep -Seconds 2
                            Clear-Host
                        }
                        else
                        {
                            Write-Host "`tRSAT is not activated..."
                            Write-Host ""
                            Write-Host "`tPress any button to continue..." -ForegroundColor Yellow

                            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

                            #Script activation dosn't work atm.
                            #Enable-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like "RSAT*"} | Format-Table -AutoSize

                        }
                    }
                }
                
                "6" #Expansion
                {
                    #Start-Process powershell -workingdirectory $PSHOME -Credential $creds -ArgumentList "/c xxx.msc"
                }

                "7" #Expansion
                {
                    #Start-Process powershell -workingdirectory $PSHOME -Credential $creds -ArgumentList "/c xxx.msc"
                }

                "8" #Expansion
                {
                    #Start-Process powershell -workingdirectory $PSHOME -Credential $creds -ArgumentList "/c xxx.msc"
                }

                "9" #Expansion
                {
                    #Start-Process powershell -workingdirectory $PSHOME -Credential $creds -ArgumentList "/c xxx.msc"
                }
         
            }


} until ( $choice -match "X" )