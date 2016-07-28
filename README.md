# Windows Ruby Manager (wrm)

### DESCRIPTION
=======
wrm is a tool to manage multiple versions of ruby on Windows. Unlike [pik](https://github.com/vertiginous/pik/) or [uru](https://bitbucket.org/jonforums/uru), wrm sets the version of ruby per PowerShell session. A default ruby installation is not required and will be ignored while wrm is used.


```console
PS C:\>wrm help
    list                          List Installed Rubies.
    use            <ruby name>    Set the current Ruby.
    install                       Install a Ruby.
    remove         <ruby name>    Remove a Ruby.
    clean                         Delete Rubies in the download cache.
    current                       Display the working version of ruby.
    add                           Add a installed version of ruby.
```

### REQUIREMENTS
=======
  - Windows
  - PowerShell 2.0+
  - [7 zip](http://www.7-zip.org/download.html)
  - Have Administrator privileges 

### INSTALL
=======
Current Version: 0.1.1  
https://github.com/DouganRedhammer/wrm/releases/latest

If you recieve the error  
```console
PS C:\>wrm
wrm: cannot be loades because running scripts is disabled on this system. 
For more information, see about_Execution_Policies at http://go.microsoft.com/fwlink/?LinkID=135170
```
Open PowerShell as Administrator, then enter
```console
PS C:\>Set-ExecutionPolicy RemoteSigned
````
For more information about Set-ExecutionPolicy see:  
[Running Scripts Downloaded from the Internet](https://blogs.msdn.microsoft.com/powershell/2007/05/05/running-scripts-downloaded-from-the-internet/)  
[Set-ExecutionPolicy](https://technet.microsoft.com/en-us/library/hh849812.aspx)  



### License
=======
MIT License

Copyright (c) 2016 Daniel Franklin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
