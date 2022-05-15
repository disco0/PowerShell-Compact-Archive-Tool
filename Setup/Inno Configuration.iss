; https://jrsoftware.org/ishelp/index.php
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "PowerShell Compact-Archive Tool"
#define MyAppVersion "1.1.0"
#define MyAppPublisher "Nicholas Gautier"
#define MyAppURL "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{02B00588-4477-4E98-AF59-E8825F957C03}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Source\LICENSE
InfoBeforeFile=C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Source\LICENSE
InfoAfterFile=C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Source\LICENSE
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Output
OutputBaseFilename=PSCAT Installer
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Source\Compile\PSCAT.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Source\Scripts\Program Modes\Clean.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Source\Scripts\Program Modes\Uninstall.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Source\Setup\Resources\Web\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

