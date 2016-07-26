. Console.ps1

if($PSVersionTable.PSVersion.Major -eq 2){
     $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

function SaveRuby([string] $rubyVersion, [string] $rubyName, [string] $rubyLocation ) {
     Try {

           [xml]$xml = Get-Content $PSScriptRoot\config.xml

           $childNode = $xml.CreateElement('Ruby')
           $childNode.SetAttribute("name", $rubyName)
           $xml.DocumentElement.AppendChild($childNode )

           $version = $xml.CreateElement('Version')
           $location = $xml.CreateElement('Location')
           $name = $xml.CreateElement('Name')

           $version.set_InnerText($rubyVersion)
           $location.set_InnerText($rubyLocation)
           $name.set_InnerText($rubyName)

           $childNode.AppendChild($version)
           $childNode.AppendChild($location)
           $childNode.AppendChild($name)

           $hasRuby = ContainsRuby $rubyName
           if($hasRuby) {
                Write-Host $rubyName is already installed -foregroundcolor $errorColor
           }
           else {
                $xml.save($PSScriptRoot+ "\config.xml")
                Write-Host saved $rubyName -foregroundcolor $successColor
           }     
      }
      Catch {
          Write-Host  $_.Exception.Message -foregroundcolor $errorColor
          return
      }
}

function ReadRubies() {
     $currentRuby = $Env:WrmRubyName
     [xml]$xml = Get-Content $PSScriptRoot\config.xml
     $xml | Select-XML -XPath '//Ruby[@name]/Name' | foreach {
          if($currentRuby -and $currentRuby.Contains($_.node.InnerXML)){
               Write-Host "*" $_.node.InnerXML -foregroundcolor $successColor
          }
          else {
               Write-Host ($_.node.InnerXML) -foregroundcolor $successColor
          }
     }

}

function SetCurrentRuby($rubyName) {
     if(!$rubyName) {
          Write-Host You must specify a ruby name  -foregroundcolor $errorColor
          return
     }
     
     $prevRubyLocation = $Env:WrmRuby
     $prevRubyName = $Env:WrmRubyName
               
     [xml]$xml = Get-Content $PSScriptRoot\config.xml
     $nodes = $xml.SelectNodes("//Ruby[@name=`"$rubyName`"]")
     if($nodes){
     	foreach ($node in $nodes) {
        	[String]$location = $node.Location 
          	
          	if($location) {
               
               if($prevRubyLocation){
               	  $Env:Path = $Env:Path.Replace($prevRubyLocation+";", "")
               }
          
               $Env:Path = $location + ";" + $Env:Path 
               Write-Host $rubyName is now the current ruby  -foregroundcolor $successColor

               $Env:WrmRuby = $location
               $Env:WrmRubyName = $rubyName
          }
     	}
     }
     else{
          Write-Host $rubyName not found -foregroundcolor $errorColor
     }
}

function DeleteRuby([string] $rubyName) {
     [xml]$xml = Get-Content $PSScriptRoot\config.xml
     $hasRuby = ContainsRuby $rubyName
     if($hasRuby) {          
          Write-Host Removing $rubyName from config
		  $nodes = $xml.SelectNodes("//Ruby[@name=`"$rubyName`"]")
		  foreach ($node in $nodes) {

		  	   $node.ParentNode.RemoveChild($node)
		  	   Write-Host Removed $rubyName from config. -foregroundcolor $successColor
		  }

          $xml.save($PSScriptRoot+ "\config.xml")

     }
     else {
          Write-Host $rubyName was not found foo -foregroundcolor $errorColor
         
     }
}

function Init() {

     Try { 
     
          if( !(Test-Path $PSScriptRoot\config.xml) ) {
               Write-Host config.xml was not found. Initializing a new config file. -foregroundcolor $errorColor
               $xml = [xml] "<AvailableRubies></AvailableRubies>"
               $xml.save($PSScriptRoot+ "\config.xml")
          }
     }
     Catch {
          Write-Host  $_.Exception.Message -foregroundcolor $errorColor
          return
     }
}

function ContainsRuby([string] $rubyName){
     [xml]$xml = Get-Content $PSScriptRoot\config.xml   
     $num = $nodes = $xml.SelectNodes("//Ruby[@name=`"$rubyName`"]")  
     return $num.count
}

function GetRubyLocation($rubyName) {
     [xml]$xml = Get-Content $PSScriptRoot\config.xml
     $nodes = $xml.SelectNodes("//Ruby[@name=`"$rubyName`"]")
     if($nodes){
     	foreach ($node in $nodes) {
        	[String]$location = $node.Location 
        	
          	if($location) {
               return $location
          	}
          }
     }
}

Init