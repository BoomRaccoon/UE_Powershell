# UE_Powershell
Handy Powershell scripts that you can add to your windows context menu

Main steps are:
- run the CreatePackStructure script and give your pack a name
- add content inside 'Samples/<PackName>/Content/'
- then run GeneratePack where 'ContentToPack' is located
- finally copy the 'FeaturePacks' + 'Samples' directories inside of your UE5 directory (you know you are in the right place if you see DIRs with those names)
  

(UE)AddModule.ps1
- go to your projects 'Source' directory and run the script
- you are asked for a module name
- folder with this name will be created
- contains 'Public' 'Private' folder and the '.Build.cs' file with basic includes
- empty '.h' and '.cpp' files are added to 'Public' 'Private'

## Add preview images
Add the images you want as a preview inside of 'ContentSettings/Media/' directory, the names are already
set and you can just save and override them.
The manifest.json file contains the name of the preview images -which will be the same as the pack name-.
  
  
Side notes:
GeneratePack will get the installed engine with it's path from 'ProgramData/Epic'. If it can't find it you will have to supply the path yourself
  
I am using those scripts in the windows context menu
![image](https://github.com/BoomRaccoon/UE_Powershell/assets/19467905/5aab54c4-f9d6-49a5-a935-388d36992543)
