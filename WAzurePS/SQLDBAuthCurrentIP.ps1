#
# SQLDBAuthCurrentIP.ps1
#===========================
#By: @WarNov 7/12/2014 - 18:12
#This script adds to the Specified SQL DB Server Database the IP of this machine as a new firewallrule



Param(

	#The SQL DB Server Name. i.e. n4x8y4oi1z	
	[string]$serverName,  
	#The name of the rule to be inserted. It is mandatory on Azure,
	#but you can ommit it here, since we produce a GUID if you do not provide one
	[string]$ruleName,
	#The path where the *.publishsettings file is located with the subscription info
	[string]$publish	
)


#First we import the info about the subscription
Import-AzurePublishSettingsFile -PublishSettingsFile $publish

#Then we process the ruleName. If no ruleName has been passed as a parameter,
#a guid name is produced
if($ruleName.Length -eq 0){
	$ruleName=[guid]::NewGuid();
}

#Now we get the ip address that we want to add. 
#Since there is no way to get the external ip that is used by our client
#You have to use an online tool that informs you about your current ip
#In this case, i'm using a tool built by my own and running on Azure
#based on a plain ASP.NET Generic Handler,
#using this simple statement: Request.UserHostAddress
#You can then use .net inside PowerShell to create a WebClient and
#execute a standar downloadstring with the tool url passed as argument
$ipAddress=(New-Object Net.WebClient).DownloadString('http://warnov.com/@ip')

#Finally we execute the main command, that will add the ip to the server
#under the specified Azure Subscription
New-AzureSqlDatabaseServerFirewallRule -ServerName $serverName -RuleName $ruleName -StartIpAddress $ipAddress -EndIpAddress $ipAddress