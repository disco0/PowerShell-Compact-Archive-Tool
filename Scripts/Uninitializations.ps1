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




<# Uninitializations
 # -------------------------------
 # Documentation:
 #  This function will remove the global variables that had been previously initialized during
 #   the initialization phase, or simply the startup operation.  The reason for this function is
 #   remove the global variables that we had used for this program, but we do not want to the
 #   variables to be available long-after the application had been terminated normally.  As such,
 #   the variables may be available to the user outside of the application, which we want to
 #   prevent.
 #
 #  This feature is only viable if the client relies heavily on the terminal; meaning that the
 #   terminal was already opened before the application was running.  Thus, the program's
 #   environment will remain available long after the program had been terminated.
 # -------------------------------
 #>
 function Uninitializations()
 {
    # Program Name
    Remove-Variable -Name "_PROGRAMNAME_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program Name (Abbreviated)
    Remove-Variable -Name "_PROGRAMNAMESHORT_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Version
    Remove-Variable -Name "_VERSION_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Version Name
    Remove-Variable -Name "_VERSIONNAME_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Release Date
    Remove-Variable -Name "_RELEASEDATE_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # License
    Remove-Variable -Name "_LICENSE_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program Homepage
    Remove-Variable -Name "_PROGRAMSITEHOMEPAGE_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program Wiki
    Remove-Variable -Name "_PROGRAMSITEWIKI_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program Downloads
    Remove-Variable -Name "_PROGRAMSITEDOWNLOADS_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program Source Repository
    Remove-Variable -Name "_PROGRAMSITESOURCEREPOSITORY_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Report a Bug or Feature
    Remove-Variable -Name "_PROGRAMREPORTBUGORFEATURE_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # .NET Framework Requirement
    Remove-Variable -Name "_DOTNETFRAMEWORK_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PowerShell Version Requirement
    Remove-Variable -Name "_POWERSHELLVERSION_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Debug Logging functionality
    Remove-Variable -Name "_DEBUGLOGGING_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Logging Lock Key
    Remove-Variable -Name "_LOGGINGLOCKKEY_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Splash Screen Hold Timer (Seconds)
    Remove-Variable -Name "_STARTUPSPLASHSCREENHOLDTIME_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Script Absolute Script Path
    Remove-Variable -Name "_SCRIPTPATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # User-Data Root Directory Path
    Remove-Variable -Name "_USERDATA_ROOT_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # User-Data Project Parent Project Directory Path
    Remove-Variable -Name "_USERDATA_PROJECT_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Output Parent Directory Path
    Remove-Variable -Name "_USERDATA_BUILDS_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Output Release Directory Path
    Remove-Variable -Name "_USERDATA_RELEASEBUILDS_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Output Development Directory Path
    Remove-Variable -Name "_USERDATA_DEVBUILDS_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program-Data Root Directory Path
    Remove-Variable -Name "_PROGRAMDATA_ROOT_LOCAL_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program-Data Project Parent Directory Path
    Remove-Variable -Name "_PROGRAMDATA_PROJECT_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Log Directory Path
    Remove-Variable -Name "_PROGRAMDATA_LOGS_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # Program-Data Parent Directory Path
    Remove-Variable -Name "_PROGRAMDATA_ROOT_ROAMING_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # User Data (Configuration)
    Remove-Variable -Name "_PROGRAMDATA_CONFIGS_PATH_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;

    # PowerShell's Window Title
    Remove-Variable -Name "_ENVIRONMENT_WINDOW_TITLE_ORIGINAL_" `
        -Scope Global `
        -Force `
        -ErrorAction SilentlyContinue;
 } # Uninitializations()