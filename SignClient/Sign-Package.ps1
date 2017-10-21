$currentDirectory = split-path $MyInvocation.MyCommand.Definition

# See if we have the ClientSecret available
if([string]::IsNullOrEmpty($env:SignClientSecret)){
	Write-Host "Client Secret not found, not signing packages"
	return;
}

# Setup Variables we need to pass into the sign client tool

$appSettings = "$currentDirectory\appsettings.json"

$appPath = "$currentDirectory\..\packages\SignClient\tools\netcoreapp2.0\SignClient.dll"

$nupgks = ls $currentDirectory\..\*.nupkg | Select -ExpandProperty FullName
$vsixs = ls $currentDirectory\..\*.vsix | Select -ExpandProperty FullName

foreach ($file in $nupgks){
	Write-Host "Submitting $fileg for signing"

	dotnet $appPath 'sign' -c $appSettings -i $file -r $env:SignClientUser -s $env:SignClientSecret -n 'AspNetCoreCloudService' -d 'AspNetCoreCloudService' -u 'https://github.com/onovotny/AspNetCoreCloudService' 

	Write-Host "Finished signing $file"
}

foreach ($file in $vsixs){
	Write-Host "Submitting $nupkg for signing"

	dotnet $appPath 'sign' -c $appSettings -i $file -r $env:SignClientUser -s $env:SignClientSecret -n 'AspNetCoreCloudService' -d 'AspNetCoreCloudService' -u 'https://github.com/onovotny/AspNetCoreCloudService' 

	Write-Host "Finished signing $file"
}

Write-Host "Sign-package complete"