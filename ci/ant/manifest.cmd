@echo off
setlocal enabledelayedexpansion

set package=%~1
if /i "!package!" == "" (
    >&2 echo.Path to package not set
    echo.Syntax: %~n0 package-path api-version
    echo.Example: %~n0 force-app\main\default 57.0
    exit /b 1
)

set api-version=%~2
if /i "!api-version!" == "" (
    >&2 echo.API version not set
    echo.Syntax: %~n0 package-path api-version
    echo.Example: %~n0 force-app\main\default 57.0
    exit /b 1
)

echo.^<?xml version="1.0" encoding="UTF-8"?^>
echo.^<Package^ xmlns="http://soap.sforce.com/2006/04/metadata"^>

set last-type=
for /f "tokens=*" %%a in ('dir /b %package%') do (
    if /i "%%~xa" == "" (
        for /f "tokens=*" %%b in ('dir /b %package%\%%a') do (
            set filepath=%package%\%%a\%%b
            set extension=%%~xb

            set metadata=
            if /i "!extension!" == ".xml" (
                set metadata=!filepath!
            ) else if /i "!extension!" == "" (
                for /f "tokens=*" %%c in ('dir /b !filepath!') do (
                    if /i "%%~xc" == ".xml" (
                        set metadata=!filepath!\%%c
                    )
                )
            )

            if /i not "!metadata!" == "" (
                set line=
                for /f "skip=1" %%c in (!metadata!) do (
                    if "!line!" == "" (
                        set line=%%c
                    )
                )

                set type=!line:~1!
                if /i not "!last-type!" == "!type!" (
                    if /i not "!last-type!" == "" (
                        echo.    ^</types^>
                    )

                    set last-type=!type!
                    echo.    ^<types^>
                    echo.        ^<name^>!type!^</name^>
                )

                for /f "tokens=1 delims=." %%c in ("%%b") do (
                    set name=%%c
                )

                echo.        ^<members^>!name!^</members^>
            )
        )
    )
)

if /i not "!last-type!" == "" (
    echo.    ^</types^>
)

echo.    ^<version^>!api-version!^</version^>

echo.^</Package^>
