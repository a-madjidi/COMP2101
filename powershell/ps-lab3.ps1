get-ciminstance win32_networkadapterconfiguration | 
	where { $_.ipenabled -eq $True } |
	select description, index, ipaddress, ipsubnet, dnsdomain, dnsserversearchorder |
	format-table -autosize
