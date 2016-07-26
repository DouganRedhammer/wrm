if($PSVersionTable.PSVersion.Major -eq 2){
     $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

function downloadFile($url, $targetFile)
{
    $client = New-Object System.Net.WebClient
    $Global:downloadComplete = $false
    $targetFileLocation = $PSScriptRoot+"\downloads\"+$targetFile+".7z"
    $eventDataComplete = Register-ObjectEvent $client DownloadFileCompleted `
        -SourceIdentifier WebClient.DownloadFileComplete `
        -Action {$Global:downloadComplete = $true}
    $eventDataProgress = Register-ObjectEvent $client DownloadProgressChanged `
        -SourceIdentifier WebClient.DownloadProgressChanged `
        -Action { $Global:DPCEventArgs = $EventArgs }    

 Write-Host  $url $targetFile $targetFileLocation

    Write-Progress -Activity 'Downloading file' -Status $url
    $client.DownloadFileAsync($url, $targetFileLocation)
   
    while (!($Global:downloadComplete)) {                
        $pc = $Global:DPCEventArgs.ProgressPercentage
        if ($pc -ne $null) {
            Write-Progress -Activity 'Downloading file' -Status $url -PercentComplete $pc
        }
    }
   
    Write-Progress -Activity 'Downloading file' -Status $url -Complete

 

    Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
    Unregister-Event -SourceIdentifier WebClient.DownloadFileComplete
    $client.Dispose()
    $Global:downloadComplete = $null
    $Global:DPCEventArgs = $null
    Remove-Variable client
    Remove-Variable eventDataComplete
    Remove-Variable eventDataProgress
    [GC]::Collect()    
}

#downloadFile "http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.3.0-x64-mingw32.7z" "ruby-2.3.0-x64-mingw32"