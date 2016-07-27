. Console.ps1
function SaveRuby([string] $rubyVersion, [string] $rubyName, [string] $rubyLocation ) {
     Try {

           [xml]$xml = Get-Content $PSScriptRoot\test.xml

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
                $xml.save($PSScriptRoot+ "\test.xml")
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
     [xml]$xml = Get-Content $PSScriptRoot\test.xml
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
     
     [xml]$xml = Get-Content $PSScriptRoot\test.xml
     $nodes = ($xml | Select-XML -XPath //Ruby[@name=`"$rubyName`"]).Node.ChildNodes
     if($nodes){
          [String]$location = $nodes[1].InnerXml 
          if($location) {
               $Env:Path = $location + ";" + $Env:Path 
               Write-Host $rubyName is now the current ruby  -foregroundcolor $successColor

               $Env:WrmRuby = $location
               $Env:WrmRubyName = $rubyName
          }
     }
     else{
          Write-Host $rubyName not found -foregroundcolor $errorColor
     }
}

function DeleteRuby([string] $rubyName) {
     [xml]$xml = Get-Content $PSScriptRoot\test.xml
          
     $hasRuby = ContainsRuby $rubyName
     if($hasRuby) {          
          Write-Host Removing $rubyName -foregroundcolor $errorColor
          $node =$xml | Select-XML -XPath //Ruby[@name=`"$rubyName`"] | foreach {
               $_.node.ParentNode.RemoveChild($_.node)
               Write-Host Removed $rubyName -foregroundcolor $successColor
          }
          $xml.save($PSScriptRoot+ "\test.xml")
     }
     else {
          Write-Host $rubyName was not found -foregroundcolor $successColor
         
     }
}

function Init() {

     Try { 
     
          if( !(Test-Path $PSScriptRoot\test.xml) ) {
               Write-Host rubies.xml was not found. Initializing.
               $xml = [xml] "<AvailableRubies></AvailableRubies>"
               $xml.save($PSScriptRoot+ "\test.xml")
          }
     }
     Catch {
          Write-Host  $_.Exception.Message -foregroundcolor $errorColor
          return
     }
}

function ContainsRuby([string] $rubyName){
     [xml]$xml = Get-Content $PSScriptRoot\test.xml     
     $num =$xml | Select-XML -XPath //Ruby[@name=`"$rubyName`"]/Name | foreach {$_.node.InnerXML}
     return $num.count
}

function GetRubyLocation($rubyName) {
     [xml]$xml = Get-Content $PSScriptRoot\test.xml
     $nodes = ($xml | Select-XML -XPath //Ruby[@name=`"$rubyName`"]).Node.ChildNodes
     if($nodes){
          [String]$location = $nodes[1].InnerXml 
          if($location) {
               return $location
          }
     }
     else{
          Write-Host $rubyName not found -foregroundcolor $errorColor
     }

}

Init