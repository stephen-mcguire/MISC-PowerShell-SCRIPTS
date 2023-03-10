ForEach ($COMPUTER in (C:\Users\smcguire\Documents\computers.txt)) 
{if(!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
 
{write-host "cannot reach $computer" -f red}
 
 
 
else {
  $key = “SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install” 
        $keytype = [Microsoft.Win32.RegistryHive]::LocalMachine 
        $RemoteBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($keytype,$Server) 
        $regKey = $RemoteBase.OpenSubKey($key) 
        $KeyValue = $regkey.GetValue(”LastSuccessTime”) 
     
        $System = (Get-Date -Format "yyyy-MM-dd hh:mm:ss")  
             
        if    ($KeyValue -lt $System) 
        { 
            Write-Host " " 
            Write-Host $computer "Last time updates were installed was: " $KeyValue 
        } 
    }


}