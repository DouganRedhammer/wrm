$ZipCommand = ""

if (Test-Path "C:\Program Files (x86)\7-Zip\7z.exe") {
     $ZipCommand = "C:\Program Files (x86)\7-Zip\7z.exe"
}
elseif(Test-Path "C:\Program Files\7-Zip\7z.exe"){
     $ZipCommand = "C:\Program Files\7-Zip\7z.exe"
}
else{
     throw "7z.exe is not installed."
}

if (!(Test-Path $ZipCommand)) {
        throw "7z.exe was not found at $ZipCommand."
}
set-alias zip $ZipCommand

function Unzip-File {
        param (
                [string] $ZipFile = $(throw "ZipFile must be specified."),
                [string] $OutputDir = $(throw "OutputDir must be specified.")
        )
        
        if (!(Test-Path($ZipFile))) {
                throw "Zip filename does not exist: $ZipFile"
                return
        }
        
        zip x -y "-o$OutputDir" $ZipFile
        
        if (!$?) {
                throw "7-zip returned an error unzipping the file."
        }
}