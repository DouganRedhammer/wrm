function CopyToRubyFolder()
{
        param (
                [string] $fromDir = $(throw "Source directory must be specified."),
                [string] $toDir = $(throw "Output directory must be specified.")
        )
        
        Copy-Item -Path $fromDir  -Destination  $toDir -Recurse
}