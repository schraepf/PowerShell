# Name: READ-HOSTS.PS1
#
# Author: Michael Schraepfer (Essendis)
#
# Date: 20160405
#
# This script parses the HOSTS file and writes entries to the console. 


# Define HOSTS file location
$hosts= "C:\windows\system32\drivers\etc\hosts"


# Error out if there is no HOSTS file, else continue parsing.
if (-not (Test-Path -Path $hosts)){            
    Throw "Hosts file not found"}        
        
        
# Define a regular expression to return first NON-whitespace character. 
# More information about using regular expressions in PowerShell at https://technet.microsoft.com/en-us/magazine/2007.11.powershell.aspx.
[regex]$r="\S"

       
# Get the content of lines that aren't blank and don't start with #.
$HostsData = Get-Content $Hosts | where {
    (($r.Match($_)).value -ne "#") -and ($_ -notmatch "^\s+$") -and ($_.Length -gt 0)
    }
        
        
# Parse lines we got above to identify the IP and HOSTNAME data we want to write to the console.            
$HostsData | foreach {
    $_ -match "(?<IP>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<HOSTNAME>\S+)" | Out-Null
    $ip=$matches.ip
    $hostname=$matches.hostname  
                
    # Parse lines for trailing comments on each HOSTS file entry, if they exist. This is optional and not in scope, but is common and included for flexibility.
    <#
        if ($_.contains("#")) {
            $comment=$_.substring($_.indexof("#")+1)
        }
        else {
            $comment=$null
           } 
    #>
                
    # Create a new PSObject to store the parsed data.
    $obj = New-Object PSObject
                
               
    # Add properties to the new object. Uncomment the third line to enable script to list any comments in the HOSTS entry.
    $obj | Add-Member Noteproperty -name "Machine IP" -Value $ip
    $obj | Add-Member Noteproperty -name "Host Name" -Value $hostname
    #$obj | Add-Member Noteproperty -name "Comment" -Value $comment
    
    
    # Write HOSTS file entries to the console. Remove "| format-list *" will output in an array instead of a list. Out of scope, but included for flexibility.                 
    $obj | format-list *
    } 
    
# End of script.    
         
    
