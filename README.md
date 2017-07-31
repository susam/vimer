Vimer
=====
Vimer is a convenience wrapper script to open files in an existing
instance of GVim or MacVim.

[![Download][SHIELD_WIN]][DOWNLOAD_WIN]
[![Download][SHIELD_LIN]][DOWNLOAD_LIN]
[![Build Status][BUILD_IMG]][BUILD_URL]
[![Coverage Status][COVERAGE_IMG]][COVERAGE_URL]

The Windows script has been tested on Windows 7 only. However, it should
work fine on other recent versions of Windows too.

The Linux/Mac script has been tested with [bash][], [ksh][] and
[zsh][] on Debian and Mac as well as with [dash][], [posh][] and
[yash][yash] on Debian. It should work fine on any POSIX compliant
system with a POSIX compliant shell.

[SHIELD_WIN]: https://img.shields.io/badge/download-vimer%2ecmd%20for%20Windows-brightgreen.svg
[SHIELD_LIN]: https://img.shields.io/badge/download-vimer%20for%20Linux%2fOS%20X-brightgreen.svg
[DOWNLOAD_WIN]: https://github.com/susam/vimer/releases/download/0.2.0/vimer.cmd
[DOWNLOAD_LIN]: https://github.com/susam/vimer/releases/download/0.2.0/vimer

[BUILD_IMG]: https://travis-ci.org/susam/vimer.svg?branch=master
[BUILD_URL]: https://travis-ci.org/susam/vimer
[COVERAGE_IMG]: https://coveralls.io/repos/github/susam/vimer/badge.svg?branch=master
[COVERAGE_URL]: https://coveralls.io/github/susam/vimer?branch=master

[bash]: https://packages.debian.org/stable/bash
[ksh]: https://packages.debian.org/stable/ksh
[zsh]: https://packages.debian.org/stable/zsh
[dash]: https://packages.debian.org/stable/dash
[posh]: https://packages.debian.org/stable/posh
[yash]: https://packages.debian.org/stable/yash


