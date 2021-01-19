# Write-EventLogEntry

A simplified and standardized function for committing to Windows event logs.

## Description

While this function does not require administrator privileges to run by itself, administrator rights are required in order to create the log & tie the event source to the log via the New-EventLog cmdlet. If the log or event source are not already prepared, this function will result in an error.

This function is intended to simplify the process of committing events to the Windows event logs and implements a simple default ID/Event-type system. The function always requires the Message parameter as input but the 'Type' and 'ID' parameters are mutually exclusive and cannot be combined.


IDs are in the format of: X000 where X == severity


| Number | Severity Level |
| ------ | -------------- |
| 1      | Error          |
| 2      | Warning        |
| 3      | Information    |
| 5      | SuccessAudit   |
| 6      | FailureAudit   |

If no ID is manually specified, a default ID is used with the 3 trailing digits are 0's.
If an ID is specified the event type is auto determined based on the first digit

## EXAMPLE

    Write-EventLogEntry -Message "Successful Process XYZ" -Type Information        

The above command would log an entry with a severity level of "Information" and ID 3000 with Message "Successful Process XYZ".

    Write-EventLogEntry -Message "Event ABC has occurred during process" -ID 1337

The above command would log an entry with a severity level of "Error" and ID 1337 with Message "Event ABC has occurred during process".
