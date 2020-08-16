@echo off

SETLOCAL EnableDelayedExpansion
:: set working directory to script directory
SET initcwd=%cd%
SET scriptpath=%~dp0
cd %scriptpath:~0,-1%
set "gbdk_version=2.95-3"

:: set default option values
set option_clean=false
set option_uninstall=false
set option_mirror=""
set mirror=""

:: find options in arguments
FOR %%a IN (%*) DO (
    set arg=%%a
    if "!arg!"=="--clean" (
        set option_clean=true
    )
    if "!arg!"=="--uninstall" (
        set option_clean=true
        set option_uninstall=true
    )
    if "!arg!"=="--mirror" (
        set option_mirror=true
        set /a search_arg_num=!arg_count!+1
        set /a arg_count_b=0
        :: TODO check variable was found at index
        FOR %%b IN (%*) DO (
            Set /a arg_count_b+=1
            if !arg_count_b!==!search_arg_num! (
                set mirror=%%b
            )
        )
    )
)

if "%option_mirror%"=="true" (
    set "mirror_str=?use_mirror=%mirror%"
)

:: download file
SET downloadfile=gbdk-%gbdk_version%-win32.zip
:: url for downloading gbdk
set url=https://sourceforge.net/projects/gbdk/files/gbdk-win32/%gbdk_version%/gbdk-%gbdk_version%-win32.zip/download%mirror_str%
:: folder where download is placed
SET "downloadfolder=C:"
:: full output filepath
SET downloadpath=%downloadfolder%\%downloadfile%

if "%option_clean%"=="true" (
    echo Cleaning directory...
    rmdir /Q /S %downloadfolder%\gbdk
)

if "%option_uninstall%"=="true" (
    exit /b %ERRORLEVEL%
)

:: download opencv from url
curl -o "%downloadpath%" -L %url%

cd %downloadfolder%\

echo Extracting gbdk...
tar -xf %downloadfile%

:: delete downloaded file
del %downloadfile%
echo gbdk install complete.

:: reset working directory
cd %initcwd%

ENDLOCAL