Contents
--------
* [Necessity](#necessity)
* [Getting Started](#getting-started)
* [Troubleshooting](#troubleshooting)
* [Context Menu](#context-menu)
  * [Windows](#windows)
  * [Xfce on Linux](#xfce-on-linux)
  * [GNOME on Linux](#gnome-on-linux)
  * [Mac](#mac)
* [License](#license)
* [Support](#support)


Necessity
---------
This project was written to address the following needs.

 1. Running `gvim foo.txt` on Windows or Linux, or `mvim foo.txt` on
    Mac, opens the file in a new GVim or MacVim window. Launching
    GVim or MacVim from the shell in this manner again and again can
    easily clutter the desktop with too many windows. Moreover, if the
    file being opened is already open in another instance of GVim or
    MacVim, the editor warns about an existing swap file and requires
    the user to take action for it. This can be distracting sometimes.

    Of course, one can open and edit all files from within a single
    GVim or MacVim instance with the editor commands such as `:e` or
    `:tabe` to avoid these problems, but it is still useful to be able
    to edit files from the shell, especially while navigating
    directories in the shell.

    Vimer offers a way to edit files from the shell such that every
    file being edited opens in a new buffer in the same instance of
    GVim or MacVim. If a file being opened is already open in GVim or
    MacVim, no warning occurs; instead the editor silently displays the
    specified file.

 2. The problems discussed in the previous point can also be solved
    using a simple wrapper script on Windows, say, myvim.cmd.

        @echo off
        gvim --remote-silent %*

    Or using alias on Linux.

        alias myvim="gvim --remote-silent"

    Here is a similar alias for Mac.

        alias myvim="mvim --remote-silent"

    But this solution is not without flaws. Of course, it takes care
    that a command like `myvim foo.txt bar.txt` opens both files in two
    buffers in the same instance of GVim or MacVim. However the
    following annoying behaviour occurs.

      - Running `myvim` without arguments leads to an error:
        `Argument missing after: "--remote-silent"`.
      - Trying to pipe standard output of one command into the standard
        input of GVim or MacVim with a command like `ls | myvim -`
        results in an empty buffer for a file named `-`. The reason for
        this is documented in the editor's documentation.
        Enter `:help remote` in the editor to read it.

    Vimer offers a litle more elaborate wrapper script that handles
    these special cases better.

      - `vimer foo.txt bar.txt` opens both files in the same instance of
         GVim or MacVim.
      - `vimer` launches a new instance of GVim or MacVim.
      - `ls | vimer -` shows the output of `ls` in an existing instance of
        GVim or MacVim if it exists.

 3. Vim provides a context menu option called *Edit with Vim* that
    opens a file in a new buffer in an *existing* tab page in an
    existing instance of GVim. However, it doesn't provide a context
    menu option that opens a file in a *new* tab page in an existing
    instance of GVim. Vimer fills this gap by creating a context menu
    option for files called *Edit with GVim tab* that opens a file in a
    new tab page in an existing instance of GVim. This feature is
    available only for Windows.


Getting Started
---------------
Vimer is a single-file executable script.

Download [`vimer.cmd`][DOWNLOAD_WIN] for Windows,
or [`vimer`][DOWNLOAD_LIN] for Linux or Mac.

Copy it to a directory specified in the PATH environment variable. On
Linux or Mac, make the script executable: `chmod u+x vimer`.

The following list describes some of the ways Vimer may be used.

 1. Launch a new instance of GVim or MacVim.

        vimer

 2. Edit files.

        vimer foo.txt bar.txt baz.txt

    If an instance of GVim or MacVim is already running, this command
    opens the files in separate buffers in the same instance of the
    editor. Otherwise, they are opened in separate buffers in a new
    instance of the editor.

 3. If the `-t` option is specified, then files are opened in separate
    tab pages in an existing instance of GVim or MacVim if it exists.
    If no instance of GVim or MacVim already exists, the files are
    opened in separate tabs in a new instance of the editor.

        vimer -t foo.txt bar.txt baz.txt

 4. Pipe the standard output of a command into the standard input of
    GVim or MacVim. Use the `-t` option to open it in a separate tab.

        ls -l | vimer -
        ls -l | vimer -t -

 5. Launch a new instance of GVim or MacVim with a specific server name.

        vimer -s FOO

    If the specified server name is already being used by another
    instance of the editor, a number postfix is applied (e.g. FOO1,
    FOO2, etc.) until a free name is encountered.

 6. Edit files in GVim or MacVim with a specific server name.

        vimer -s FOO foo.txt bar.txt baz.txt

    If an instance of GVim or MacVim with the specified server name is
    already running, this command opens the files in that instance of
    the editor. If such an instance of the editor does not exist, then
    the first server with the number postfix will be used.

    If there is no existing instance of the editor with a matching
    server name or a server name with number postfix, the files are
    opened in separate buffers in a new instance of the editor with the
    specified server name, or a server name with number postfix.

 7. Enable a context menu option called *Edit with GVim* for files on
    Windows.

        vimer --enable

    After executing the above command, on right clicking a file, an
    option called *Edit with GVim* should appear in the context menu.
    Selecting this option opens the file in an existing instance of GVim
    if it exists. If no existing instance of GVim already exists, then
    the file is opened in a new instance of GVim.

    A similar context menu option called *Edit with existing Vim* is
    already provided by the GVim installer for Windows. But this option
    is provided in Vimer anyway because combining this option with `-t`
    creates a context menu option to open files in separate tab pages,
    as explained in the next point. Such a context menu option is not
    provided by the GVim installer for Windows.

 8. Enable a context menu option called *Edit with GVim tab* for files
    on Windows.

        vimer -t --enable

 9. Disable context menu options on Windows.

        vimer --disable
        vimer -t --disable

    The `--enable` and `--disable` options are not supported for Linux
    and Mac. See the [Context Menu](#context-menu) section below to
    read how to create such context menu option in other desktop
    environments.

10. For more details on how to use Vimer, execute the following command.

        vimer --help

Users who are very used to typing `vi`, `vim`, `gvim` or `mvim` to run
the editor and find it difficult to type `vimer` might want to rename this
script. For example, a user very used to typing `vi`, might want to
rename this script from `vimer.cmd` to `vi.cmd` on Windows, or to `vi`
on Linux or Mac.


Troubleshooting
---------------
 1. When the script is executed from a 32 bit [Console2][C2] window running on a
    64 bit Windows operating system, the script fails with the following
    error.

        ERROR: The system was unable to find the specified registry key or value.

    To work around the issue, execute the script in the native Windows
    Command Prompt, or install the 64 bit Console2 application and
    execute the script from a 64 bit Console2 window.

 2. After the script is renamed to `gvim` on Linux or `mvim` on Mac,
    running `gvim` or `mvim` with a filename as argument may still open
    the file in a new instance of the editor, not in an existing instance
    of the editor, even if such an instance already exists.

    If this happens, it is very likely that the `gvim` or `mvim` command
    is still running GVim or MacVim, respectively, not Vimer.

    To confirm, execute the following command on Linux.

        gvim --version

     Or the following command on Mac.

        mvim --version

    If the string "VIM" appears in the first line of the output, it is
    GVim or MacVim.

    If it is confirmed that running `gvim` on Linux, or `mvim` on Mac
    executes GVim or MacVim, respectively, ensure that the path where
    this script is located appears before the path where GVim or MacVim
    is located in the PATH environment variable.

    Further, on Linux or Mac, set the `VIM_CMD` environment variable
    to the absolute path of GVim or MacVim. For more details about this,
    see the next point.

 3. When the script is renamed to `gvim` on Linux or `mvim` on Mac,
    and `gvim` or `mvim` is run, the shell may hang. If the `VIM_CMD`
    environment variable is not set, internally, the script invokes the
    `gvim` command on Linux or the `mvim` command on Mac to edit
    files. But when this script itself is named as `gvim` on Linux or
    `mvim` on Mac, invoking `gvim` or `mvim`, respectively, ends up
    invoking itself thereby resulting in an infinite recursion.

    To resolve the issue, set the `VIM_CMD` environment variable to the
    absolute path of GVim. Here is an example for Linux.

        export VIM_CMD=/usr/bin/gvim

    Here is an example for Mac.

        export VIM_CMD=/usr/local/bin/mvim

    Consider adding this to the shell's initialization file (e.g.
    ~/.bashrc) so that this environment variable is persistent and
    available across shell sessions.

    As a workaround, consider renaming the script to something other than
    `gvim` or `mvim`, perhaps `vi` which is short and sweet and has the
    additional advantage that no matter what system it is, one only has
    to remember to type `vi` to edit files.

[C2]: http://sourceforge.net/projects/console/


Context Menu
------------
This section descibes how to add context menu option for files that
opens files in an existing instance of GVim or MacVim in various desktop
environments. This section does not require the use of Vimer.

The steps provided in the sections below create a context menu option to
edit files in new buffers. To edit files in new tabs instead, use the
`--remote-tab-silent` option instead of the `--remote-silent` option in
the sections below.

### Windows ###
The following steps have been found to work fine on Windows XP and
Windows 7. These steps probably work fine on other versions of Windows
too.

 1. Run the following command.

        regedit

 2. Go to `HKEY_CLASSES_ROOT\*\shell`. Right click on the node named
    `shell`, select *New* > *Key*. Name the new key as `Edit with GVim`.

 3. Then right click on the new node, select *New* > *Key* and name the
    new node as `command`.

 4. Now `HKEY_CLASSES_ROOT\*\shell\Edit with GVim\command`
    should be the current node. On the right-hand pane, double click on
    *(Default)* and enter the command to edit a file in existing GVim.
    Here is an example.

        "C:\Program Files (x86)\Vim\vim74\gvim.exe" --remote-silent "%1"

 4. Click *OK*.

To remove this context menu option, run `regedit`, go to
`HKEY_CLASSES_ROOT\*\shell`, right click on the node for this context
menu, select *Delete* and click *Yes*.

Alternatively, run `vimer --enable` to automatically find the path to
`gvim.exe` and create the registry value described above. To remove this
registry value, run `vimer --disable`. To enable or disable similar
registry value that creates a context menu option to edit files with
existing GVim in a new tab page, run `vimer --tab --enable` or
`vim --tab -disable`, respectively.

### Xfce on Linux ###
The following steps have been found to work fine on Xfce 4.10 on Debian
8.0. These steps probably work fine on Xfce 4 on any Linux distribution.

 1. Run *Thunar*, i.e. *Applications Menu* > *File Manager*.

 2. From the menu, go to *Edit* > *Configure custom actions*.

 2. Click the plus icon to add a new custom action..

 3. Enter the following details.
      - Name: `Edit with GVim`
      - Command: `gvim --remote-silent %F`
      - Icon: vim 

 4. Go to *Apperance Conditions* tab and select *Directories*,
    *Text Files* and *Other Files*.

 5. Click *OK*. Click *Close*.

To remove this context menu option, follow step 1 again, select the
context menu option, click the bin icon to delete the currently selected
action and click *Delete*.

### GNOME on Linux ###
The following steps have been found to work fine on GNOME 2.28.2 on
CentOS 6.5 and GNOME 3.4.1 on Debian 8.2 (Jessie). These steps probably
work fine on GNOME 2 and GNOME 3 on any Linux distribution. The steps
below need to be performed in a shell.

 1. On GNOME 2, go to the ~/.gnome2/nautilus-scripts/ directory.

        cd ~/.gnome2/nautilus-scripts/

    On GNOME 3, go to ~/.local/share/nautilus/scripts/ instead.

        cd ~/.local/share/nautilus/scripts/

 2. Now create an executable script that contains the shell command to
    edit files in an existing instance of GVim if it exists.

        echo 'gvim --remote-silent "$@"' > "Edit with GVim"
        chmod u+x "Edit with GVim"

After following these steps, open Nautilus (File Browser on GNOME 2, or
Files on GNOME 3), right click on a file, select Scripts > Edit with GVim.

To remove this context menu option, delete the script for the context
menu option from ~/.gnome2/nautilus-scripts (GNOME 2) or
~/.local/share/nautilus/scripts (GNOME 3).

### Mac ###
The following steps have been found to work fine on Mac 10.9.5
(Mavericks).

 1. Go to *Launchpad*, search for *Automator*, then click on it to
    launch it. It should display a dialog box to choose a type for the
    new document. If this is not displayed, click *New Document* to
    display it.

 2. Select *Service* and click *Choose*.

 3. In the *Service receives selected* drop-down list,
    select *files or folders*.

 4. Under *Library*, select *Utilities* and double click
    *Run Shell Script*.

 5. In the new pane that appears, go to the *Pass Input* drop-down list
    and select *as arguments*.

 6. Erase all the code in the text box and enter the shell command to
    edit files in an existing instance of MacVim if it exists. Note
    that the absolute path to MacVim should be used in the command.

        /usr/local/bin/mvim --remote-silent "$@"

 7. From the menu, select *File* > *Save*. Enter `Edit with MacVim`
    as the service name and click *Save*.

 8. From the menu, select *Automator* > *Quit Automator*.

To remove this context menu option, launch Finder, select
*Go* > *Go to Folder*, enter `~/Library/Services`, right click on the
workflow for this context menu option and select *Move to Trash*.


License
-------
This is free and open source software. You can use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of it,
under the terms of the MIT License. See [LICENSE.md][L] for details.

This software is provided "AS IS", WITHOUT WARRANTY OF ANY KIND,
express or implied. See [LICENSE.md][L] for details.

[L]: LICENSE.md


Support
-------
To report bugs, suggest improvements, or ask questions, please create a
new issue at <http://github.com/susam/vimer/issues>.
