<# Common CUI
 # ------------------------------
 # ==============================
 # ==============================
 # This class will hold common Console User Interface instructions and procedures to
 #  reduce code duplication.  With the functions provided in this class, we can easily
 #  keep most of the User Interface content unified and consistent through out the
 #  entire program.  With the consistency of the UI, the end-user can easily navigate
 #  within the program with the outmost ease.  If we were not consistent, the user
 #  will easily get frustrated with the program.
 #>




class CommonCUI
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Border - Dash - Long
    # ---------------
    # A simple string that provides a long dashed border.
    Hidden static [string] $borderDashLong = "----------------------------------------------------";


    # Border - Dash Spaced - Long
    # ---------------
    # A simple string that provides a long dash spaced border.
    Hidden static [string] $borderSubcategory = "- - - - - - - - - - - - - - - - - - - - - - - - - - ";


    #endregion



   <# Draw Program Title Header
    # -------------------------------
    # Documentation:
    #  This function will display the Program's information to the user so that they
    #   are able to see what version of the program is currently running within the
    #   shell.
    # -------------------------------
    #>
    static [void] DrawProgramTitleHeader()
    {
        # Display the program information
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");

        # Show the full program name
        [Logging]::DisplayMessage("`t$($Global:_PROGRAMNAME_)");

        # Show the version, version name, and the release date of the version.
        [Logging]::DisplayMessage("Version $($Global:_VERSION_) - $($Global:_VERSIONNAME_)`t`t$($Global:_RELEASEDATE_)");

        # Change of contents
        [Logging]::DisplayMessage("$([CommonCUI]::borderSubcategory)");

        # Show the intended supported project
        [Logging]::DisplayMessage("Designed for $([ProjectInformation]::projectName) [$([ProjectInformation]::codeName)]");
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");
        [Logging]::DisplayMessage("$([CommonCUI]::borderDashLong)");


        # Provide some extra padding
        [Logging]::DisplayMessage("`r`n`r`n");
    } # DrawProgramTitleHeader()




   <# Draw Section Header
    # -------------------------------
    # Documentation:
    #  This function will provide a header for the desired section.
    # -------------------------------
    # Input:
    #  [string] Section Title
    #   The title of the section that will be drawn.
    # -------------------------------
    #>
    static [void] DrawSectionHeader([string] $sectionTitle)
    {
        [Logging]::DisplayMessage("`t`t  $sectionTitle");
        [Logging]::DisplayMessage("`t~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~`r`n");
    } # DrawSectionHeader()




   <# Draw Menu Instructions
    # -------------------------------
    # Documentation:
    #  This function will display the Menu instructions to the user so that they know
    #   how to interact with the application.  The instructions are to be minimal but yet
    #   concise so that the user can easily start using the program, but not to the point
    #   of flooding the returning user.
    # -------------------------------
    #>
    static [void] DrawMenuInstructions()
    {
        [Logging]::DisplayMessage("Select from the following available options:");
        [Logging]::DisplayMessage("----------------------------------------------------");
    } # DrawMenuInstructions()
} # CommonCUI