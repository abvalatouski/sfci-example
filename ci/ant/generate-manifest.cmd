@echo off
setlocal enabledelayedexpansion

echo.^<?xml version="1.0" encoding="UTF-8"?^>
echo.^<Package^ xmlns="http://soap.sforce.com/2006/04/metadata"^>

set package=%~1
set last_type=
for /f "tokens=*" %%a in ('dir /b %package%') do (
    for /f "tokens=*" %%b in ('dir /b %package%\%%a') do (
        set filepath=%package%\%%a\%%b
        set extension=%%~xb

        set metadata=
        if /i "!extension!" == ".xml" (
            set metadata=!filepath!
        ) else if /i "!extension!" == "" (
            set metadata=!filepath!\%%b.js-meta.xml
        )

        if /i not "!metadata!" == "" (
            set line=
            for /f "skip=1" %%c in (!metadata!) do (
                if "!line!" == "" (
                    set line=%%c
                )
            )

            set type=!line:~1!
            if /i not "!last_type!" == "!type!" (
                if /i not "!last_type!" == "" (
                    echo.    ^</types^>
                )

                set last_type=!type!
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

if /i not "!last_type!" == "" (
    echo.    ^</types^>
)

set version=%~2
echo.    ^<version^>!version!^</version^>

echo.^</Package^>
