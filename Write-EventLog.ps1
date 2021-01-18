#Requires -Version 3
#Requires -Runasadministrator

#region Declarations

#Declare the Event viewer "source" for events being written to the log.
#Example: "Software X Installer"
$EventSource = "Title/Function of Script"

#Declare the title of the log that entries are being committed to
#Example: "Application", custom logs can be set here, they will be located in Event Viewer in the root of "Applications and Services Log" 
$LogTitle = "Title of Log"

# Provision new source for Event log
New-EventLog -LogName $LogTitle -Source $EventSource -ErrorAction SilentlyContinue

#endregion Declarations

function Write-EventLogEntry {
    <#
    .SYNOPSIS
        A simplified and standardized function for committing to Windows event logs.
    
    .DESCRIPTION
        While this function does not require administrator privileges to run by itself, administrator rights are required in order to create the log & tie the event source
        to the log via the New-EventLog cmdlet. If the log or event source are not already prepared, this function will result in an error.

        This function is intended to simplify the process of committing events to the Windows event logs and implements a simple default ID/Event-type system. The function
        always requires the Message parameter as input but the 'Type' and 'ID' parameters are mutually exclusive and cannot be combined.

        The default IDs use the following scheme: X000

        Where the trailing zeros are the default when a specific ID is not given.
        Where X = the # for the event severity level (event type)

            1 = Error
            2 = Warning
            3 = Information
            5 = SuccessAudit
            6 = FailureAudit

            Where the trailing zeros are the default.
    
        If an event type is not provided to the function, an ID is required and the ID provided is automatically categorized where the first digit defines the event type.
            1 = Error
            2 = Warning
            3 = Information
            5 = SuccessAudit
            6 = FailureAudit
    
    .OUTPUTS
      This function does not output to the pipeline.
    
    .NOTES
      Version:          1.0.1
      Author:           Matt Drummond
      Published Date:   15 January 2021
    
    .EXAMPLE
        Write-EventLogEntry -Message "Successful Process XYZ" -Type Information
        
        The above command would log an entry with a severity level of "Information" and ID 3000 with Message "Successful Process XYZ".

    .EXAMPLE
        Write-EventLogEntry -Message "Event ABC has occurred during process" -ID 1337

        The above command would log an entry with a severity level of "Error" and ID 1337 with Message "Event ABC has occurred during process".
    #>

    # Create $message $Information and $ID parameters, and set help messages
    # All fields are set to mandatory, but ID, and Type are different parameter sets, and occupy the same position in the command.
    # logic for what the function requires: $Message AND ($Type OR $ID)
    param (
        [parameter(Mandatory,HelpMessage = 'Input text for the log entry', Position = 0)]
        [String]
        $Message,
        [parameter(Mandatory,ParameterSetName='Type',HelpMessage = 'Input type (severity level) for the log entry', Position = 1)]
        [string]
        [ValidateSet('Error', 'Warning', 'Information', 'SuccessAudit', 'FailureAudit')]
        $Type,
        [parameter(Mandatory,ParameterSetName='ID',HelpMessage = 'Input event ID for the log entry', Position = 1)]
        [int]
        [ValidatePattern("[1,2,3,5,6][0-9][0-9][0-9]")]
        $ID
    )

    # Specify final input parameters within $log_params variable
    $log_params = @{

        # LogTitle and EventSource are declared external from this function and are not expected to change for a given powershell process
        Logname   = $LogTitle
        Source    = $EventSource

        # Sets the EntryType to the parameter provided to the function, otherwise if an ID has been provided the event type will select itself based on the ID
        Entrytype = $(
            Switch ($ID){
                {1000..1999 -Contains $ID}{
                    Write-Output 'Error'
                }
                {2000..2999 -Contains $ID}{
                    Write-Output 'Warning'
                }
                {3000..3999 -Contains $ID}{
                    Write-Output 'Information'
                }
                {5000..5999 -Contains $ID}{
                    Write-Output 'SuccessAudit'
                }
                {6000..6999 -Contains $ID}{
                    Write-Output 'FailureAudit'
                }
                default{
                    Write-Output $type
                }
            }
        )
        # Sets the Event ID to the parameter provided to the function, otherwise if a type has been provided the ID will select a default code based on the event type
        EventID   = $(
            Switch ($type) {
                'Error'{
                    Write-Output -InputObject 1000
                }
                'Warning'{
                    Write-Output -InputObject 2000
                }
                'Information'{
                    Write-Output -InputObject 3000
                }
                'SuccessAudit'{
                    Write-Output -InputObject 5000
                }
                'FailureAudit'{
                    Write-Output -InputObject 6000
                }
                default{
                    Write-Output -InputObject $ID
                }
            }       
            
        )       
        Message   = $Message
    }
    #Commit logs from $log_params to Event Viewer
    Write-EventLog @log_params
}
