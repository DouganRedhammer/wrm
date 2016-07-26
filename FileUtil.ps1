. Console.ps1
$ZipCommand = ""
if($PSVersionTable.PSVersion.Major -eq 2){
     $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}
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

function CopyToRubyFolder()
{
        param (
                [string] $fromDir = $(throw "Source directory must be specified."),
                [string] $toDir = $(throw "Output directory must be specified.")
        )
        
        Copy-Item -Path $fromDir  -Destination  $toDir -Recurse
}


function Unzip-File {
        param (
                [string] $ZipFile = $(throw "ZipFile must be specified."),
                [string] $OutputDir = $(throw "OutputDir must be specified.")
        )
        
        if (!(Test-Path($ZipFile))) {
                throw "Zip filename does not exist: $ZipFile"
                return
        }
        if (!(Test-Path($OutputDir))) {
                throw "OutputDir does not exist: $OutputDir"
                return
        }

        
        zip x  $ZipFile -y "-o$OutputDir"
        
        if (!$?) {
                throw "7-zip returned an error unzipping the file."
        }
        
        
}

function DeleteRubyDirectory($rubyLocation) {

     Try {
         # get-childitem $rubyLocation -recurse  | remove-item -Recurse
          
          # cause occasional exception
          Remove-Item  $rubyLocation -Recurse -Force 
          Write-Host $rubyLocation has been deleted.
     }
     Catch {
          Write-Host  $_.Exception.Message -foregroundcolor $errorColor
          return
     }
}

function CleanDownloadDirectory() {

     Try {
          #get-childitem $PSScriptRoot\downloads\* -recurse  | remove-item -Recurse
          Remove-Item -Recurse -force $PSScriptRoot\downloads\*
          Write-Host Downloads has been cleaned. -foregroundcolor $successColor
     }
     Catch {
          Write-Host  $_.Exception.Message -foregroundcolor $errorColor
          return
     }
}
