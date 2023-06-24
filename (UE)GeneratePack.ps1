# region MAKE_UEPATH
    $LauncherInstallFile = $env:ProgramData + "\Epic\UnrealEngineLauncher\LauncherInstalled.dat"
    $bInstallerExists = Test-Path $LauncherInstallFile

    $args[0] = $args[0] -replace ("^'")  -replace ("'$")
    $File_ContentToPack = Join-Path -Path $args[0] -ChildPath "\ContentToPack.txt"
    $File_ContentToPack

    if ( ($bInstallerExists) ) {
        
        $Regex_UE = "(?<=InstallLocation`": `").*UE_.*(?=\`")"
        
        
        $FoundMatches = select-string -Pattern $Regex_UE $LauncherInstallFile | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value | Select-Object -Unique
        
        #foreach ($match in $FoundMatches) {
        #    write-host "["$FoundMatches.IndexOf($match)"]" $match
        #}
        #$selection = Read-Host -Prompt 'Select the path to use'
        #$Path_UE = $FoundMatches[$selection]
        $Path_UE = $FoundMatches[0]
    }
    else
    { write-host "EXIT.\nBecause: couldn't find installed unreal version and no path was provided" }
# endregion


if( !(Test-Path -Path $File_ContentToPack) )
    {Write-Host "EXIT`nBecause:The given path $($args[0])  does not contain a 'ContentToPack.txt'."; EXIT}


# Get Pack-Name from JSON file
$File_Manifest = Get-Childitem -File -Recurse -ErrorAction Stop -Path $args[0] -Include *manifest.json* 
$Name_Pack = Get-Content -Raw -Path $File_Manifest | ConvertFrom-Json
$Name_Pack = $Name_Pack.Name.Text + ".upack"
# build path for output .upack file
$OutPath_PackFile = Join-Path -Path $args[0] -ChildPath "\FeaturePacks\" | Join-Path -ChildPath $Name_Pack

$File_ContentToPack
$OutPath_PackFile

$cmd = Join-Path -Path $Path_UE -ChildPath "\Engine\Binaries\Win64\UnrealPak.exe"
$arguments = "-Create=$File_ContentToPack", $OutPath_PackFile
&  $cmd $arguments

$Path_EngineFeaturePacks = Join-Path -Path $Path_UE -ChildPath "\FeaturePacks\"
$Path_EngineSamples = Join-Path -Path $Path_UE -ChildPath "\Samples\"
$Path_PackFeaturePacks = Join-Path -Path $args[0] -ChildPath "\FeaturePacks\*"
$Path_PackSamples = Join-Path -Path $args[0] -ChildPath "\Samples\*"


copy-item -Path $Path_PackFeaturePacks -Destination $Path_EngineFeaturePacks -Recurse
copy-Item $Path_PackSamples -Destination $Path_EngineSamples -Recurse