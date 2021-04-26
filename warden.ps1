Start-Transcript -Path C:\${hostname}_warden.txt

$hostname = hostname

Write-Host "Starting remediation..."

$firewall = netsh.exe advfirewall firewall show rule name=dns
echo $firewall
$rule = netsh.exe advfirewall firewall delete rule name=dns
Write-Host "Deleting Rule DNS - $($rule)"


$files = `
"C:\Windows\System32\Tasks\Winnet",`
"C:\Windows\System32\Tasks\Sync",`
"C:\Windows\System32\Tasks\NT TASK\Winnet",`
"C:\Windows\System32\Tasks\t.zz3r0.com",`
"C:\Windows\System32\Tasks\HMYN8Qa",`
"C:\Windows\System32\Tasks\i6T0C1qP\Zc2fp1CxG",`
"C:\Windows\System32\Tasks\t.zker9.com",`
"C:\Windows\System32\Tasks\MicroSoft\Windows\L27GYgaZQF\sFnLW9pZOh",`
"C:\Windows\System32\Tasks\uiAZCtNgeU",`
"C:\Windows\System32\Tasks\bwKIAkFozi8"

Foreach ($file in $files) {
if (Test-Path $file -PathType leaf)
    {
        del $file
        Write-Host "Deleting File - $($file)"
    }
}


$tasks = `
"Sync",`
"Winnet",`
"t.zz3r0.com",`
"HMYN8Qa",`
"Zc2fp1CxG",`
"sFnLW9pZOh",`
"t.zker9.com",`
"uiAZCtNgeU",`
"bwKIAkFozi8"

Foreach ($task in $tasks) {
if (schtasks.exe /query /tn $task)
    {
schtasks.exe /end /tn $task
schtasks.exe /delete /tn $task /f
Write-Host "Deleting Task - $($task)"
    }
}


$services = Get-WmiObject Win32_Service | Where-object {($_.pathname -like "*monitoring*") -and (($_.pathname -like "*powershell*") -or ($_.pathname -like "*downloadstring*")) -or (($_.pathname -like "*firewall*") -and ($_.pathname -like "*1.1.1.1*")) -or (($_.pathname -like "*powershell*") -and ($_.pathname -like "*base64*")) -or (($_.pathname -like "*powershell*") -and ($_.pathname -like "*downloadstring*")) -or (($_.pathname -like "*powershell*") -and ($_.pathname -like "*webclient*")) -or (($_.pathname -like "*powershell*") -and ($_.pathname -like "*downloaddata*"))}

Foreach ($service in $services) {
if (Get-Service $service.Name)
    {
        sc.exe stop $service.Name
        sc.exe delete $service.Name
        Write-Host "Deleting Service - $($service.Name)"
    }
}


ipconfig /flushdns
Write-Host "Flushing DNS"

Stop-Transcript