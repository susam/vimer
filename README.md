Vimer is an executable single-file script to open files in an existing instance of GVim or MacVim.

# Necessity

This project addresses the need for efficient file management when using GVim or MacVim across different operating systems.
It simplifies opening files from the shell without cluttering the desktop with multiple windows or dealing with swap file warnings.
Vimer enables editing in a single GVim or MacVim instance, handling files already in use seamlessly.

Opening files with `gvim` or `mvim` from the shell can lead to a cluttered desktop with multiple windows and swap file warnings when files are already open.
While internal editor commands can prevent this, shell-based file editing remains essential during directory navigation.

Alternative solutions, such as wrapper scripts (`myvim.cmd` on Windows or `alias myvim='gvim --remote-silent'` on Linux and Mac), partially address these issues but introduce new problems like errors when run without arguments or incorrect handling of piped commands.
However, this approach has shortcomings.
For instance, executing `myvim` without arguments triggers an error, and piping output into GVim or MacVim with `ls | myvim -` mistakenly opens an empty buffer named `-`.
Vimer introduces a refined wrapper script that adeptly manages these exceptions.

# Getting Started

Download `vimer.cmd` for Windows / `vimer` for Linux and Mac.
Place it in a directory in `%PATH%/$PATH`. 
(On Linux and Mac, grant execution rights with `chmod u+x vimer`.)
Then, for example:

1. Launch a new instance of GVim or MacVim with `vimer`.
2. Open files in the same instance with `vimer foo.txt bar.txt baz.txt`.
3. Use `-t` to open files in separate tabs with `vimer -t foo.txt bar.txt baz.txt`.
4. Pipe command output into GVim or MacVim with `ls -l | vimer -` or in a new tab with `ls -l | vimer -t -`.
5. Start GVim or MacVim with a specific server name using `vimer -s FOO`.
6. Edit with a named server using `vimer -s FOO foo.txt bar.txt baz.txt`.

For detailed usage, run `vimer --help`.

Users accustomed to `vi`, `vim`, `gvim`, or `mvim` may rename the script for convenience, such as changing `vimer.cmd` to `vi.cmd` on Windows or `vi` on Linux or Mac.

# File Manager Default Editor

If you use a file manager such as [Total Commander](https://www.ghisler.com/) (on Microsoft Windows or [Linux/Mac OS](https://www.ghisler.ch/wiki/index.php/Total_Commander_under_Wine)), [Double Commander](https://github.com/doublecmd/doublecmd) or [Krusader](https://krusader.org), then this is a great choice as a single instance editor (for a single instance file manager) by choosing it as preferred editor.

- In Total Commander this is achieved by

    1. copying the `vimer` folder into `%COMMANDER_PATH%\addons\vimer`
    1. choosing `COMMANDER_PATH%\addons\vimer\vimer.cmd` in the Options Dialogue, or adding in the section `[Configuration]` in the file `%COMMANDER_PATH%\wincmd.ini` the line `Editor=%COMMANDER_PATH%\addons\vimer\vimer.cmd`.

- In Krusader in Options/Configure Krusader/Tools/Editor and setting the path `vimer --tab`
- In Double Commander in Configuration/Options/General/Editor, enable `external program` and choose as path `vimer --tab` (in case the `vimer` script resides in a directory in `$PATH`, otherwise its full path).

# System Default Editor

- To use `vimer` as a default editor on Microsoft Windows, run [NotepadReplacer](https://www.binaryfortress.com/NotepadReplacer/) once and for all.
    Use [Text Editor Anywhere](https://www.listary.com/text-editor-anywhere) to paste the currently edited text (say in a entry box of the Browser) into it.

- On Linux, add an entry `~/.config/applications/mimeapps.list`

    ```ini
    [Default Applications]
    text/plain=vimer.desktop
    ```

    where `~/.config/applications/vimer.desktop` reads

    ```ini
    [Desktop Entry]
    Type=Application
    Name=Vimer
    Exec=$HOME/bin/vimer %u
    ```

    with `$HOME/bin` being replaced by the path of the `vimer` script.

# Related

These scripts differ from [Susam's original vimer scripts](https://github.com/susam/vimer/pull/5) in 

- launching an instance of Vim if none found on Microsoft Windows and Linux/ Mac OS,
- finding Vim by falling back an executable in `$PATH` or the one set by `$EDITOR` on Microsoft Windows and Linux/ Mac OS,
- no longer offering the creation of context menu entries on an administered Microsoft Windows machine
