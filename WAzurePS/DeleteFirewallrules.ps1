#
# DeleteFirewallRules.ps1
#===========================
#By: @WarNov 7/2/2014 - 20:32
#This script deletes all the firewallrules created inside a given SQL DB Server, except the one destinated for Azure Ips: AllowAllWindowsAzureIps
#The name of the server is passed as parameter.
#The script uses the azure cmdlets from version 0.8.3
#thus, the following output from azure sql firewallrule list <serverName> command is expected:

#info:    Executing command sql firewallrule list
#info:    Getting firewall rules
#data:    Name                                 Start IP address  End IP address
#data:    -----------------------------------  ----------------  ---------------
#data:    AllowAllWindowsAzureIps              0.0.0.0           0.0.0.0
#data:    ClientIPAddress_2013-08-29_23:01:06  181.135.91.179    181.135.91.179
#data:    ClientIPAddress_2013-11-07_22:32:07  181.135.203.146   181.135.203.146
#data:    ClientIPAddress_2013-11-11_17:58:34  181.136.118.169   181.136.118.169
#...
#...
#...
#data:    ClientIPAddress_2014-06-16_21:32:20  181.135.80.166    181.135.80.166
#info:    sql firewallrule list command OK

#you can notice the internal rule is found on the 4th row, so rules to delete are found from 5th row.
#Last row is skipped since it does not have a rule name, because it is the command status message.
#Please check out posible changes in the output and make corrections of this script just in case.
#The script assumes you have set the credentials of the subscription you wanna work with


Param(
  [string]$sqlDBServerName  
)
$frwrlz=azure sql firewallrule list $sqlDBServerName
$rlzCount=$frwrlz.Count-6
if($rlzCount -ge 1){
	$begin=5
	for ($i = $begin; $i -lt $begin+$rlzCount; $i++){
		$ruleName=$frwrlz[$i].Split(" ")[4]
		azure sql firewallrule delete -q -v $sqlDBServerName $ruleName
	}	
}
Write-Host $rlzCount "firewall rules deleted";