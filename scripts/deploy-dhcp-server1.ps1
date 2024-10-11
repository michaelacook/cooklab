# Deploy and configure DHCP for cooklab.local
# Author: Mike Cook <mcook0775@outlook.com>

# Install DHCP with management tools
Install-WindowsFeature DHCP -IncludeManagementTools

# Add necessary groups then restart service
netsh dhcp add securitygroups
Restart-Service DHCPServer

# Add server to authorized DHCP servers list in Active Directory
Add-DhcpServerInDC -DNSName dc01.cooklab.local -IPAddress 192.168.10.2

# Notify Server Manager that post-install configuration is complete
Set-ItemProperty `
    -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 `
    -Name ConfigurationState -Value 2

### Configure scopes ###

## Sales scope ##

Add-DhcpServerv4Scope `
    -Name "LAN 1: Sales Dept" `
    -StartRange 192.168.20.1 `
    -EndRange 192.168.20.30 `
    -SubnetMask 255.255.255.224 `
    -State Active

Add-DhcpServerv4ExclusionRange `
    -ScopeId 192.168.20.0 `
    -StartRange 192.168.20.1 `
    -EndRange 192.168.20.2

Set-DhcpServerv4OptionValue `
    -ScopeId 192.168.20.0 `
    -DnsServer 192.168.10.2,192.168.10.3 `
    -DnsDomain "cooklab.local" `
    -Router 192.168.20.1 `

Set-DhcpServerv4Scope -ScopeId 192.168.20.0 -LeaseDuration 0.8:00:00

## Markting scope ##

Add-DhcpServerv4Scope `
    -Name "LAN 2: Marketing Dept" `
    -StartRange 192.168.20.33 `
    -EndRange 192.168.20.62 `
    -SubnetMask 255.255.255.224 `
    -State Active

Add-DhcpServerv4ExclusionRange `
    -ScopeId 192.168.20.32 `
    -StartRange 192.168.20.33 `
    -EndRange 192.168.20.34

Set-DhcpServerv4OptionValue `
    -ScopeId 192.168.20.32 `
    -DnsServer 192.168.10.2,192.168.10.3 `
    -DnsDomain "cooklab.local" `
    -Router 192.168.20.33 `

Set-DhcpServerv4Scope -ScopeId 192.168.20.32 -LeaseDuration 0.8:00:00

## Finance & admin scope ##

Add-DhcpServerv4Scope `
    -Name "LAN 3: Finance Dept" `
    -StartRange 192.168.20.65 `
    -EndRange 192.168.20.94 `
    -SubnetMask 255.255.255.224 `
    -State Active

Add-DhcpServerv4ExclusionRange `
    -ScopeId 192.168.20.64 `
    -StartRange 192.168.20.65 `
    -EndRange 192.168.20.66

Set-DhcpServerv4OptionValue `
    -ScopeId 192.168.20.64 `
    -DnsServer 192.168.10.2,192.168.10.3 `
    -DnsDomain "cooklab.local" `
    -Router 192.168.20.65 `

Set-DhcpServerv4Scope -ScopeId 192.168.20.64 -LeaseDuration 0.8:00:00

## IT scope ##

Add-DhcpServerv4Scope `
    -Name "LAN 4: IT Dept" `
    -StartRange 192.168.100.1 `
    -EndRange 192.168.100.14 `
    -SubnetMask 255.255.255.240 `
    -State Active

Add-DhcpServerv4ExclusionRange `
    -ScopeId 192.168.100.0 `
    -StartRange 192.168.100.1 `
    -EndRange 192.168.100.2

Set-DhcpServerv4OptionValue `
    -ScopeId 192.168.100.0 `
    -DnsServer 192.168.10.2,192.168.10.3 `
    -DnsDomain "cooklab.local" `
    -Router 192.168.100.1 `

Set-DhcpServerv4Scope -ScopeId 192.168.100.0 -LeaseDuration 0.8:00:00

## Guest scope ##

Add-DhcpServerv4Scope `
    -Name "LAN 5: Guest network" `
    -StartRange 192.168.200.1 `
    -EndRange 192.168.200.254 `
    -SubnetMask 255.255.255.0 `
    -State Active

Add-DhcpServerv4ExclusionRange `
    -ScopeId 192.168.200.0 `
    -StartRange 192.168.200.1 `
    -EndRange 192.168.200.2

Set-DhcpServerv4OptionValue `
    -ScopeId 192.168.200.0 `
    -DnsServer 192.168.10.2,192.168.10.3 `
    -DnsDomain "cooklab.local" `
    -Router 192.168.200.1 `

Set-DhcpServerv4Scope -ScopeId 192.168.200.0 -LeaseDuration 0.8:00:00

