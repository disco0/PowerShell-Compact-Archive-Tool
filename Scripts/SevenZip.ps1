﻿<# PowerShell Compact-Archive Tool
 # Copyright (C) 2022
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #>




<# Seven Zip
 # ------------------------------
 # ==============================
 # ==============================
 # This class allows the possibility to utilize 7Zip functionality within the program.  7Zip
 #  is a popular compression tool that supports common archive data file formats such as: ZIP,
 #  GZIP, and 7Z.  For the best compression, 7Z is preferred - though it has a greater performance
 #  impact when it comes to expeditious unpacking of data in RealTime environments.  For the best
 #  performance with compression, ZIP is preferred.  With this object, it is possible to: list
 #  files, verify, extract, and create a new archive data file.  However, the use of 7Zip is
 #  merely an optional setting.  Because 7Zip is an external command (external executable), it is
 #  not required for the user to already have this particular software installed on the host system.
 #  But, in order to use 7Zip's functionality or to compact and extract a 7Z file format, then it
 #  is a requirement to install the 7Zip program from that point onward.
 # NOTE:
 #  - This is only required if wanting to: verify, list files from, generate, or extract a 7Z (or
 #     PK7 for ZDoom's mods) file.
 #  - In order to utilize 7Zip functionality within this program, the 7Zip software must first be
 #     installed properly on the host system.  Otherwise, the features may not be readily available.
 # DEPENDENCIES (Optional):
 #  7Zip version 19.00 or later.
 #   - https://www.7-zip.org/
 #>




class SevenZip
{
    # Object Singleton Instance
    # =================================================
    # =================================================


    #region Singleton Instance

    # Singleton Instance of the object
    hidden static [SevenZip] $_instance = $null;




    # Get the instance of this singleton object (default)
    static [SevenZip] GetInstance()
    {
        # If there was no previous instance of the object - then create one.
        if ($null -eq [SevenZip]::_instance)
        {
            # Create a new instance of the singleton object.
            [SevenZip]::_instance = [SevenZip]::new();
        } # if : No Singleton Instance

        # Provide an instance of the object.
        return [SevenZip]::_instance;
    } # GetInstance()




