Function welcome {
	write-output "Welcome to planet $env:computername Overlord $env:username"
	$now = get-date -format 'HH:MM tt on dddd'
	write-output "It is $now."
}

Function get-cpuinfo {
	get-ciminstance cim_processor | format-list Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores
}

Function get-mydisks {
	new-object -typename psobject -property @{
	Manufacturer= (get-disk).manufacturer;
	Model= (get-disk).model;
	SerialNumber= (get-disk).serialnumber;
	FirmwareRevision= (get-disk).firmwareversion;
	Size= (get-disk).size
 } | ft
}

Function get-adapterconf {
	get-ciminstance win32_networkadapterconfiguration | 
	where { $_.ipenabled -eq $True } |
	select description, index, ipaddress, ipsubnet, dnsdomain, dnsserversearchorder |
	format-table -autosize
}

Function get-sysreport {
	param ([switch]$System, [switch]$Disks, [switch]$Network)
	
	if ( ( ! $Disks) -and ( ! $Network) )
	{
		"------------Computer System------------"
		$computersystem = get-wmiobject win32_computersystem
		$compobjects = $computersystem | foreach {$sys = $_
			new-object -typename psobject -property @{
													"Description"=$computersystem.Description
													}
		}
		$compobjects | format-list "Description"

		"------------Operating System------------"
		$operatingsystem = get-wmiobject win32_operatingsystem
		$osobjects = $operatingsystem | foreach {$os = $_
			new-object -typename psobject -property @{
													"System Name"=$operatingsystem.Name
													"Version Number"=$operatingsystem.Version
													}
		}
		$osobjects | format-list "System Name", "Version Number"

		"------------Processor------------"
		$processor = get-wmiobject win32_processor
		$processorobjects = $processor | foreach {$cpu = $_
			new-object -typename psobject -property @{
													"Description"=$cpu.Description
													"Number of Cores"=$cpu.NumberOfCores
													"L2 Cache Size (KB)"=$cpu.L2CacheSize / 1kb
													"L3 Cache Size (KB)"=$cpu.L3CacheSize / 1kb
													"Clock Speed (GHz)"=$cpu.CurrentClockSpeed
													}
		}
		$processorobjects | format-list "Description", "Number of Cores", "L2 Cache Size (KB)", "L3 Cache Size (KB)", "Clock Speed (GHz)"
		
		"------------Memory------------"  
		$physicalmemory = get-wmiobject win32_physicalmemory
		$totalmemory = 0
		$memoryobjects = $physicalmemory | foreach {$memory = $_
			new-object -typename psobject -property @{
													"Manufacturer"=$memory.Manufacturer
													"Description"=$memory.Description
													"Size (GB)"=$memory.Capacity / 1gb
													"Bank"=$memory.BankLabel
													}
			$totalmemory += $memory.Capacity / 1gb
		}

		$memoryobjects | format-table "Manufacturer", "Description", "Size (GB)", "Bank"
		"Total RAM: ${totalmemory}GB"

		"`n`n------------Video Controllers------------" 
		$videocards = get-wmiobject win32_videocontroller
		$videoobjects = $videocards | foreach {$videocard = $_
			new-object -typename psobject -property @{
													"Manufacturer/Description"=$videocard.Description
													"Screen Resolution"=$videocard.VideoModeDescription
													}
		}
		$videoobjects | format-list "Manufacturer/Description", "Screen Resolution"
	}
	
	if ( ( ! $System ) -and ( ! $Disk ) )
	{
		"------------Network Adapters------------" 
		$adapters = get-wmiobject win32_networkadapterconfiguration -filter ipenabled=true
		$networkobjects = $adapters | foreach {$adapter = $_
			new-object -typename psobject -property @{
													"Description"=$adapter.Description
													"Index"=$adapter.Index
													"IP Address"=$adapter.IPAddress
													"IP Subnet"=$adapter.IPSubnet
													"DNS Domain"=$adapter.DNSDomain
													"DNS Server"=$adapter.DNSServerSearchOrder
													}
		}
		$networkobjects | format-table "Description", "Index", "IP Address", "IP Subnet", "DNS Domain", "DNS Server"
	}
	
		if ( ( ! $System ) -and ( ! $Network ) )
	{
		"------------Disk Drives------------" 
		$diskdrives = get-wmiobject win32_diskdrive
		foreach ($disk in $diskdrives) {
			$partitions = $disk.GetRelated("win32_diskpartition")
			foreach ($partition in $partitions) {
				$logicaldisks = $partition.GetRelated("win32_logicaldisk")
				foreach ($logicaldisk in $logicaldisks) {
					new-object -typename psobject -property @{
															"Drive"=$logicaldisk.deviceid
															"Size (GB)"=$logicaldisk.size / 1gb -as [int]
															"Free Space (GB)"=$logicaldisk.FreeSpace / 1gb -as [int]
															"Percentage Free"=($logicaldisk.FreeSpace / $logicaldisk.size) * 100 -as [int]
															"Model"=$disk.Model
															"Manufacturer"=$disk.Manufacturer
															} | format-table "Drive", "Model", "Manufacturer", "Size (GB)", "Free Space (GB)", "Percentage Free"
				}
			}
		}
	}
}
