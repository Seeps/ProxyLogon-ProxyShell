Get-WinEvent -LogName "MSExchange Management" | 
Where-Object {
    ($_.Message -like "*new-mailboxexportrequest*" -and $_.Message -like "*aspx*") -or 
    ($_.Message -like "*new-exchangecertificate*" -and $_.Message -like "*aspx*") -or 
    ($_.Message -like "*set-oabvirtualdirectory*" -and $_.Message -like "*script*")
} |
Select-Object TimeCreated, Message |
Out-File "C:\proxylogonshell.txt"
