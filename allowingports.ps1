New-NetFirewallRule -DisplayName "Block All Inbound Traffic tcp" -Direction Inbound -Action Block -LocalPort 1-49151 -Protocol TCP
New-NetFirewallRule -DisplayName "Block All Inbound Traffic udp" -Direction Inbound -Action Block -LocalPort 1-49151 -Protocol UDP


$ports = 21114, 21115, 21116, 21117, 21118, 21119, 53, 445, 135, 137, 138, 389, 636, 3268, 3269

foreach ($port in $ports) {

	New-NetFirewallRule -DisplayName "Allow Port $port inbound" -Direction Inbound -LocalPort $port -Protocol TCP -Action allow
	New-NetFirewallRule -DisplayName "Allow Port $port outbound" -Direction Outbound -LocalPort $port -Protocol TCP -Action allow

}

New-NetFirewallRule -DisplayName "Allow Port 53 udp inbound" -Direction Inbound -LocalPort 53 -Protocol UDP -Action allow
New-NetFirewallRule -DisplayName "Allow Port 53 udp outbound" -Direction Outbound -LocalPort 53 -Protocol UDP -Action allow
New-NetFirewallRule -DisplayName "Allow Port 21116 udp inbound" -Direction Inbound -LocalPort 21116 -Protocol UDP -Action allow
New-NetFirewallRule -DisplayName "Allow Port 21116 udp outbound" -Direction Outbound -LocalPort 21116 -Protocol UDP -Action allow


<#
This script creates firewall rules for all important ports for AD and ports for RustDesk.
Hopefully this doesn't break the competition that would be sad :(

#>

