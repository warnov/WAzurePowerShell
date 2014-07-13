#
# SQLDBAuthCurrentIP.ps1
#===========================
#By: @WarNov 7/12/2014 - 18:12
#This script adds to the Specified SQL DB Server Database the IP of this machine as a new firewallrule



Param(
  [string]$serverName,  
  [string]$ruleName,
  [string]$publish
)
Import-AzurePublishSettingsFile -PublishSettingsFile $publish
if($ruleName.Length -eq 0){
	$ruleName=[guid]::NewGuid();
}
$ipAddress=(New-Object Net.WebClient).DownloadString('http://warnov.com/@ip')

New-AzureSqlDatabaseServerFirewallRule -ServerName $serverName -RuleName $ruleName -StartIpAddress $ipAddress -EndIpAddress $ipAddress