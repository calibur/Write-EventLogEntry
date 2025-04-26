# Write-EventLogEntry

![PowerShell](https://img.shields.io/badge/PowerShell-v3.0+-blue)
![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)
![Status](https://img.shields.io/badge/Status-Stable-brightgreen)

> **TL;DR:** A simplified, standardized PowerShell function for committing entries to Windows Event Logs.

---

## Overview

**Write-EventLogEntry** is a streamlined PowerShell function that simplifies writing to Windows Event Logs.  
It supports automatic assignment of event types and IDs, enforcing a clear and standardized format for entries.

> **Note:** While the function itself does **not** require administrative privileges to run, **creating a new event source** with `New-EventLog` **does require** administrator rights. If the event source or log does not already exist, the function will fail.

---

## Key Features

- Simplified event log commits with minimal input.
- Automatically assigns event types based on ID, or default IDs based on type.
- Built-in input validation for consistency.
- Supports writing to both standard and custom event logs.

---

## Severity and ID Mapping

Event IDs follow a `X000` format, where the first digit (`X`) represents the severity level:

| Severity Level | Starting Digit | Example ID |
| -------------- | --------------- | ---------- |
| Error          | 1               | 1000       |
| Warning        | 2               | 2000       |
| Information    | 3               | 3000       |
| SuccessAudit   | 5               | 5000       |
| FailureAudit   | 6               | 6000       |

- If only the `Type` parameter is specified, a default ID (`X000`) is assigned.
- If an `ID` is manually specified, the function automatically determines the `Type` based on the first digit.

---

## Parameters

| Parameter | Description |
|-----------|-------------|
| `-Message` (Required) | The text to log into the Event Viewer. |
| `-Type` (Optional, exclusive with `-ID`) | The severity level: `Error`, `Warning`, `Information`, `SuccessAudit`, or `FailureAudit`. |
| `-ID` (Optional, exclusive with `-Type`) | Custom Event ID following the format `[1,2,3,5,6][0-9][0-9][0-9]`. |

> **Important:** `-Type` and `-ID` are **mutually exclusive** — specify only one.

---

## EXAMPLE
```powershell
Write-EventLogEntry -Message "Successful Process XYZ" -Type Information        
```
The above command would log an entry with a severity level of "Information" and ID 3000 with Message "Successful Process XYZ".
```powershell
Write-EventLogEntry -Message "Event ABC has occurred during process" -ID 1337
```
The above command would log an entry with a severity level of "Error" and ID 1337 with Message "Event ABC has occurred during process".


