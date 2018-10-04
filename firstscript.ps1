
$scriptPath1 = "C:\Users\deeksha.p\Documents\myscript\web1.ps1"
$scriptPath2 = "C:\Users\deeksha.p\Documents\myscript\web2.ps1"

Invoke-Command  -FilePath $scriptPath1 write-host " first website creating"

Invoke-Command  -FilePath $scriptPath2 write-host " second website creating"
