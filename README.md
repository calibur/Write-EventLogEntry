# Write-EventLogEntry

A simplified and standardized function for committing to Windows event logs.

## Description

While this function does not require administrator privileges to run by itself, administrator rights are required in order to create the log & tie the event source to the log via the New-EventLog cmdlet. If the log or event source are not already prepared, this function will result in an error.

This function is intended to simplify the process of committing events to the Windows event logs and implements a simple default ID/Event-type system. The function always requires the Message parameter as input but the 'Type' and 'ID' parameters are mutually exclusive and cannot be combined.

The default IDs use the following scheme:

X000

Where the trailing zeros are the default when a specific ID is not given.

Where X = the # for the event severity level (event type)

| Number | Severity Level |
| ------ | -------------- |
| 1      | Error          |
| 2      | Warning        |
| 3      | Information    |
| 5      | SuccessAudit   |
| 6      | FailureAudit   |

## EXAMPLE

    Write-EventLogEntry -Message "Successful Process XYZ" -Type Information        

The above command would log an entry with a severity level of "Information" and ID 3000 with Message "Successful Process XYZ".

    Write-EventLogEntry -Message "Event ABC has occurred during process" -ID 1337

The above command would log an entry with a severity level of "Error" and ID 1337 with Message "Event ABC has occurred during process".
