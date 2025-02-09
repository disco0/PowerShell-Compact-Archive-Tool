<# PowerShell Compact-Archive Tool
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




<# Common Functions
 # ------------------------------
 # ==============================
 # ==============================
 # This class will hold functions that are commonly used within the program.
 #  Functions provided are in a general form, thus they can be used anywhere
 #  and everywhere - and they provide the same procedure and behavior regardless
 #  where called within the program.
 #>




class CommonFunctions
{
   <# Is 7Zip Available?
    # -------------------------------
    # Documentation:
    #  This function will determine if the 7Zip functionality is available
    #   on the host system.  In order for this operation to work, we will
    #   use the 7Zip object to check if such feature is present.
    # -------------------------------
    # Output:
    #  [bool] 7Zip Availability
    #   When true, this will mean that 7Zip is available and can be used.
    #   False, however, will mean that the 7Zip functionality is not available.
    # -------------------------------
    #>
    static [bool] IsAvailable7Zip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Latch onto the single instance of the 7Zip object
        [SevenZip] $sevenZip = [SevenZip]::GetInstance();
        # ----------------------------------------


        # Return the results from the detection function
        return $sevenZip.Detect7ZipExist();
    } # IsAvailable7Zip()




   <# Is Git Available?
    # -------------------------------
    # Documentation:
    #  This function will determine if the Git functionality is available
    #   on the host system.  In order for this operation to work, we will
    #   use the Git object to check if such feature is present.
    # -------------------------------
    # Output:
    #  [bool] Git Availability
    #   When true, this will mean that Git is available and can be used.
    #   False, however, will mean that the Git functionality is not available.
    # -------------------------------
    #>
    static [bool] IsAvailableGit()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Latch onto the single instance of the Git object
        [GitControl] $gitControl = [GitControl]::GetInstance();
        # ----------------------------------------


        # Return the results from the detection function
        return $gitControl.DetectGitExist();
    } # IsAvailableGit()




   <# Is .NET Core ZIP Archive Available?
    # -------------------------------
    # Documentation:
    #  This function will determine if the .NET Core Zip  functionality
    #   is available on the host system.  In order for this operation
    #   to work, we will use the Default Zip object to check if such
    #   feature is present.
    # -------------------------------
    # Output:
    #  [bool] .NET Core Zip Availability
    #   When true, this will mean that Zip is available and can be used.
    #   False, however, will mean that the Zip functionality is not available.
    # -------------------------------
    #>
    static [bool] IsAvailableZip()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Latch onto the single instance of the Zip object
        [DefaultCompress] $defaultCompress = [DefaultCompress]::GetInstance();
        # ----------------------------------------


        # Return the results from the detection function
        return $defaultCompress.DetectCompressModule();
    } # IsAvailableZip()
} # CommonFunctions