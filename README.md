# Shimpsy

## ![0xHexagram][hexagram]

Simple shim creator: select one directory referenced in your $ENV:PATH and create here shims (shortcuts on steroids) to your favourite programs

## FAQ

### What is shim?

Shim is a shortcut to executable file.  Actually it is a shortcut on steroids.  Basically it is `YourProgram.exe` which looks and behaves the same as your original program, but located in another place

### What is shim for?

for making your Windows configuration simpler, better and easier to replicate.  You can collect shims to your command-line and GUI programs in one location, shortening you $ENV:PATH, improving speed of search of programs and avoiding calling old/other versions of programs

### How do I use shims?

* you choose the place where your shims are going to live. Basically Shimpsy chooses it automatically if you have [Scoop](http://scoop.sh) or [Chocolatey](https://chocolatey.org) package manager installed

* you make sure that this location is in your PATH environment variable. That's why `~\scoop\shims`  and  `c:\ProgramData\chocolatey\bin` are good candidates as they are already in. `~\scoop\shims` is particularly good as creating shims there doesn't require elevating privileges and doesn't impact other users of computer.  Sometimes your intention is opposite: to have shims in read-only state for users and applicable to everyone, in this case Chocolatey dir is preferable. You can even create your own `b:\tools` directory, add it to PATH and you are done

* Check how many directories are mentioned in System and User PATHs: they tend to inflate when apps forget/neglect to remove their dirs after uninstallation or being agressively abused and filled in with lots of directories by others. Create shims by invoking `shimpsy <path to .exe>`

### Why shim is better than .lnk shortcut?

shortcut.lnk is for graphic (GUI) mode only, like creating icon on a desktop pointing to your application.  shim.exe behaves exactly as original program both in GUI and command-line

### Why shim is better than symlink or hardlink?

until recently Windows allowed to create symlinks for administrator user only.  hardlinks cannot cross the disks boundaries, i.e. you can't have c:\tools\program.hardlink.exe  pointing to d:\program.exe



[hexagram]: https://gist.githubusercontent.com/TurboBasic/9dfd228781a46c7b7076ec56bc40d5ab/raw/03942052ba28c4dc483efcd0ebf4bfc6809ed0d0/hexagram3D.png 'hexagram of Wisdom'
