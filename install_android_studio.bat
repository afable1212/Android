@echo off
setlocal

echo ==========================================
echo ANDROID STUDIO ZIP INSTALL STARTING
echo ==========================================

set "ZIPFILE=%TEMP%\android-studio.zip"
set "EXTRACTDIR=%TEMP%\android-studio-extract"
set "TARGETDIR=C:\Program Files\Android\Android Studio"

echo Downloading Android Studio ZIP...
curl -L -o "%ZIPFILE%" "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.2.6/android-studio-panda2-windows.zip"

if not exist "%ZIPFILE%" (
    echo ERROR: Download failed.
    pause
    exit /b 1
)

for %%I in ("%ZIPFILE%") do set SIZE=%%~zI
echo Downloaded size: %SIZE% bytes

if %SIZE% LSS 100000000 (
    echo ERROR: File is too small. Download is not the real Android Studio package.
    pause
    exit /b 1
)

if exist "%EXTRACTDIR%" rmdir /s /q "%EXTRACTDIR%"
mkdir "%EXTRACTDIR%"

echo Extracting ZIP...
tar -xf "%ZIPFILE%" -C "%EXTRACTDIR%"

if not exist "%EXTRACTDIR%\android-studio" (
    echo ERROR: Extraction failed or ZIP contents unexpected.
    pause
    exit /b 1
)

if exist "%TARGETDIR%" rmdir /s /q "%TARGETDIR%"
mkdir "C:\Program Files\Android" 2>nul

echo Copying files...
xcopy "%EXTRACTDIR%\android-studio" "%TARGETDIR%\" /E /I /H /Y

if not exist "%TARGETDIR%\bin\studio64.exe" (
    echo ERROR: studio64.exe not found after copy.
    pause
    exit /b 1
)

echo Creating desktop shortcut...
set "VBSFILE=%TEMP%\CreateASShortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBSFILE%"
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\Android Studio.lnk" >> "%VBSFILE%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBSFILE%"
echo oLink.TargetPath = "%TARGETDIR%\bin\studio64.exe" >> "%VBSFILE%"
echo oLink.WorkingDirectory = "%TARGETDIR%\bin" >> "%VBSFILE%"
echo oLink.Save >> "%VBSFILE%"
cscript //nologo "%VBSFILE%"
del "%VBSFILE%"

echo ==========================================
echo ANDROID STUDIO INSTALLED
echo Launch:
echo "%TARGETDIR%\bin\studio64.exe"
echo ==========================================

pause