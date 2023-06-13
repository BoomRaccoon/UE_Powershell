# region 

if($args.Count -eq 0)
{
	$Path_targetDir = Read-Host -Prompt "Give the directory the folders should be created in"
	$Name_Pack = Read-Host -Prompt "Give the name the pack should be named"
}
elseif ($args.Count -eq 1)
{
	if(Test-Path $args[0])
		{ $Path_targetDir = $args[0]+ "\" }
	else
	{
		$Path_targetDir = Read-Host -Prompt "The given path was incorrect please give a valid path"
		$Name_Pack = Read-Host -Prompt "Give the name the pack should be named"
	}
	$Name_Pack = Read-Host -Prompt "Give the pack a name"
}
elseif ($args.Count -eq 2) {
	if(Test-Path $args[0])
	{

	}
}

Write-Host "Do you want to add a description? (y/n)"
$selection = $Host.UI.RawUI.ReadKey()
if($selection.Character -eq "y")
{
	$Description = Read-Host -Prompt "Please type in the description you want to use for the pack. (Can be changed afterwards inside manifest.json)"
}

Write-Host "Do you want to add search tags? (y/n)"
$selection = $Host.UI.RawUI.ReadKey()
if($selection.Character -eq "y")
{
	$Tags = Read-Host -Prompt "Type the search tags seperated with a comma like 'desert,landscape,net'. (Can be changed afterwards inside manifest.json)"
}

$Path_Full = $Path_targetDir + $Name_Pack

# endregion


# region StringsForFiles
$ManifestContent = 
@"
{
	"Version": 1,
	"Name":
	[
		{
			"Language": "en",
			"Text": "$Name_Pack"
		}
	],
	"Description":
	[
		{
			"Language": "en",
			"Text": "$(If ($Description) {$Description} Else {"You can change this description before packing in the manifest.json"})"

		}
	],
	"AssetTypes": [],
	"SearchTags":
	[
		{
			"Language": "en",
			"Text": "$(If ($Tags) {$Tags} Else {})"
		}
	],
	"ClassTypes": "",
	"Category": "Content",
	"Thumbnail": "$($Name_Pack).png",
	"Screenshots":
	[
		"$($Name_Pack)_Preview.png"
	]
}
"@

$ConfigContent =
@"
[AdditionalFilesToAdd]
+Files=Samples/$($Name_Pack)/Content/*.*
"@

$ContentToPack =
@"
"$Path_Full\ContentSettings\Config\"
"$Path_Full\ContentSettings\Media\"
"$Path_Full\ContentSettings\manifest.json"
"@

# endregion






# region CreateDirectoriesAndFiles
New-Item -ItemType Directory -Path $Path_Full
New-Item -ItemType Directory -Path ($Path_Full + "\ContentSettings")
New-Item -ItemType Directory -Path ($Path_Full + "\ContentSettings\Config")
New-Item -ItemType Directory -Path ($Path_Full + "\ContentSettings\Media")
New-Item -Path ($Path_Full + "\ContentSettings\Media\$($Name_Pack).png")
New-Item -Path ($Path_Full + "\ContentSettings\Media\$($Name_Pack)_Preview.png")
New-Item -Path ($Path_Full + "\ContentSettings\manifest.json")
Set-Content ($Path_Full + "\ContentSettings\manifest.json")  $ManifestContent
New-Item -Path ($Path_Full + "\ContentSettings\Config\config.ini")
Set-Content ($Path_Full + "\ContentSettings\Config\config.ini") $ConfigContent

New-Item -ItemType Directory -Path ($Path_Full + "\Samples")
New-Item -ItemType Directory -Path ($Path_Full + "\Samples\$($Name_Pack)\Content")
New-Item -ItemType Directory -Path ($Path_Full + "\FeaturePacks")
New-Item -Path ($Path_Full + "\ContentToPack.txt")
Set-Content ($Path_Full + "\ContentToPack.txt") $ContentToPack
# endregion

Write-Host "Now just add the actual content inside of Samples/Content/"