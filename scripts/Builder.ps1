<# Builder
 # ------------------------------
 # ==============================
 # ==============================
 # This class is the heart of the program - in which it allows the
 #  desired project to be compiled into a single archive data file.
 #  The builder will perform various steps to assure that the project
 #  is up to date with the remote repository, assure that all of the
 #  dependencies are ready for use, perform the compiling operation,
 #  verify the integrity of the newly generated archive datafile,
 #  and create any useful documentation as requested.  The user has
 #  full flexibility as to how the Builder operates and with what
 #  capabilities are usable.
 #>



class Builder
{
   <# Build
    # -------------------------------
    # Documentation:
    #  This function is essentially our main driver into creating a
    #   ZDoom based archive datafile generated by using the project's
    #   source files.  Because this function is our main driver into
    #   achieving this goal, we have to assure that the process is
    #   well organized and is keeping the operation - easy to manage.
    #   By doing this, we will want to approach this in a sequential
    #   manner while also checking our work consistently.  Meaning,
    #   in order to compile the project's source files into one single
    #   archive file, we may need to update the source via a Source
    #   Control tool - then we may proceed with compacting the data.
    #   This is only a brief example out of many possible cases now
    #   and as well in the future when and if the functionality were
    #   to expand.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = The Project Build had reached an error.
    #   $true = The Project Build had successfully been created.
    # -------------------------------
    #>
    static [bool] Build ()
    {
        # Before we begin, we must make sure that the required resources
        #  are available for us to use within this operation.
        
        # To avoid compiling issues, we will merely return an error for now.
        return $false;
    } # Builder()




   <# Prerequisite Check
    # -------------------------------
    # Documentation:
    #  The function performs a validation check to assure that all
    #   of the required resources are available for the compiling
    #   process.  If incase we found one or more resources - that
    #   is imperative for the entire operation to work correctly -
    #   then we may ultimately abruptly abort the entire compile
    #   operation.
    # -------------------------------
    # Output:
    #  [bool] Exit code
    #   $false = One or more resources were missing but required.
    #   $true = All of the resources were accounted for and ready.
    # -------------------------------
    #>
    hidden static [bool] PrerequisiteCheck()
    {
        # Declarations and Initializations
        # ----------------------------------------
        # Retrieve the current instance of the User Preferences object; this contains the user's
        #  generalized settings.
        [UserPreferences] $userPreferences = [UserPreferences]::GetInstance();
        # ----------------------------------------


        # Can we find the project's source files?
        if (![CommonIO]::CheckPathExists("$($userPreferences.GetProjectPath())", $true))
        {
            # Unable to find the project's source files; unable to continue.
            return $false;
        } # if : Check Project source files exists


        # Can we find the output path?
        if (![CommonIO]::CheckPathExists("$($userPreferences.GetProjectBuildsPath())", $true))
        {
            # Unable to find the output path directory; unable to continue.
            return $false;
        } # if : Check Output Path exists


        # Determine if the chosen compression tool is available for us to utilize.
        switch ($userPreferences.GetCompressionTool())
        {
            # dotNET Archive Zip
            [UserPreferencesCompressTool]::InternalZip
            {
                # Make sure that the dotNET Archive Zip is available
                if (![CommonFunctions]::IsAvailableZip())
                {
                    # Unable to find the dotNET Archive Zip
                    return $false;
                } # If : Found Default Zip

                # Finished
                break;
            } # dotNET Archive Zip

            # 7Zip
            [UserPreferencesCompressTool]::SevenZip
            {
                # Make sure that the 7Zip is available
                if (![CommonFunctions]::IsAvailable7Zip())
                {
                    # Unable to find the 7Zip application
                    return $false;
                } # If : Found 7Zip

                # Finished
                break;
            } # 7Zip

            # Unknown or Unsupported (Error Case)
            default
            {
                # Unknown or Unsupported compression tool!
                return $false;
            } # Unknown or Unsupported
        } # Switch : Determine Specified Compression Tool


        # Determine if the user wanted us to use Git Features
        if ($userPreferences.GetUseGitFeatures())
        {
            # Assure that we are able to find the Git Application
            if (![CommonFunctions]::IsAvailableGit())
            {
                # Unable to find the Git application.
                return $false;
            } # if : Check if Git Exists
        } # if : Git Features Requested


        # If we made it to this point, then we have all of the resources
        #  that we need to compile this project!
        return $true;
    } # PrerequisiteCheck()
} # Builder