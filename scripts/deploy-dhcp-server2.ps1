# Deploy and configure DHCP for cooklab.local
# Author: Mike Cook <mcook0775@outlook.com>

# Install DHCP with management tools
Install-WindowsFeature DHCP -IncludeManagementTools

# Add necessary groups then restart service
netsh dhcp add securitygroups
Restart-Service DHCPServer

# Add server to authorized DHCP servers list in Active Directory
Add-DhcpServerInDC -DNSName dc02.cooklab.local -IPAddress 192.168.10.3

# Notify Server Manager that post-install configuration is complete
Set-ItemProperty `
    -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 `
    -Name ConfigurationState -Value 2

