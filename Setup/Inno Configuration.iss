; https://jrsoftware.org/ishelp/index.php
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "PowerShell Compact-Archive Tool"
#define MyAppVersion "1.1.0"
#define MyAppPublisher "Nicholas Gautier"
#define MyAppURL "https://github.com/SibTiger/PowerShell-Compact-Archive-Tool"
#define MyAppInstallerName "PSCAT Installer" + " " + "v" + MyAppVersion




; Output Path
; ~ ~ ~ ~ ~ ~
; This defines the output path of the installer.
; NOTE: Relative Path only.
#define OutputDirectory "..\..\Installers\"


; Debug and Testing
; ~ ~ ~ ~ ~ ~ ~ ~ ~
; This defines if we are wanting to generate an installer package or if we want to check this script for errors
;   without generating an executable file.
; NOTE: Regardless of this setting, the Output Directory will be cleaned.
;
; Values:
;   No  = Only check this script for errors, nothing is generated.
;   Yes = Generates an installer executable file.
#define GenerateInstaller "Yes"






[Setup]
;        Compiler Related Configurations
; =============================================
; =============================================
; ---------------------------------------------

; Internal Compression Level
; - - - - - - - - - - - - - -
; This defines the compression level that will be used for Inno's internal structure.  Ideally, there's no
;   real need to configure this - other than to maybe save a few kilobytes.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_internalcompresslevel
InternalCompressLevel = normal


; Compression Algorithm and Compression Level
; - - - - - -
; This will define the compression type and compression level that will be using when compacting the software's
;   assets into the installation package.  We will use LZMA\2 with the best possible compression possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compression
Compression = lzma2/ultra64


; Solid Compression
; - - - - - - - - -
; Compact the files in such a way that it benefits the overall compression ratio within the installer package.
;   In doing so, data contents that are a like, will be combined instead of containing duplicated data.
;   Decompressing, however, in Real-Time will be hindered.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_solidcompression
SolidCompression = yes


; LZMA Algorithm
; - - - - - - - -
; This controls the algorithm that will be used for LZMA\2 Compressor.  Use the normal algorithm to benefit
;   overall compression.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmaalgorithm
LZMAAlgorithm = 1


; LZMA Use Separate Process
; - - - - - - - - - - - - -
; Allow the ability for the LZMA\2 Compressor to use its own system resources, instead of being tied down
;   to Inno's process.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmauseseparateprocess
LZMAUseSeparateProcess = yes


; LZMA Match Finder
; - - - - - - - - -
; Determine the Match Finder method that will be used with the LZMA\2 Compressor.  Using Binary Tree will
;   give use additional increase in compression.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmamatchfinder
LZMAMatchFinder = BT


; Compression Threads
; - - - - - - - - - -
; Determines if the LZMA\2 Compressor will utilize the host's one or multiple CPU virtual threads, if
;   available.  Using 'auto' will allow the Compressor to automatically determine the threads it will
;   need in order successfully compact the data efficiently.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compressionthreads
CompressionThreads = auto


; Merge Duplicate Files
; - - - - - - - - - - -
; If incase there exists multiple duplicate files, then we can be able to ignore all other duplicate
;   sources but only use the first instance instance.  By doing this, we minimize the need to store
;   every duplicate file - thus reducing the overall package size.  Moreover, the output that
;   requires the duplicated data to exist, will still be provided as intended.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_mergeduplicatefiles
MergeDuplicateFiles = yes





;           Output Configuration
; =============================================
; =============================================
; ---------------------------------------------

; Output
; - - - -
; This specifies if we are wanting to generate an installer package or to merely test the script
;   for errors.  However, regardless of this setting, Inno will still perform a cleanup operation
;   within the OutputDir.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_output
Output = {#GenerateInstaller}


; Output Base File Name
; - - - - - - - - - - -
; This provides the setup filename in the output result.  This essentially is our final compiled
;   build that the user will install.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_outputbasefilename
OutputBaseFilename = {#MyAppInstallerName}


; Output Directory
; - - - - - - - - -
; This will specify the location in which the setup file will be stored once the Inno Builder had
;   successfully compiled, or generated, the installer file(s).
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_outputdir
OutputDir = {#OutputDirectory}


















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
;OutputDir=C:\Users\Nicholas\Projects\Software\PowerShell-Compact-Archive-Tool\Output
;OutputBaseFilename=PSCAT Installer
;Compression=lzma
;SolidCompression=yes
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

