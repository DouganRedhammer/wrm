. ConfigUtil.ps1
. unzip.ps1
. copy.ps1
. FileUtil.ps1
. Console.ps1
if($PSVersionTable.PSVersion.Major -eq 2){
     $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}
function list(){
     ReadRubies
}

function use($whichRuby){
     SetCurrentRuby $whichRuby
}

function current(){
     Write-Host $Env:WrmRubyName -foregroundcolor $successColor

#    $x = $Env:Path
#     $x.Split("{;}") | ForEach {
#          if($_.Contains('\NodeRubyManager\rubies')){
#               Write-Host $_ is the current ruby -foregroundcolor $successColor
#               break
#          }
#     }
}

function install(){

    # $PSScriptRoot = $MyInvocation.MyCommand.Path
     $rubyList = New-Object System.Collections.ArrayList
     $array = @()

     if($PSVersionTable.PSVersion.Major -gt 2){
     $site = Invoke-WebRequest -UseBasicParsing -Uri http://rubyinstaller.org/downloads/archives
     $site.Links | foreach {

          if ($_.href.ToLower().Contains("mingw32.7z")) {
               $object = New-Object -TypeName PSObject
               $object | Add-Member -Name 'RubyVersion' -MemberType Noteproperty -Value $_.href.Replace("http://dl.bintray.com/oneclick/rubyinstaller/", "").Replace("-mingw32.7z", "") 
               $object | Add-Member -Name 'Link' -MemberType Noteproperty -Value $_.href
               $array += $object
          }
     }
     }
     else{
     
          $pattern = '(http://dl.bintray.com/oneclick/rubyinstaller/[^"]*mingw32.7z)' 
          $x = (New-Object System.Net.WebClient).DownloadString("http://rubyinstaller.org/downloads/archives")
          $x | Select-String -AllMatches $pattern | 
                          Foreach {$_.Matches }  | Foreach {
                          
                  $object = New-Object -TypeName PSObject
               $object | Add-Member -Name 'Link' -MemberType Noteproperty -Value $_.Value
               $object | Add-Member -Name 'RubyVersion' -MemberType Noteproperty -Value $_.Value.Replace("http://dl.bintray.com/oneclick/rubyinstaller/", "").Replace("-mingw32.7z", "") 
               $array += $object
                          }
     }
     $rubyOption = 0
     $array |
          ForEach-Object {New-Object psObject -Property @{'Option'=$rubyOption;'RubyVersion'= $_.RubyVersion;};$rubyOption ++;  } |
          Format-Table  -Auto

     $dlRuby = Read-Host "Install which version?"
     $rubyVersion  = $array[$dlRuby].RubyVersion
     if(($rubyName = Read-Host "Name this version? `n Press enter to accept default value [$rubyVersion]") -eq ''){ $rubyName = $rubyVersion}else{$rubyName}
     Write-Host $rubyName
     . getRuby.ps1; downloadFile -url $array[$dlRuby].Link -targetFile $rubyVersion
     $fileName = $rubyVersion + ".7z"
      Unzip-File $PSScriptRoot\downloads\$fileName $PSScriptRoot\downloads\
     Write-Host Installing...
     $inputDir = $PSScriptRoot + "\downloads\" + $rubyVersion + "-mingw32"
     $outputDir = $PSScriptRoot + "\rubies\" + $rubyName
     CopyToRubyFolder $inputDir $outputDir
      
     $rubyLocation = $outputDir + "\bin"
     SaveRuby $rubyVersion $rubyName $rubyLocation > $null
     
     
}

function remove($whichRuby){
     $rubyLocation = GetRubyLocation $whichRuby
     if(-not $rubyLocation) {
          Write-Host $whichRuby was not found.
          return
     }
     
     #$deleteRubyDir = Read-Host "Delete [$whichRuby]? Yn `nPress enter to accept default value Y"
    

    # if($deleteRubyDir.ToUpper() -eq 'Y' -or  ){
     if(($deleteRubyDir = Read-Host "Delete [$whichRuby]? Yn `nPress enter to accept default value Y") -eq '' -or $deleteRubyDir.ToUpper() -eq 'Y'){
          DeleteRubyDirectory $rubyLocation.Replace("bin","")  
          Write-Host  $rubyLocation has been removed. -foregroundcolor $successColor
          DeleteRuby $whichRuby
     }
     
}

function clean() {
     CleanDownloadDirectory
}

function add(){
     $rubyLocation = Read-Host "Ruby location?"
     $hasRuby = Get-ChildItem -Path $rubyLocation -Filter ruby.exe
     if($hasRuby -ne '' ) {
          $rubyName = Read-Host "Ruby name?"
     $rubyVersion = (Get-Item $rubyLocation\ruby.exe).VersionInfo.FileVersion
     SaveRuby $rubyVersion $rubyName $rubyLocation > $null
     }
     else{
          Write-Host $rubyLocation does not contain bin\ruby.exe
          exit
     }

}

function help() {
Write-Host "The following commands are available:
Function       Parameter      Description
-----------------------------------------
list                          List Installed Rubies.
use            <ruby name>    Set the current Ruby.
install                       Install a Ruby.
remove         <ruby name>    Remove a Ruby.
clean                         Delete Rubies in the download cache.
current                       Display the working version of ruby.
add                           Add a installed version of ruby.
"
}



switch ($args[0]) 
    { 
          'list' {list}
          'use' {use $args[1]}
          'install' {install}
          'remove' {remove $args[1]}
          'clean' {clean}
          'help' {help}
          'current' {current}
          'add' {add}
    }