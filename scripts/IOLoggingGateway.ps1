﻿<# Basic IO and Logging Gateway
 # ------------------------------
 # ==============================
 # ==============================
 # This class allows the ability to send a message or capture
 #  a message through various methods in a single instance.
 #  A single instance allows the possiblity for a message to be
 #  displayed via the terminal's buffer and also to be logged,
 #  this methodolgy helps to dramatically reduce code duplication
 #  and simplifies the procedures with sending a message to the
 #  user and to record input from the user or file in a monitored
 #  environment.
 #
 # REQUIRED DEPENDENCIES:
 #  - IOCommon
 #  - Logging
 #>



 class IOLoggingGateway
 {
   <# Display Message
    # -------------------------------
    # Documentation:
    #  This function will provide a gateway into both
    #   displaying the desired message to the user's
    #   screen and also logging the same message.
    # NOTE:
    #  The formatting and specifications of the message
    #   will be evaluated in the inner-specific functions
    #   that are called within this function.
    # -------------------------------
    # Input:
    #  [string] Message
    #   The message that is to be presented on the screen.
    #  [IOCommonMessageLevel] Message Level
    #   The level of the message that is to be presented
    #    or formatted.
    # -------------------------------
    #>
    static [void] DisplayMessage([string] $msg, [IOCommonMessageLevel] $msgLevel)
    {
        # Display the message to the terminal screen
        [IOCommon]::WriteToBuffer("$($msg)", "$($msgLevel)");

        # Log the message
        [Logging]::WriteLogFile("$($msg)");
    } # DisplayMessage()




   <# Get User Input
    # -------------------------------
    # Documentation:
    #  This function will provide a gateway into both
    #   retrieving the user's input for a desired request
    #   and also logging that request.
    # -------------------------------
    # Output:
    #  [string] User's Input Request
    #    Returns the user's request.
    # -------------------------------
    #>
    static [string] GetUserInput()
    {
        # Declarations and Initializations
        # ----------------------------------------
        [string] $userInput = $null;    # This will hold the user's feedback
        [string] $prompt = ">>>>> ";    # The prompt message that will be
                                        #  recorded in the logfile.
        # ----------------------------------------


        # Fetch user input
        $userInput = [IOCommon]::FetchUserInput();

        # Log the user's input
        [Logging]::WriteLogFile("$($prompt)$($userInput)");

        # Return the user's request
        return "$($userInput)";
    } # GetUserInput()
 } # IOLoggingGateway