echo off
echo.
echo ##############################################################
echo ███████╗████████╗██╗  ██╗██╗   ██╗
echo ██╔════╝╚══██╔══╝██║  ██║╚██╗ ██╔╝
echo █████╗     ██║   ███████║ ╚████╔╝ 
echo ██╔══╝     ██║   ██╔══██║  ╚██╔╝  
echo ███████╗   ██║   ██║  ██║   ██║   
echo ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝                  
echo De-Bloat Windows 10 & bye bye telemetry script
echo Uruchamiasz na wlasna odpowidzialnosc :)
echo ##############################################################
echo.
pause
echo =========================
echo == Zatrzymywanie uslug ==
echo =========================
echo.
sc stop DiagTrack
echo DiagTrack - zatrzymany...
sc stop diagnosticshub.standardcollector.service
echo DiagnosticHub - zatrzymany...
sc stop dmwappushservice
echo Push Service - zatrzymany...
sc stop WMPNetworkSvc
echo WindowsMediaPlayer po sieci - zatrzymany...
sc stop WSearch
echo WindowsSearch - zatrzymany.
echo.
echo ======================
echo == Wylaczanie uslug ==
echo ======================
echo.
sc config DiagTrack start= disabled
echo DiagTrack - wylaczony...
sc config diagnosticshub.standardcollector.service start= disabled
echo DiagnosticHub - wylaczony...
sc config dmwappushservice start= disabled
echo Push Service - wylaczony...
sc config RemoteRegistry start= disabled
echo Zdalnego rejestru - wylaczony...
sc config TrkWks start= disabled
echo LinkTrackingService - wylaczony...
sc config WMPNetworkSvc start= disabled
echo WindowsMediaPlayer po sieci - wylaczony...
sc config WSearch start= disabled
echo WindowsSearch - wylaczony...
REM sc config SysMain start= disabled
echo.
echo ======================================
echo == Wylaczanie zadan w harmonogramie ==
echo ======================================
echo.
schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
echo SmartScreen - wylaczony...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
echo Microsoft Compatibility Appraiser - wylaczony...
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
echo Program Data Updater - wylaczony...
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Uploader" /Disable
echo Skladowe Windows Customer Experience Improvement - wylaczone...
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
echo Telemetria dla Windows Office - wylaczona...
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable
echo Historia plikow - wylaczona...
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
echo Telemetria sieci - wylaczona...
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
echo Automatyczna konfiguracja proxy - wylaczona...
REM schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable
REM schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable

:timesynchro
set /p %timesync%= 1 - wyłącz synchronizację / 2 - nie wyłączaj:

:start
if %timesync%==1 goto #A1
if %timesync%==2 goto #B1
:end

:#A1
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /Disable
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable
echo Synchronizacja czasu wyłączona - wylaczona...
goto :continue

:#B1
echo Kontynuuje skrypt.
goto :continue

:continue
REM schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable
REM schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update" /Disable
echo.
echo == Usuwam Telemetrie Windows ==
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f
echo.
echo zmiana klucza -> Pozwol aplikacjom na uzywanie mogego Advertising ID...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
echo wylaczam SmartScreen dla Windows Store...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f
echo ... i wymuszanie "lokalnego" jezyka na stronach www
reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f
echo Udostepnianie danych HotSpot'ow - adios
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f
echo HotSpot Auto-Connect dla udostepnionych HotSpot'ow - adieu
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f
echo zmiana trybu instalacji Windows na "Powiadom przed instalacja"
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v UxOption /t REG_DWORD /d 1 /f
echo wylaczenie pobieranie P2P dla WidnowsUpdate(poza siecia lokalna)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f
echo wylaczam WindowsSearch na pasku start (zostanie tylko ikona)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 1 /f
echo usuwam liste ostatnio otwieranych dokumentow
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f
echo zmieniam tryb pracy WindowsExplorer na "Ten Komputer" zamiast "Szybki dostep"
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
echo.
echo == Usuwanie MS Bloatware == 
PowerShell -Command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsCamera* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *bing* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *OneNote* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *people* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *photos* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *SkypeApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *solit* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsSoundRecorder* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *zune* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Sway* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *CommsPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *ConnectivityStore* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Facebook* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Twitter* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Drawboard PDF* | Remove-AppxPackage"
echo.
echo i jeszcze kilka malych Tweak'ow
echo.
echo pokazuj ukryte pliki w Eksploratorze Windows
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
echo pokazuj rozszerzenia typow plikow
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t  REG_DWORD /d 0 /f
echo.
echo ##############################################################
echo Wybierz opcję deinstalacje OneDrive - decyzja nalezy do Ciebie.
echo ##############################################################
:onedriveuninstall
set /p %onedrive%=1 - usun OneDrive / 2 - nie usuwaj:

:start
if %onedrive%==1 goto #A2
if %onedrive%==2 goto #B2
:end

:#A2
start /wait "" "%SYSTEMROOT%\SYSWOW64\ONEDRIVESETUP.EXE" /UNINSTALL
rd C:\OneDriveTemp /Q /S >NUL 2>&1
rd "%USERPROFILE%\OneDrive" /Q /S >NUL 2>&1
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S >NUL 2>&1
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S >NUL 2>&1
reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /f /v Attributes /t REG_DWORD /d 0 >NUL 2>&1
reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /f /v Attributes /t REG_DWORD /d 0 >NUL 2>&1
echo OneDrive has been removed. Windows Explorer needs to be restarted.
start /wait TASKKILL /F /IM explorer.exe
start explorer.exe
goto :done

:#B2
echo Koniec skryptu.
goto :done

:done
echo Czyszczenie zakonczone! Milego korzystania z czystszej wersji Win10
echo Mozesz juz bezpiecznie zamknac to okno.
pause >null
