$args[0] = $args[0] -replace ("^'")  -replace ("'$")

if($args.Count -eq 1)
{
	$Name_Module = Read-Host -Prompt "Name for the Module: "
}
else { Write-Host "please call this from the 'Source' directory" }

# $File_Target = Get-Childitem -File -Recurse -ErrorAction Stop -Path $args[0] -Include *.Target.cs*
# if(!$File_Target)
# 	{write-host "EXIT`nBecause: there was no target file"; EXIT}

$Path_NewModule = Join-Path -Path $args[0] -ChildPath $Name_Module
$File_NewBuildCS = $Name_Module + ".Build.cs"
$File_NewBuildCS = Join-Path -Path $Path_NewModule -ChildPath $File_NewBuildCS


# region BuildCS string
$Content_BuildCS = 
@"
using UnrealBuildTool;

public class $Name_Module : ModuleRules
{
	public $Name_Module(ReadOnlyTargetRules Target) : base(Target)
	{
		PublicDependencyModuleNames.AddRange(
			new string[] {
				"Core",
				"CoreUObject",
				"Engine",
			});
		
		PublicDependencyModuleNames.AddRange(
				new string[] {
					"$Name_Module"
				});

		PublicIncludePaths.AddRange(
			new string[]
			{
				"$Name_Module/Public"
			});

		PrivateIncludePaths.AddRange(
			new string[]
			{
				"$Name_Module/Private"
			});
	}
}
"@

# endregion

### could be used to add entry to target file
# $Regex_ExtraModules = "(?smi)(?<=ExtraModuleNames.Add\().*(?=\))"
# $file_content = Get-Content $args[0] -Raw
# $FoundMatches = $file_content | select-string -Pattern $Regex_ExtraModules
# $check = $FoundMatches.Matches -split ","
# $tabs = $check[0] | select-string -Pattern "\s*"
# $new_entry = $tabs.Matches[0].Value + "`"MyEditorModule`""
# $new_AddModules = $check + $new_entry
# $new_AddModules = $new_AddModules -join ","


New-Item -ItemType Directory -Path $Path_NewModule
New-Item -ItemType Directory -Path ( Join-Path -Path $Path_NewModule -ChildPath "\Public")
New-Item -ItemType Directory -Path ( Join-Path -Path $Path_NewModule -ChildPath "\Private")

New-Item -ItemType File -Path $File_NewBuildCS
Set-Content $File_NewBuildCS $Content_BuildCS
New-Item -ItemType File -Path (Join-Path ($Path_NewModule + "\Public") -ChildPath ($Name_Module + ".h"))
New-Item -ItemType File -Path (Join-Path ($Path_NewModule + "\Private") -ChildPath ($Name_Module + ".cpp"))

