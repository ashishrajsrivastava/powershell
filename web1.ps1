
#$appConfigFile = "web.config"
    ### Load configuration file
    Write-Host "Loading configuration file $configFile"
    $configFile = "C:\DEV7.xml"

    if((Test-Path $configFile) -eq $false)
    {
        throw "Config file not found: $configFile" 
    }

    [xml]$file = [xml](get-content -Path $configFile)

    #echo "Beginning the installation of  service $service"
    echo ""
    echo "Command line arguments:"
    echo "========================================="
    #echo "website          = $service"
    echo "configSourceFile = $configFile"
    echo "========================================="
    echo ""
  


    [xml]$file = [xml](get-content -Path $configFile)
    $configfile = "C:\Users\deeksha.p\Documents\Nexus\Nexus\DEV7.xml"
    [xml]$file = [xml](get-content -Path $configFile)
    $AppPoolName = $file.SelectNodes("/env/AppPools/AppPool/@apppool")[0].Value
    echo "$AppPoolName"
    $port=$file.SelectSingleNode("/env/IpAddresses/IpAddress/@useport").Value
     echo "$Port"
    $Address = $file.SelectNodes("/env/IpAddresses/IpAddress/@name")[0].Value 
    echo "$Address"
    $Websitename=$file.SelectNodes("/env/Websitename/website/@name")[0].Value
    echo "$Websitename"
    $pysicalpath = "C:\test" 

    #$default_page=$file.SelectSingleNode("/env/Server-Type/Websites/Website[@name='$service']/@default-page").Value

    #Check if website exits
    if(-Not(Get-Website | Where-Object {$_.Name -eq "$WebSiteName"}))
    {
        echo "The website $WebSiteName was not found on this server!"
    }
    else {
    echo  "Removing Website $WebSiteName"
       Remove-Website  -Name $WebSiteName
    }

    #Check if required HTTPS binding is available
    if(-Not(Get-WebBinding -Name "$WebSiteName" -protocol 'http'))
    {
        echo "Not HTTPS binding was found for $WebSiteName website"
    } 


    #Check installation path 
    if ( $(Try {Test-Path $homedir.trim() } Catch { $false }) )
    {
       echo "TargetPath $homedir found on target machine. Removing old files."
        Remove-Item -path   "$homedir\*" -Force -Recurse
    }
    Else
    {
        echo "Creating target directory - $homedir."
        New-Item $homedir -type directory        
    }

 
  # Check if exist otherwise Create WebAppPool  
  try
{
$poolCreated = Get-WebAppPoolState $AppPoolName 
Write-Host $AppPoolName pool "Already Exists"
}
catch
{
# Assume it doesn't exist. Create it.
New-WebAppPool -Name $AppPoolName
#Set-ItemProperty IIS:\AppPools\$AppPoolName -name processModel -value @{IdentityType = "SpecificUser"; Username = ("{0}$" -f$serviceAccount); Password=$serviceAccountPassword ;}
Set-ItemProperty IIS:\AppPools\$AppPoolName managedRuntimeVersion v4.0
}

# Create Website
if(Test-Path "IIS:\Sites\$WebsiteName" -pathType Any)
    {
     write-host "website already exists"
    }
    else 
    {
      Write-Output "Creating Website '$WebsiteName'"

        # Create the website
        New-Website -Name $WebsiteName -Port $port -PhysicalPath $pysicalpath -force -ApplicationPool $Apppoolname
    }

    $bindings = @( @{ protocol="http"; bindingInformation="$address`:$port"} )
    echo $bindings
	
		# Set the binding with the specified IP Address and port
		Set-WebConfigurationProperty "/system.applicationHost/sites/site[@name='$WebsiteName']" -PSPath IIS:\ -Name Bindings -Value $bindings







