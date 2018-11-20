This repository was created to demonstrate a purposed bug in FreePascal on MacOS (Darwin).

LoadLibrary and GetProcedureAddress failed on Darwin only (working on Windows and Linux).

* [Lazarus Forum Thread](https://forum.lazarus.freepascal.org/index.php/topic,43192.0.html)
* [FreePascal Bug Tracker Issue](https://bugs.freepascal.org/view.php?id=34550)

This was an implementation / porting error. The correct return value of LoadLibrary is TLibHandle. While porting the code from Delphi on Windows, the affected code, and created test code, used THandle instead.

Changing THandle to TLibHandle results in working dynamically linked library functions.
