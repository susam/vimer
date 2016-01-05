@echo off & goto :main

rem Vimer - A convenience wrapper for gvim --remote(-tab)-silent.

rem The MIT License (MIT)
rem
rem Copyright (c) 2010-2016 Susam Pal
rem
rem Permission is hereby granted, free of charge, to any person obtaining
rem a copy of this software and associated documentation files (the
rem "Software"), to deal in the Software without restriction, including
rem without limitation the rights to use, copy, modify, merge, publish,
rem distribute, sublicense, and/or sell copies of the Software, and to
rem permit persons to whom the Software is furnished to do so, subject to
rem the following conditions:
rem
rem The above copyright notice and this permission notice shall be
rem included in all copies or substantial portions of the Software.
rem
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
rem EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
rem MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
rem IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
rem CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
rem TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
rem SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


rem Starting point of this script.
:main
    setlocal
    set VERSION=0.1.0
    set COPYRIGHT=Copyright (c) 2010-2016 Susam Pal
    set LICENSE_URL=http://susam.in/licenses/mit/
    set NAME=%~n0

    set BUF_SHORTCUT=Edit with GVim
    set TAB_SHORTCUT=Edit with GVim tab

    if "%VIM_CMD%" == "" call :find_vim

    set tab=
    call :parse_arguments %*

    endlocal
    goto :eof


rem Automatically detect the path of GVim executable.
rem
rem If GVim is found on the system, set VIM_CMD to its path; do not set
rem VIM_CMD otherwise.
:find_vim
    rem Automatically detect the path of GVim executable.
    for /f "tokens=2*" %%a in (
            'reg query HKLM\SOFTWARE\Vim\GVim') do set VIM_CMD=%%b
    goto :eof


rem Parse command line arguments passed to this script.
rem
rem Arguments:
rem   arg...: All arguments this script was invoked with
:parse_arguments
    rem Parse options.
    if %1. == -t. (
        set tab=-tab
        shift
        goto :parse_arguments
    ) else if %1. == --tab. (
        set tab=-tab
        shift
        goto :parse_arguments
    ) else if %1. == -n. (
        call :show_name
        goto :eof
    ) else if %1. == --name. (
        call :show_name
        goto :eof
    ) else if %1. == -e. (
        call :enable
        goto :eof
    ) else if %1. == --enable. (
        call :enable
        goto :eof
    ) else if %1. == -d. (
        call :disable
        goto :eof
    ) else if %1. == --disable. (
        call :disable
        goto :eof
    ) else if %1. == -w. (
        call :where_am_i
        goto :eof
    ) else if %1. == --where. (
        call :where_am_i
        goto :eof
    ) else if %1. == -h. (
        call :show_help
        goto :eof
    ) else if %1. == --help. (
        call :show_help
        goto :eof
    ) else if %1. == /?. (
        call :show_help
        goto :eof
    ) else if %1. == -v. (
        call :show_version
        goto :eof
    ) else if %1. == --version. (
        call :show_version
        goto :eof
    )

    rem Handle no arguments or hyphen as an argument.
    if %1. == . (
        call :exec_vim
        goto :eof
    ) else if %1. == -. (
        rem Hyphen should not be followed by any arguments.
        if not %2. == . (
            call :err Too many edit arguments: "%2"
            exit /b 1
        )
        call :exec_vim_with_stdin
        goto :eof
    )

    rem Consume remaining arguments.
    set args=%1
    :begin_loop_args
        shift
        if %1. == . goto :end_loop_args
        set args=%args% %1
        goto :begin_loop_args
    :end_loop_args

    rem Execute GVim with the remaining arguments.
    call :exec_vim --remote%tab%-silent %args%
    goto :eof