    # Get the instance of this singleton object (with arguments).
    #  This is useful if we already know the properties of this
    #  new instance of the object.
    static [SevenZip] GetInstance([string] $executablePath, `                           # Executable Path
                                    [SevenZipCompressionMethod] $compressionMethod, `   # Create Zip or 7Zip archive datafiles
                                    [SevenZipAlgorithmZip] $algorithmZip, `             # Algorithm to use for ZIP
                                    [SevenZipAlgorithm7Zip] $algorithm7Zip, `           # Algorithm to use for the 7Zip
                                    [SevenZipCompressionLevel] $compressionLevel, `     # Compression Level
                                    [bool] $verifyBuild, `                              # Verify Archive datafile
                                    [bool] $generateReport, `                           # Create report
                                    [bool] $generateReportFilePDF)                      # Create a PDF Report
    {
        # if there was no previous instance of the object, then create one.
        if ($null -eq [SevenZip]::_instance)
        {
            # Create a new instance of the singleton object
            [SevenZip]::_instance = [SevenZip]::new($executablePath, `
                                                    $compressionMethod, `
                                                    $algorithmZip, `
                                                    $algorithm7Zip, `
                                                    $compressionLevel, `
                                                    $verifyBuild, `
                                                    $generateReport, `
                                                    $generateReportFilePDF);
        } # If: No Singleton Instance

        # Provide an instance of the object.
        return [SevenZip]::_instance;
    } # GetInstance()

    #endregion




    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # 7Zip Executable Path
    # ---------------
    # The path to the '7z.exe' executable within the Windows environment.
    Hidden [string] $__executablePath;


    # Compression Method
    # ---------------
    # The compression method in which to compact the newly generated archive
    #  data files.  Possible options can be:
    #   - Zip [PK3]
    #   - 7Zip [PK7]
    Hidden [SevenZipCompressionMethod] $__compressionMethod;


    # Algorithm [PK3|Zip]
    # ---------------
    # The compression algorithm that will be used when compacting the Zip (PK3)
    #  archive files.
    Hidden [SevenZipAlgorithmZip] $__algorithmZip;


    # Algorithm [PK7|7Zip]
    # ---------------
    # The compression algorithm that will be used when compacting the 7Zip (PK7)
    #  archive files.
    Hidden [SevenZipAlgorithm7Zip] $__algorithm7Zip;


    # Compression Level
    # ---------------
    # How tightly to compress the files going inside the archive data file that
    #  is currently being generated.  Levels of compression range from 0 to 9.
    #  Where:
    #   - 0 is no compression
    #   - 5 is standard compression
    #   - 9 is the maximum compression possible
    Hidden [SevenZipCompressionLevel] $__compressionLevel;


    # Verify Build
    # ---------------
    # Test the integrity of the archive data file and the files that are within
    #  the compressed file.
    Hidden [bool] $__verifyBuild;


    # Generate Report
    # ---------------
    # Allow the possibility to generate a report about the archive datafile.
    #  Reports provide some insight about the archive datafile and the
    #  contents that are within the file itself.
    Hidden [bool] $__generateReport;


    # Generate Report - PDF File
    # ---------------
    # Dependant on the Generate Report functionality, this variable will dictate
    #  if a PDF file is to be generated during the creation of the report.  The
    #  PDF file will contain all of the information from the originated report source.
    Hidden [bool] $__generateReportFilePDF;


    # Log Root
    # ---------------
    # The main parent directory's absolute path that will hold this object's
    #  logs and reports directories.
    Hidden [string] $__rootLogPath;


    # Report Path
    # ---------------
    # This directory, in absolute form, will hold reports that were generated
    #  from this object.  Reports provide some insight about the archive datafile
    #  and the contents that are within the file itself.
    Hidden [string] $__reportPath;


    # Log Root Path
    # ---------------
    # This directory, in absolute form, will hold logfiles that were generated
    #  from this object when creating, verifying, extracting, and listing
    #  contents from within an archive datafile.
    Hidden [string] $__logPath;


    # Object GUID
    # ---------------
    # Provides a unique identifier to the object, useful to make sure that we are using
    #  the right object within the software.
    Hidden [GUID] $__objectGUID;

    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions

    # Default Constructor
    SevenZip()
    {
        # Executable path to the 7z.exe
        $this.__executablePath = $this.Find7Zip();

        # Compression Method
        $this.__compressionMethod = [SevenZipCompressionMethod]::Zip;

        # Algorithm [Zip]
        $this.__algorithmZip = [SevenZipAlgorithmZip]::Deflate;

        # Algorithm [7Zip]
        $this.__algorithm7Zip = [SevenZipAlgorithm7Zip]::LZMA2;

        # Compression Level
        $this.__compressionLevel = [SevenZipCompressionLevel]::Normal;

        # Verify Build
        $this.__verifyBuild = $true;

        # Generate Report
        $this.__generateReport = $false;

        # Generate Report - PDF File
        $this.__generateReportFilePDF = $false;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\7Zip";

        # Report Directory Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Directory Path
        $this.__logPath = "$($this.__rootLogPath)\logs";

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # Default Constructor




    # User Preference : On-Load
    SevenZip([string] $executablePath, `
            [SevenZipCompressionMethod] $compressionMethod, `
            [SevenZipAlgorithmZip] $algorithmZip, `
            [SevenZipAlgorithm7Zip] $algorithm7Zip, `
            [SevenZipCompressionLevel] $compressionLevel, `
            [bool] $verifyBuild, `
            [bool] $generateReport, `
            [bool] $generateReportFilePDF)
    {
        # Executable path to the 7z.exe
        $this.__executablePath = $executablePath;

        # Compression Method
        $this.__compressionMethod = $compressionMethod;

        # Algorithm [Zip]
        $this.__algorithmZip = $algorithmZip;

        # Algorithm [7Zip]
        $this.__algorithm7Zip = $algorithm7Zip;

        # Compression Level
        $this.__compressionLevel = $compressionLevel;

        # Verify Build
        $this.__verifyBuild = $verifyBuild;

        # Generate Report
        $this.__generateReport = $generateReport;

        # Generate Report - PDF File
        $this.__generateReportFilePDF = $generateReportFilePDF;

        # Log Root Directory Path
        $this.__rootLogPath = "$($global:_PROGRAMDATA_LOGS_PATH_)\7Zip";

        # Report Directory Path
        $this.__reportPath = "$($this.__rootLogPath)\reports";

        # Log Directory Path
        $this.__logPath = "$($this.__rootLogPath)\logs";

        # Object Identifier (GUID)
        $this.__objectGUID = [GUID]::NewGuid();
    } # User Preference : On-Load

    #endregion



    #region Getter Functions

   <# Get Executable Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Executable Path' variable.
    # -------------------------------
    # Output:
    #  [string] Executable Path
    #   The value of the 'Executable Path' to the 7z.exe binary file.
    # -------------------------------
    #>
    [string] GetExecutablePath()
    {
        return $this.__executablePath;
    } # GetExecutablePath()




   <# Get Compression Method
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Compression Method' variable.
    # -------------------------------
    # Output:
    #  [SevenZipCompressionMethod] Compression Method
    #   The value of the 'Compression Method'.
    # -------------------------------
    #>
    [SevenZipCompressionMethod] GetCompressionMethod()
    {
        return $this.__compressionMethod;
    } # GetCompressionMethod()




   <# Get Algorithm [PK3|Zip]
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Algorithm' variable used with Zip method.
    # -------------------------------
    # Output:
    #  [SevenZipAlgorithmZip] Algorithm [ZIP]
    #   The value of the 'Compression Algorithm'.
    # -------------------------------
    #>
    [SevenZipAlgorithmZip] GetAlgorithmZip()
    {
        return $this.__algorithmZip;
    } # GetAlgorithmZip()




   <# Get Algorithm [PK7|7Zip]
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Algorithm' variable used with 7Zip method.
    # -------------------------------
    # Output:
    #  [SevenZipAlgorithm7Zip] Algorithm [7Zip]
    #   The value of the Compression Algorithm.
    # -------------------------------
    #>
    [SevenZipAlgorithm7Zip] GetAlgorithm7Zip()
    {
        return $this.__algorithm7Zip;
    } # GetAlgorithm7Zip()




   <# Get Compression Level
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Compression Level' variable.
    # -------------------------------
    # Output:
    #  [SevenZipCompressionLevel] Compression Level
    #   The value of the 'Compression Level'.
    # -------------------------------
    #>
    [SevenZipCompressionLevel] GetCompressionLevel()
    {
        return $this.__compressionLevel;
    } # GetCompressionLevel()




   <# Get Verify Build
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Verify Build' variable.
    # -------------------------------
    # Output:
    #  [bool] Verify Build
    #   The value of the 'Verify Build'.
    # -------------------------------
    #>
    [bool] GetVerifyBuild()
    {
        return $this.__verifyBuild;
    } # GetVerifyBuild()




   <# Get Generate Report
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Generate Report' variable.
    # -------------------------------
    # Output:
    #  [bool] Generate Report
    #   The value of the 'Generate Report'.
    # -------------------------------
    #>
    [bool] GetGenerateReport()
    {
        return $this.__generateReport;
    } # GetGenerateReport()




   <# Get Generate Report - Generate PDF File
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Generate Report - PDF File' variable.
    # -------------------------------
    # Output:
    #  [bool] Generate Report using PDF File
    #   The value of the 'Generate Report - PDF File'.
    # -------------------------------
    #>
    [bool] GetGenerateReportFilePDF()
    {
        return $this.__generateReportFilePDF;
    } # GetGenerateReportFilePDF()




   <# Get Report Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Report Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Report Path
    #   The value of the 'Report Directory Path'.
    # -------------------------------
    #>
    [string] GetReportPath()
    {
        return $this.__reportPath;
    } # GetReportPath()




   <# Get Log Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Log Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Log Path
    #   The value of the 'Log Directory Path'.
    # -------------------------------
    #>
    [string] GetLogPath()
    {
        return $this.__logPath;
    } # GetLogPath()




   <# Get Root Log Directory Path
    # -------------------------------
    # Documentation:
    #  Returns the value of the 'Root Log Directory Path' variable.
    # -------------------------------
    # Output:
    #  [string] Root Log Path
    #   The value of the 'Log Root Directory Path'.
    # -------------------------------
    #>
    [string] GetRootLogPath()
    {
        return $this.__rootLogPath;
    } # GetRootLogPath()




   <# Get Object GUID
    # -------------------------------
    # Documentation:
    #  Returns the value of the object's 'Global Unique ID' variable.
    # -------------------------------
    # Output:
    #  [GUID] Global Unique Identifier (GUID)
    #   The value of the object's GUID.
    # -------------------------------
    #>
    [GUID] GetObjectGUID()
    {
        return $this.__objectGUID;
    } # GetObjectGUID()


    #endregion



    #region Setter Functions

   <# Set Executable Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Executable Path' variable.
    # -------------------------------
    # Input:
    #  [string] Executable Path
    #   The location of the 7Zip executable within the host system.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetExecutablePath([string] $newVal)
    {
        # Because we are testing for an actual file, we must assure that
        #  the file really exists within the host's filesystem.
        if([CommonIO]::DetectCommand($newVal, "Application") -eq $false)
        {
            # Could not find the executable.
            return $false;
        } # If : Command Not Found


        # Set the path
        $this.__executablePath = $newVal;

        # Successfully updated.
        return $true;
    } # SetExecutablePath()




   <# Set Compression Method
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Compression Method' variable.
    # -------------------------------
    # Input:
    #  [SevenZipCompressionMethod] Compress Method
    #   The choice between 7Zip or Zip archive data file format.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionMethod([SevenZipCompressionMethod] $newVal)
    {
        # Because the value must fit within the 'SevenZipCompressionMethod'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__compressionMethod = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionMethod()




   <# Set Algorithm [PK3|Zip]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Zip Algorithm' variable.
    # -------------------------------
    # Input:
    #  [SevenZipAlgorithmZip] Algorithm Zip
    #   The algorithm that will be used when compacting a new Zip archive data file.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetAlgorithmZip([SevenZipAlgorithmZip] $newVal)
    {
        # Because the value must fit within the 'SevenZipAlgorithmZip'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__algorithmZip = $newVal;

        # Successfully updated.
        return $true;
    } # SetAlgorithmZip()




   <# Set Algorithm [PK7|7Zip]
    # -------------------------------
    # Documentation:
    #  Sets a new value for the '7Zip Algorithm' variable.
    # -------------------------------
    # Input:
    #  [SevenZipAlgorithm7Zip] Algorithm 7Zip
    #   The algorithm that will be used when compacting a new 7Zip archive data file.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetAlgorithm7Zip([SevenZipAlgorithm7Zip] $newVal)
    {
        # Because the value must fit within the 'SevenZipAlgorithm7Zip'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__algorithm7Zip = $newVal;

        # Successfully updated.
        return $true;
    } # SetAlgorithm7Zip()




   <# Set Compression Level
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Compression Level' variable.
    # -------------------------------
    # Input:
    #  [SevenZipCompressionLevel] Compression Level
    #   The desired compression level for compacting newly generated
    #    archive data files.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetCompressionLevel([SevenZipCompressionLevel] $newVal)
    {
        # Because the value must fit within the 'SevenZipCompressionLevel'
        #  datatype, there really is no point in checking if the new
        #  requested value is 'legal'.  Thus, we are going to trust the
        #  value and automatically return success.
        $this.__compressionLevel = $newVal;

        # Successfully updated.
        return $true;
    } # SetCompressionLevel()




   <# Set Verify Build
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Verify Build' variable.
    # -------------------------------
    # Input:
    #  [bool] Verify Archive
    #   When true, allow the possibility to test the archive datafile's
    #    integrity.  Otherwise, do not allow the possibility to
    #    examine the archive file.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetVerifyBuild([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__verifyBuild = $newVal;

        # Successfully updated.
        return $true;
    } # SetVerifyBuild()




   <# Set Generate Report
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Generate Report' variable.
    # -------------------------------
    # Input:
    #  [bool] Generate Report
    #   When true, this will allow the report functionality to be
    #    executed.  Otherwise the report functionality will be turned
    #    off.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetGenerateReport([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__generateReport = $newVal;

        # Successfully updated.
        return $true;
    } # SetGenerateReport()




   <# Set Generate Report - Generate PDF File
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Generate Report - PDF File' variable.
    # -------------------------------
    # Input:
    #  [bool] Generate Report - PDF File
    #   When true, this will allow the report functionality to generate
    #    a PDF file.  Otherwise, only the text file will be produced.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetGenerateReportFilePDF([bool] $newVal)
    {
        # Because the value is either true or false, there really is no
        #  point in checking if the new requested value is 'legal'.
        #  Thus, we are going to trust the value and automatically
        #  return success.
        $this.__generateReportFilePDF = $newVal;

        # Successfully updated.
        return $true;
    } # SetGenerateReportFilePDF()




   <# Set Root Log Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Root Log Path' variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!  IT IS RECOMMENDED
    #   TO _NOT_ REVISE THIS VARIABLE UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Input:
    #  [string] Root Log Path
    #   The new location of the Root Log directory.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetRootLogPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__rootLogPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetRootLogPath()




   <# Set Log Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Log Path' variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!  IT IS RECOMMENDED
    #   TO _NOT_ REVISE THIS VARIABLE UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Input:
    #  [string] Log Path
    #   The new location of the Logging directory.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetLogPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__logPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetLogPath()




   <# Set Report Path
    # -------------------------------
    # Documentation:
    #  Sets a new value for the 'Report Path' variable.
    #
    # WARNING:
    #  CHANGING THE PATH CAN CAUSE CONSISTENCY ISSUES!  IT IS RECOMMENDED
    #   TO _NOT_ REVISE THIS VARIABLE UNLESS IT IS ABSOLUTELY NECESSARY!
    # -------------------------------
    # Input:
    #  [string] Report Path
    #   The new location of the Report directory.
    # -------------------------------
    # Output:
    #  [bool] Status
    #   true = Success; value has been changed.
    #   false = Failure; could not set a new value.
    # -------------------------------
    #>
    [bool] SetReportPath([string] $newVal)
    {
        # Inspect to see if the path exists
        if (Test-Path $newVal.trim())
        {
            # Path exists; use it as requested
            $this.__reportPath = $newVal;
            return $true;
        } # IF: Path Exists

        # Failure; Path does not exist.
        return $false;
    } # SetReportPath()

    #endregion



    #region Private Functions


   <# Check Required Directories
    # -------------------------------
    # Documentation:
    #  This function will check to make sure that the log and report directories,
    #   that are used in this class, currently exists within the host system's filesystem.
    #
    # ----
    #
    #  Directories to be checked:
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\logs
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\reports
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = One or more directories does not exist.
    #    $true = Directories exist
    # -------------------------------
    #>
    Hidden [bool] __CheckRequiredDirectories()
    {
        # Make sure the the following directories:
        return (([CommonIO]::CheckPathExists($this.GetRootLogPath(), $true) -eq $true) -and   ` # Check the Root Log Directory
                ([CommonIO]::CheckPathExists($this.GetReportPath(), $true) -eq $true) -and    ` # Check the Report Path Directory
                ([CommonIO]::CheckPathExists($this.GetLogPath(), $true) -eq $true));            # Check the Log Path Directory
    } # __CheckRequiredDirectories()




   <# Create Directories
    # -------------------------------
    # Documentation:
    #  This function will create the necessary directories that will hold the log and
    #   report files that are generated from this class.  If the directories do not
    #   exist on the filesystem already, there is a change that some operations might
    #   fail due to the inability to safely store the log and\or the report files
    #   generated by the functions within this class.  If the directories do not
    #   already exist, this function will try to create them automatically - without
    #   interacting with the end-user.  If the directories already exist within the
    #   filesystem, then nothing will be performed.
    #
    # ----
    #
    #  Directories to be created:
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\logs
    #   - %LOCALAPPDATA%\<PROG_NAME>\7Zip\reports
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #    $false = Failure creating the new directories.
    #    $true  = Successfully created the new directories
    #             OR
    #             Directories already existed, nothing to do.
    # -------------------------------
    #>
    Hidden [bool] __CreateDirectories()
    {
        # First, check if the directories already exist.
        if($this.__CheckRequiredDirectories() -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("The 7Zip logging directories already exists;" + `
                                    " there is no need to create the directories again.");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("7Zip Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n" + `
                                        "`t`tThe Report Directory is:`t$($this.GetReportPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The directories exist, no action is required.
            return $true;
        } # IF : Check if Directories Exists


        # ----


        # Because one or all of the directories does not exist, we must first
        #  check which directory does not exist and then try to create it.

        # Root Log Directory
        if([CommonIO]::CheckPathExists($this.GetRootLogPath(), $true) -eq $false)
        {
            # Root Log Directory does not exist, try to create it.
            if ([CommonIO]::MakeDirectory($this.GetRootLogPath()) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the 7Zip root logging and report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The root directory path is: " + $this.GetRootLogPath();

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Root Log Directory


        # ----


        # Log Directory
        if([CommonIO]::CheckPathExists($this.GetLogPath(), $true) -eq $false)
        {
            # Log Directory does not exist, try to create it.
            if ([CommonIO]::MakeDirectory($this.GetLogPath()) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the 7Zip logging directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The logging directory path is: " + $this.GetLogPath();

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Log Directory


        # ----


        # Report Directory
        if([CommonIO]::CheckPathExists($this.GetReportPath(), $true) -eq $false)
        {
            # Report Directory does not exist, try to create it.
            if ([CommonIO]::MakeDirectory($this.GetReportPath()) -eq $false)
            {
                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Couldn't create the 7Zip report directory!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "The report directory path is: " + $this.GetReportPath();

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Failure occurred; could not create directory.
                return $false;
            } # If : Failed to Create Directory
        } # If : Not Detected Report Directory


        # ----


        # Fail-safe; final assurance that the directories have been created successfully.
        if($this.__CheckRequiredDirectories() -eq $true)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully created the 7Zip logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("7Zip Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory is:`t`t$($this.GetRootLogPath())`r`n" + `
                                        "`t`tThe Logging Directory is:`t$($this.GetLogPath())`r`n" + `
                                        "`t`tThe Report Directory is:`t$($this.GetReportPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The directories exist
            return $true;
        } # IF : Check if Directories Exists


        # ONLY REACHED UPON ERROR
        # If the directories could not be detected - despite being created on the filesystem,
        #  then something went horribly wrong.
        else
        {
            # The directories could not be found.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Failed to detect the 7Zip required logging and report directories!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("7Zip Logging Directories:`r`n" + `
                                        "`t`tThe Root Directory was:`t`t$($this.GetRootLogPath())`r`n" + `
                                        "`t`tThe Logging Directory was:`t$($this.GetLogPath())`r`n" + `
                                        "`t`tThe Report Directory was:`t$($this.GetReportPath())`r`n");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # Else : If Directories Not Found


        # A general error occurred; the directories could not be created.
        return $false;
    } # __CreateDirectories()


    #endregion



    #region Public Functions


    #region 7Zip Detection


   <# Detect 7Zip Executable
    # -------------------------------
    # Documentation:
    #  This function will try to detect the 7Zip executable by making sure that the
    #   assigned member variable is setup properly.  To accomplish this task, this
    #   function will make sure that the variable contains some sort of data and to
    #   make sure that the variable is pointing to a binary file.  After investigating
    #   the variable, this function will return the result in Boolean form.
    # -------------------------------
    # Output:
    #  [bool] Detected Code
    #    $false = Failed to detect the external executable.
    #    $true  = Successfully detected the external executable.
    # -------------------------------
    #>
    [bool] Detect7ZipExist()
    {
        # Make sure that the value is not empty (or null).
        if ($null -eq $this.GetExecutablePath())
        {
            # No value was provided; unable to perform a check as nothing was provided.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find the 7Zip executable as there was no path provided!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "7Zip Executable Path is: " + $this.GetExecutablePath();

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the value is empty, this function was unable to detect the
            #  executable file.
            return $false;
        } # if : Executable Path is Empty


        # Check if the 7Zip executable was found.
        if ([CommonIO]::DetectCommand($this.GetExecutablePath(), "Application") -eq $true)
        {
            # Successfully located the 7Zip executable.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully located the 7Zip executable!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "7Zip Executable Path is: " + $this.GetExecutablePath();

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that the executable was found.
            return $true;
        } # If : Detected 7Zip

        # Failed to detect the executable.
        else
        {
            # The path provided already does not point to a valid executable or
            #  the path does not exist.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to find the 7Zip executable as the path was not valid!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "7Zip Executable Path is: " + $this.GetExecutablePath();

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return that the executable could not be found.
            return $false;
        } # Else : Unable to Detect 7zip
    } # Detect7ZipExist()




   <# Find 7Zip
    # -------------------------------
    # Documentation:
    #  This function will try to automatically find the 7Zip executable by checking
    #   some prevalent locations within the host's filesystem.  If this function was
    #   able to successfully detect the executable, then the path to the binary file
    #   will be returned.  Otherwise, if the application was not found, then '$null'
    #   will be returned instead.
    # -------------------------------
    # Output:
    #  [string] 7Zip Executable (Absolute) Path
    #    Returns the location of where the 7Zip application resides.
    #    NOTE:
    #       $null - signifies that the 7Zip executable could not be found in the common
    #                locations.
    # -------------------------------
    #>
    [string] Find7Zip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $path = @("7z.exe",`                                 # Location: %PATH%
                             "7za.exe", `                               # Location: %PATH% {7Zip CLI; Stand-Alone}
                            "${env:PROGRAMFILES}\7-Zip\7z.exe", `       # Location: %ProgramFiles%       {x86_32}
                            "${env:PROGRAMFILES(x86)}\7-Zip\7z.exe");   # Location: %ProgramFiles(x86)%  {x86_64}
        # ----------------------------------------


        # Try to automatically find the 7Zip executable by inspecting each path within the array.
        foreach ($index in $path)
        {
            # Check the path to see if the 7Zip application was found with the given path.
            if([CommonIO]::DetectCommand($index, "Application") -eq $true)
            {
                # Successfully found the executable


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Successfully located the 7Zip executable!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = "7Zip was found in: " + $index;

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                            $logAdditionalMSG, `            # Additional information
                                            [LogMessageLevel]::Verbose);    # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Successfully found the executable; return the path.
                return $index;
            } # if : Inspect the Individual Path
        } # Foreach : Check all Common Paths



        # Could not find the 7Zip executable


        # * * * * * * * * * * * * * * * * * * *
        # Debugging
        # --------------

        # Generate the initial message
        [string] $logMessage = "Could not automatically locate the 7Zip executable!";

        # Generate any additional information that might be useful
        [string] $logAdditionalMSG = ("Places to automatically look:`r`n" + `
                                    "`t`t- $($path -join "`r`n`t`t- ")");

        # Pass the information to the logging system
        [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                    $logAdditionalMSG, `            # Additional information
                                    [LogMessageLevel]::Warning);    # Message level

        # * * * * * * * * * * * * * * * * * * *


        # If the application could not be found, then return nothing ($null) to signify
        #  that this function was unable to find the application.
        return $null;
    } # Find7Zip()

    #endregion


    #region Inspect Archive

   <# Archive-File Hash
    # -------------------------------
    # Documentation:
    #  This function will generate and provide the desired hash value from the
    #   requested archive data file.  If incase the hash value is unobtainable,
    #   such as the archive data file being corrupted; file was not found; hash
    #   failed to be generated; or any reason at all, then this function will
    #   return 'ERR' to signify that an error had occurred.
    #
    # DEVELOPER NOTES:  Because 7Zip does _NOT_ provide clean output, such as
    #       returning only the hash value, the use of Regular Expression is
    #       required to parse the output.  PowerShell, luckily, supports RegEx!
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The requested archive data file that the hash value will be generated from.
    #  [FileHashAlgorithm7Zip] Hashing Algorithm
    #   The requested hash algorithm to generate from the desired archive data file.
    #    NOTE: For a list of supported algorithms, please check this website:
    #          https://sevenzip.osdn.jp/chm/cmdline/commands/hash.htm
    # -------------------------------
    # Output:
    #  [string] Hash Value
    #   The generated hash value from the requested archive file.
    #    NOTE:
    #       ERR - signifies that an error has been reached, the hash value could not
    #               be generated.
    # -------------------------------
    #>
    [string] ArchiveHash([string] $file, `                          # The archive file that the hash value is generated from.
                        [FileHashAlgorithm7Zip] $hashAlgorithm)     # The desired hash algorithm to generate.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $sourceDir = [string]((Get-Item $file).DirectoryName);     # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = "h -scrc$($hashAlgorithm) `"$($file)`"";     # Arguments to be used when invoking the 7Zip executable.
                                                                            #  This will allow 7Zip to generate the desired Hash information
                                                                            #  based from the archive datafile.
        [string] $outputResult = $null;                                     # This variable will hold the newly generated hash value from the
                                                                            #  7Zip executable.
        [string] $execReason = "Generate $($hashAlgorithm) Hash";           # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the logging requirements are met.
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to generate the hash value of the desired archive file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return "ERR";
        } # If : Logging Requirements are Met


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($this.Detect7ZipExist() -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to generate the Hash value as the 7Zip application was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip executable was not found, it is not possible" + `
                                        " to generate the requested hash value.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error as the 7Zip executable was not found, it is not possible to generate the Hash value.
            return "ERR";
        } # if : 7Zip was not detected


        # Make sure that the archive data file exists within the provided path.
        if ([CommonIO]::CheckPathExists($file, $true) -eq $false)
        {
            # The requested file does not exist.  We cannot generate a hash value without the archive datafile.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to generate the Hash value as the archive data file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The archive data file was not found with the given path.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error as the archive data file does not exist with the given path.
            return "ERR";
        } # if : File does not exist


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command to generate the desired hash information.
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # 7Zip Executable Path
                                        $extCMDArgs, `                  # Arguments to generate the hash from the archive data file.
                                        $sourceDir, `                   # The working directory that 7Zip will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory path.
                                        $this.GetLogPath(), `           # The Error Output Directory path.
                                        $this.GetReportPath(), `        # The Report Directory path.
                                        $execReason, `                  # The reason why we are running 7Zip; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $true, `                        # We will be capturing the STDOUT - we will need to process it.
                                        [ref]$outputResult) -ne 0)      # Variable containing the STDOUT; used for processing.
        {
            # 7Zip closed with an error


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to fetch the Hash value as 7Zip returned an error!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application returned an error, it was not" + `
                                        " possible to fetch the requested Hash value.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # This function will return an error as the 7Zip executable reported a possible failure.
            return "ERR";
        } # if : 7Zip Closed with Error


        # Evaluation Requirement Check
        # - - - - - - - - - - - - - -
        # Before we can perform some various operations using Regular Expression, we
        #  first need to make sure that the output, generated by 7Zip, meets the basic
        #  requirements for this function to operate successfully.
        #  Requirements are the following:
        #   - The data is NOT null or empty.
        #   - The data contains a recognizable key phrase.  This key phrase is necessary
        #      to make sure that the data provided by the 7Zip executable was valid.  All
        #      other values could possibly mean that the archive file was corrupted,
        #      unsupported hash value, or something just went horribly wrong.
        #  If the requirements are not meant - then it is simply not possibly to get the
        #   hash value or to properly parse the data.
        # ---------------------------

        # Make sure that the variable containing the Hash information, from 7Zip, is not empty.
        #  We need the variable to be initialized with some sort of data, if the data provided
        #  was empty (or null) - it is not possible to rigorously evaluate the output as needed.
        if ($null -eq $outputResult)
        {
            # The output cannot be evaluated; there is nothing to inspect.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Could not obtain the Hash value as the value was either empty or lost!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("An error occurred were the Hash value was either not provided by" + `
                                        " 7Zip or was lost internally.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the hash value was not fully captured, this function will have to return an error.
            return "ERR";
        } # if : Output Result is Empty


        # The most important part, does the key-phrase exists within the output?  If the
        #  key-phrase was found, it is possible to proceed further within this function.
        #
        #  KEY-PHRASE(RegEx):
        #    "Everything\ is\ Ok\r\n$"
        if (($outputResult -match "Everything Is Ok`r`n$") -eq $false)
        {
            # The key-phrase was not detected; it is not possible to parse the data correctly.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to parse the Hash value provided by the 7Zip application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Unable to parse the Hash Value as the Key-Phrase was not found as expected!`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return an error as the Key-Phrase was not found in 7Zip's output.
            return "ERR";
        } # if : Key-Phrase not Detected

        # ---------------------------
        # - - - - - - - - - - - - - -


        # Now, to do some RegEx'ing!
        # - - - - - - - - - - - - - -
        # ---------------------------
        # To assure that I - as well as others - can follow the parsing protocol, the
        #  procedure has been split up into several steps to ensure that it is easy to
        #  follow and to maintain in the future.
        # Please see this link for PowerShell RegEx
        #  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions


        # REGEX PASS 1
        # Replace 'Everything is Okay' with nothing
        #  NOTE: PowerShell RegEx Commands
        #   `r`n = New Line
        #      $ = End of Line
        $outputResult = ($outputResult -replace "`r`n`r`nEverything Is Ok`r`n$", $null);


        # REGEX PASS 2
        # Capture the Hash Value from the end of the output provided by the 7Zip executable.
        #  Check to make sure that the Hash Value was found at the end of the output string,
        #  if not detected - then something else was unexpectedly found.
        if (($outputResult -match "\s\w+$") -eq $false)
        {
            # The hash value was not found as expected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to parse the Hash value successfully!"

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Unable to properly parse the output that was gathered by the 7Zip application." + `
                                        "  Expected to find the Hash Value at Pass 2.`r`n" + `
                                        "`tRequested Hash Algorithm: $($hashAlgorithm)`r`n" + `
                                        "`tArchive data file to inspect: $($file)`r`n" + `
                                        "`tOutput from 7Zip: $($outputResult)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The parsing value did not match with what was expected, immediately leave
            #  and return an error.
            return "ERR";
        } # if : Unexpected Value Reached - Error


        # FINAL
        # Return the final result, which should only contain the parsed Hash Value that was
        #  generated by the 7Zip executable.
        return [string]($matches[0]);
    } # ArchiveHash()




   <# Verify Archive
    # -------------------------------
    # Documentation:
    #  This function will initiate 7Zip's ability to test the file contents
    #   that currently resides within the archive data file as well as verify
    #   the archive file's data structure.  With this function, it is possible
    #   to identify if the data within the archive is corrupted or if the
    #   archive's structure was damaged.
    #
    #  Test Integrity Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/test.htm
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The requested archive data file that will be verified.  This
    #    verification process checks the compact file's data structure and
    #    the data within the compressed file itself.
    # -------------------------------
    # Output:
    #  [bool] Verification Process Code
    #    $false = The archive data file is corrupted.
    #    $true = The archive data file is healthy.
    # -------------------------------
    #>
    [bool] VerifyArchive([string] $file)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = [string](Split-Path $file -leaf);              # Obtain only just the file name itself while omitting
                                                                            #  the absolute path.
        [string] $sourceDir = [string]((Get-Item $file).DirectoryName);     # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = "t `"$($file)`"";                            # Arguments to be used when invoking the 7Zip executable.
                                                                            #  This will allow 7Zip to perform a verification test on
                                                                            #  the specified archive data file.
        [string] $outputResult = $null;                                     # This variable will hold the output that is generated by
                                                                            #  the 7Zip executable.
        [string] $execReason = "Verifying $($fileName)";                    # Description; used for logging
        # ----------------------------------------



        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------


        # Make sure that the logging requirements are met.
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to verify the requested archive data file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tArchive data file to verify: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Logging Requirements are Met


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($this.Detect7ZipExist() -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to verify the requested archive data file as the 7Zip application was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application was not found, it is not possible to test the desired " + `
                                        "archive data file's integrity.`r`n" + `
                                        "`tArchive data file to verify: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the 7Zip application was not found, return false to signify that the operation had failed.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the archive data file exists within the provided path.
        if ([CommonIO]::CheckPathExists($file, $true) -eq $false)
        {
            # The archive data file does not exist with the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to verify the requested archive data file as the compact file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The archive data file was not found with the given path.`r`n" + `
                                        "`tArchive data file to verify: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the archive file was not found, it is not possible to perform a test.
            return $false;
        } # if : File does not exist


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # 7Zip Executable Path
                                        $extCMDArgs, `                  # Arguments to generate the hash from the archive data file.
                                        $sourceDir, `                   # The working directory that 7Zip will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory path.
                                        $this.GetLogPath(), `           # The Error Output Directory path.
                                        $this.GetReportPath(), `        # The Report Directory path.
                                        $execReason, `                  # The reason why we are running 7Zip; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $true, `                        # We will be capturing the STDOUT - we will need to process it.
                                        $outputResult) -ne 0)           # Variable containing the STDOUT; used for processing.
        {
            # 7Zip closed with an error; the archive file did not pass the verification test.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "7Zip detected that the archive data file may had been corrupted or damaged!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because 7Zip reported that the archive data file is corrupted or damaged, " + `
                                        "it may not be possible to recover the data or to access the contents within " + `
                                        "the archive file.`r`n" + `
                                        "`tArchive data file to verify: $($file)`r`n" + `
                                        "`tPossible Output from 7Zip: $($outputResult)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purposes.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # 7Zip had detected that the archive file is corrupted.
            return $false;
        } # if : Verification Test Failed


        # Verification Test Passed!
        return $true;
    } # VerifyArchive()




   <# Fetch Hash Information
    # -------------------------------
    # Documentation:
    #  This function will retrieve all of the possible hash information
    #   associated with the desired archive data file.
    #  The file hashes are essentially a fingerprint to that specific
    #   file.  If the hash provided differs from the previously known
    #   hash information, then it could mean that the file could have
    #   been corrupted or was modified.
    # -------------------------------
    # Input:
    #  [string] Archive File Path
    #   The absolute path to the desired archive data file to inspect.
    # -------------------------------
    # Output:
    #  [string] Hash Values
    #   A string list of all supported hash values that are associated
    #    with the desired archive data file.
    # -------------------------------
    #>
    [string] FetchHashInformation([string] $file)
    {
        # Get all of the hash values that is associated with the archive file and return the results.
        #  NOTE: MD5 is also attached to the list as it is still commonly used and widely accepted.
        return (
                "CRC32:`r`n" + `
                "  $($this.ArchiveHash($file, [FileHashAlgorithm7Zip]::crc32))`r`n`r`n" + `
                "CRC64:`r`n" + `
                "  $($this.ArchiveHash($file, [FileHashAlgorithm7Zip]::crc64))`r`n`r`n" + `
                "SHA1:`r`n" + `
                "  $($this.ArchiveHash($file, [FileHashAlgorithm7Zip]::sha1))`r`n`r`n" + `
                "CRC256:`r`n" + `
                "  $($this.ArchiveHash($file, [FileHashAlgorithm7Zip]::sha256))`r`n`r`n" + `
                "BLAKE2sp:`r`n" + `
                "  $($this.ArchiveHash($file, [FileHashAlgorithm7Zip]::blake2sp))`r`n`r`n" + `
                "MD5:`r`n" + `
                "   $([CommonIO]::FileHash($file, [FileHashAlgorithmDotNet]::md5))`r`n`r`n");
    } # FetchHashInformation()




   <# List Files in Archive
    # -------------------------------
    # Documentation:
    #  This function will provide a list of files that currently resides within the archive data file.
    #   The list generated will be returned to the calling function.
    #
    #  List Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/list.htm
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The archive file that will be inspected.
    #  [bool] Show Technical Information
    #   When true, this will show All Technical Information - provided by 7Zip.
    #    This will use the '-slt' argument when providing a list of all of the
    #    files that is associated within the archive data file.
    # -------------------------------
    # Output:
    #  [string] File List
    #    List of files that exists within the archive file.
    #    NOTE:
    #       ERR - signifies that an error has been reached, the list could not
    #               be generated.
    # -------------------------------
    #>
    [string] ListFiles([string] $file, `            # The Archive File to Inspect
                        [bool] $showTechInfo)       # Provide Verbose Information regarding Each File
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $fileName = [string](Split-Path $file -leaf);              # Obtain only just the file name itself while omitting
                                                                            #  the absolute path.
        [string] $sourceDir = [string]((Get-Item $file).DirectoryName);     # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = "l `"$($file)`"";                            # Arguments to be used when invoking the 7Zip executable.
                                                                            #  This will allow 7Zip to retrieve a list of all of the
                                                                            #  files that exists within the archive file.
        [string] $outputResult = $null;                                     # This variable will hold the output that is generated by
                                                                            #  the 7Zip executable.
        [string] $execReason = "List From $($fileName)";                    # Description; used for logging
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the list of files from the archive data file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tArchive data to inspect: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `       # Initial message
                                        $logAdditionalMSG, `   # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return "ERR";
        } # If : 7Zip Logging Directories


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($this.Detect7ZipExist() -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the list of files from the archive data file as the 7Zip application was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application was not found, it is not possible to retrieve a list of files" + `
                                        " that currently resides within the archive data file.`r`n" + `
                                        "`tArchive data file to inspect: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the 7Zip application was not found, return an error to signify that the operation had failed.
            return "ERR";
        } # if : 7Zip was not detected


        # Make sure that the archive data file exists within the provided path.
        if ([CommonIO]::CheckPathExists($file, $true) -eq $false)
        {
            # The archive data file does not exist with the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to retrieve the list of files from the archive data file as the compact file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The archive data file was not found with the given path.`r`n" + `
                                        "`tAbsolute Path of the Archive file: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # It is not possible to inspect the archive file as it was not found.
            return "ERR";
        } # if : File does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -


        # If the user requested verbose information regarding each file, then just
        #  append that argument to the parameter list.
        if ($showTechInfo -eq $true)
        {
            # This will append the 'Technical Information' argument to the parameter
            #  list.  With that argument, it will provide verbose information regarding
            #  each file within the archive data file.
            $extCMDArgs = "$($extCMDArgs) -slt";
        } # if : Provide Technical Information


        # Execute the command
        [CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # 7Zip Executable Path
                                $extCMDArgs, `                      # Arguments to provide a list of all files within the archive file.
                                $sourceDir, `                       # The working directory that 7Zip will start from.
                                $this.GetLogPath(), `               # The Standard Output Directory path.
                                $this.GetLogPath(), `               # The Error Output Directory path.
                                $this.GetReportPath(), `            # The Report Directory path.
                                $execReason, `                      # The reason why we are running 7Zip; used for logging purposes.
                                $false, `                           # Are we building a report?
                                $true, `                            # We will be capturing the STDOUT - we will need to process it.
                                [ref]$outputResult) | Out-Null;     # Variable containing the STDOUT; used for processing.


        # Just for assurance; make sure that we have an actual list from the archive
        #  file.  If in case the list was not retrieved successfully, then place an
        #  'ERR' to signify that an issue occurred, but still providing a value.
        if ($null -eq $outputResult)
        {
            # The Output from 7Zip contained no data.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "7Zip executed with a list of files within the archive file, but output was null!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("7Zip was executed and generated a list of files and directories that resides within the" + `
                                            " requested archive data file, but strangely - the output is currently empty.`r`n" + `
                                            "`tTo Resolve this issue:`r`n" + `
                                            "`t`t- You may need to report this bug as it could be an issue with how the data is being captured.`r`n" + `
                                            "`tArchive Data to Inspect: $($file)`r`n" + `
                                            "`tShow Technical Information: $($showTechInfo)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Because the output was NULL, throw in a default error message.
            $outputResult = "ERR";
        } # If : List was not valid


        # Output the final result
        return $outputResult;
    } # ListFiles()

    #endregion


    #region Archive File Management

   <# Extract Archive
    # -------------------------------
    # Documentation:
    #  This function will extract all of the contents that reside within the
    #   provided archive data file to the desired output directory.  This
    #   function will create a new directory with the same name as the archive
    #   file, omitting the file extension, within the desired output path given
    #   - this will be our extracting directory.  If incase the final extracting
    #   directory already exists, then this function will try to make a unique
    #   directory by attaching a time and data stamp to the directory's name.
    #   Though, if this function is incapable of creating a unique directory
    #   then the entire operation will be aborted as there is no valid directory
    #   to store the data that would be extracted.
    #  For Example:
    #   E:\User\JackMass\Documents\{{DESIRED_OUTPUT}}\{{ARCHIVE_FILENAME_EXTRACTED_FILES}}\*
    #  OR
    #   E:\User\JackMass\Documents\{{DESIRED_OUTPUT}}\{{FILENAME_EXTRACTED_FILES}}{{DATE_TIME_STAMP}}\*
    #
    #  Extract Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/extract.htm
    # -------------------------------
    # Input:
    #  [string] Target File
    #   The requested archive data file that will be extracted.
    #  [string] Output Path
    #   The absolute path of where to extract all of the contents within the desired
    #    archive file.
    #  [string] (REFERENCE) Directory Output
    #   The extracting directory's absolute path of where the contents of the archive file
    #    have been placed within the system's filesystem.  This path will be returned back
    #    to the calling function.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = A failure occurred while extracting contents from the archive file.
    #    $true  = Successfully extracted contents from the archive file.
    # -------------------------------
    #>
    [bool] ExtractArchive([string] $file, `         # The archive file we want to extract the data from.
                        [string] $outputPath, `     # The desired path we want to store the extracted data.
                        [ref] $directoryOutput)     # The extracting directory of where the contents had been placed.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $finalOutputPath = $null;                                  # This will contain the absolute path of the output (extracted) directory.
        [string] $getDateTime = $null;                                      # Holds the date and time, though only used when needing to create a
                                                                            #  unique output directory name.
        [string] $fileName = `                                              # Get the filename of the archive file without the path nor file extension.
          [string]([System.IO.Path]::GetFileNameWithoutExtension($file));
        [string] $fileNameExt = [string](Split-Path $file -leaf);           # Get only the filename and file extension of the archive file.
        [string] $sourceDir = [string]((Get-Item $file).DirectoryName);     # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = "x `"$($file)`"";                            # Arguments to be used when invoking the 7Zip executable.
                                                                            #  This will allow 7Zip to extract all of the files that are present within
                                                                            #  the desired archive data file to the requested output path.
        [string] $execReason = "Extracting $($fileNameExt)";                # Description; used for logging
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to extract the archive data file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tArchive data to Extract: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : 7Zip Logging Directories


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($this.Detect7ZipExist() -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to extract the archive data file; unable to find the 7Zip Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application was not found, it is not possible to extract the requested archive data file.`r`n" + `
                                        "`tArchive data file to Extract: $($file)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the 7Zip application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the archive data file exists within the provided path.
        if ([CommonIO]::CheckPathExists($file, $true) -eq $false)
        {
            # The archive data file does not exist with the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to extract the archive data file as the compact file was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The archive data file was not found with the given path.`r`n" + `
                                        "`tAbsolute Path of the Archive file: $($file)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # It is not possible to extract the archive file as it was not found.
            return $false;
        } # if : Target file does not exist


        # Make sure that the output path exists with the path provided.
        if ([CommonIO]::CheckPathExists($outputPath, $true) -eq $false)
        {
            # The extract directory does not exist with the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to extract the archive data file because the output path does not exist!";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The extract output directory path does not exist with the provided path.`r`n" + `
                                        "`tAbsolute Path of the Archive file: $($file)`r`n" + `
                                        "`tAbsolute Path of the Extracted Directory: $($outputPath)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # The output path does not exist; we cannot extract the contents.
            return $false;
        } # if : Output Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -



        # CREATE THE OUTPUT DIRECTORY
        # - - - - - - - - - - - - - -
        # Before the archive data file can be extracted, the extracting directory must be created first.  The
        #  extracting directory's path will be within the output path requested, but the name of the extracting
        #  directory will be the same as the filename from the compressed file that is being extracted from.
        #  The exception to this rule is when the extracting directory's name already exists within the output
        #  path, then a timestamp will be appended to the directory's name instead to keep the names unique.
        # ---------------------------


        # Prepare the extracting directory path.
        #  OutputPath + Filename
        $finalOutputPath = "$($outputPath)\$($fileName)";


        # Does the extracting output directory already exist?
        if ([CommonIO]::CheckPathExists($finalOutputPath, $true) -eq $false)
        {
            # Because the extracting directory has a unique name, it will be used as the final output path.

            # Create the new extracting directory
            if([CommonIO]::MakeDirectory($finalOutputPath) -eq $false)
            {
                # A failure occurred while trying to create the new extracting directory.  Because of this
                #  failure, it is not possible to continue this operation.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Unable to extract the archive data file because the extracting directory could not be created!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Requested archive file to extract: $($file)`r`n" + `
                                            "`tOutput Directory: $($outputPath)`r`n" + `
                                            "`tAbsolute Path of Extracting Directory: $($finalOutputPath)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Because the extracting directory could not be created, it is not possible to proceed any further.
                return $false;
            } # INNER-if : Failed to create directory
        } # if : Does the output already exists?

        # The output directory already exists
        else
        {
            # Because the directory already exists, it must be revised in order to make it unique.
            #  To accomplish this task a timestamp will be attached to the directory to make it unique
            #  while giving the data 'meaning' to it.
            #  Date and Time Format Scheme:
            #  DD-MMM-YYYY_HH-MM-SS ~~> 09-Feb-2007_01-00-00
            $getDateTime = [string](Get-Date -UFormat "%d-%b-%Y_%H-%M-%S");

            # Now attach the timestamp to the name:
            $finalOutputPath = "$($finalOutputPath)_$($getDateTime)";

            # Now try to make the directory, if this fails - it is not possible to continue any further.
            if([CommonIO]::MakeDirectory($finalOutputPath) -eq $false)
            {
                # A failure occurred while trying to create the new extracting directory.  Because of this
                #  failure, it is not possible to continue this operation.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Unable to extract the archive data file because the extracting directory could not be created!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Requested archive file to extract: $($file)`r`n" + `
                                            "`tOutput Directory: $($outputPath)`r`n" + `
                                            "`tAbsolute Path of Extracting Directory: $($finalOutputPath)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Because the extracting directory could not be created, it is not possible to proceed any further.
                return $false;
            } # INNER-if : Failed to create directory (x2)
        } # else : Make a Unique Directory


        # Now save the output path to our reference (pointer) variable, this will allow the
        #  calling function to get the absolute path of where the directory resides.
        #  Thus, the calling function can bring the new directory to the user's
        #  attention using whatever methods necessary.
        $directoryOutput.Value = $finalOutputPath;


        # ---------------------------
        # - - - - - - - - - - - - - -



        # EXECUTE THE 7ZIP EXTRACT TASK
        # - - - - - - - - - - - - - - -
        # -----------------------------

        # Attach the extracting output directory to the extCMD Arguments
        $extCMDArgs = "$($extCMDArgs) -o`"$($finalOutputPath)`"";

        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # 7Zip Executable Path
                                        $extCMDArgs, `                  # Arguments to extract the desired archive data file.
                                        $sourceDir, `                   # The working directory that 7Zip will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running 7Zip; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $false, `                       # Do we need to capture the STDOUT so we can process it further?
                                        $null) -ne 0)                   # Variable containing the STDOUT; if we need to process it.
        {
            # 7Zip reached an error


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to extract the data within the archive file!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested archive data file to extract: $($file)`r`n" + `
                                        "`tOutput Directory: $($outputPath)`r`n" + `
                                        "`tAbsolute Path of Extracting Directory: $($finalOutputPath)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `       # Initial message
                                        $logAdditionalMSG, `   # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # The operation had failed -- the archive file was not extracted.
            return $false;
        } # if : Extraction Operation Failed


        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation
        return $true;
    } # ExtractArchive()




   <# Create Archive File
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to create a new archive data
    #   file by using the 7Zip application.  Though, this functionality
    #   only works with bulk operations instead of minor additions by
    #   updating an already existing archive file.  Meaning, this function
    #   mainly accepts a parent directory that already contains all of the
    #   files and subdirectories that will be added into the compressed file.
    #
    #  Extract Files Information:
    #    https://sevenzip.osdn.jp/chm/cmdline/commands/add.htm
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The name of the archive file that will be created during this operation.
    #  [string] Output Path
    #   The path to place the newly created archive data file.
    #  [string] Target Directory
    #   The root of the directory that contains all of the data that we want to compact
    #    into a single archive data file.
    #   NOTE: This argument might contain wildcards, for example:
    #       D:\Users\Admin\Desktop\TopSecret\*.*
    #  [string] (REFERENCE) Archive File Path
    #   This will hold the absolute path, including the file name, of the newly
    #    created archive file's final destination within the system's filesystem.
    #    This path will be returned back to the calling function.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = A failure occurred while creating the archive file.
    #    $true  = Successfully created the archive file.
    # -------------------------------
    #>
    [bool] CreateArchive([string] $archiveFileName, `       # The name of the archive that will be created.
                        [string] $outputPath, `             # The destination path of the archive file.
                        [string] $targetDirectory, `        # The directory we want to compact; may contain wildcards.
                        [ref] $archivePath)                 # The full path of the archive file's location.
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $sourceDir = [string](Get-Item $targetDirectory);  # The Working Directory for the 7Zip executable.
        [string] $extCMDArgs = $null;                               # Arguments to be used when invoking the 7Zip executable.
                                                                    #  This will allow 7Zip to create a new archive data
                                                                    #  file, a bulk operation, by targeting the requested
                                                                    #  directory.
        [string] $execReason = "Creating $($archiveFileName)";      # Description; used for logging
        [string] $getDateTime = $null;                              # Holds the date and time, though only used when needing to create a
                                                                    #  unique archive file name if necessary.
        [string] $archiveFileExtension = $null;                     # Contains the File Extension to be used for the archive filename.
        [string] $archiveFileNameFull = $null;                      # This will contain the absolute path of the archive data file's
                                                                    #  final destination. output (extracted) directory.
        # ----------------------------------------


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create the archive data file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tAbsolute Path of the Target Directory: $($targetDirectory)`r`n" + `
                                        "`tRequested Archive File to Create: $($archiveFileName)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : 7Zip Logging Directories


        # Make sure that the 7Zip executable has been detected and is presently ready to be used.
        if ($this.Detect7ZipExist() -eq $false)
        {
            # The 7Zip executable was not detected.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create the archive data file; unable to find the 7Zip Application!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the 7Zip application was not found, it is not possible to create a new archive data file as requested.`r`n" + `
                                        "`tAbsolute Path of the Target Directory: $($targetDirectory)`r`n" + `
                                        "`tRequested Archive File to Create: $($archiveFileName)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the 7Zip application was not found, return an error to signify that the operation had failed.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the output directory exists within the provided path.
        if ([CommonIO]::CheckPathExists($outputPath, $true) -eq $false)
        {
            # The output directory does not exist with the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create the archive data file as the output directory was not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The output directory was not found within the given path.`r`n" + `
                                        "`tPath of the Output Directory: $($outputPath)`r`n" + `
                                        "`tPath of the Target Directory: $($targetDirectory)`r`n" + `
                                        "`tRequested Archive File to Create: $($archiveFileName)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure to signal that an error was reached.
            return $false;
        } # if : Output directory does not exist


        # Make sure that the Target Directory, the data to be compacted, exists within the provided path.
        if ([CommonIO]::CheckPathExists($targetDirectory, $true) -eq $false)
        {
            # The Target Directory does not exist within the provided path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create the archive data file because the Target Directory does not exist!";


            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("The Target Directory path does not exist with the provided path.`r`n" + `
                                        "`tPath of the Target Directory: $($targetDirectory)`r`n" + `
                                        "`tRequested Archive File to Create: $($archiveFileName)");


            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the Target Directory does not exist, the operation must be aborted.
            return $false;
        } # if : Target Directory does not exist

        # ---------------------------
        # - - - - - - - - - - - - - -



        # DETERMINE THE ARCHIVE FILE EXTENSION
        # - - - - - - - - - - - - - - - - -
        # Try to figure out what File Extension that will be attached to the archive file name.
        #
        # NOTE: This is configured to respect the file extension convention that were set as a
        #        standard by the (G)ZDoom engine.  For more details regarding the file extension
        #        standards, please view the ZDoom Wiki:
        #           https://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement
        # ---------------------------------

        # Inspect the user's preferred compiling method
        switch ($this.GetCompressionMethod())
        {
            ([SevenZipCompressionMethod]::Zip)
            {
                # Zip {PK3} Compression Method
                $archiveFileExtension = "pk3";
                break;
            } # Zip | PK3

            ([SevenZipCompressionMethod]::SevenZip)
            {
                # 7Zip {PK7} Compression Method
                $archiveFileExtension = "pk7";
                break;
            } # 7Zip | PK7

            default
            {
                # The compression method that was chosen - is unknown.  It is not possible to continue
                #  any further, the choice must be either a Zip or 7Zip archive data file format.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Unable to create the archive data file as the requested compression method was unsupported!";


                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("The supported compression methods are the following:`r`n" + `
                                            "`t`t> Zip (PK3)`r`n" + `
                                            "`t`t> 7Zip (7Zip)`r`n" + `
                                            "`r`n" + `
                                            "`tPlease be sure that your settings are set to use either of these compression methods.`r`n" + `
                                            "`tFor more information regarding the Compression Methods, please see the ZDoom Wiki:`r`n" + `
                                            "`t`thttps://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement`r`n" + `
                                            "`r`n" + `
                                            "`tDesired Compression Method: $($this.GetCompressionMethod())`r`n" + `
                                            "`tPath of the Target Directory: $($targetDirectory)`r`n" + `
                                            "`tRequested Archive File to Create: $($archiveFileName)");


                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage($logMessage, `                # Message to display
                                            [LogMessageLevel]::Error);  # Message level

                # Alert the user through a message box as well that an issue had occurred;
                #   the message will be brief as the full details remain within the terminal.
                [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

                # * * * * * * * * * * * * * * * * * * *


                # Because the desired compression method in is not supported, it is not possible to continue any further.
                #  The user must reconfigure their settings to the supported compression methods.
                return $false;
            } # Unknown
        } # switch


        # ---------------------------------
        # - - - - - - - - - - - - - - - - -



        # DETERMINE THE ARCHIVE FILE NAME
        # - - - - - - - - - - - - - -
        # Try to determine a unique filename for the archive data file.  The archive file will be placed within
        #  the requested output directory, but the name of the archive file needs to be unique when placed within
        #  the output directory.  The file name is unique when it is the only filename within the output directory.
        #  If a file within the output directory - already contains the exact same name, then the filename is no
        #  longer unique.  When this scenario happens, merely attach a timestamp on the archive data file name.
        #  This will greatly help to accomplish making the filename of the archive data file unique.  However,
        #  in a rare occurrence, if the name and the timestamp attached is still not enough to make the filename
        #  unique, then the operation will fail.
        # ---------------------------


        # Prepare the filename of the archive data file.
        #  OutputPath + Archive Filename
        $archiveFileNameFull = "$($outputPath)\$($archiveFileName).$($archiveFileExtension)";


        # Does the desired filename already exist within the output directory?
        if ([CommonIO]::CheckPathExists($archiveFileNameFull, $true) -eq $true)
        {
            # Because there already exists a file with the same filename within the
            #  output directory, a timestamp will be attached to the filename.  This
            #  will help to make the filename unique.  Additionally, this will help to
            #  provide meaning to the file.  The user will be able to easily recognize
            #  the archive file by keeping the base filename with the timestamp
            #  attached to it.
            #  Date and Time Format Scheme:
            #  DD-MMM-YYYY_HH-MM-SS ~~> 09-Feb-2007_01-00-00
            $getDateTime = [string](Get-Date -UFormat "%d-%b-%Y_%H-%M-%S");

            # Recreate the filename with the timestamp attached to it.
            $archiveFileNameFull = "$($outputPath)\$($archiveFileName)_$($getDateTime).$($archiveFileExtension)";

            if ([CommonIO]::CheckPathExists($archiveFileNameFull, $true) -eq $true)
            {
                # Because there already exists a file already with the same filename
                #  (including timestamp), it is not possible to move forward at this time.
                #  It is not possible to make a unique filename for the archive data file.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Unable to create the archive data file as a filename couldn't be finalized!";


                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Unable to make a unique filename for the archive data file!`r`n" + `
                                            "`tRequested Archive File to Create: $($archiveFileName)`r`n" + `
                                            "`tProposed filename of the archive file: $($archiveFileNameFull)`r`n" + `
                                            "`tPath of the Output Directory: $($outputPath)`r`n" + `
                                            "`tPath of the Target Directory: $($targetDirectory)`r`n");


                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level


                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage($logMessage, `                # Message to display
                                            [LogMessageLevel]::Error);  # Message level


                # Alert the user through a message box as well that an issue had occurred;
                #   the message will be brief as the full details remain within the terminal.
                [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

                # * * * * * * * * * * * * * * * * * * *


                # Because a unique filename could not be created, abort the operation.
                return $false;
            } # INNER-if : Filename (with Timestamp) Already Exists at Output Path
        } # if : Filename Already Exists at Output Path


        # Now save the output path to our reference (pointer) variable, this will allow the
        #  calling function to get the absolute path of where the archive data file resides.
        #  Thus, the calling function can bring the new archive file to the user's attention
        #  using whatever methods necessary.
        $archivePath.Value = $archiveFileNameFull;


        # ---------------------------
        # - - - - - - - - - - - - - -



        # GENERATE THE ARGUMENTS
        # - - - - - - - - - - - -
        # Generate the arguments to use when calling the 7Zip application.  The arguments
        #  will be crafted based upon the user's preferences for using 7Zip.
        # -----------------------


        # Since we are going to create a new archive data file, use the add 'a' switch.
        $extCMDArgs = "a";


        # Attach the archive file name
        $extCMDArgs = "$($extCMDArgs) `"$($archiveFileNameFull)`"";


        # Attach the target directory
        $extCMDArgs = "$($extCMDArgs) `"$($targetDirectory)`"\*";



        # Determine the desired compression method and the compression algorithm that will
        #  be utilized for this operation.
        switch ($this.GetCompressionMethod())
        {
            ([SevenZipCompressionMethod]::Zip)
            {
                # Zip {PK3} Compression Method
                $extCMDArgs = "$($extCMDArgs) -tzip -mm=$($this.GetAlgorithmZip())";
                break;
            } # Zip | PK3


            ([SevenZipCompressionMethod]::SevenZip)
            {
                # 7Zip {PK7} Compression Method
                $extCMDArgs = "$($extCMDArgs) -t7z -mm=$($this.GetAlgorithm7Zip())";
                break;
            } # 7Zip | PK7


            default
            {
                # The desired compression method is unknown.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Unable to create the archive data file as the compression method is not supported!";


                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("The desired compression method is not supported for this operation!`r`n" + `
                                            "`tSelected Compression Method: $($this.GetCompressionMethod())`r`n" + `
                                            "`t7Zip Arguments Generated thus far: $($extCMDArgs)`r`n" + `
                                            "`tRequested Archive File to Create: $($archiveFileName)");


                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level


                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage($logMessage, `                # Message to display
                                            [LogMessageLevel]::Error);  # Message level

                # Alert the user through a message box as well that an issue had occurred;
                #   the message will be brief as the full details remain within the terminal.
                [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

                # * * * * * * * * * * * * * * * * * * *


                # Because the compression method is not supported, the operation will fail.
                return $false;
            } # Unknown
        } # switch



        # Now append the desired compression level
        switch ($this.GetCompressionLevel())
        {
            ([SevenZipCompressionLevel]::Store)
            {
                # No Compression
                $extCMDArgs = "$($extCMDArgs) -mx=0";
                break;
            } # Store {No Compression}

            ([SevenZipCompressionLevel]::Minimal)
            {
                # Minimal Compression
                $extCMDArgs = "$($extCMDArgs) -mx=3";
                break;
            } # Minimal Compression

            ([SevenZipCompressionLevel]::Normal)
            {
                # Standard Compression
                $extCMDArgs = "$($extCMDArgs) -mx=5";
                break;
            } # Standard Compression

            ([SevenZipCompressionLevel]::Maximum)
            {
                # Maximum-as-possible Compression
                $extCMDArgs = "$($extCMDArgs) -mx=9";
                break;
            } # Maximum Compression

            Default
            {
                # The desired compression value is unknown.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Unable to create the archive data file as the compression level was unknown!";


                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("The desired compression level is not supported!`r`n" + `
                                            "`tSelected Compression Level: $($this.GetCompressionLevel())`r`n" + `
                                            "`t7Zip Arguments Generated thus far: $($extCMDArgs)`r`n" + `
                                            "`tRequested Archive File to Create: $($archiveFileName)");


                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level


                # Display a message to the user that something went horribly wrong
                #  and log that same message for referencing purpose.
                [Logging]::DisplayMessage($logMessage, `                # Message to display
                                            [LogMessageLevel]::Error);  # Message level


                # Alert the user through a message box as well that an issue had occurred;
                #   the message will be brief as the full details remain within the terminal.
                [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

                # * * * * * * * * * * * * * * * * * * *


                # Because the compression level is unknown or not supported, the operation must be aborted.
                return $false;
            } # Unknown Value
        } # switch : Compression Level


        # -----------------------
        # - - - - - - - - - - - -



        # EXECUTE THE 7ZIP CREATION TASK
        # - - - - - - - - - - - - - - -
        # -----------------------------


        # Execute the command
        if ([CommonIO]::ExecuteCommand($this.GetExecutablePath(), `     # 7Zip Executable Path
                                        $extCMDArgs, `                  # Arguments to generate the desired archive data file
                                        $sourceDir, `                   # The working directory that the 7Zip will start from.
                                        $this.GetLogPath(), `           # The Standard Output Directory Path.
                                        $this.GetLogPath(), `           # The Error Output Directory Path.
                                        $this.GetReportPath(), `        # The Report Directory Path.
                                        $execReason, `                  # The reason why we are running 7Zip; used for logging purposes.
                                        $false, `                       # Are we building a report?
                                        $false, `                       # Do we need to capture the STDOUT so we can process it further?
                                        $null) -ne 0)                   # Variable containing the STDOUT; if we need to process it.
        {
            # 7Zip reached an error.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while trying to create the archive data file!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Requested Archive File to Create: $($archiveFileName)`r`n" + `
                                        "`tProposed filename of the archive file: $($archiveFileNameFull)`r`n" + `
                                        "`tPath of the Output Directory: $($outputPath)`r`n" + `
                                        "`tPath of the Target Directory: $($targetDirectory)`r`n" + `
                                        "`t7Zip Arguments: $($extCMDArgs)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # Display a message to the user that something went horribly wrong
            #  and log that same message for referencing purpose.
            [Logging]::DisplayMessage($logMessage, `                # Message to display
                                        [LogMessageLevel]::Error);  # Message level

            # Alert the user through a message box as well that an issue had occurred;
            #   the message will be brief as the full details remain within the terminal.
            [CommonGUI]::MessageBox($logMessage, [System.Windows.MessageBoxImage]::Hand) | Out-Null;

            # * * * * * * * * * * * * * * * * * * *


            # Return signal that the operation had failed.
            return $false;
        } # if : Archive File Creation Failed


        # -----------------------------
        # - - - - - - - - - - - - - - -


        # Successfully finished the operation.
        return $true;
    } # CreateArchive()

    #endregion



    #region Report

   <# Create a new Report
    # -------------------------------
    # Documentation:
    #  This function will create a report based upon the archive data file that
    #   is provided when calling this function.
    #  The report will contain information regarding the archive file.  The
    #   information may contain a list of files that resides within the archive
    #   datafile, typical hashes data of the archive file itself, and any general
    #   details that might be useful for inspection purposes.
    # -------------------------------
    # Input:
    #  [string] Archive File
    #   The archive file that will be used to generate the report; this is our
    #    target file.
    #  [string] (REFERENCE) Return the File Path [Text File]
    #   Returns the full path of the generated TXT report file.  Useful to
    #    provide a full location as to where the report resides within the host's
    #    filesystem.
    #  [string] (REFERENCE) Return the File Path [Portable Document File]
    #   Returns the full path of the generated PDF report file.  Useful to
    #    provide a full location as to where the report resides within the host's
    #    filesystem.
    # -------------------------------
    # Output:
    #  [bool] Status Code
    #    $false = Failure occurred while generating the report.
    #    $true  = Successfully created the report or user did not request to
    #               generate a report.
    # -------------------------------
    #>
    [bool] CreateNewReport([string] $archiveFile, `     # The archive file that we will generate a report from.
                           [ref] $returnFilePathTXT, `  # Returns the report's path (TXT)
                           [ref] $returnFilePathPDF)    # Returns the report's path (PDF)
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Get the filename without the path, extension is kept.
        [string] $fileNameExt = [string](Split-Path $ArchiveFile -leaf);


        # The following variables will hold the current date and time from the host system.
        #  With this, it will be available for the filename and inside the report.
        # - - - -
        # >> Date
        [string] $dateNow = [string](Get-Date -UFormat "%d-%b-%y");
        # >> Time
        [string] $timeNow = [string](Get-Date -UFormat "%H.%M.%S");
        # >> Date && Time
        [string] $dateTime = "$($dateNow) $($timeNow)";
        # - - - -


        # The following variables will hold the report's filename.
        # - - - -
        # >> Standard Textfile
        [string] $fileNameTXT = "$($this.GetReportPath())\$($fileNameExt) - $($dateTime).txt";

        # >> Portable Document File (PDF)
        [string] $fileNamePDF = "$($this.GetReportPath())\$($fileNameExt) - $($dateTime).pdf";
        # - - - -


        # Prepare the reference variables with the report file names (with path)
        # - - - -
        # >> Standard Textfile
        $returnFilePathTXT.Value = $fileNameTXT;

        # >> Portable Document File (PDF)
        #  Make sure that the user wanted a PDF file before assuming to provide the path.
        if ($this.GetGenerateReportFilePDF())
        {
            # User requested to generate a report using the PDF format
            $returnFilePathPDF.Value = $fileNamePDF;
        } # if : Make PDF Report
        # - - - -


        # This variable will hold the output provided by the various function calls that are used in this method.
        #  Because some of the information provided might be excessively large, we will only store one chunk of
        #  data at a time throughout the entire process.  It might be possible to store multiple chunks into this
        #  variable in one shoot, but we will require much more resources from the host's system main memory.  Lets
        #  try to conserve the user's primary storage.
        # NOTE: CLR String Datatypes can reach ~3GB of memory usage.
        [string] $outputContent = $null;


        # This will be used to jump from one case to another; this will greatly help to keep the procedure organized.
        #  Essentially this variable will drive the structure of the report, but in a proper sequential manner.
        [int] $traverse = 0;


        # This variable will contain a border that will visually help to separate each section of the report.  With
        #  this defined in this way, we can cut code redundancy without having type it over and over again through
        #  out this entire function.
        [string] $sectionBorder = ("------------------------------`r`n" + `
                                    "==============================`r`n" + `
                                    "==============================`r`n");


        # This variable will be used as our break to escape the do-while loop; when we are finished generating the
        #  report - this variable will allow us to move forward into the final stages of completing the newly created
        #  report.
        [bool] $readyToBreak = $false;
        # ----------------------------------------



        # Did the user want a report of the archive data file?
        if ($this.GetGenerateReport() -eq $false)
        {
            # The user does not wish to have a report generated; we will abort this operation by request.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = ("Unable to create the report because the user does not request to" + `
                                    " generate one (User Settings).");

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Current User Setting: $($this.GetGenerateReport())`r`n" + `
                                        "`tRequested file to generate a report: $($archiveFile)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the user did not want a report generated, merely return 'true'.
            return $true;
        } # if : Do not create report


        # Dependency Check
        # - - - - - - - - - - - - - -
        #  Make sure that all of the resources are available before trying to use them
        #   This check is to make sure that nothing goes horribly wrong.
        # ---------------------------

        # Make sure that the 7Zip Logging directories are ready for use (if required)
        if ($this.__CreateDirectories() -eq $false)
        {
            # Because the logging directories could not be created, we cannot log.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create a report on the archive data file due to logging complications!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Because the logging directories for 7Zip could not be created," + `
                                        " nothing can be logged as expected.`r`n" + `
                                        "`tTo resolve the issue:`r`n" + `
                                        "`t`t- Make sure that the required logging directories are created.`r`n" + `
                                        "`t`t- OR Disable logging`r`n" + `
                                        "`tRequested file to generate a report: $($archiveFile)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the logging features are required, we cannot run the operation.
            return $false;
        } # If : Logging Requirements are Met


        # Make sure that the 7Zip executable was detected.
        if ($this.Detect7ZipExist() -eq $false)
        {
            # Because 7Zip was not detected, it is not possible to proceed any further
            #  as the application is required to analyze and inspect the files within
            #  the archive data file.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create a report on the archive data file; unable to find the 7Zip Executable!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Be sure that the 7Zip application is presently installed and assure that this program is able to detect the executable.`r`n" + `
                                        "`tRequested file to generate a report: $($archiveFile)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because 7Zip was not found, it is not possible to proceed any further.
            return $false;
        } # if : 7Zip was not detected


        # Make sure that the target archive file exists.
        if ([CommonIO]::CheckPathExists($ArchiveFile, $true) -eq $false)
        {
            # The target archive data file does not exist; we cannot perform a report on something
            #  when that file simply does not exist with the given file path.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to create a report on the archive data file because the target file does not exist!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = "Requested file to generate a report: " + $archiveFile;

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Return a failure as the target file does not exist.
            return $false;
        } # if : Target Archive File does not Exist


        # ---------------------------
        # - - - - - - - - - - - - - -


        # Generate the Report (Procedure Methodology)
        #  This loop will help us to stay organized as we traverse through each step.
        DO
        {
            # Sequential steps
            switch ($traverse)
            {
                # Report Header
                0
                {
                    # Prepare the message that we will write to the report.
                    # Word Art for the report's header were provided by this website:
                    #  http://patorjk.com/software/taag
                    #  FONT: Big
                    #  All other settings set to 'default'.
                    $outputContent = ("+-------------------------------------------------------------------------+`r`n" + `
                                      "|  ______ ___________ _____    _____  ______ _____   ____  _____ _______  |`r`n" + `
                                      "| |____  |___  /_   _|  __ \  |  __ \|  ____|  __ \ / __ \|  __ \__   __| |`r`n" + `
                                      "|     / /   / /  | | | |__) | | |__) | |__  | |__) | |  | | |__) | | |    |`r`n" + `
                                      "|    / /   / /   | | |  ___/  |  _  /|  __| |  ___/| |  | |  _  /  | |    |`r`n" + `
                                      "|   / /   / /__ _| |_| |      | | \ \| |____| |    | |__| | | \ \  | |    |`r`n" + `
                                      "|  /_/   /_____|_____|_|      |_|  \_\______|_|     \____/|_|  \_\ |_|    |`r`n" + `
                                      "+-------------------------------------------------------------------------+`r`n" + `
                                      "`r`n`r`n" + `
                                      "Synopsis`r`n" + `
                                      "----------`r`n" + `
                                      "This report was generated on $($dateNow) at $($timeNow) for the archive file" + `
                                      " named '$($fileNameExt)'.  This report contains an overview of what is within" + `
                                      " the archive data file and information regarding the file itself.  The information" + `
                                      " provided can be helpful for validation purposes and assuring that the archive data" + `
                                      " file itself was not damaged." + `
                                      "`r`n`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Header to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested file to generate a report: $($archiveFile)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the report's Header
                    break;
                } # Case : Report Header



                # Table of Contents
                1
                {
                    # Build the output
                    $outputContent = "Table of Contents:`r`n" + `
                                     "---------------------`r`n" + `
                                     "1) Project Information`r`n" + `
                                     "2) Archive File Information`r`n" + `
                                     "3) File Hash Details`r`n" + `
                                     "4) List of Files inside Archive`r`n" + `
                                     "`r`n`r`n";


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Table of Contents to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested file to generate a report: $($archiveFile)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the report's Table of Contents
                    break;
                } # Case : Table of Contents



                # Project Information
                2
                {
                    # Prepare the message that we will write to the report.
                    $outputContent = ("1) PROJECT INFORMATION`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is information regarding the project.`r`n`r`n" + `
                                     "Project Name:`r`n" + `
                                     "`t$([ProjectInformation]::projectName)`r`n`r`n" + `
                                     "Project Code Name:`r`n" + `
                                     "`t$([ProjectInformation]::codeName)`r`n`r`n" + `
                                     "Filename:`r`n" + `
                                     "`t$([ProjectInformation]::fileName)`r`n`r`n" + `
                                     "Project Website:`r`n" + `
                                     "`t$([ProjectInformation]::urlWebsite)`r`n`r`n" + `
                                     "Project's Documentation:`r`n" + `
                                     "`t$([ProjectInformation]::urlWiki)`r`n`r`n" + `
                                     "Project's Repository:`r`n" + `
                                     "`t$([ProjectInformation]::urlSource)`r`n" + `
                                     "`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Project Information to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested file to generate a report: $($archiveFile)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the report's Project Information
                    break;
                } # Case : Project Information



                # Archive Information
                3
                {
                    # Prepare the message that we will write to the report.
                    $outputContent = ("2) ARCHIVE FILE INFORMATION`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is information regarding the archive file.  This information can" + `
                                     " be helpful to know the properties of the archive data file itself.`r`n`r`n" + `

                                     "File Property Information:`r`n" + `
                                     "File Base Name:`r`n" + `
                                     "  $($(Get-Item $archiveFile).BaseName)`r`n`r`n" + `
                                     "File Exists in Directory:`r`n" + `
                                     "  $($(Get-Item $archiveFile).DirectoryName)`r`n`r`n" + `
                                     "File Created:`r`n" + `
                                     "  $($(Get-Item $archiveFile).CreationTime)`r`n`r`n" + `
                                     "File Created (UTC):`r`n" + `
                                     "  $($(Get-Item $archiveFile).CreationTimeUtc)`r`n`r`n" + `
                                     "File Attributes:`r`n" + `
                                     "  $($(Get-Item $archiveFile).Attributes)`r`n`r`n" + `
                                     "Size of File:`r`n" + `
                                     "  $($(Get-Item $archiveFile).Length) bytes`r`n`r`n");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the Archive Information to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested file to generate a report: $($archiveFile)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the report's Archive Information
                    break;
                } # Case : Archive Information



                # File Hash Information
                4
                {
                    # Prepare the message that we will write to the report.
                    $outputContent = ("3) FILE HASH INFORMATION`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "File Hash values are helpful to know if the archive file was: corrupted, damaged," + `
                                     " or altered.  The hash of the file signifies a 'fingerprint', each hash is generally" + `
                                     " unique to that file at the given time it was created or updated.  When the hash" + `
                                     " value is different, in comparison to another version of the same file, it is" + `
                                     " likely that the finger-print has changed or the file itself was damaged\corrupted" + `
                                     " during transfer from one location to the next.`r`n" + `
                                     "Provided below is the list of Hash values regarding $($fileNameExt)." + `
                                     "`r`n`r`n" + `

                                     "File Hash Information:`r`n" + `
                                     "$($this.FetchHashInformation($archiveFile))");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the File Hash Information to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested file to generate a report: $($archiveFile)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Finished with the report's File Hash Information
                    break;
                } # Case : File Hash Information



                # List of Files Within the Archive File
                5
                {
                    # Prepare the message that we will write to the report.
                    $outputContent = ("4) LIST OF FILES INSIDE THE ARCHIVE FILE`r`n" + `
                                     "$($sectionBorder)`r`n`r`n" + `
                                     "Provided below is a list of files that exists within the archive data file." + `
                                     "`r`n`r`n" + `

                                     "List of Files inside $($fileNameExt):`r`n" + `
                                     "$($this.ListFiles($archiveFile, $true))");


                    # Write the message to the report file
                    if ([CommonIO]::WriteToFile($fileNameTXT, $outputContent) -eq $false)
                    {
                        # Because there was failure while writing to the report file, we cannot proceed any further.


                        # * * * * * * * * * * * * * * * * * * *
                        # Debugging
                        # --------------

                        # Generate the initial message
                        [string] $logMessage = "Unable to write the List of Files Inside the Archive File to the report!";

                        # Generate any additional information that might be useful
                        [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                                    "`tIteration Step: $($traverse)`r`n" + `
                                                    "`tRequested file to generate a report: $($archiveFile)`r`n" + `
                                                    "`tTried to write to report file: $($fileNameTXT)`r`n" + `
                                                    "`tInformation to write:`r`n" + `
                                                    "$($outputContent)");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                        # * * * * * * * * * * * * * * * * * * *


                        # Failure occurred while writing to the file.
                        return $false;
                    } # If : Failure to write file


                    # Increment the traverse variable; proceed to the next step.
                    $traverse++;


                    # Jump out of the Loop key; without this flag - a Run-Away will occur.
                    $readyToBreak = $true;


                    # Finished with the report's File Hash Information
                    break;
                } # Case : List of Files Within the Archive File



                # Default - ERROR; Run Away
                default
                {
                    # Something went horribly wrong
                    #  In normal cases, we should _NEVER_ reach this point.


                    # * * * * * * * * * * * * * * * * * * *
                    # Debugging
                    # --------------

                    # Generate the initial message
                    [string] $logMessage = "Run-Away had occurred while generating the requested report!";

                    # Generate any additional information that might be useful
                    [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                                "`tIteration Step: $($traverse)`r`n" + `
                                                "`tRequested file to generate a report: $($archiveFile)`r`n" + `
                                                "`tTried to write to report file: $($fileNameTXT)`r`n");

                        # Pass the information to the logging system
                        [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                                    $logAdditionalMSG, `        # Additional information
                                                    [LogMessageLevel]::Error);  # Message level

                    # * * * * * * * * * * * * * * * * * * *


                    # Because a Run-Away occurred,
                    return $false;
                } # Case : Default
            } # switch()
        } While ($readyToBreak -eq $false);



        # Does the user also want a PDF file of the report?
        if ($this.GetGenerateReportFilePDF() -eq $true)
        {
            # Create the PDF file as requested
            if([CommonIO]::CreatePDFFile($fileNameTXT, $fileNamePDF) -eq $false)
            {
                # Failure occurred while creating the PDF document.


                # * * * * * * * * * * * * * * * * * * *
                # Debugging
                # --------------

                # Generate the initial message
                [string] $logMessage = "Could not create a PDF file of the report!";

                # Generate any additional information that might be useful
                [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                            "`tReport is based on the archive file: $($archiveFile)`r`n" + `
                                            "`tText file of the report: $($fileNameTXT)`r`n" + `
                                            "`tTried to create PDF file: $($fileNamePDF)");

                # Pass the information to the logging system
                [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                            $logAdditionalMSG, `        # Additional information
                                            [LogMessageLevel]::Error);  # Message level

                # * * * * * * * * * * * * * * * * * * *


                # Because the report could not be made in the PDF format, we will signify an error.
                return $false;
            } # If : Failure while creating PDF
        } # If : Make PDF Report



        # Successfully wrote to the file
        return $true;
    } # CreateNewReport()

    #endregion



    #region File Management

   <# Thrash Logs and Reports
    # -------------------------------
    # Documentation:
    #  This function will expunge any log and report files that were generated by this object.
    #   Such files are only removed, by this function, if their extensions are known within
    #   this function.  For example, if a file extension known in this function is '*.txt'
    #   and '*.docx', only those files will be removed from the logging directories.
    # -------------------------------
    # Input:
    #  [bool] Expunge reports
    #   When this argument is set to true, reports - that were generated by this object - will
    #    be thrashed.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = One or more operations failed.
    #   $true = Successfully expunged the files.
    #           OR
    #           Logging and\or Report directories were not found.
    # -------------------------------
    #>
    [bool] ThrashLogs([bool] $expungeReports)
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string[]] $extLogs = @('*.err', '*.out');      # Array of log extensions
        [string[]] $extReports = @('*.txt', '*.pdf');   # Array of report extensions
        [string] $knownExtensions = $null;              # This will hold a nice string value of all of
                                                        #  the extensions that this function will remove;
                                                        #  extensions being: $extLogs and $extReports combined.
                                                        #  This is primarily used for logging purposes.
        [bool] $exitCode = $true;                       # The exit code status provided by the log\report
                                                        #  deletion operation status.  If the operation
                                                        #  was successful then true will be set, otherwise
                                                        #  it will be false to signify an error.
        # ----------------------------------------


        # Before we start, setup the known extensions variable for logging purposes.
        #  Get all of the known extensions used for logging; $extLogs
        foreach ($item in $extLogs)
        {
            # if this is the first entry in the variable, then just apply the item
            #  to the string without adding a appending the previous entries.
            if ($null -eq $knownExtensions)
            {
                # First entry to the string.
                $knownExtensions = $item;
            }# If: first entry

            # There is already information in the variable, append the new entry to the
            #  previous data.
            else
            {
                # Append the entry to the string list.
                $knownExtensions += ", " + $item;
            } # Else: Append entry
        } # Foreach: Known Logging Extensions


        #  Did the user wanted to remove all report files?
        if ($expungeReports)
        {
            # Get all of the known extensions used for reports; $extReports
            foreach($item in $extReports)
            {
                # Append the entry to the string list.
                $knownExtensions += ", " + $item;
            } # Foreach: Known Report Extensions
        } # If: Reports are included in operation



        # Make sure that the logging directories exist.  If the directories are not
        #  available presently, then there is nothing that can be done at this time.
        if ($this.__CheckRequiredDirectories() -eq $false)
        {
            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Unable to delete the requested files as the logging directories were not found!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Warning);    # Message level

            # * * * * * * * * * * * * * * * * * * *



            # This is not really an error, however the directories simply
            #  does not exist -- nothing can be done.
            return $true;
        } # IF : Required Directories Exists


        # Because the directories exists let's try to thrash the logs.
        if([CommonIO]::DeleteFile($this.GetLogPath(), $extLogs) -eq $false)
        {
            # Reached a failure upon removing the requested log files.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while removing the requested log files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the operation failed, we will update the exit code to 'false'
            #  to signify that we reached an error.
            $exitCode = $false;
        } # If : failure to delete files


        # ----


        # Did the user also wanted to thrash the reports?
        if (($expungeReports -eq $true) -and `
            ([CommonIO]::DeleteFile($this.GetReportPath(), $extReports) -eq $false))
        {
            # Reached a failure upon removing the requested log files.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "A failure occurred while removing the requested report files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `            # Initial message
                                        $logAdditionalMSG, `        # Additional information
                                        [LogMessageLevel]::Error);  # Message level

            # * * * * * * * * * * * * * * * * * * *


            # Because the operation failed, we will update the exit code to 'false'
            #  to signify that we reached an error.
            $exitCode = $false;
        } # If : thrash the reports


        # If everything succeeded, provide this information to the logfile.
        if ($exitCode)
        {
            # The operation was successful, provide the information to the logfile.


            # * * * * * * * * * * * * * * * * * * *
            # Debugging
            # --------------

            # Generate the initial message
            [string] $logMessage = "Successfully expunged the requested files!";

            # Generate any additional information that might be useful
            [string] $logAdditionalMSG = ("Object: 7Zip`r`n" + `
                                        "`tRequested file extensions to delete: $($knownExtensions)");

            # Pass the information to the logging system
            [Logging]::LogProgramActivity($logMessage, `                # Initial message
                                        $logAdditionalMSG, `            # Additional information
                                        [LogMessageLevel]::Verbose);    # Message level

            # * * * * * * * * * * * * * * * * * * *
        } # If: Everything was Successful


        # If we made it here, then everything went okay!
        return $exitCode;
    } # ThrashLogs()

    #endregion
    #endregion
} # SevenZip




<# File Hash Algorithm (7Zip) [ENUM]
 # -------------------------------
 # List of Hash Algorithms that is supported with the 7Zip Application.
 #
 # List of supported hash algorithms:
 #  - https://sevenzip.osdn.jp/chm/cmdline/commands/hash.htm
 # -------------------------------
 #>
enum FileHashAlgorithm7Zip
{
    crc32       = 0; # Cyclic Redundancy Check (32bit)
    crc64       = 1; # Cyclic Redundancy Check (64bit)
    sha1        = 2; # Secure Hash Algorithm 1
    sha256      = 3; # Secure Hash Algorithm 256
    blake2sp    = 4; # BLAKE2sp (Multi-Core)
} # FileHashAlgorithm7Zip




<# 7Zip Compression Method [ENUM]
 # -------------------------------
 # List of compression methods that is supported with the 7Zip application.
 #  Despite that 7Zip may support more compression types, this application
 #  will only focus on a few popular or widely known methods instead.
 #
 # List of all Compression Methods supported by 7Zip
 #  - https://sevenzip.osdn.jp/chm/cmdline/switches/method.htm
 # -------------------------------
 #>
enum SevenZipCompressionMethod
{
    Zip         = 0; # Zip format [PK3]
    SevenZip    = 1; # 7Zip format [PK7]
} # SevenZipCompressionMethod




<# 7Zip Algorithm Zip [ENUM]
 # -------------------------------
 # List of compression algorithms that can be set when utilizing the Compression
 #  Method Zip.  Despite that the 7Zip application may support more compression
 #  algorithms for the Zip method, this application will only focus on a few
 #  popular or widely known methods instead.
 #
 # List of all Compression Algorithms supported by 7Zip
 #  - https://sevenzip.osdn.jp/chm/cmdline/switches/method.htm#Zip
 # -------------------------------
 #>
enum SevenZipAlgorithmZip
{
    Deflate = 0; # Deflate Algorithm
    LZMA    = 1; # LZMA Algorithm
    BZip2   = 2; # BZip2 Algorithm
} # SevenZipAlgorithmZip




<# 7Zip Algorithm 7z [ENUM]
 # -------------------------------
 # List of compression algorithms that can be set when utilizing the Compression
 #  Method 7z.  Despite that the 7Zip application may support more compression
 #  algorithms for the 7z method, this application will only focus on a few
 #  popular or widely known methods instead.
 #
 # List of all Compression Algorithms supported by 7Zip
 #  - https://sevenzip.osdn.jp/chm/cmdline/switches/method.htm#7Z
 # -------------------------------
 #>
enum SevenZipAlgorithm7Zip
{
    LZMA2   = 0; # LZMA2 Algorithm
    LZMA    = 1; # LZMA Algorithm
    BZip2   = 2; # BZip2 Algorithm
    PPMd    = 3; # PPMd Algorithm
} # SevenZipAlgorithm7Zip




<# 7Zip Compression Level [ENUM]
 # -------------------------------
 # List of compression levels that can be utilized when compacting an individual
 #  or a collection of files into a desired archive datafile.  Despite that the
 #  7Zip application may support more compression levels, this application aims
 #  to keep the process simple for the end-user.
 #
 # List of all compression levels supported by 7Zip
 #  - https://sevenzip.osdn.jp/chm/cmdline/switches/method.htm#ZipX
 #  - https://sevenzip.osdn.jp/chm/cmdline/switches/method.htm#SevenZipX
 # -------------------------------
 #>
enum SevenZipCompressionLevel
{
    Store   = 0; # Store [No Compression] {0}
    Minimal = 1; # Minimal compression    {3}
    Normal  = 2; # Standard compression   {5}
    Maximum = 3; # Maximum compression    {9}
} # SevenZipCompressionLevel