rem Save standard input in a temporary file and edit it.
:exec_vim_with_stdin
    setlocal

    rem Create temporary directory.
    set tmp_dir=%temp%\vimer
    if not exist %tmp_dir% (
        mkdir %tmp_dir%
        if errorlevel 1 (
            call :err Cannot create temporary directory: %tmp_dir%.
            exit /b 1
        )
    )

    rem Determine a unique temporary filename.
    set filename=_STDIN_%random%_%date:/=-%_%time::=-%.tmp
    set filename=%filename: =_%
    set stdin_file="%tmp_dir%\%filename%"
    if exist "%stdin_file%" (
        endlocal
        goto :exec_vim_with_stdin
    )

    rem Create temporary file and edit it.
    findstr "^" > "%stdin_file%"
    call :exec_vim %* --remote%tab%-silent "%stdin_file%"

    endlocal
    goto :eof


rem Execute GVim with specified arguments.
rem
rem Arguments:
rem   arg...: One or more arguments to GVim
rem
rem Errors:
rem   Exit with an error message if VIM_CMD variable is not set.
:exec_vim
    if "%VIM_CMD%" == "" (
        call :err Cannot find GVim.
        exit /b 1
    )

    start "" "%VIM_CMD%" %*
    goto :eof


rem Show the known name or path of GVim executable.
:show_name
    echo %VIM_CMD%
    call :pause
    goto :eof


rem Add a new context menu option to open files with this script.
:enable
    setlocal
    if %tab%. == -tab. (set k=%TAB_SHORTCUT%) else (set k=%BUF_SHORTCUT%)
    set d=\"%VIM_CMD%\" --remote%tab%-silent \"%%1\"
    reg add "HKCR\*\shell\%k%\command" /f /ve /d "%d%"
    endlocal
    call :pause
    goto :eof


rem Remove context menu option to open files with this script.
:disable
    setlocal
    if %tab%. == -tab. (set k=%TAB_SHORTCUT%) else (set k=%BUF_SHORTCUT%)
    reg delete "HKCR\*\shell\%k%" /f
    endlocal
    call :pause
    goto :eof


rem Show the path of this script.
:where_am_i
    echo %~f0
    call :pause
    goto :eof


rem Print error message.
rem
rem Arguments:
rem   string...: String to print to standard error stream.
:err
    echo %NAME%: %* >&2
    call :pause
    goto :eof


rem Show help.
:show_help
    echo Usage: %NAME% [-t] [-e^|-d] [-n] [-w] [-h] [-v] [-^|FILE...]
    echo.
    echo This is a GVim wrapper script to open files in existing GVim.
    echo If an existing instance of GVim is running, the files are
    echo opened in it, otherwise, a new GVim instance is launched. If no
    echo arguments are specified, a new GVim instance is launched.
    echo.
    echo If this script cannot find GVim, set the VIM_CMD environment
    echo variable with the command to execute GVim as its value.
    echo.
    echo Arguments:
    echo   -               Read text from standard input.
    echo   FILE...         Read text from one or more files.
    echo.
    echo Options:
    echo   -t, --tab       Open each file in new tab.
    echo   -e, --enable    Enable context menu option to edit files.
    echo   -d, --disable   Disable context menu option to edit files.
    echo   -n, --name      Show the name/path of GVim being used.
    echo   -w, --where     Show the path where this script is present.
    echo   -h, --help, /?  Show this help and exit.
    echo   -v, --version   Show version and exit.
    echo.
    echo Report bugs to ^<https://github.com/susam/vimer/issues^>.
    call :pause
    goto :eof


rem Show version and copyright.
:show_version
    echo Vimer %VERSION%
    echo %COPYRIGHT%
    echo.
    echo This is free software. You are permitted to use, copy, modify, merge,
    echo publish, distribute, sublicense, and/or sell copies of it, under the
    echo terms of the MIT License. See ^<%LICENSE_URL%^> for the
    echo complete license.
    echo.
    echo Written by Susam Pal.
    call :pause
    goto :eof


rem Pause if this script was invoked from command prompt.
:pause
    echo %cmdcmdline% | findstr /i /c:"%~nx0" > nul && pause > nul
    goto :eof
